# NBGLM for Valley Fever by Trevor Reckell
# Negative binomial distributed lag GLM for Valley fever in all four regions
# This is alternate R version of my NBGLM_VF_8_24_26.m in MATLAB and keeps the same structure and the
# same numbers so the two can be checked against each other
#
# This is the statistical baseline companion to the mechanistic ODE script
# It is the model class that is standard in the Valley fever literature so it is the fair statistical benchmark for the ODEs

# Method and citations
#  Head JR and colleagues Lancet Planet Health 2022 6(10) e793 to e803
#  monthly surveillance counts modelled with distributed monthly lags on
# climate a population offset seasonality and a long term trend
#  Comrie AC Environ Health Perspect 2005 and Tamerius and Comrie PLoS One 2011
#  justify the lag window running out to 24 months
#  Gasparrini A distributed lag models give the crossbasis idea used here in
# its polynomial Almon form

# Model
#  y_t ~ NegBin(mu_t, kappa) treated as a quasi likelihood when counts are fractional
#  log(mu_t) = log(N_t) + b0 + b1 trend_t + two harmonic pairs at 12 and 6 months
#            + sum_j g_j TempCB_j(t) + sum_j h_j PziCB_j(t)
#  Distributed lags are constrained by a degree 3 polynomial basis over lags
#  0 to 24 months so each climate variable costs 4 coefficients instead of 25
#  Total mean parameters k is 14 plus kappa so p is 15 which is the same order
#  as the fitted ODE models

#Estimation window
#   The climate series are extended 24 months before the outcome window using
#   Jan 2011 to Dec 2012 from the same NOAA series. Every lag therefore lands on
#   observed climate and the model is estimated on months 1 to 132 with n = 132
#   so RRMSE AIC AICc and BIC compare directly with the ODE models. A secondary
#   re score on months 25 to 132 is still printed for continuity with earlier tables

#Forecasting
# Same expanding window as the ODE script with nFitList = 96 108 120. The
#  model is climate driven only with no autoregressive case terms so the
#  forecasts are direct not recursive and there is no case data leakage.
#   Climate over the forecast year is treated as known exogenous forcing

# Error metrics use the same formulas as the ODE script
#   fit and forecast RRMSE = 100 * sqrt(mean(r^2)) / mean(observed in window)
#   the persistence seasonal and train mean baselines use the ODE lines

#Running a selection or a single line with Ctrl+Enter will skip the settings block and give object not found errors


library(stats)
library(graphics)
library(grDevices)
library(utils)
options(digits = 10)

# config
LMAX      <- 24      # maximum climate lag in months
DEG       <- 3       # Almon polynomial degree for the lag curve
USE_TREND <- TRUE    # linear long term trend
NHARM     <- 2       # harmonic pairs for 12 and 6 month seasonality

FIT_OBJECTIVE <- "nb_mle"   # "nb_mle" is maximum likelihood and is the field standard
# "rrmse" minimises the same RRMSE objective the ODE
# particle swarm minimises for a like for like criterion

nFitList <- c(96, 108, 120)
yrLabel  <- c("2021", "2022", "2023")
regionList <- 1:4           # 1 AZ 2 MARICOPA 3 PIMA 4 PINAL

#helper functions 
# MATLAB style pchip. R has monotone splines but the slopes are computed a
# little differently so this follows the MATLAB formulas directly 
pchip_matlab <- function(x, y, xi) {
  n   <- length(x)
  h   <- diff(x)
  del <- diff(y) / h
  d   <- numeric(n)
  for (k in 2:(n - 1)) {
    if (sign(del[k - 1]) * sign(del[k]) > 0) {
      w1 <- 2 * h[k] + h[k - 1]
      w2 <- h[k] + 2 * h[k - 1]
      d[k] <- (w1 + w2) / (w1 / del[k - 1] + w2 / del[k])
    } else {
      d[k] <- 0
    }
  }
  d[1] <- ((2 * h[1] + h[2]) * del[1] - h[1] * del[2]) / (h[1] + h[2])
  if (sign(d[1]) != sign(del[1])) {
    d[1] <- 0
  } else if (sign(del[1]) != sign(del[2]) && abs(d[1]) > abs(3 * del[1])) {
    d[1] <- 3 * del[1]
  }
  d[n] <- ((2 * h[n - 1] + h[n - 2]) * del[n - 1] - h[n - 1] * del[n - 2]) / (h[n - 1] + h[n - 2])
  if (sign(d[n]) != sign(del[n - 1])) {
    d[n] <- 0
  } else if (sign(del[n - 1]) != sign(del[n - 2]) && abs(d[n]) > abs(3 * del[n - 1])) {
    d[n] <- 3 * del[n - 1]
  }
  idx <- findInterval(xi, x, all.inside = TRUE)
  s   <- xi - x[idx]
  hk  <- h[idx]
  cc  <- (3 * del[idx] - 2 * d[idx] - d[idx + 1]) / hk
  bb  <- (d[idx] - 2 * del[idx] + d[idx + 1]) / hk^2
  y[idx] + s * (d[idx] + s * (cc + s * bb))
}

# polynomial Almon distributed lag basis where C(t, j) = sum_l x(t - l) * (l / LMAX)^j
# This constrains the 25 lag coefficients to a smooth degree DEG curve which is
# the standard to keep distributed lag models identifiable x_ext has n + LMAX values so outcome month t sits at extended index t + LMAX
# and lag l is x_ext[t + LMAX - l] so every row is fully defined
almon_crossbasis <- function(x_ext, n, LMAX, DEG) {
  if (length(x_ext) != n + LMAX) stop("extended climate must have n + LMAX values")
  x <- x_ext - mean(x_ext)
  w <- (0:LMAX) / max(LMAX, 1)
  C <- matrix(NA_real_, n, DEG + 1)
  for (tt in 1:n) {
    te <- tt + LMAX
    xs <- x[te:(te - LMAX)]          # lag 0 then 1 and so on up to LMAX
    for (j in 0:DEG) {
      C[tt, j + 1] <- sum(xs * w^j)
    }
  }
  C
}

# columns are intercept then trend then harmonics then the temp crossbasis then
# the PZI crossbasis. temp_ext and pzi_ext have n + LMAX values with the LMAX
#pre sample months first so the design matrix has no NA in it
build_design <- function(temp_ext, pzi_ext, pop, n, LMAX, DEG, useTrend, nHarm) {
  m <- 0:(n - 1)
  colNames <- "intercept"
  X <- matrix(1, n, 1)
  if (useTrend) {
    X <- cbind(X, (m - mean(m)) / sd(m))
    colNames <- c(colNames, "trend")
  }
  moy <- m %% 12
  for (kH in 1:nHarm) {
    X <- cbind(X, sin(2 * pi * kH * moy / 12), cos(2 * pi * kH * moy / 12))
    colNames <- c(colNames, sprintf("sin%d", kH), sprintf("cos%d", kH))
  }
  CB <- cbind(almon_crossbasis(temp_ext, n, LMAX, DEG), almon_crossbasis(pzi_ext, n, LMAX, DEG))
  if (any(is.na(CB))) stop("crossbasis has NA so the extended climate is short")
  CB <- scale(CB)                       # centre and scale each column like MATLAB did
  CB <- matrix(as.numeric(CB), nrow = n)  # drop the attributes scale leaves behind
  X  <- cbind(X, CB)
  for (v in c("temp", "pzi")) {
    for (j in 0:DEG) colNames <- c(colNames, sprintf("%s_lagpoly%d", v, j))
  }
  colnames(X) <- colNames
  offs <- log(pop)                      # population offset
  list(X = X, offs = offs, colNames = colNames)
}

#recovers the lag response curve from the Almon coefficients
lag_curves <- function(beta, LMAX, DEG, useTrend, nHarm) {
  base <- 1 + as.numeric(useTrend) + 2 * nHarm
  w    <- (0:LMAX) / max(LMAX, 1)
  B    <- matrix(0, LMAX + 1, DEG + 1)
  for (j in 0:DEG) B[, j + 1] <- w^j
  lagT <- as.vector(B %*% beta[(base + 1):(base + DEG + 1)])
  lagP <- as.vector(B %*% beta[(base + DEG + 2):(base + 2 * DEG + 2)])
  list(lagT = lagT, lagP = lagP)
}

nb_negloglik <- function(p, X, y, offs) {
  b   <- p[-length(p)]
  kap <- exp(min(max(p[length(p)], -10), 15))
  mu  <- exp(pmin(pmax(as.vector(X %*% b) + offs, -30), 30))
  f   <- -sum(lgamma(y + kap) - lgamma(kap) - lgamma(y + 1)
              + kap * log(kap / (kap + mu)) + y * log(mu / (kap + mu)))
  if (!is.finite(f)) f <- 1e10
  f
}

# the ODE particle swarm objective so the estimation criteria can be matched
rrmse_obj <- function(b, X, y, offs) {
  mu <- exp(pmin(pmax(as.vector(X %*% b) + offs, -30), 30))
  f  <- sqrt(mean((mu - y)^2)) / mean(y)
  if (!is.finite(f)) f <- 1e10
  f
}

# NB GLM by max likelihood or by the ODE script RRMSE objective
# Start from a least squares fit on the log scale then run Nelder Mead then
# BFGS then Nelder Mead again which is robust for this 15 parameter surface
#  mirrors the fminsearch fminunc fminsearch chain in the MATLAB code
fit_nbglm <- function(Xtr, ytr, offtr, Xall, offall, objMode) {
  b0 <- as.vector(qr.solve(Xtr, log(pmax(ytr, 0.5)) - offtr))
  objMode <- tolower(objMode)
  if (objMode == "nb_mle") {
    p   <- c(b0, log(30))
    obj <- function(p) nb_negloglik(p, Xtr, ytr, offtr)
  } else if (objMode == "rrmse") {
    p   <- b0
    obj <- function(p) rrmse_obj(p, Xtr, ytr, offtr)
  } else {
    stop("FIT_OBJECTIVE must be nb_mle or rrmse")
  }
  
  nmCtrl <- list(maxit = 20000, reltol = 1e-12)
  p <- optim(p, obj, method = "Nelder-Mead", control = nmCtrl)$par
  p <- tryCatch(optim(p, obj, method = "BFGS",
                      control = list(maxit = 50000, reltol = 1e-12, ndeps = rep(1e-6, length(p))))$par,
                error = function(e) p)
  p <- optim(p, obj, method = "Nelder-Mead", control = nmCtrl)$par
  
  if (objMode == "nb_mle") {
    beta   <- p[-length(p)]
    logkap <- p[length(p)]
  } else {
    beta <- p
    # plug in kappa so the reported dispersion is on the same footing
    muT    <- exp(pmin(as.vector(Xtr %*% beta) + offtr, 30))
    logkap <- log(max(mean(muT)^2 / max(var(ytr - muT) - mean(muT), .Machine$double.eps), 1e-3))
  }
  muAll <- exp(pmin(as.vector(Xall %*% beta) + offall, 30))
  list(beta = beta, logkap = logkap, muAll = muAll)
}

nb_loglik <- function(kappa, y, mu) {
  kappa <- max(kappa, .Machine$double.xmin)
  sum(lgamma(y + kappa) - lgamma(kappa) - lgamma(y + 1)
      + kappa * log(kappa / (kappa + mu))
      + y     * log(mu    / (kappa + mu)))
}

#IC
nb_ic <- function(y, mu, kfree, label) {
  y  <- as.vector(y)
  mu <- as.vector(mu)
  if (length(y) != length(mu)) {
    stop(sprintf("%s: data has %d months, model has %d. The objective returned a short solution.",
                 label, length(y), length(mu)))
  }
  if (any(!is.finite(mu)) || any(mu <= 0)) stop(sprintf("%s: mu must be finite and strictly positive.", label))
  if (any(y < 0)) stop(sprintf("%s: negative counts.", label))
  n <- length(y)
  S <- list()
  
  # both RRMSE conventions from the same trajectory
  r <- y - mu
  S$rrmse_mean <- sqrt(mean(r^2)) / mean(y)
  S$rrmse_obs  <- if (all(y > 0)) sqrt(mean((r / y)^2)) else NA_real_
  
  # integer check
  nFrac <- sum(abs(y - round(y)) > 1e-9)
  if (nFrac > 0) {
    message(sprintf(paste0("%s: %d of %d monthly counts are fractional (weekly to monthly allocation). ",
                           "The NB expression is a quasi likelihood not a probability mass. ",
                           "Rounded series values printed for comparison."), label, nFrac, n))
  }
  
  # kappa hat by a one dimensional search on log kappa
  opt     <- optimize(function(q) -nb_loglik(exp(q), y, mu), lower = log(1e-3), upper = log(1e6), tol = 1e-8)
  S$kappa <- exp(opt$minimum)
  S$logL  <- nb_loglik(S$kappa, y, mu)
  
  # criteria with p = kfree + 1 where the extra one is kappa
  p       <- kfree + 1
  S$n     <- n
  S$kfree <- kfree
  S$p     <- p
  S$aic   <- -2 * S$logL + 2 * p
  S$aicc  <- if (n - p - 1 > 0) S$aic + 2 * p * (p + 1) / (n - p - 1) else NA_real_
  S$bic   <- -2 * S$logL + p * log(n)
  
  # same criteria on the rounded series
  yr          <- round(y)
  optr        <- optimize(function(q) -nb_loglik(exp(q), yr, mu), lower = log(1e-3), upper = log(1e6), tol = 1e-8)
  S$kappa_int <- exp(optr$minimum)
  S$logL_int  <- nb_loglik(S$kappa_int, yr, mu)
  S$aic_int   <- -2 * S$logL_int + 2 * p
  S$bic_int   <- -2 * S$logL_int + p * log(n)
  
  # like for like Gaussian with all constants and the same p
  s2           <- mean(r^2)
  S$logL_gauss <- -0.5 * n * (log(2 * pi) + log(s2) + 1)
  S$aic_gauss  <- -2 * S$logL_gauss + 2 * p
  
  cat(sprintf("\n%s information criteria (negative binomial, plug-in)\n", label))
  cat(sprintf("  n = %d | free structural k = %d | p = k+1 = %d\n", n, kfree, p))
  cat(sprintf("  RRMSE mean-normalised (objective) : %.6f\n", S$rrmse_mean))
  cat(sprintf("  RRMSE per-observation (paper eq.) : %.6f\n", S$rrmse_obs))
  cat(sprintf("  kappa_hat                         : %.4f\n", S$kappa))
  cat(sprintf("  logL   : %.4f\n", S$logL))
  cat(sprintf("  AIC    : %.4f\n", S$aic))
  cat(sprintf("  AICc   : %.4f\n", S$aicc))
  cat(sprintf("  BIC    : %.4f\n", S$bic))
  cat(sprintf("  rounded series : kappa %.4f | AIC %.4f (%+.2f) | BIC %.4f\n",
              S$kappa_int, S$aic_int, S$aic_int - S$aic, S$bic_int))
  cat(sprintf("  Gaussian all-constants, same p : AIC %.4f, so NB is %+.2f\n",
              S$aic_gauss, S$aic - S$aic_gauss))
  S
}

# prints a results block in R syntax that can be pasted 
print_block <- function(modelName, county, fitFull, fitCommon, aicF, aiccF, bicF,
                        aicC, aiccC, bicC, kpar, nobs, fcR, fcP, fcO, pers, seas, tmean) {
  fmt <- function(v) paste(sprintf("%.4f", v), collapse = ", ")
  cat("B <- list()\n")
  cat(sprintf('B$model <- "%s"; B$region <- "%s"\n', modelName, county))
  cat(sprintf("B$fitRRMSE_full   <- %.4f   # months 1-132\n", fitFull))
  cat(sprintf("B$fitRRMSE_common <- %.4f   # months 25-132\n", fitCommon))
  cat(sprintf("B$aic_full <- %.4f; B$aicc_full <- %.4f; B$bic_full <- %.4f\n", aicF, aiccF, bicF))
  cat(sprintf("B$aic_common <- %.4f; B$aicc_common <- %.4f; B$bic_common <- %.4f\n", aicC, aiccC, bicC))
  cat(sprintf("B$k <- %d; B$n <- %d\n", kpar, nobs))
  cat(sprintf("B$fcRRMSE <- c(%s)\n", fmt(fcR)))
  cat(sprintf("B$fcPers  <- c(%s)\n", fmt(pers)))
  cat(sprintf("B$fcSeas  <- c(%s)\n", fmt(seas)))
  cat(sprintf("B$fcMean  <- c(%s)\n", fmt(tmean)))
  cat("B$fcPred <- rbind(\n")
  for (h in 1:3) cat(sprintf("  c(%s)%s\n", fmt(fcP[h, ]), ifelse(h < 3, ",", "")))
  cat(")\n")
  cat("B$fcObs <- rbind(\n")
  for (h in 1:3) cat(sprintf("  c(%s)%s\n", fmt(fcO[h, ]), ifelse(h < 3, ",", "")))
  cat(")\n")
  cat("BLOCKS[[length(BLOCKS) + 1]] <- B\n")
}

# ------------------------- shared time vectors ----------------------------
# month boundaries in days with 133 values which is used for plotting
t_inf_data <- c(
  0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365, 396,
  424, 455, 485, 516, 546, 577, 608, 638, 669, 699, 730, 761, 789, 820,
  850, 881, 911, 942, 973, 1003, 1034, 1064, 1095, 1126, 1155, 1186, 1216, 1247,
  1277, 1308, 1339, 1369, 1400, 1430, 1461, 1492, 1520, 1551, 1581, 1612, 1642, 1673,
  1704, 1734, 1765, 1795, 1826, 1857, 1885, 1916, 1946, 1977, 2007, 2038, 2069, 2099,
  2130, 2160, 2191, 2222, 2250, 2281, 2311, 2342, 2372, 2403, 2434, 2464, 2495, 2525,
  2556, 2587, 2616, 2647, 2677, 2708, 2738, 2769, 2800, 2830, 2861, 2891, 2922, 2953,
  2981, 3012, 3042, 3073, 3103, 3134, 3165, 3195, 3226, 3256, 3287, 3318, 3346, 3377,
  3407, 3438, 3468, 3499, 3530, 3560, 3591, 3621, 3652, 3683, 3711, 3742, 3772, 3803,
  3833, 3864, 3895, 3925, 3956, 3986, 4017
)

# mid month day of each of the 132 months which is the temperature PZI and population grid
tind <- c(
  15.5, 45, 74.5, 105, 135.5, 166, 196.5, 227.5, 258, 288.5, 319, 349.5,
  380.5, 410, 439.5, 470, 500.5, 531, 561.5, 592.5, 623, 653.5, 684, 714.5,
  745.5, 775, 804.5, 835, 865.5, 896, 926.5, 957.5, 988, 1018.5, 1049, 1079.5,
  1110.5, 1140.5, 1170.5, 1201, 1231.5, 1262, 1292.5, 1323.5, 1354, 1384.5, 1415, 1445.5,
  1476.5, 1506, 1535.5, 1566, 1596.5, 1627, 1657.5, 1688.5, 1719, 1749.5, 1780, 1810.5,
  1841.5, 1871, 1900.5, 1931, 1961.5, 1992, 2022.5, 2053.5, 2084, 2114.5, 2145, 2175.5,
  2206.5, 2236, 2265.5, 2296, 2326.5, 2357, 2387.5, 2418.5, 2449, 2479.5, 2510, 2540.5,
  2571.5, 2601.5, 2631.5, 2662, 2692.5, 2723, 2753.5, 2784.5, 2815, 2845.5, 2876, 2906.5,
  2937.5, 2967, 2996.5, 3027, 3057.5, 3088, 3118.5, 3149.5, 3180, 3210.5, 3241, 3271.5,
  3302.5, 3332, 3361.5, 3392, 3422.5, 3453, 3483.5, 3514.5, 3545, 3575.5, 3606, 3636.5,
  3667.5, 3697, 3726.5, 3757, 3787.5, 3818, 3848.5, 3879.5, 3910, 3940.5, 3971, 4001.5
)

# day stamps of the 12 annual population estimates
t_pop_data <- c(
  0, 181, 546, 911, 1277, 1642, 2007, 2372, 2647, 3103, 3468, 3833
)

nMonths <- 132
estRows <- 1:nMonths     # the full outcome window since the pre sample climate
# supplies every lag for month 1
cat(sprintf("NB distributed-lag GLM | lags 0-%d mo, Almon degree %d\n", LMAX, DEG))
cat(sprintf("Estimation window: months %d-%d (n = %d), same as the ODE models\n",
            estRows[1], estRows[length(estRows)], length(estRows)))
cat(sprintf("Objective: %s\n", FIT_OBJECTIVE))

# regions data
# case and climate series are copied straight from the MATLAB script
# temp_pre and pzi_pre are Jan 2011 to Dec 2012 and are used only to feed the
# distributed lags so the model is estimable on the full outcome window
# pzi_pre already has the same plus 10 shift as pzi_data
region_data <- function(Region) {
  if (Region == 1) {
    county <- "AZ"
    y_inf_data <- c(
      798.9142857, 726.2857143, 461.5714286, 326, 356.4285714, 425, 431.5714286, 431.4285714,
      463.7142857, 401.1428571, 489.7142857, 682.1428571, 696, 564.8571429, 591.8571429, 574,
      529.2857143, 595, 505.1428571, 319.5714286, 347.8571429, 352.2857143, 325.7142857, 338.8571429,
      435.5714286, 410, 380, 432.5714286, 517.4285714, 471.7142857, 700.1428571, 727.7142857,
      778.7142857, 944.5714286, 786.1428571, 800, 684, 581.2857143, 464.1428571, 574.4285714,
      529.1428571, 459, 454.8571429, 483.2857143, 495.4285714, 392.4285714, 553, 590,
      577, 532.1428571, 416, 408.7142857, 457.1428571, 442.7142857, 417.2857143, 522.8571429,
      522.2857143, 444.8571429, 643.4285714, 953.8571429, 1184.714286, 898.2857143, 584.4285714, 564.2857143,
      552, 663, 611, 689.5714286, 609.8571429, 538, 622.7142857, 523.4285714,
      630.4285714, 745.5714286, 658, 811.4285714, 749.7142857, 797.7142857, 818.2857143, 943.2857143,
      971, 798.2857143, 902.4285714, 1115.285714, 1059, 930, 830, 635.2857143,
      475.7142857, 630.5714286, 747.1428571, 800.2857143, 1067.142857, 1188.285714, 1175.571429, 1382.857143,
      1560.142857, 1323.285714, 1113.428571, 1147.285714, 863.1428571, 854.4285714, 809, 814.4285714,
      810.7142857, 736.7142857, 842, 1009.857143, 1223.714286, 952.8571429, 673.5714286, 704.5714286,
      787, 948.1428571, 911.2857143, 1072.571429, 715.7142857, 625.8571429, 617.1428571, 691.2857143,
      759, 704.4285714, 615.2857143, 773.5714286, 702.4285714, 750.7142857, 706, 869.2857143,
      974.4285714, 929.8571429, 1126, 1335, 1417
    )
    temp_data <- c(
      38.6, 42.2, 54.8, 59.4, 67.4, 79.5, 81, 78.5, 72.4, 58.8, 51.3, 41.5,
      46.5, 50, 53.9, 59.1, 66.8, 77.7, 81.4, 76.5, 74.2, 64.9, 51.7, 44.3,
      45.1, 52, 56.3, 58.4, 62.9, 78.4, 78.6, 80.6, 75, 64.5, 48.3, 40.9,
      41.8, 50.6, 54.9, 58.5, 64.6, 80.3, 82.4, 77.5, 71.6, 66.1, 53.1, 44.7,
      42.3, 49.4, 56.6, 59.9, 66.1, 79.8, 81.5, 79.1, 72.4, 65.1, 57.6, 46.6,
      47.6, 46.7, 52.3, 62.9, 68.5, 78.6, 82.3, 80.2, 76, 59.9, 49.4, 42.8,
      42.4, 40.9, 51.7, 60.3, 60.7, 75.2, 81.9, 81.9, 73.8, 60, 52.1, 42.2,
      43.7, 45.9, 51, 59.3, 70.5, 76.8, 82.8, 84.1, 75.6, 66.2, 53.5, 42,
      42.6, 46.5, 49.4, 61.2, 67.9, 80.6, 81.4, 79.5, 74.8, 59.9, 55.8, 45.6,
      43.5, 44, 51.8, 60.5, 68.6, 78.6, 82.2, 79, 75.9, 61.8, 46.1, 42.8,
      40.3, 41.9, 47.2, 58.4, 66.5, 72.4, 85.4, 80.7, 73.6, 64.4, 52.6, 45.4
    )
    pzi_data <- c(
      10.62, 9.22, 8.26, 7.91, 8.25, 7.71, 11.94, 10.43, 11.66, 8.52, 12.04, 8.76,
      7.16, 6.9, 8.03, 7.26, 7.22, 6.88, 9.67, 12.5, 12.95, 8.7, 7.98, 10.2,
      10.95, 8.23, 8.67, 8.47, 10.74, 10.34, 10.35, 9.59, 10.03, 11.91, 9.92, 8.87,
      10.34, 7.49, 6.66, 8.81, 8.83, 8.16, 8.32, 11.03, 10.42, 7.91, 9.67, 11.41,
      12, 10.17, 7.85, 8.52, 10.04, 8.96, 12.46, 8.01, 8.45, 7.26, 6.84, 7.38,
      7.64, 9.06, 7.82, 5.99, 7.16, 7.63, 11.46, 9.36, 8.46, 14.53, 8.8, 8.9,
      10.48, 13.67, 10.25, 9.89, 11.96, 10.88, 7.47, 6.54, 10.97, 7.91, 14.44, 11.23,
      8.92, 10.21, 12.52, 10.47, 11.24, 9.56, 6.77, 5.54, 6.75, 7.38, 8.08, 8.18,
      9.89, 7.85, 8.99, 7.1, 7, 7.21, 14.84, 9.74, 9.84, 9.69, 7.21, 10.62,
      8.14, 8.52, 8.52, 6.77, 6.97, 8.74, 10.66, 12.3, 10.1, 10.64, 9.4, 10.35,
      12.34, 10.55, 12.46, 9.84, 11.96, 10.83, 6.61, 8.88, 9.72, 7.75, 8.67, 9.03
    )
    y_pop_data <- c(
      6594981, 6634984, 6733840, 6832810, 6944767, 7048088,
      7158024, 7275070, 7151502, 7272499, 7366720, 7431344
    )
    # degF from the NOAA Climate at a Glance series for Jan 2011 through Dec 2012
    temp_pre <- c(
      41.5000, 41.7000, 53.3000, 58.9000, 63.2000, 75.7000, 80.8000, 82.2000,
      74.6000, 62.8000, 49.4000, 39.9000, 45.3000, 45.6000, 51.6000, 60.6000,
      69.3000, 78.7000, 79.9000, 80.5000, 73.7000, 63.8000, 53.8000, 42.4000
    )
    # raw NOAA Z index plus 10 for the same 24 months
    pzi_pre <- c(
      7.7900, 9.9900, 7.9500, 7.9600, 8.5500, 7.5800, 9.5700, 7.3900,
      9.9200, 9.1500, 10.1400, 10.7800, 7.8900, 8.3700, 8.6000, 7.3500,
      7.1400, 7.1800, 11.5100, 9.8200, 9.4300, 7.9800, 7.8900, 10.3700
    )
  } else if (Region == 2) {
    county <- "MARICOPA"
    y_inf_data <- c(
      565.4, 514, 323.7142857, 232.7142857, 258.1428571, 294.1428571, 286, 305,
      324.2857143, 281.4285714, 337.2857143, 500.2857143, 460, 406.7142857, 439, 418.2857143,
      372.2857143, 419.7142857, 353.1428571, 227, 224.7142857, 253.2857143, 223.1428571, 225.2857143,
      315.4285714, 244, 268, 312.2857143, 364.2857143, 331.5714286, 448.8571429, 501.7142857,
      557.5714286, 674.2857143, 553.4285714, 586.2857143, 505.7142857, 414.5714286, 340.4285714, 427.8571429,
      369.1428571, 318.8571429, 333.7142857, 327.5714286, 369.7142857, 284, 425.1428571, 427.1428571,
      398.8571429, 370.4285714, 290, 264, 305.7142857, 310.7142857, 290.8571429, 345.5714286,
      364.1428571, 323.5714286, 477.8571429, 721.1428571, 905, 702.7142857, 437.5714286, 428.7142857,
      421, 481, 430, 494.5714286, 448, 389.8571429, 461.7142857, 362.4285714,
      464.4285714, 555, 440.4285714, 567.5714286, 514, 545.2857143, 556.1428571, 657.8571429,
      666.7142857, 575, 631.7142857, 806.2857143, 754, 677, 597, 463.4285714,
      305.5714286, 415.4285714, 500.7142857, 535.4285714, 735, 860, 882.4285714, 1035.571429,
      1150.428571, 994.2857143, 804.7142857, 829.4285714, 637.5714286, 620.8571429, 605.7142857, 571.4285714,
      613.8571429, 529.4285714, 646.1428571, 773.2857143, 919.2857143, 708.8571429, 514.2857143, 501.7142857,
      593.1428571, 692.5714286, 669.7142857, 773.7142857, 525.5714286, 442.7142857, 430.4285714, 514.1428571,
      558.1428571, 501.4285714, 433.2857143, 548.8571429, 511.4285714, 542, 491.1428571, 609.7142857,
      704, 689.1428571, 842.4285714, 989.1428571, 1072.428571
    )
    temp_data <- c(
      50, 52.9, 65, 69.8, 78.2, 88.5, 91.4, 89.6, 83.2, 69.2, 62.1, 52.3,
      56.5, 59.8, 64.5, 69.8, 77.9, 87.2, 91.3, 86.4, 84.4, 74.7, 61.8, 53.9,
      55.1, 61.5, 67.2, 68.8, 73, 88.1, 89.4, 92.3, 85.6, 74.7, 58, 50.7,
      51.7, 61.8, 65.6, 69.2, 74.7, 90.2, 93.2, 88.8, 82.4, 76.6, 63.6, 54.8,
      52, 58.5, 66.8, 70.7, 76.9, 89.4, 91.8, 90.4, 82.8, 76.2, 67.4, 56.9,
      58.4, 56.2, 62.6, 73, 78.1, 87.1, 91.9, 90.3, 87.4, 69.6, 59.7, 52.5,
      52.8, 50.2, 61.4, 70.3, 71.1, 85.6, 92.4, 92.6, 84.2, 71, 62.2, 52.5,
      53.5, 55.7, 60.3, 69, 81.2, 86.7, 94, 94.7, 87, 76.6, 63.9, 52.9,
      53.2, 57, 59.9, 71.6, 77.4, 89.9, 90.2, 88.8, 84.7, 69.9, 66.2, 55.2,
      53.7, 55, 62.5, 70.7, 78, 89, 92, 89, 86, 72.4, 55.5, 51.5,
      50, 52.6, 56.8, 68.7, 76.5, 81.7, 96, 92, 84.2, 74.9, 63.2, 55.6
    )
    pzi_data <- c(
      11.19, 9.57, 9.05, 8.3, 8.4, 8.6, 10.31, 9.64, 10.95, 8.72, 13.29, 8.92,
      7.68, 7.11, 8.73, 7.78, 7.86, 8.47, 10.07, 13.74, 15.11, 9.01, 8.2, 10.15,
      10.2, 7.97, 8.1, 8.49, 10.23, 9.47, 8.95, 7.89, 9.81, 11.29, 9.41, 8.75,
      10.84, 7.72, 6.72, 8.7, 8.68, 8.92, 7.67, 10.57, 8.92, 8.19, 9.67, 10.84,
      11, 11.25, 8.09, 8.62, 9.25, 8.84, 12.26, 8.76, 8.04, 7.75, 7.43, 7.89,
      7.82, 8.77, 7.47, 7.25, 7.91, 8.98, 13.33, 10.48, 8.17, 16.69, 9.11, 8.62,
      9.84, 13.51, 10.12, 9.43, 10.42, 9.92, 8.32, 7.2, 13.61, 8.33, 14.64, 10.86,
      8.77, 10.93, 13.42, 11.24, 11.26, 8.67, 7.06, 7.09, 7.46, 7.71, 8.02, 8.8,
      9.8, 7.94, 8.14, 7.53, 7.91, 8.81, 15.97, 12.66, 9.59, 9.52, 7.61, 11.6,
      8.49, 8.95, 7.88, 7.87, 8.12, 9.31, 10.8, 12.56, 9.97, 10.21, 9.47, 11.1,
      11.67, 10.64, 11.91, 11.03, 11.01, 9.89, 7.22, 7.43, 9.54, 7.93, 8.66, 9.77
    )
    y_pop_data <- c(
      3912523, 3944859, 4094842, 4174423, 4258019, 4307033,
      4405306, 4492261, 4420568, 4500147, 4586431, 4585871
    )
    # degF from the NOAA Climate at a Glance series for Jan 2011 through Dec 2012
    temp_pre <- c(
      52.3000, 51.7000, 63.2000, 69.7000, 73.7000, 84.9000, 90.8000, 93.5000,
      86.1000, 74.2000, 59.5000, 49.9000, 55.4000, 55.9000, 61.3000, 70.3000,
      79.2000, 87.7000, 89.7000, 91.1000, 84.3000, 73.9000, 63.8000, 52.7000
    )
    # raw NOAA Z index plus 10 for the same 24 months
    pzi_pre <- c(
      8.0500, 9.9100, 7.8500, 8.4000, 8.4000, 8.5400, 9.5000, 7.3800,
      8.3600, 8.4200, 10.2700, 10.6100, 8.0900, 7.8200, 8.4900, 7.9000,
      7.8100, 8.5000, 11.3800, 9.9000, 9.9500, 8.1300, 8.1200, 10.1000
    )
  } else if (Region == 3) {
    county <- "PIMA"
    y_inf_data <- c(
      128.0714286, 116.4285714, 70.57142857, 42.28571429, 62.57142857, 71.71428571, 88.28571429, 71.28571429,
      88.85714286, 72.28571429, 80.28571429, 106.4285714, 137, 82.28571429, 91.85714286, 77.28571429,
      81.57142857, 82, 80.42857143, 46.57142857, 62, 52.28571429, 61, 57.14285714,
      58.57142857, 96, 66, 58.57142857, 71.28571429, 75, 148.1428571, 115.7142857,
      112.8571429, 146.2857143, 114.1428571, 109.1428571, 86.85714286, 80.28571429, 64.71428571, 79.42857143,
      73.57142857, 79.57142857, 73.28571429, 75.85714286, 55.71428571, 68.14285714, 60.71428571, 90,
      95.71428571, 83.85714286, 64.14285714, 74.28571429, 87.42857143, 67, 63.85714286, 105.4285714,
      75.85714286, 58.14285714, 82.42857143, 128.5714286, 146, 90.42857143, 83.85714286, 71.71428571,
      59.42857143, 83.28571429, 97.28571429, 103.2857143, 87.71428571, 76.28571429, 76, 75,
      62.71428571, 85.71428571, 111.8571429, 127.5714286, 115.7142857, 115.5714286, 122, 146.5714286,
      143, 100.1428571, 118.4285714, 123.4285714, 131, 101, 110, 92.57142857,
      82.57142857, 102.8571429, 122.2857143, 125.2857143, 164.5714286, 143.1428571, 127.7142857, 162.4285714,
      165.5714286, 138.5714286, 138.2857143, 140.7142857, 88.14285714, 110, 104.5714286, 117.7142857,
      84.28571429, 80.14285714, 92.14285714, 98.85714286, 123.5714286, 95.42857143, 57.14285714, 83.85714286,
      83.57142857, 112.2857143, 113.8571429, 139.7142857, 100.5714286, 81.71428571, 89.14285714, 79,
      93.71428571, 103.4285714, 87.57142857, 89, 87.28571429, 100.5714286, 104, 109.4285714,
      115.2857143, 93.42857143, 113.4285714, 132, 134.5714286
    )
    temp_data <- c(
      48, 49.5, 62.7, 66.7, 74.4, 85.6, 85.3, 83.9, 79.8, 67.1, 60.2, 50.8,
      55.5, 58.1, 61.7, 66.6, 74.2, 85.2, 85.9, 82.1, 80.4, 72.2, 60, 52.1,
      53.4, 59.7, 63.5, 65.6, 69.5, 84.6, 84.2, 86.9, 81, 71.9, 57, 49.5,
      50.3, 59.6, 62.7, 65.9, 71.1, 86.1, 88.2, 83.4, 77.9, 74.2, 61.1, 53.7,
      50.3, 57.1, 65.1, 68.3, 73.1, 85.9, 86, 84.8, 78.9, 74.7, 66.3, 55.1,
      56.9, 55, 60.5, 70.6, 74.7, 84.1, 86.7, 85.1, 83.1, 67.4, 57.6, 51.1,
      51.7, 48.6, 59, 67, 67.5, 81.4, 87.6, 87.2, 79.9, 68.7, 61.2, 51.6,
      52.2, 52.8, 58, 66.1, 77.3, 83.2, 88.6, 89.6, 82.8, 73.9, 62.7, 50.9,
      51.5, 54.8, 57.2, 68.5, 74.4, 86.6, 84.7, 83.9, 80.7, 68, 64.2, 54.2,
      52, 52, 59.5, 67.8, 75.2, 84.9, 86.7, 83.3, 81.5, 68.9, 54.1, 50.5,
      49, 50.3, 55.5, 65.9, 73.1, 79.1, 91.1, 87.3, 82, 73.1, 61.8, 54
    )
    pzi_data <- c(
      9.94, 10.4, 8.27, 8.04, 8.16, 8.23, 10.48, 10.21, 10.37, 8.27, 13.32, 9.16,
      7.62, 7.18, 8.27, 8.11, 8.05, 7.98, 10.59, 11.6, 12.03, 10.55, 8.23, 10.35,
      12.34, 8.45, 8.32, 9.19, 10.13, 11.13, 9.25, 8.08, 12.24, 11.52, 9.11, 9.08,
      10.78, 7.84, 6.91, 9.45, 8.42, 9.86, 8.24, 9.57, 10.93, 7.81, 8.95, 10.14,
      10.71, 9.14, 6.89, 7.94, 8.67, 8.17, 12.31, 7.77, 7.77, 7.36, 7.42, 8.26,
      7.21, 10.82, 8, 7.34, 8.03, 10.14, 11.34, 9.7, 9.35, 14.9, 8.92, 9.8,
      10.23, 13.59, 10.56, 10.04, 10.95, 10.3, 7.42, 8.54, 13.23, 8.06, 14.66, 11.59,
      9.49, 10.36, 11.7, 10.99, 10.51, 9.04, 6.36, 6.36, 6.86, 7.46, 8.05, 8.45,
      10.66, 8.26, 8.38, 7.95, 8.03, 8.88, 18.62, 12.45, 9.39, 8.38, 7.63, 9.82,
      8.41, 8.51, 7.73, 7.73, 7.96, 10.1, 10.83, 12.76, 10.19, 10.15, 8.83, 10.62,
      11.38, 10.98, 10.49, 9.88, 10.42, 9.39, 6.58, 8.2, 8.69, 7.92, 8.52, 10.4
    )
    y_pop_data <- c(
      996046.5, 998668, 1005699, 1012028, 1018638, 1024476,
      1030517, 1036290, 1043433, 1051707, 1063162, 1063993
    )
    # degF from the NOAA Climate at a Glance series for Jan 2011 through Dec 2012
    temp_pre <- c(
      50.6000, 49.9000, 61.5000, 67.2000, 70.6000, 82.8000, 86, 87.8000,
      81.6000, 71.1000, 57, 47, 53.8000, 53.6000, 58.2000, 67.6000,
      76, 84.6000, 84.3000, 85.9000, 79.7000, 71.2000, 62.4000, 51.7000
    )
    # raw NOAA Z index plus 10 for the same 24 months
    pzi_pre <- c(
      7.8700, 9.4500, 7.3800, 8.7500, 8.3900, 8.1300, 9.8400, 7.5100,
      10.0700, 8.1600, 10.9000, 11.6400, 8.2100, 8.5600, 8.5900, 8.3900,
      8.7400, 9.1000, 11.0900, 8.4400, 11.6600, 7.7800, 8.2200, 9.8700
    )
  } else if (Region == 4) {
    county <- "PINAL"
    y_inf_data <- c(
      53.74285714, 48.85714286, 36.28571429, 15.42857143, 17.71428571, 34.14285714, 33.57142857, 30.57142857,
      35.42857143, 25.42857143, 34.14285714, 41.42857143, 61, 38.85714286, 35.14285714, 54.85714286,
      43.71428571, 57.42857143, 40.14285714, 27.42857143, 33.42857143, 28.14285714, 22.28571429, 30,
      33.57142857, 37, 32, 37.57142857, 48.28571429, 42.14285714, 48.71428571, 60.42857143,
      68.71428571, 71.28571429, 78.85714286, 73.14285714, 56.85714286, 47.85714286, 42.14285714, 42.14285714,
      57.85714286, 32.71428571, 28.42857143, 50.85714286, 30.71428571, 26.42857143, 42.71428571, 47.85714286,
      49.28571429, 47.42857143, 24.57142857, 42, 36.57142857, 39.28571429, 33.57142857, 33.85714286,
      46.71428571, 26, 46.85714286, 64.71428571, 85.42857143, 65.57142857, 34.85714286, 36.57142857,
      47.42857143, 56.57142857, 43, 52.85714286, 37.57142857, 32, 51.85714286, 42.14285714,
      63.57142857, 52.14285714, 57.57142857, 66.57142857, 56.71428571, 75.71428571, 77.71428571, 81.57142857,
      80, 65.28571429, 91.85714286, 121.8571429, 118, 83.28571429, 71.71428571, 36.28571429,
      45.85714286, 71.42857143, 77.57142857, 87.85714286, 99.85714286, 118, 112.1428571, 121.7142857,
      162.2857143, 117.1428571, 99, 105.8571429, 76.57142857, 62.57142857, 58.14285714, 73.71428571,
      62.42857143, 61.28571429, 65.85714286, 78.57142857, 133.8571429, 99.85714286, 66.42857143, 74,
      69.71428571, 79.28571429, 73.85714286, 95.28571429, 49.28571429, 50.85714286, 50.71428571, 61.14285714,
      70.57142857, 56.57142857, 49, 62.57142857, 49.71428571, 57.57142857, 59.57142857, 100.5714286,
      93.85714286, 77.57142857, 106.4285714, 131.4285714, 141.1428571
    )
    temp_data <- c(
      48.2, 50.5, 62.6, 67.6, 76.5, 87.3, 88.2, 86.7, 81.4, 68.4, 60.7, 50.5,
      54.4, 58.4, 62.5, 68.3, 76.3, 86.8, 88.6, 84.3, 81.9, 73.2, 60.2, 52.2,
      52.8, 59.5, 64.6, 66.6, 71.6, 86.9, 87, 88.9, 82, 72.5, 56.4, 48.7,
      50.1, 59.3, 63.4, 67.1, 73.6, 88, 90.1, 85.2, 80.3, 75.4, 62.1, 53.5,
      50.8, 57.3, 65, 68.2, 74.9, 87.8, 88, 86.4, 81.1, 75, 66.2, 54.9,
      56.4, 55.6, 61.1, 71.5, 76.9, 85.8, 89, 87, 84.3, 68.7, 58, 51,
      50.9, 49.3, 59.3, 68.4, 69.7, 84.3, 90.3, 89.7, 82.5, 70.3, 61.3, 51.2,
      51.5, 53.4, 58.8, 67.6, 79.4, 85.3, 91.1, 92, 84.6, 75, 62.6, 51,
      52, 55.8, 58.2, 69.8, 76.5, 88.4, 86.7, 85.7, 82.2, 69.2, 64.7, 54.8,
      51.9, 52.3, 59.9, 68.9, 76.8, 87.3, 89.4, 85.8, 84, 70.7, 55, 50.4,
      48.8, 51.1, 55.8, 67, 75.4, 81.2, 93.7, 90, 82.8, 74.4, 62.3, 53.9
    )
    pzi_data <- c(
      10.82, 9.64, 9.2, 8.65, 8.65, 8.4, 11.98, 8.05, 9.7, 8.48, 12.07, 8.79,
      7.53, 6.86, 8.95, 7.4, 7.51, 7.88, 8.81, 10.79, 14.72, 10.25, 7.99, 10.15,
      11.68, 8.12, 7.78, 9.04, 10.83, 10.48, 9.33, 9.75, 13.02, 11.84, 9.73, 8.65,
      10.84, 7.7, 6.75, 8.86, 8.33, 9.53, 7.85, 9.88, 9.85, 8, 9.6, 10.02,
      10.87, 8.92, 7.26, 7.86, 8.61, 8.31, 13.3, 9.2, 7.85, 7.5, 7.19, 7.94,
      7.67, 9.63, 7.46, 6.74, 7.52, 9.43, 11.6, 9.57, 10.68, 14.41, 9.01, 9.05,
      9.83, 14.28, 9.55, 9.82, 10.37, 10.31, 8.35, 6.86, 11.6, 8.08, 14.76, 11.76,
      9.24, 10.3, 11.11, 10.56, 11.07, 8.67, 6.74, 6.69, 7.18, 7.55, 8.15, 8.5,
      9.84, 7.74, 8.15, 7.18, 7.49, 8.05, 18.35, 10.85, 11.11, 8.74, 7.43, 10.29,
      9.01, 8.97, 8.48, 7.22, 7.47, 9.72, 9.13, 12.4, 9.67, 10.03, 9.01, 12.06,
      11.71, 10.98, 10.68, 10.67, 11.82, 10.26, 6.83, 7.9, 9.35, 7.75, 8.99, 10
    )
    y_pop_data <- c(
      389237, 392627, 400229, 409058, 420111, 432159,
      444369, 457288, 462789, 480299, 503184, 516263
    )
    # degF from the NOAA Climate at a Glance series for Jan 2011 through Dec 2012
    temp_pre <- c(
      49.8000, 49.7000, 62.2000, 68.6000, 72.3000, 84.5000, 88.8000, 90.5000,
      83.8000, 72.5000, 57.9000, 48, 53.4000, 54.2000, 59.1000, 68.7000,
      77.7000, 86.9000, 87, 88.1000, 81.7000, 72.6000, 62.7000, 51.7000
    )
    # raw NOAA Z index plus 10 for the same 24 months
    pzi_pre <- c(
      8.0100, 9.1500, 7.3000, 8.2000, 8.3500, 8, 9.1000, 8.2400,
      9.6200, 8.2900, 10.0100, 11.1600, 8.5400, 8.5800, 8.7400, 8.0400,
      8.0200, 8.3500, 10.7400, 11.0900, 9.1400, 7.8400, 8.0500, 10.3700
    )
  } else {
    stop("region_data: Region must be 1 (AZ), 2 (MARICOPA), 3 (PIMA) or 4 (PINAL)")
  }
  list(county = county, y_inf_data = y_inf_data, temp_data = temp_data,
       pzi_data = pzi_data, y_pop_data = y_pop_data, temp_pre = temp_pre, pzi_pre = pzi_pre)
}

# loop over the four regions
RES <- list()
for (Region in regionList) {
  rd <- region_data(Region)
  county     <- rd$county
  y_inf_data <- rd$y_inf_data
  temp_data  <- rd$temp_data
  pzi_data   <- rd$pzi_data
  y_pop_data <- rd$y_pop_data
  temp_pre   <- rd$temp_pre
  pzi_pre    <- rd$pzi_pre
  cat(sprintf("\n=====================  %s  (Region %d)  =====================\n", county, Region))
  
  if (length(temp_pre) != 24 || length(pzi_pre) != 24) {
    message(sprintf("%s: pre sample climate missing or wrong length so this region is skipped", county))
    next
  }
  stopifnot(length(y_inf_data) == 133, length(t_inf_data) == 133)
  stopifnot(length(temp_data) == 132, length(pzi_data) == 132, length(tind) == 132)
  stopifnot(max(nFitList) + 12 == 132)
  
  # extended climate with the 24 pre sample months in front of the 132 outcome months
  temp_ext <- c(temp_pre, temp_data)    # 156 values from Jan 2011 to Dec 2023
  pzi_ext  <- c(pzi_pre, pzi_data)      # 156 values and plus 10 shifted throughout
  stopifnot(length(temp_ext) == nMonths + LMAX, length(pzi_ext) == nMonths + LMAX)
  
  y     <- y_inf_data[1:nMonths]
  pop_m <- pchip_matlab(t_pop_data, y_pop_data, tind)
  Dsg   <- build_design(temp_ext, pzi_ext, pop_m, nMonths, LMAX, DEG, USE_TREND, NHARM)
  X        <- Dsg$X
  offs     <- Dsg$offs
  colNames <- Dsg$colNames
  kMean    <- ncol(X)                    # mean parameters including the intercept
  
  # full period fit on months 1 to 132 
  fit  <- fit_nbglm(X[estRows, , drop = FALSE], y[estRows], offs[estRows], X, offs, FIT_OBJECTIVE)
  beta   <- fit$beta
  logkap <- fit$logkap
  muAll  <- fit$muAll
  mu       <- muAll[estRows]
  errorOBJ <- sqrt(mean((mu - y[estRows])^2)) / mean(y[estRows])
  cat(sprintf("\n%s NB-GLM full fit | RRMSE = %.6f  (%.2f%%) on months %d-%d\n",
              county, errorOBJ, 100 * errorOBJ, estRows[1], estRows[length(estRows)]))
  saveRDS(list(errorOBJ = errorOBJ, beta = beta, logkap = logkap, colNames = colNames),
          paste0("glm_RRMSE_", county, ".rds"))
  
  # information criteria from nb_ic which is the same function the ODE script uses
  rrmse      <- errorOBJ
  data_mon   <- y[estRows]
  n          <- length(data_mon)
  k          <- kMean                    # unambiguous unlike a tree ensemble
  noiseFloor <- 100 * (sd(diff(data_mon, differences = 2)) / sqrt(6)) / mean(data_mon)
  
  ICnb <- nb_ic(data_mon, mu, k, paste("NB-GLM", county))
  aic  <- ICnb$aic
  aicc <- ICnb$aicc
  bic  <- ICnb$bic
  
  # secondary re score on months 25 to 132 for continuity with the earlier
  # common window tables. Same fitted trajectory and a shorter scoring window
  cw   <- 25:nMonths
  ICcw <- nb_ic(y[cw], mu[cw - estRows[1] + 1], k, paste("NB-GLM", county, "[25-132 re-score]"))
  rrmse_common <- 100 * sqrt(mean((mu[cw - estRows[1] + 1] - y[cw])^2)) / mean(y[cw])
  cat(sprintf("  kappa (joint MLE)                 : %.4f\n", exp(logkap)))
  cat(sprintf("  RRMSE (objective convention)      : %.6f  (noise floor %.4f)\n", rrmse, noiseFloor / 100))
  saveRDS(list(ICnb = ICnb, ICcw = ICcw, rrmse_common = rrmse_common, n = n, k = k, rrmse = rrmse,
               aic = aic, aicc = aicc, bic = bic, noiseFloor = noiseFloor, beta = beta, logkap = logkap,
               LMAX = LMAX, DEG = DEG, estRows = estRows, FIT_OBJECTIVE = FIT_OBJECTIVE),
          paste0("glm_IC_", county, ".rds"))
  
  # full fit plot
  plot(t_inf_data[1:nMonths], y, pch = 16, col = "black", xaxt = "n",
       xlab = "Year", ylab = "Cases per month", ylim = c(0, max(y) * 1.25),
       main = paste(county, "Valley Fever - NB distributed-lag GLM fit"))
  mtext(sprintf("RRMSE %.2f%%  (noise floor %.2f%%)  |  AIC %.1f  AICc %.1f  BIC %.1f  (k = %d, n = %d)",
                rrmse * 100, noiseFloor, aic, aicc, bic, k, n), side = 3, line = 0.3, cex = 0.85)
  lines(t_inf_data[estRows], mu, lwd = 3, col = adjustcolor(rgb(0.20, 0.55, 0.25), alpha.f = 0.65))
  axis(1, at = seq(0, 365 * 11, by = 365), labels = 2013:2024)
  grid()
  legend("topleft", bty = "n", legend = c(paste(county, "reported"), "NB-GLM fit"),
         col = c("black", rgb(0.20, 0.55, 0.25)), pch = c(16, NA), lwd = c(NA, 3))
  
  # estimated lag curves which are the interpretable payoff compared with XGBoost
  LC <- lag_curves(beta, LMAX, DEG, USE_TREND, NHARM)
  op <- par(mfrow = c(1, 2))
  plot(0:LMAX, LC$lagT, type = "l", lwd = 2, xlab = "Lag (months)", ylab = "log-RR per unit",
       main = paste(county, "temperature lag curve"))
  abline(h = 0, lty = 3)
  grid()
  plot(0:LMAX, LC$lagP, type = "l", lwd = 2, col = rgb(0.85, 0.33, 0.10),
       xlab = "Lag (months)", ylab = "log-RR per unit", main = paste(county, "PZI lag curve"))
  abline(h = 0, lty = 3)
  grid()
  par(op)
  
  #  expanding window forecasting
  fitRRMSE <- rep(NA_real_, 3)
  fcRRMSE  <- rep(NA_real_, 3)
  fcPers   <- rep(NA_real_, 3)
  fcSeas   <- rep(NA_real_, 3)
  fcMean   <- rep(NA_real_, 3)
  PRED     <- vector("list", 3)
  fcResid  <- vector("list", 3)
  fcPredMat <- matrix(NA_real_, 3, 12)
  fcObsMat  <- matrix(NA_real_, 3, 12)
  betaH   <- matrix(NA_real_, length(colNames), 3)
  logkapH <- rep(NA_real_, 3)
  
  for (h in 1:3) {
    nF <- nFitList[h]
    trRows <- 1:nF                        # full window since lags are fed by the pre sample climate
    fitH <- fit_nbglm(X[trRows, , drop = FALSE], y[trRows], offs[trRows], X, offs, FIT_OBJECTIVE)
    muH <- fitH$muAll
    PRED[[h]]   <- muH
    betaH[, h]  <- fitH$beta
    logkapH[h]  <- fitH$logkap
    
    # direct forecast from the climate only design with no recursion and no case leakage
    dFit <- y[trRows]
    rFit <- muH[trRows] - dFit
    dFc  <- y[(nF + 1):(nF + 12)]
    rFc  <- muH[(nF + 1):(nF + 12)] - dFc
    fitRRMSE[h] <- 100 * sqrt(mean(rFit^2)) / mean(dFit)
    fcRRMSE[h]  <- 100 * sqrt(mean(rFc^2))  / mean(dFc)
    fcResid[[h]] <- rFc
    fcPredMat[h, ] <- muH[(nF + 1):(nF + 12)]
    fcObsMat[h, ]  <- dFc
    # baselines using the ODE script lines including the month 1 based training mean
    fcPers[h] <- 100 * sqrt(mean((y[nF]              - dFc)^2)) / mean(dFc)
    fcSeas[h] <- 100 * sqrt(mean((y[(nF - 11):nF]    - dFc)^2)) / mean(dFc)
    fcMean[h] <- 100 * sqrt(mean((mean(y[1:nF])      - dFc)^2)) / mean(dFc)
  }
  
  cat(sprintf("\n%s  NB-GLM 1-year-ahead forecast, RRMSE = RMSE/mean (%%)\n", county))
  cat(sprintf("%-8s %8s %10s %10s %10s %10s\n", "year", "in-samp", "FORECAST", "persist", "seasonal", "trainmean"))
  for (h in 1:3) {
    cat(sprintf("%-8s %8.2f %10.2f %10.2f %10.2f %10.2f\n", yrLabel[h],
                fitRRMSE[h], fcRRMSE[h], fcPers[h], fcSeas[h], fcMean[h]))
  }
  cat("(in-samp is over months 1-nF, same window as the ODE models)\n")
  cat(sprintf("beats best baseline: %s\n",
              paste(fcRRMSE < pmin(fcPers, fcSeas, fcMean), collapse = " ")))
  
  # Full window values are primary and the months 25 to 132
  # re score fills the common slots for continuity with earlier tables
  print_block("NBGLM", county, 100 * errorOBJ, rrmse_common,
              aic, aicc, bic, ICcw$aic, ICcw$aicc, ICcw$bic,
              k, n, fcRRMSE, fcPredMat, fcObsMat, fcPers, fcSeas, fcMean)
  
  # full fit monthly trajectory for plotting elsewhere
  cat(sprintf("\n#### FULL-FIT TRAJECTORY - NBGLM - %s (months 1-132) ####\n", county))
  cat(sprintf("NBGLM_%s_FullFit <- c(%s)\n", county, paste(sprintf("%.4f", mu), collapse = ", ")))
  
  # parameter set. this model is its parameter vector which is
  # 14 coefficients plus kappa so any column below reproduces that forecast year
  cat(sprintf("\n#### NB-GLM PARAMETER SET - %s (objective: %s) ####\n", county, FIT_OBJECTIVE))
  cat(sprintf("# config: LMAX=%d DEG=%d trend=%d nHarm=%d  (k=%d mean params + kappa)\n",
              LMAX, DEG, as.numeric(USE_TREND), NHARM, k))
  cat(sprintf("#%-22s %14s %14s %14s %14s\n", "coefficient", "full(1-132)",
              "win2021(1-96)", "win2022(1-108)", "win2023(1-120)"))
  for (cc in seq_along(colNames)) {
    cat(sprintf("# %-22s %14.6f %14.6f %14.6f %14.6f\n", colNames[cc],
                beta[cc], betaH[cc, 1], betaH[cc, 2], betaH[cc, 3]))
  }
  cat(sprintf("# %-22s %14.4f %14.4f %14.4f %14.4f\n", "kappa",
              exp(logkap), exp(logkapH[1]), exp(logkapH[2]), exp(logkapH[3])))
  cat(sprintf("beta_%s_full <- c(%s)\n", county, paste(sprintf("%.8g", beta), collapse = ", ")))
  for (h in 1:3) {
    cat(sprintf("beta_%s_%s <- c(%s)\n", county, yrLabel[h], paste(sprintf("%.8g", betaH[, h]), collapse = ", ")))
  }
  cat("# Deterministic. Least squares start values then Nelder-Mead and BFGS with no random\n")
  cat("# component so identical data and config give identical coefficients.\n")
  
  saveRDS(list(fitRRMSE = fitRRMSE, fcRRMSE = fcRRMSE, fcPers = fcPers, fcSeas = fcSeas,
               fcMean = fcMean, fcResid = fcResid, fcPred = fcPredMat, fcObs = fcObsMat,
               nFitList = nFitList, yrLabel = yrLabel, LMAX = LMAX, DEG = DEG),
          paste0("glm_FOR_RRMSE_", county, ".rds"))
  
  # forecast plot
  cols <- c(rgb(0.35, 0.70, 0.90), rgb(0.00, 0.60, 0.50), rgb(0.80, 0.40, 0.00))
  plot(t_inf_data[1:132], y, pch = 16, col = "black", xaxt = "n",
       xlab = "Year", ylab = "New cases per month", ylim = c(0, max(y) + 200),
       main = paste("Forecast of", county, "Valley Fever Using NB Distributed-Lag GLM"))
  mtext(sprintf("forecast RRMSE  2021 %.1f%%  2022 %.1f%%  2023 %.1f%%   (best naive %.1f / %.1f / %.1f%%)",
                fcRRMSE[1], fcRRMSE[2], fcRRMSE[3],
                min(fcPers[1], fcSeas[1], fcMean[1]), min(fcPers[2], fcSeas[2], fcMean[2]),
                min(fcPers[3], fcSeas[3], fcMean[3])), side = 3, line = 0.3, cex = 0.85)
  lines(t_inf_data[1:96], PRED[[1]][1:96], lwd = 5, col = adjustcolor("blue", alpha.f = 0.45))
  for (h in 1:3) {
    nF <- nFitList[h]
    lines(t_inf_data[(nF + 1):(nF + 12)], PRED[[h]][(nF + 1):(nF + 12)], lwd = 5, col = cols[h])
    abline(v = t_inf_data[nF + 1], lwd = 1.5)
  }
  axis(1, at = seq(0, 365 * 11, by = 365), labels = 2013:2024)
  grid()
  legend("topleft", bty = "n",
         legend = c(paste(county, "Infected"), "NB-GLM fit (through 2020)", paste(yrLabel, "forecast")),
         col = c("black", adjustcolor("blue", alpha.f = 0.45), cols),
         pch = c(16, NA, NA, NA, NA), lwd = c(NA, 5, 5, 5, 5))
  
  RES[[length(RES) + 1]] <- list(county = county, errorOBJ = errorOBJ, k = k, n = n,
                                 aic = aic, aicc = aicc, bic = bic, kappa = exp(logkap),
                                 fitRRMSE = fitRRMSE, fcRRMSE = fcRRMSE,
                                 fcPers = fcPers, fcSeas = fcSeas, fcMean = fcMean)
}

# ==== cross region summary===
cat("\n\n== NB DISTRIBUTED-LAG GLM SUMMARY, ALL REGIONS ==\n")
cat(sprintf("%-9s %9s %4s %5s %10s %10s %10s | %8s %8s %8s\n",
            "region", "fitRRMSE%", "k", "n", "AIC", "AICc", "BIC", "FC 2021", "FC 2022", "FC 2023"))
for (i in seq_along(RES)) {
  R <- RES[[i]]
  cat(sprintf("%-9s %9.2f %4d %5d %10.1f %10.1f %10.1f | %8.2f %8.2f %8.2f\n",
              R$county, 100 * R$errorOBJ, R$k, R$n, R$aic, R$aicc, R$bic,
              R$fcRRMSE[1], R$fcRRMSE[2], R$fcRRMSE[3]))
}
cat("AIC/AICc/BIC are negative-binomial (nb_ic, same as the ODE script) on months 1-132\n")
cat("with n = 132 so they compare directly to the ODE criteria. Pre-sample NOAA climate\n")
cat("(2011-2012) feeds the lags and no extra outcome data enter the likelihood.\n")
saveRDS(list(RES = RES, LMAX = LMAX, DEG = DEG, USE_TREND = USE_TREND, NHARM = NHARM,
             FIT_OBJECTIVE = FIT_OBJECTIVE, nFitList = nFitList, yrLabel = yrLabel),
        "glm_ALL_summary.rds")