# XGboost for valley fever 
# Trevor Reckell
# XGBoost fit and expanding window forecast of Valley fever in all four regions
# 
#
# For each region the script runs
#   a full period fit on months 1 to 132 (Jan 2013 to Dec 2023) with RRMSE and
#   negative binomial AIC AICc BIC from nb_ic with n = 132
#   expanding window forecasting with nFitList = 96 108 120 so fit 8 years and
#   forecast 2021 then 9 years for 2022 then 10 years for 2023 with fit and
#   forecast RRMSE and the persistence seasonal and train mean baselines
#   computed with the identical formulas to the ODE script
#
# I've implented this in MATLAB tooand that version drove the Python xgboost package. 
# this uses xgboost R package which shares the same C++ core. 
# need  install.packages("xgboost")
# Use xgboost 2.0 or newer. 
#
# Comparability notes which are the same conventions as the ODE file
#   objective reg:squarederror so minimising MSE on a fixed window is identical
#   to minimising RRMSE = sqrt(mean(r^2)) / mean(y)
#   forecasts are recursive so case lags past the origin use the model's own
#   predictions and the forecast year is pre set to NA so leakage is impossible
#   temperature PZI(+10) and population over the forecast year are known
#   exogenous forcing exactly as the ODE models use the observed climate splines
#   population is pchip through the same 12 census points Model 0 uses
#   early window missing lags stay NA since XGBoost routes missing natively so
#   the IC sample size stays at n = 132 matching the ODE
#   AIC AICc BIC use the NB plug in likelihood with kappa by a 1 d MLE and
#   p = kfree + 1 where kfree is the total leaf count since each leaf weight is
#   a fitted parameter. A sensitivity IC with kfree = number of hyperparameters
#   is printed too deterministic since subsample = colsample = 1 and nthread = 1


library(stats)
library(graphics)
library(grDevices)
library(utils)
if (!requireNamespace("xgboost", quietly = TRUE)) {
  install.packages("xgboost")       # one time install from CRAN
}
library(xgboost)

options(digits = 10)

#  configuration 
XGB <- list(
  n_estimators     = 300,
  max_depth        = 3,
  learning_rate    = 0.05,
  min_child_weight = 3,
  reg_lambda       = 1.0,
  subsample        = 1.0,     # 1.0 means deterministic
  colsample_bytree = 1.0,     # 1.0 means deterministic
  objective        = "reg:squarederror",
  n_jobs           = 1,
  random_state     = 42
)
nHyper <- 7                   # for the sensitivity IC only
set.seed(XGB$random_state)    # the R package takes its seed from R not from a parameter

caseLags <- c(1, 2, 3, 6, 12)
climLags <- c(0, 1, 2, 3, 6, 9, 12, 18, 24)   # out to about 2 years since Valley fever
# responds to climate at 1 to 2 year lags

nFitList <- c(96, 108, 120)   # identical to the ODE forecasting sections
yrLabel  <- c("2021", "2022", "2023")

regionList <- 1:4             # 1 AZ 2 MARICOPA 3 PIMA 4 PINAL

# helper functions
# R needs these defined before they are called so they live up here

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

# rows are months 1 to 132. Lags that reach before Jan 2013 are NA and XGBoost
# routes missing values natively so all 132 rows stay usable and the IC sample
# size matches the ODE n = 132
build_features <- function(yv, temp_m, pzi_m, pop_m, moy, caseLags, climLags) {
  nloc <- length(yv)
  lag  <- function(v, L) if (L == 0) v else c(rep(NA_real_, L), v[1:(nloc - L)])
  X <- cbind(moy, pop_m)
  cn <- c("moy", "pop")
  for (L in climLags) {
    X  <- cbind(X, lag(temp_m, L), lag(pzi_m, L))
    cn <- c(cn, sprintf("temp_lag%d", L), sprintf("pzi_lag%d", L))
  }
  for (L in caseLags) {
    X  <- cbind(X, lag(yv, L))
    cn <- c(cn, sprintf("cases_lag%d", L))
  }
  colnames(X) <- cn
  X
}

xgb_fit <- function(X, yv, XGB) {
  dtrain <- xgb.DMatrix(data = X, label = yv, missing = NA)
  params <- list(
    objective        = XGB$objective,
    max_depth        = XGB$max_depth,
    eta              = XGB$learning_rate,
    min_child_weight = XGB$min_child_weight,
    lambda           = XGB$reg_lambda,
    subsample        = XGB$subsample,
    colsample_bytree = XGB$colsample_bytree,
    tree_method      = "hist",            
    nthread          = XGB$n_jobs
  )
  xgb.train(params = params, data = dtrain, nrounds = XGB$n_estimators, verbose = 0)
}

xgb_predict <- function(model, X) {
  if (is.null(dim(X))) X <- matrix(X, nrow = 1)
  as.vector(predict(model, newdata = xgb.DMatrix(data = X, missing = NA)))
}

# leaf weight is a fitted parameter of the ensemble
count_leaves <- function(model) {
  dmp <- xgb.dump(model)
  sum(grepl("leaf=", dmp, fixed = TRUE))
}

# cheap fingerprint of the fitted ensemble to confirm run to run identity in R
dump_checksum <- function(model) {
  txt <- paste(xgb.dump(model), collapse = "")
  v   <- as.numeric(utf8ToInt(txt))
  s   <- sum(v * seq_along(v)) %% 2^32
  sprintf("%04X%04X", as.integer(s %/% 65536), as.integer(s %% 65536))
}

nb_loglik <- function(kappa, y, mu) {
  kappa <- max(kappa, .Machine$double.xmin)
  sum(lgamma(y + kappa) - lgamma(kappa) - lgamma(y + 1)
      + kappa * log(kappa / (kappa + mu))
      + y     * log(mu    / (kappa + mu)))
}

# IC
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

# print out be pasted into a comparison script
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

#  shared time vectors 
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
moy     <- (0:(nMonths - 1)) %% 12 + 1          # month of year with Jan = 1

# each region data 
# all series are copied straight from the MATLAB script
# y_inf_data is monthly reported cases Jan 2013 to Jan 2024 with 133 values
# and only 1 to 132 are used. temp_data is monthly mean temperature in degF
# with 132 values. pzi_data is the monthly Palmer Z index plus 10 with 132
# values. y_pop_data is the 12 annual population estimates
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
  } else {
    stop("region_data: Region must be 1 (AZ), 2 (MARICOPA), 3 (PIMA) or 4 (PINAL)")
  }
  list(county = county, y_inf_data = y_inf_data, temp_data = temp_data,
       pzi_data = pzi_data, y_pop_data = y_pop_data)
}

cat(sprintf("xgboost %s loaded which is the same C++ core as the Python package\n",
            as.character(packageVersion("xgboost"))))

# __loop over the four regions__
RES <- list()
for (Region in regionList) {
  rd <- region_data(Region)
  county     <- rd$county
  y_inf_data <- rd$y_inf_data
  temp_data  <- rd$temp_data
  pzi_data   <- rd$pzi_data
  y_pop_data <- rd$y_pop_data
  cat(sprintf("\n=====  %s  (Region %d)  =====\n", county, Region))
  
  # alignment checks using the same windows as the ODE script
  stopifnot(length(y_inf_data) == 133, length(t_inf_data) == 133)
  stopifnot(length(temp_data) == 132, length(pzi_data) == 132, length(tind) == 132)
  stopifnot(length(y_pop_data) == 12, length(t_pop_data) == 12)
  stopifnot(max(nFitList) + 12 == 132)
  
  y     <- y_inf_data[1:nMonths]                       # months 1 to 132 which is data_mon in the ODE
  pop_m <- pchip_matlab(t_pop_data, y_pop_data, tind)  # monthly population
  cat("Fit window     : months 1-132  (Jan 2013 - Dec 2023)\n")
  cat("Forecast blocks: 97-108 (2021) | 109-120 (2022) | 121-132 (2023)\n")
  
  #full period fit on months 1 to 132
  X_full     <- build_features(y, temp_data, pzi_data, pop_m, moy, caseLags, climLags)
  model_full <- xgb_fit(X_full, y, XGB)
  mu_raw     <- xgb_predict(model_full, X_full)
  
  # base score check. estimates it from the data, if this does not match the Python run
  # the trees will differ a little
  bs <- tryCatch({
    cfg <- xgb.config(model_full)
    if (is.character(cfg)) {
      regmatches(cfg, regexpr('"base_score":"?[-0-9.eE+]+', cfg))
    } else {
      paste("base_score:", cfg$learner$learner_model_param$base_score)
    }
  }, error = function(e) NA_character_)
  if (length(bs) == 1 && !is.na(bs)) cat("  ", bs, "\n")
  
  if (any(mu_raw <= 0)) {
    message(sprintf("%d in-sample predictions <= 0 and clipped to 1e-6 for the NB likelihood only", sum(mu_raw <= 0)))
  }
  mu <- pmax(mu_raw, 1e-6)
  
  # same objective the ODE swarm minimises which is the mean normalised RRMSE
  errorOBJ <- sqrt(mean((mu_raw - y)^2)) / mean(y)
  cat(sprintf("\n%s XGBoost full fit | RRMSE = %.6f  (%.2f%%)\n", county, errorOBJ, 100 * errorOBJ))
  saveRDS(list(errorOBJ = errorOBJ), paste0("xgb_RRMSE_", county, ".rds"))
  
  # information criteria from nb_ic with n = 132
  kLeaves <- count_leaves(model_full)
  cat(sprintf("ensemble size: %d leaves across %d trees -> kfree = %d\n",
              kLeaves, XGB$n_estimators, kLeaves))
  
  rrmse      <- errorOBJ
  data_mon   <- y
  n          <- length(data_mon)
  k          <- kLeaves
  noiseFloor <- 100 * (sd(diff(data_mon, differences = 2)) / sqrt(6)) / mean(data_mon)
  
  ICnb <- nb_ic(data_mon, mu, k, paste("XGBoost", county))
  aic  <- ICnb$aic
  aicc <- ICnb$aicc
  bic  <- ICnb$bic
  
  IChyp <- nb_ic(data_mon, mu, nHyper, paste("XGBoost", county, "(k = #hyperparams, sensitivity)"))
  
  # same criteria on the common window months 25 to 132 so the NB GLM which
  # used to lose 24 months to its lag burn in can be compared
  COMMON_START <- 25
  cw   <- COMMON_START:nMonths
  ICcw <- nb_ic(y[cw], mu[cw], k, paste("XGBoost", county, "[common window 25-132]"))
  fitRRMSE_common <- 100 * sqrt(mean((mu_raw[cw] - y[cw])^2)) / mean(y[cw])
  cat(sprintf("  IC sensitivity to k: leaves k=%d -> AIC %.1f | hyperparams k=%d -> AIC %.1f\n",
              kLeaves, ICnb$aic, nHyper, IChyp$aic))
  cat(sprintf("  RRMSE (objective convention)      : %.6f  (noise floor %.4f)\n", rrmse, noiseFloor / 100))
  saveRDS(list(ICnb = ICnb, IChyp = IChyp, n = n, k = k, nHyper = nHyper, rrmse = rrmse,
               aic = aic, aicc = aicc, bic = bic, noiseFloor = noiseFloor, XGB = XGB,
               caseLags = caseLags, climLags = climLags),
          paste0("xgb_IC_", county, ".rds"))
  
  # full fit plot
  plot(t_inf_data[1:nMonths], data_mon, pch = 16, col = "black", xaxt = "n",
       xlab = "Year", ylab = "Cases per month", ylim = c(0, max(data_mon) * 1.25),
       main = paste(county, "Valley Fever - XGBoost monthly incidence fit"))
  mtext(sprintf("RRMSE %.2f%%  (noise floor %.2f%%)  |  NB AIC %.1f  BIC %.1f  (k = %d leaves)",
                rrmse * 100, noiseFloor, aic, bic, kLeaves), side = 3, line = 0.3, cex = 0.85)
  lines(t_inf_data[1:nMonths], mu_raw, lwd = 3, col = adjustcolor(rgb(0.85, 0.33, 0.10), alpha.f = 0.6))
  axis(1, at = seq(0, 365 * 11, by = 365), labels = 2013:2024)
  grid()
  legend("topleft", bty = "n", legend = c(paste(county, "reported"), "XGBoost fit"),
         col = c("black", rgb(0.85, 0.33, 0.10)), pch = c(16, NA), lwd = c(NA, 3))
  
  # ---------------- expanding window forecasting --------------------------
  fitRRMSE <- rep(NA_real_, 3)
  fcRRMSE  <- rep(NA_real_, 3)
  fcPers   <- rep(NA_real_, 3)
  fcSeas   <- rep(NA_real_, 3)
  fcMean   <- rep(NA_real_, 3)
  PRED     <- vector("list", 3)
  fcResid  <- vector("list", 3)
  kLeavesH <- rep(NA_real_, 3)
  checksumH <- rep(NA_character_, 3)
  fcPredMat <- matrix(NA_real_, 3, 12)
  fcObsMat  <- matrix(NA_real_, 3, 12)
  
  for (h in 1:3) {
    nF <- nFitList[h]
    
    # train strictly on months 1 to nF with features built from actual data
    Xtr     <- build_features(y, temp_data, pzi_data, pop_m, moy, caseLags, climLags)
    model_h <- xgb_fit(Xtr[1:nF, , drop = FALSE], y[1:nF], XGB)
    kLeavesH[h]  <- count_leaves(model_h)
    checksumH[h] <- dump_checksum(model_h)
    
    # recursive 12 month forecast. The forecast year is pre set to NA so case
    # lags past the origin can only come from the model's own predictions
    yhat <- y
    yhat[(nF + 1):(nF + 12)] <- NA_real_
    for (j in (nF + 1):(nF + 12)) {
      Xj      <- build_features(yhat, temp_data, pzi_data, pop_m, moy, caseLags, climLags)
      yhat[j] <- xgb_predict(model_h, Xj[j, , drop = FALSE])
    }
    PRED[[h]] <- yhat
    
    # errors with identical formulas to the ODE forecast sections
    dFit <- y[1:nF]
    rFit <- xgb_predict(model_h, Xtr[1:nF, , drop = FALSE]) - dFit
    dFc  <- y[(nF + 1):(nF + 12)]
    rFc  <- yhat[(nF + 1):(nF + 12)] - dFc
    fitRRMSE[h] <- 100 * sqrt(mean(rFit^2)) / mean(dFit)
    fcRRMSE[h]  <- 100 * sqrt(mean(rFc^2))  / mean(dFc)
    fcResid[[h]] <- rFc
    fcPredMat[h, ] <- yhat[(nF + 1):(nF + 12)]
    fcObsMat[h, ]  <- dFc
    fcPers[h] <- 100 * sqrt(mean((y[nF]              - dFc)^2)) / mean(dFc)
    fcSeas[h] <- 100 * sqrt(mean((y[(nF - 11):nF]    - dFc)^2)) / mean(dFc)
    fcMean[h] <- 100 * sqrt(mean((mean(y[1:nF])      - dFc)^2)) / mean(dFc)
  }
  
  cat(sprintf("\n%s  XGBoost 1-year-ahead forecast, RRMSE = RMSE/mean (%%)\n", county))
  cat(sprintf("%-8s %8s %10s %10s %10s %10s\n", "year", "in-samp", "FORECAST", "persist", "seasonal", "trainmean"))
  for (h in 1:3) {
    cat(sprintf("%-8s %8.2f %10.2f %10.2f %10.2f %10.2f\n", yrLabel[h],
                fitRRMSE[h], fcRRMSE[h], fcPers[h], fcSeas[h], fcMean[h]))
  }
  cat(sprintf("beats best baseline: %s\n",
              paste(fcRRMSE < pmin(fcPers, fcSeas, fcMean), collapse = " ")))
  
  # paste ready block
  print_block("XGBoost", county, 100 * errorOBJ, fitRRMSE_common,
              aic, aicc, bic, ICcw$aic, ICcw$aicc, ICcw$bic,
              k, n, fcRRMSE, fcPredMat, fcObsMat, fcPers, fcSeas, fcMean)
  
  # full fit monthly trajectory for plotting elsewhere
  cat(sprintf("\n#### FULL-FIT TRAJECTORY - XGBoost - %s (months 1-132) ####\n", county))
  cat(sprintf("XGB_%s_FullFit <- c(%s)\n", county, paste(sprintf("%.4f", mu_raw), collapse = ", ")))
  
  # reproducibility notes. An XGBoost parameter set is a couple of thousand
  # leaf weights which is not a printable vector. What fully determines the
  # model is the hyperparameters plus the training window and the dump checksum
  cat(sprintf("\n#### XGBOOST PARAMETER SET - %s ####\n", county))
  cat(sprintf("# n_estimators=%d max_depth=%d eta=%g min_child_weight=%g\n",
              XGB$n_estimators, XGB$max_depth, XGB$learning_rate, XGB$min_child_weight))
  cat(sprintf("# lambda=%g subsample=%g colsample=%g objective=%s seed=%d n_jobs=%d\n",
              XGB$reg_lambda, XGB$subsample, XGB$colsample_bytree, XGB$objective,
              XGB$random_state, XGB$n_jobs))
  cat(sprintf("# caseLags=%s  climLags=%s\n", paste(caseLags, collapse = " "), paste(climLags, collapse = " ")))
  cat(sprintf("# full fit: train months 1-132, %d leaves, dump checksum %s\n",
              kLeaves, dump_checksum(model_full)))
  for (h in 1:3) {
    cat(sprintf("# %s window: train months 1-%d, %d leaves, checksum %s\n",
                yrLabel[h], nFitList[h], kLeavesH[h], checksumH[h]))
  }
  cat("# Deterministic since subsample=colsample=1 and nthread=1 so identical\n")
  cat("# hyperparameters and training window give identical trees and forecasts.\n")
  
  saveRDS(list(fitRRMSE = fitRRMSE, fcRRMSE = fcRRMSE, fcPers = fcPers, fcSeas = fcSeas,
               fcMean = fcMean, fcResid = fcResid, fcPred = fcPredMat, fcObs = fcObsMat,
               nFitList = nFitList, yrLabel = yrLabel, kLeavesH = kLeavesH, XGB = XGB),
          paste0("xgb_FOR_RRMSE_", county, ".rds"))
  
  # forecast plot
  fit8 <- xgb_predict(xgb_fit(Xtr[1:96, , drop = FALSE], y[1:96], XGB), Xtr[1:96, , drop = FALSE])
  cols <- c(rgb(0.35, 0.70, 0.90), rgb(0.00, 0.60, 0.50), rgb(0.80, 0.40, 0.00))
  plot(t_inf_data[1:132], y, pch = 16, col = "black", xaxt = "n",
       xlab = "Year", ylab = "New cases per month", ylim = c(0, max(y) + 200),
       main = paste("Forecast of", county, "Valley Fever Using XGBoost"))
  mtext(sprintf("forecast RRMSE  2021 %.1f%%  2022 %.1f%%  2023 %.1f%%   (best naive %.1f / %.1f / %.1f%%)",
                fcRRMSE[1], fcRRMSE[2], fcRRMSE[3],
                min(fcPers[1], fcSeas[1], fcMean[1]), min(fcPers[2], fcSeas[2], fcMean[2]),
                min(fcPers[3], fcSeas[3], fcMean[3])), side = 3, line = 0.3, cex = 0.85)
  lines(t_inf_data[1:96], fit8, lwd = 5, col = adjustcolor("blue", alpha.f = 0.45))
  for (h in 1:3) {
    nF <- nFitList[h]
    lines(t_inf_data[(nF + 1):(nF + 12)], PRED[[h]][(nF + 1):(nF + 12)], lwd = 5, col = cols[h])
    abline(v = t_inf_data[nF + 1], lwd = 1.5)
  }
  axis(1, at = seq(0, 365 * 11, by = 365), labels = 2013:2024)
  grid()
  legend("topleft", bty = "n",
         legend = c(paste(county, "Infected"), "XGBoost fit (first 8 years)", paste(yrLabel, "forecast")),
         col = c("black", adjustcolor("blue", alpha.f = 0.45), cols),
         pch = c(16, NA, NA, NA, NA), lwd = c(NA, 5, 5, 5, 5))
  
  # collect for the summary table
  RES[[length(RES) + 1]] <- list(county = county, errorOBJ = errorOBJ, kLeaves = kLeaves,
                                 aic = aic, aicc = aicc, bic = bic, aic_hyp = IChyp$aic,
                                 fitRRMSE = fitRRMSE, fcRRMSE = fcRRMSE,
                                 fcPers = fcPers, fcSeas = fcSeas, fcMean = fcMean)
}

# ======================= cross region summary ==============================
cat("\n\n==================== XGBOOST SUMMARY, ALL REGIONS ====================\n")
cat(sprintf("%-9s %9s %6s %10s %10s %10s | %8s %8s %8s\n",
            "region", "fitRRMSE%", "k", "AIC", "AICc", "BIC", "FC 2021", "FC 2022", "FC 2023"))
for (i in seq_along(RES)) {
  R <- RES[[i]]
  cat(sprintf("%-9s %9.2f %6d %10.1f %10.1f %10.1f | %8.2f %8.2f %8.2f\n",
              R$county, 100 * R$errorOBJ, R$kLeaves, R$aic, R$aicc, R$bic,
              R$fcRRMSE[1], R$fcRRMSE[2], R$fcRRMSE[3]))
}
cat("(forecast columns are RRMSE % = 100*RMSE/mean of the observed forecast year,\n")
cat(" identical to fcRRMSE in the ODE script. AIC/AICc/BIC are negative-binomial\n")
cat(" plug-in with kfree = leaf count. See xgb_IC_<region>.rds for the sensitivity\n")
cat(" version with kfree = #hyperparameters.)\n")
saveRDS(list(RES = RES, XGB = XGB, caseLags = caseLags, climLags = climLags,
             nFitList = nFitList, yrLabel = yrLabel),
        "xgb_ALL_summary.rds")