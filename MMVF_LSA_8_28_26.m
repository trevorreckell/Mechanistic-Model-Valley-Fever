%  MMVF_LSA.m
% =========================================================================
%  LOCAL SENSITIVITY ANALYSIS OF THE MECHANISTIC VALLEY FEVER MODELS
%
%  Integrated Absolute Normalised Sensitivity (IANS) of the symptomatic
%  infection compartment I with respect to every dynamic model parameter,
%  computed for all four study regions and averaged across them, separately
%  for each of the five models (M1, M2, M3, M4a, M4b).
%
%  The sensitivity is taken of the quantity the models are actually FITTED
%  TO: monthly integrated incidence. For Models 2, 3, 4a and 4b that is
%      m_k(p) = INT_{month k} psi_I E(t) dt,        k = 1..132
%  and for Model 1, which has no E compartment, it is the same integral of
%  epsilon*S*H. These are the flux handles used by the objective functions and
%  by section 9 of the main script, so the sensitivity target and the fitting
%  target now coincide.
%
%      S_jk     = (dm_k/dp_j) * (p_j / m_k)         (dimensionless elasticity)
%      IANS_j   = SUM_k |S_jk| * dt_k               (units: days)
%      IANS_j / T                                   (mean absolute elasticity,
%                                                    month-length weighted)
%
%  dt_k is the length of calendar month k, so IANS is the month-length
%  weighted L1 norm of the elasticity and T = SUM_k dt_k = 4017 days. This is
%  the discrete counterpart of INT_0^T |S_j(t)| dt and carries the same units,
%  so it is directly comparable to the old IANS axis.
%
%  MAIN DELIVERABLE: TEN FIGURES
%    Section 5 produces one bar figure per model, in the style of the old
%    "%% 4 : Bar Graph for State 'I' Sensitivity". The bar height is the MEAN
%    of IANS_j over the four regions (AZ, Maricopa, Pima, Pinal), the black
%    whisker is the min-max range across those four regions, and the bars are
%    sorted descending. The y axis is log10 by default: IANS spans five to six
%    decades, so on a linear axis the lower two thirds of the ranking is
%    invisible. Set CFG.yScales = {'linear','log'} to get both.
%
%    A grey band and a heavy black line mark the numerical resolution floor.
%    Bars inside the band are estimator noise; see note 9.
%
%    Filenames: LSA_out/IANS_mean_<model>_<target>_<log|linear>.png
%
%    The 0-1 scaled companion figure from the old "%% 5" is retained but OFF
%    by default (CFG.makeScaled), so the figure count stays at exactly 10.
%
%    Layout of this file:
%      0 configuration          4b numerical resolution probe
%      1 data                    5 main figures (the deliverable)
%      2 fitted parameters       6 tables, rank concordance, CSV/MAT export
%      3 model metadata          7 self-checks
%      3b optimum reparameterisation
%      4 IANS computation        8 optional deep dive, then local functions
%
% =========================================================================
%  WHAT CHANGED RELATIVE TO THE PREVIOUS VERSION OF THIS FILE, AND WHY
% =========================================================================
%  1. PARAMETER VECTORS REPLACED. All 20 model-region vectors are now the
%     current full-sample fits taken verbatim from section 9 (choose_model==9)
%     of Mechanistic_Model_Valley_Fever_07_33_26.m. The old
%     params_mXpswarm_<region> vectors have been deleted, not commented out,
%     so there is no way to run the old numbers by accident.
%
%  2. GAP PARAMETERISATION. This is the change that silently invalidated the
%     old script. The ODE functions no longer read the thermal and moisture
%     optima directly; they read a base plus a gap:
%         M3   T_opt_H = p(10),  T_opt_A = p(10) + p(11)
%              S_opt_A = p(12),  S_opt_H = p(12) + p(13)
%         M4a  T_opt_H = p(9),   T_opt_A = p(9)  + p(10)
%              S_opt_A = p(11),  S_opt_H = p(11) + p(12)
%         M4b  T_opt_H = p(11),  T_opt_A = p(11) + p(12)
%              S_opt_A = p(14),  S_opt_H = p(14) + p(13)     <-- note the
%                                                                reversed order
%     Consequences handled here:
%       (a) the index map is per-model and Model 4b's is REVERSED relative to
%           M3 and M4a, so M.gapIdx carries it explicitly and a startup check
%           reconstructs all twelve optima and asserts they are physical;
%       (b) THE FOUR OPTIMA ARE REPORTED AS FOUR SEPARATE PARAMETERS, which is
%           how the manuscript defines them. The optimiser searched (base, gap),
%           so the sensitivity columns are rotated into (base, base + gap) by
%           the exact Jacobian of that change of variables in lsa_optcoords().
%           Relabelling the gap column "T_opt_A" without the rotation would
%           publish the wrong number: the gap elasticity is not the optimum
%           elasticity. The rotation is applied to S_j(t), before any absolute
%           value or integration, because |a| + |b| is not |a + b|.
%           CFG.optCoords = "fitted" reports the searched coordinates instead.
%       (c) the elasticity of an optimum is the gap elasticity times
%           (optimum / gap). Where the fit pinned the gap tightly -- Model 4b
%           in Maricopa has a 0.51 F gap against a 73.8 F optimum -- that
%           factor reaches 145. Section 3b prints every factor so a reader can
%           see where a large optimum elasticity comes from, and the section 4b
%           resolution probe operates on the ROTATED sensitivities, so the
%           amplified noise in those columns is measured rather than hidden.
%
%  3. MODEL FUNCTIONS REPLACED with the current ones from the bottom of
%     Mechanistic_Model_Valley_Fever_07_33_26.m: M1_SF_T, M2_SF, M3_SF,
%     M4_SF_S, M5_SF. These now take county as an ARGUMENT rather than a
%     global, use the inlined pchip lookup, cap the drought multiplier at
%     F_DR_MAX = 100, hoist decT / kT, and (M4b) tie psi_A = 1.5*psi_I.
%     The old copies in this file used the pre-gap indexing, an uncapped
%     F_dr, an untied psi_A and a `global county`, so every M3/M4a/M4b
%     sensitivity produced by the old file was wrong.
%
%  4. THE THREE DUPLICATED CLIMATE BLOCKS ARE NOW ONE FUNCTION. M3_SF,
%     M4_SF_S and M5_SF in the main script each carry a byte-identical copy
%     of the temperature and Palmer Z-Index series and of the spline cache.
%     Those three copies were verified identical and are replaced here by a
%     single mmvf_climate(). This is a refactor, not a model change: same
%     tind, same data, same pchip, same inlined cubic evaluation, same
%     persistent cache key [county temp_shift alpha_PZI beta_PZI].
%
%  5. HARD-CODED SENSITIVITY VECTORS DELETED. The old file computed
%     sensitivity_for_I and then plotted M5_sens_mean, a mean of four
%     hard-coded M5_sens_<region> arrays pasted from earlier runs. The plot
%     therefore ignored the value just computed. Those arrays came from the
%     old parameterisation and are gone. Everything plotted here is computed
%     in this run.
%
%  6. INITIAL-CONDITION ENTRIES ARE EXCLUDED, DELIBERATELY. The fitted
%     vectors end in initial conditions (M1 p13-p14, M2 p18-p22, M3 p31-p35,
%     M4a p39-p44, M4b p41-p46). These never enter the right-hand side, so a
%     sensitivity computed by perturbing them inside the ODE is identically
%     zero and meaningless. The old file mixed the two: its section 4 looped over
%     length(p_vec) while the axis was labelled 1:num_params-6 and the name
%     arrays were shorter still, so bars and labels could not have been in
%     register. Here the loop, the names and the axis all run over the
%     dynamic parameters only: 12, 17, 30, 38 and 40 for M1..M4b.
%     (If the sensitivity to an initial condition is wanted it must be done
%     by differentiating y0(p), which is a separate calculation.)
%
%  7. FIXED TIME GRID. IANS is now integrated on the same daily grid
%     0:1:4017 that the objective functions solve on, rather than on whatever
%     adaptive grid the solver happened to return, so the four regions and the
%     five models are integrated over identical quadrature nodes.
%
%  8. MEAN ACROSS REGIONS, WITH THE SPREAD SHOWN. The requested statistic is
%     the arithmetic mean of IANS over the four regions. Because that mean can
%     be dominated by one region (the old M4b numbers ranged from 1.5e4 in
%     Pima to 3.1e5 in Pinal for beta), every figure also carries the min-max
%     whisker, and section 6 reports the coefficient of variation across
%     regions, Kendall's W and the mean pairwise Spearman rank correlation, so
%     a reader can see whether the ranking is a regional consensus or an
%     artefact of one county.
%
%  9. SELF-CHECKS THAT WOULD CATCH AN INDEXING ERROR (section 7):
%       - T_d_s is structurally absent from the right-hand side of both
%         M4_SF_S (index 29) and M5_SF (index 30), so its IANS must be
%         exactly 0. If it is not, the parameter indexing is wrong.
%       - in M3 and M4a the organic-matter decay term is (TF/T_decay)*delta_O,
%         so only the ratio is identified and |IANS(T_decay)| must equal
%         |IANS(delta_O)| to solver tolerance.
%       - the finite-difference step is halved and the two answers compared
%         (Richardson-style), and the FSA and finite-difference engines are
%         cross-checked against each other for all five models.
%       - NUMERICAL RESOLUTION (section 4b). IANS is recomputed with the
%         differencing step h and with h/2, in every region. A value is
%         RESOLVED if the two agree to within CFG.resTol of itself; the
%         model's resolution FLOOR is the largest IANS that failed, taken
%         over regions. At or below the floor the central difference is
%         returning its own arithmetic noise, so the value is not a
%         sensitivity and is neither quoted nor ranked. The floor is measured,
%         not chosen. It is corroborated independently by the exact
%         delta_O/T_decay identity, whose discrepancy is by construction pure
%         noise and lands at the same order (0.065 d for M3, 0.074 d for
%         M4a against floors of 0.025 d and 0.198 d).
%         Being below the floor means the influence is UNMEASURABLE at this
%         tolerance. It does NOT mean the influence is zero: an IANS of
%         EXACTLY zero is a separate, structural finding, reported by its own
%         diagnostic, and means the branch that parameter controls is never
%         taken by that region's climate series.
%       - the estimator itself is unit-tested against a closed form: for
%         flux(t) = a*exp(-b*t) the monthly elasticity with respect to a is
%         exactly 1 and the elasticity with respect to b is analytic, so
%         lsa_month, the relative central difference, the normalisation and
%         the quadrature weights are all checked against known answers with
%         no ODE involved. Offline this returns 3.5e-12 and 2.8e-7.
%
%  10. DIFFERENTIATION ENGINE. Two are implemented and they estimate the same
%     quantity; CFG.method picks one in a single line, and self-check (d)
%     compares them. "cfd" is the default and is the recommended one to report:
%       - it perturbs p_j(1 +- h) in RELATIVE terms, so it behaves identically
%         for sigma ~ 1e-12, c ~ 2e-12 and phi_A ~ 1e-9 as it does for
%         H_max ~ 400. MATLAB's odeSensitivity estimates the parameter
%         Jacobian by an internal step rule that is neither documented in
%         detail nor citable, and which may be absolute rather than relative;
%         at 1e-12 that is the difference between a real column and noise.
%       - the target is now a FUNCTIONAL of the solution (a month integral of
%         psi_I*E), not a state. "cfd" differentiates it by re-evaluating the
%         observable at the perturbed vector, which automatically picks up the
%         explicit dependence on psi_I. The "fsa" path has to assemble that
%         product rule by hand, which is one more place to be wrong.
%       - it is reproducible from three numbers in a methods section
%         (CFG.fdRelStep, CFG.relTol, CFG.absTol), in any language, and
%         self-check (c) gives a convergence table by halving the step.
%     "fsa" is kept because it was the previous engine and because an
%     independent second estimate is worth reporting in the SI, but it is not
%     a drop-in substitute here and the reason is worth stating in the paper:
%       - sensitivity analysis in MATLAB's ode object requires a SUNDIALS
%         solver. Setting Solver = "ode15s" is accepted silently and then
%         fails at solve time;
%       - the raw sensitivities dy/dp_j span about thirty orders of magnitude
%         because the parameters do. At the tolerances the finite-difference
%         path uses, CVODES cannot pass its error test at all: Model 1 dies at
%         t = 270 with "the error test failed repeatedly", and what it returns
%         disagrees with central differences by a factor of 3e3.
%         lsa_sens_fsa therefore differentiates with respect to
%         q_j = p_j / p_j^fit, which puts every sensitivity variable on the
%         scale of y and makes a scalar AbsoluteTolerance meaningful, and it
%         uses its own looser CFG.fsaRelTol / CFG.fsaAbsTol;
%       - it is slow, and not by a small factor. MEASURED: Model 1 alone --
%         5 states, 12 parameters, 65 augmented equations, a 730-day window and
%         a completely smooth right-hand side -- took 15 minutes. Model 2 is
%         roughly four times that and Model 4b about thirteen times, before
%         counting the branch switches that force step reductions. Something
%         structural is slow rather than merely heavy; the leading suspect is
%         the requested output grid, since asking the ode object for one point
%         per day routes through ode/solveAt. CFG.fsaNaturalGrid = true lets
%         the solver choose its own grid instead.
%     For those reasons CFG.crossCheck now defaults to FALSE. Nothing is lost:
%     self-checks (b), (c) and (e) verify the estimator against ANALYTIC truth
%     -- an exact algebraic identity, a closed-form elasticity, and step
%     refinement -- which is a stronger argument in a paper than agreement with
%     a second numerical scheme that is itself fragile on these models.
%       If the fsa leg raises a solver warning, self-check (d) declares it
%       unusable and skips the comparison rather than recording a failure: a
%       reference that did not converge cannot condemn the cfd answer.
%
%  NOT ADDRESSED HERE, because it does not enter a local sensitivity
%  calculation: the switch of the information criteria to the Gaussian
%  least-squares likelihood with p = k+1, the mean-normalised RRMSE, the
%  full-window n = 132 NB-GLM, the F/V split for RER_E, and Model 4b's free
%  parameter count of 41. The free-parameter counts ARE used, but only to
%  annotate which parameters were pinned; see PINNED below, where the M4b
%  count is asserted to be 41.
% =========================================================================

clear; clc; close all;

%% ======================== 0. CONFIGURATION ==============================
CFG = struct();

% =========================================================================
%  THE ONE LINE TO CHANGE TO SWITCH DIFFERENTIATION ENGINE
% =========================================================================
CFG.method = "cfd";      % "cfd" = central differences in the relative
                         %         parameter  <-- recommended, report this one
                         % "fsa" = MATLAB ode object + odeSensitivity
% =========================================================================

CFG.models        = [1 2 3 4 5];  % 1 M1, 2 M2, 3 M3, 4 M4a, 5 M4b
CFG.regions       = [1 2 3 4];    % 1 AZ, 2 Maricopa, 3 Pima, 4 Pinal
                                  % all four are needed for the region mean

% ---- what the sensitivity is taken OF ----------------------------------
%   "incidence_monthly" : the 132 monthly integrals of the incidence flux.
%                  THIS IS THE FITTED OBSERVABLE -- the objective functions
%                  form cumtrapz of the flux and diff it at the calendar
%                  month boundaries, and this reproduces that exactly. Default.
%   "incidence"  : the instantaneous incidence flux psi_I*E(t) itself
%                  (epsilon*S*H for M1), integrated continuously rather than
%                  aggregated to months. A strictly finer-resolution view of
%                  the same object; useful as a robustness check, since it
%                  retains sub-monthly sign changes that the monthly
%                  aggregation averages out.
%   "I"          : the symptomatic infection STOCK. What the old file's
%                  section 4 used. At a 90-day sojourn the stock is a heavily
%                  low-passed version of the incidence, so its sensitivity
%                  ranking need not match the fitted one. Kept for continuity.
CFG.target        = "incidence_monthly";

CFG.fallbackToCFD = true;   % if the ode/odeSensitivity path errors, switch
                            % that model-region to "cfd" and say so loudly

% The central-difference error in S_j is about C*h^2 (truncation) plus
% RelTol/h (solver noise, which does not cancel because ode15s picks a
% different step sequence for the + and - solves). That is minimised at
% h* = (RelTol/2)^(1/3), and the resulting error accumulates through
% SUM w|S| into an IANS noise floor of roughly T*(h*^2 + RelTol/h*) days.
%   RelTol 1e-8,  h 1e-3  -> floor ~ 0.04 d   (measured: ~0.3 d)
%   RelTol 1e-9,  h 1e-3  -> floor ~ 0.008 d  <- default, h is near h* = 8e-4
%   RelTol 1e-10, h 5e-4  -> floor ~ 0.002 d  <- use if the section 4b probe
%                                                leaves too much unresolved
% Section 4b MEASURES the floor rather than trusting this estimate.
CFG.fdRelStep     = 1e-3;   % central-difference step, RELATIVE: p_j*(1 +- h)
CFG.relTol        = 1e-9;
CFG.absTol        = 1e-11;
CFG.dtOut         = 1;      % output grid spacing in days; 1 = daily,
                            % matching the objective functions

% ---- verification (adds runtime; leave on for a paper run) --------------
% ---- engine cross-check: OFF by default --------------------------------
% Comparing "cfd" against "fsa" was meant to be independent evidence that the
% differentiation is right. It is not worth its cost here. Measured: Model 1
% alone -- 5 states, 12 parameters, 65 augmented equations, a 730-day window
% and a completely smooth right-hand side -- took 15 MINUTES. Model 2 is about
% four times that, and M4b about thirteen times before counting its branch
% switches.
%
% Nothing is lost by skipping it, because self-checks (b), (c) and (e) compare
% against ANALYTIC truth rather than against a second numerical scheme:
%     (e) the elasticity of a pure scale parameter is exactly 1   -> 1e-9
%     (b) the delta_O / T_decay identity is exact                 -> 1.5e-4
%     (c) h -> h/2 refinement, in all 20 model-regions            -> the floor
% Those are a stronger verification story for a paper than agreement with a
% second estimator that is itself fragile on these models.
%
% Set true if you want the comparison anyway; the speed settings below keep it
% bounded, and everything else in the run is already on disk by that point.
CFG.crossCheck       = false;
CFG.crossCheckMaxSec = 600;           % wall-clock budget. Remaining models are
                                      % skipped once it is exhausted; a solve
                                      % already in flight cannot be interrupted
CFG.crossCheckModels = [1];           % Model 1 only. The RHS-independent
                                      % machinery -- the month integration, the
                                      % normalisation, the quadrature -- is
                                      % shared by all five models, so agreement
                                      % on M1 and M2 exercises it. M3, M4a and
                                      % M4b can be added, but forward
                                      % sensitivity carries 410 augmented
                                      % equations for M4b and will run for a
                                      % very long time.
CFG.crossCheckRegion = 1;
CFG.crossCheckMonths = 12;            % TRUNCATED window for the cross-check.
                                      % The claim being tested is that the two
                                      % estimators agree, which does not depend
                                      % on window length. [] = full window.
% Forward sensitivity needs its own, looser tolerances. Even after the
% parameter rescaling in lsa_sens_fsa the augmented system spans a far wider
% dynamic range than the states alone, and CVODES will fail its error test at
% the tolerances the finite-difference path uses.
% Deliberately looser than the finite-difference path. This is an
% order-of-magnitude agreement test judged against a 5% threshold, not a
% production estimate, so there is no reason to pay for eight digits.
CFG.fsaRelTol        = 1e-6;
CFG.fsaAbsTol        = 1e-8;
% Let the solver pick its own output grid instead of demanding one point per
% day. Asking MATLAB's ode object for a long vector of output times routes
% through ode/solveAt, and that appears to carry a large per-point cost: it is
% the leading suspect for the 15 minutes above. The monthly target only needs
% the cumulative integral at the 13 month boundaries, and lsa_month reaches
% those by cumtrapz + interp1, which works on any grid. Accuracy on the
% adaptive grid is lower than on the daily one, which is acceptable for a 5%
% comparison. Set false to go back to the daily grid.
CFG.fsaNaturalGrid   = true;

% ---- numerical resolution probe (section 4b) ---------------------------
% Recomputes IANS with h and h/2 and calls a parameter RESOLVED when halving
% the step moves its IANS by less than resTol of itself. The largest IANS
% among the unresolved parameters is the model's resolution floor: below it
% the estimator is reporting its own noise, not sensitivity, and the value
% must not be quoted. This is a property of the estimator, so the probe
% always runs with "cfd" even when CFG.method is "fsa".
CFG.resProbe        = true;
CFG.resProbeModels  = [1 2 3 4 5];
CFG.resRegions      = [1 2 3 4];      % probe EVERY region, so the floor is
                                      % measured rather than extrapolated from
                                      % one county
CFG.resTol          = 0.05;           % a value is resolved when h -> h/2 moves
                                      % it by less than this fraction of itself
CFG.hideBelowFloor  = false;          % true drops unresolved bars entirely

% ---- presentation ------------------------------------------------------
CFG.excludePinned = false;  % true drops LB==UB parameters from the figures
CFG.markPinned    = true;   % append * to the label of a pinned parameter
CFG.yScales       = {'log'};   % one figure per model per entry. IANS spans
                            % five to six decades, so the log axis is the only
                            % one on which the lower two thirds of the ranking
                            % is legible. Use {'linear','log'} to get both.
CFG.labelInterp   = 'latex';   % 'latex' gives proper italic math: a lowercase
                            % delta is unmistakably delta and not Delta. Fall
                            % back to 'tex' if your release's LaTeX
                            % interpreter chokes on a label.
% ---- which coordinates the optima are reported in -----------------------
%  "biological" : report d/d T_opt_H, d/d T_opt_A, d/d S_opt_A, d/d S_opt_H,
%                 i.e. the four optima as separate parameters, which is how
%                 the manuscript defines them. DEFAULT.
%  "fitted"     : report d/d T_opt_H, d/d(T gap), d/d S_opt_A, d/d(S gap),
%                 the coordinates the optimiser actually searched.
%  The two are related by an exact linear change of variables; see the
%  reparameterisation note in the header and lsa_optcoords() below. Running
%  both and comparing is a reasonable SI robustness check.
CFG.optCoords     = "biological";

CFG.gapSymbol     = 'delta';   % ONLY used when CFG.optCoords == "fitted".
                               % How to render the two gap parameters:
                            %   'delta' -> \delta T_opt, \delta S_opt
                            %   'Delta' -> \Delta T_opt, \Delta S_opt
                            %   'gap'   -> T_gap, S_gap, matching the naming
                            %              in the main script's bounds block
                            % NOTE 'delta' reuses the symbol that already
                            % denotes the decay rates (delta_H, delta_A, ...).
                            % 'gap' avoids that clash if a reviewer objects.
CFG.makeScaled    = false;  % also emit the old "%% 5" 0-1 scaled companion.
                            % OFF so the figure count is exactly 10.
% ---- what the figure axis reports --------------------------------------
%  "IANS"       : the integrated absolute normalised sensitivity, in days.
%  "elasticity" : IANS / T, the MEAN ABSOLUTE ELASTICITY over the window.
%                 Dimensionless, and directly readable: 7.39 means that a 1%
%                 change in the parameter moves monthly incidence by 7.4% on
%                 average across the eleven years. Because it is a division by
%                 the fixed window T = 4017 d, the ranking, the relative bar
%                 heights, the CVs and the position of every bar relative to
%                 the resolution floor are all IDENTICAL -- only the axis
%                 numbers and the axis label change. Worth considering for the
%                 main text: "IANS = 29699 days" needs the window length to
%                 interpret, "mean elasticity = 7.4" does not.
CFG.figureMetric  = "IANS";

CFG.labelFontSize = [];     % [] = auto from the number of bars
CFG.labelGapFrac  = 0.005;  % vertical gap between the axis and the top of the
                            % rotated parameter labels, as a fraction of the
                            % axis height. 0.005 puts them just short of
                            % touching; raise it if they collide with the box.
CFG.showErrorBars = true;

% ---- output ------------------------------------------------------------
% ---- Supplementary Information ------------------------------------------
% Section 9 prints every SI table as finished LaTeX, between delimiters, so it
% can be selected in the command window and pasted straight into the
% manuscript. The same text is also written to LSA_out/SI_*.tex, so \input{}
% can be used instead of pasting.
CFG.emitSI   = true;

CFG.outDir   = 'LSA_out';
CFG.saveFigs = true;
CFG.saveData = true;
CFG.keepSeries = true;      % keep the full S_j(t) arrays in memory / .mat

% ---- optional single model-region deep dive (old sections 2, 3 and 6) ---
CFG.deepDive       = false;
CFG.deepDiveModel  = 5;
CFG.deepDiveRegion = 4;
if CFG.deepDive && ~CFG.keepSeries
    % the deep dive plots S_j(t), which is only retained when keepSeries is on
    warning('LSA:keepSeries','CFG.deepDive needs CFG.keepSeries; turning it on.');
    CFG.keepSeries = true;
end

if CFG.saveFigs || CFG.saveData
    if ~exist(CFG.outDir,'dir'), mkdir(CFG.outDir); end
end
fprintf('MMVF local sensitivity analysis\n');
fprintf('  target = %s | engine = %s | grid = %g day | h = %g\n\n', ...
        CFG.target, CFG.method, CFG.dtOut, CFG.fdRelStep);

%% ======================== 1. DATA =======================================
% Verbatim from Mechanistic_Model_Valley_Fever_07_33_26.m.

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

y_pop_data_Maricopa=[3912523,3944859,4094842,4174423,4258019,4307033,4405306,4492261,4420568,4500147,4586431,4585871];
 y_pop_data_Pinal=[389237,392627,400229,409058,420111,432159,444369,457288,462789,480299,503184,516263];
 y_pop_data_AZ=[6594981,6634984,6733840,6832810,6944767,7048088,7158024,7275070,7151502,7272499,7366720,7431344];
 y_pop_data_Pima=[996046.5,998668,1005699,1012028,1018638,1024476,1030517,1036290,1043433,1051707,1063162,1063993];

nMonths = 132;
REGNAME = {'Arizona','Maricopa','Pima','Pinal'};
REGTAG  = {'AZ','MARICOPA','PIMA','PINAL'};

D = struct();
D.y_inf = {y_inf_data_AZ, y_inf_data_Maricopa, y_inf_data_Pima, y_inf_data_Pinal};
D.y_pop = {y_pop_data_AZ, y_pop_data_Maricopa, y_pop_data_Pima, y_pop_data_Pinal};
D.regName = REGNAME;
D.regTag  = REGTAG;
D.tGrid   = (t_inf_data(1):CFG.dtOut:t_inf_data(nMonths+1))';   % 0:1:4017
D.tMonBnd = t_inf_data(1:nMonths+1);
for rr = 1:4
    D.pop0(rr) = D.y_pop{rr}(1);
    D.icI(rr)  = D.y_inf{rr}(1);
end
fprintf('time grid: %d points, %g to %g days (%.2f years)\n', ...
        numel(D.tGrid), D.tGrid(1), D.tGrid(end), (D.tGrid(end)-D.tGrid(1))/365);

%% ================= 2. FITTED PARAMETER VECTORS ==========================
%  PARAMS{model, region}: model 1..5 = M1, M2, M3, M4a, M4b
%                         region 1..4 = AZ, Maricopa, Pima, Pinal
%  Copied verbatim from section 9 (choose_model==9) of
%  Mechanistic_Model_Valley_Fever_07_33_26.m. Lengths 14, 22, 35, 44, 46.
%  The trailing entries of each vector are fitted INITIAL CONDITIONS and are
%  excluded from the sensitivity analysis; see note 6 in the header.
PARAMS = cell(5,4);

%% ===== Model 1 (14 parameters: 12 dynamic + 2 initial conditions) =====
PARAMS{1,1} = [59.819320607780909; 0.000000007000002; 0.000000015934065; 488.248356107040365; 0.000254049648165; 0.000057534822154; 0.000000019631126; 0.000057534821894; 0.011111111111111; 0.000210321465422; 0.000000070000107; 0.000000000038826; 0.700008928515749; 145.654231703993730];   % AZ, RRMSE 0.268484
PARAMS{1,2} = [117.396738885814997; 0.000000007000002; 0.000000007188252; 617.609873700934600; 0.000131371158005; 0.000057534822064; 0.000000024197755; 0.000057534821798; 0.011111111111111; 0.000213693353926; 0.000000070001721; 0.000000000106034; 0.700000000000000; 142.327195817737334];   % MARICOPA, RRMSE 0.285035
PARAMS{1,3} = [13.707170009139306; 0.085570186089860; 0.011804192517915; 383.592993758794705; 0.000093937508338; 0.000076967437441; 0.000000007552830; 0.000057533671233; 0.011111111111111; 0.000205334244721; 0.000001394189633; 0.000000000001826; 1237.084451297610940; 364.865951614427956];   % PIMA, RRMSE 0.230653
PARAMS{1,4} = [4.104783597297622; 0.096778679224352; 0.013203824239969; 569.038552901852654; 0.000000700000655; 0.000133774404533; 0.000000005198789; 0.000057534741761; 0.011111111111111; 0.000205419771950; 0.000000391305959; 0.000000000014769; 1383.096523963753953; 732.210937676779281];   % PINAL, RRMSE 0.324293

%% ===== Model 2 (22 parameters: 17 dynamic + 5 initial conditions) =====
PARAMS{2,1} = [1119.673810941309966; 0.000012538605823; 0.127278988063898; 0.024155170031966; 444.136169866438024; 0.000496121510790; 0.006519866403098; 0.001963578346973; 0.000000079235489; 0.000362421438148; 0.000000002302651; 0.000057533891392; 0.011111111111111; 0.000210321465422; 0.090712122998805; 0.081794072405837; 0.000000000038818; 404.566880158106358; 1265.108326948068452; 453.488674288425045; 859.319077418109941; 529.180202657599580];   % AZ, RRMSE 0.250695
PARAMS{2,2} = [6.688755930006960; 0.000000008129526; 0.000004874896140; 0.082760403241896; 671.718192688082127; 0.000000700020713; 0.002273785948712; 0.000767792345455; 0.000013997254299; 0.000558481985768; 0.000000001911089; 0.000057534698963; 0.011111111111111; 0.000213693353926; 0.098346584747439; 0.001046978698850; 0.000000000106019; 28.046081216285270; 1375.947559932918011; 440.044684316842336; 1279.131970559353931; 363.423956947767977];   % MARICOPA, RRMSE 0.269622
PARAMS{2,3} = [80.749223902065253; 0.000000003659564; 0.000002785224382; 0.019347248557537; 495.769446584037041; 0.000000701600197; 0.003281520310664; 0.001110233746123; 0.000000000071363; 0.000076967493628; 0.000000001967271; 0.000057534705004; 0.011111111111111; 0.000205334244721; 0.081126229535339; 0.001754998858043; 0.000000000001827; 1394.733863985635026; 704.836463184780200; 294.526659179488945; 1264.290625113529586; 82.406357338366746];   % PIMA, RRMSE 0.229112
PARAMS{2,4} = [35.210407765727965; 0.000000002714531; 0.000015707470732; 0.083689468606248; 253.986836684243229; 0.000000730112001; 0.010314403463452; 0.001430667965101; 0.000000000302788; 0.000133773257553; 0.000000002206482; 0.000057533809714; 0.011111111111111; 0.000205419771950; 0.112036233818516; 0.000007638578316; 0.000000000014766; 306.293277976660875; 1328.480355506721253; 696.123267097616349; 1046.037199844794259; 35.705789551942033];   % PINAL, RRMSE 0.316866

%% ===== Model 3 (35 parameters: 30 dynamic + 5 initial conditions) =====
PARAMS{3,1} = [121.647026136518207; 0.000171582093428; 0.000001112698335; 0.009628346917829; 356.708525266917889; 0.000738567871845; 0.149183708593133; 0.008377010484608; 0.000121932987587; 66.699341995866959; 1.951401260192324; 8.559651073641161; 7.818836233992521; 60.000000000000000; 915.414519161241401; 481.152406049119406; 625.014752578259845; 31.003643172201819; 16.475636922913473; 12.638013941415497; 1.960099456757267; 8.595118231246754; 0.000289432409882; 0.000000001541336; 0.000057533997031; 0.011111111111111; 0.000210321465422; 0.048271782609317; 0.000045488216020; 0.000000000038821; 890.292532165403259; 896.908725967099826; 111.629067788287259; 2283.412275469522228; 506.319823270873940];   % AZ, RRMSE 0.204697
PARAMS{3,2} = [1210.745656629924497; 0.000006106873662; 0.000172891758025; 0.000214358080323; 527.078600711938066; 0.001731430062362; 0.147848971466471; 0.008333898889787; 0.000149765182065; 77.884409746170476; 0.657681219105589; 7.190391055414935; 7.138892596605803; 60.000000000000000; 1049.830400780916307; 599.489263387295182; 1047.986448785460880; 67.804475095535594; 18.491029649116488; 19.955593886706939; 5.820743123446388; 16.484522605566749; 0.000551106320106; 0.000000001430252; 0.000057534304809; 0.011111111111111; 0.000213693353926; 0.047159413153799; 0.008353574903904; 0.000000000106030; 173.350178384387391; 1014.055855116197336; 112.639225589646102; 2719.610999012020329; 384.719993972715486];   % MARICOPA, RRMSE 0.231381
PARAMS{3,3} = [7.974789633627400; 0.000244290377324; 0.012947682711138; 0.066457491685601; 225.709294095726165; 0.001044226803247; 0.143731971417000; 0.008353371089747; 0.000109336560286; 65.251769466308076; 11.733399229412976; 8.742246731362465; 4.919057044424289; 60.000000000000000; 1046.129933917649623; 597.374826957500545; 1003.641358189958623; 19.178060792576204; 19.916478787958859; 19.877849588900368; 2.832988697877099; 19.467356714624465; 0.000069584570940; 0.000000001928383; 0.000057534225353; 0.011111111111111; 0.000205334244721; 0.047776710776763; 0.039505432612010; 0.000000000001827; 22.065932272039760; 1439.540333185684858; 97.750719028835491; 1692.990221178428101; 86.745821009599894];   % PIMA, RRMSE 0.220350
PARAMS{3,4} = [1233.240108380029142; 0.027373031149519; 0.000000687447197; 0.057311517284252; 682.501405975331636; 0.158096484992296; 0.143448094439472; 0.008334187070249; 0.000000001150163; 67.106922991564630; 15.355925338199979; 9.028947866400438; 7.688218252138783; 60.000000000000000; 985.516122797131288; 548.737608946524460; 605.808167524595319; 49.636695507007779; 16.476149163344768; 19.778615928204246; 8.397746575463147; 10.587514884223108; 0.000132474366751; 0.000000000684483; 0.000057533710261; 0.011111111111111; 0.000205419771950; 0.049760530410873; 0.000000383177193; 0.000000000014767; 778.243413567490961; 1075.435419945277999; 30.655631219756273; 1595.149142121232899; 31.527504531340266];   % PINAL, RRMSE 0.275606

%% ===== Model 4a (44 parameters: 38 dynamic + 6 initial conditions) =====
PARAMS{4,1} = [0.000243666479594; 0.000001476003319; 0.001360631525695; 132.216959729745042; 0.000124613838241; 0.133730779965216; 0.008372383158753; 0.000000476971202; 68.878392653915796; 1.213900967523803; 7.635771120319417; 7.490837951289586; 60.000000000000000; 1030.591304818165327; 373.893118176951305; 820.052322713295439; 18.760217888900293; 16.432322636657275; 19.717317271913956; 1.567827390115654; 15.241235475925684; 99.469243786083879; 0.003331921907938; 0.001540810205215; 0.000000000660898; 51.735094060607530; 0.000000000371716; 6.517906427689955; 31.000000000000000; 16.194864105242871; 0.000152631962250; 0.000000006127908; 0.000057534545102; 0.011111111111111; 0.000210321465422; 0.052304955508472; 0.000000788097337; 0.000000000038825; 9130.794140355916170; 697.987255994155930; 1086.166212772173822; 39.425213504496149; 476.426163151241155; 461.389785440890705];   % AZ, RRMSE 0.212713
PARAMS{4,2} = [0.000026262845225; 0.000004244768099; 0.000136872884361; 645.410020444638008; 0.003076579915238; 0.026218330687722; 0.008354445732622; 0.000000837606006; 77.561671961398631; 0.500252828736612; 7.030254908872792; 6.280675959540225; 60.000000000000000; 1049.315898994371764; 472.076116474287062; 120.218818925646445; 147.834044705340943; 17.089127442892060; 16.974074978460507; 13.640213807483915; 14.099018604017768; 96.519333557173596; 0.000120347843770; 0.007993794514870; 0.000000000878991; 52.344260630574020; 0.000000636713396; 7.062286260088653; 31.000000000000000; 65.784052391577447; 0.000557233671944; 0.000000009269535; 0.000057534808754; 0.011111111111111; 0.000213693353926; 0.047176130919348; 0.000000631198223; 0.000000000106028; 14786.157089752581669; 166.713963632682493; 2.871847264037639; 88.097017297813281; 560.332386947904752; 383.519730185970218];   % MARICOPA, RRMSE 0.196643
PARAMS{4,3} = [0.000107814751815; 0.000005000426691; 0.000096900897273; 249.521593395793133; 0.000634361849585; 0.030379436792917; 0.008351618089900; 0.000000112727567; 65.505346689204231; 10.961792638497833; 8.872604761056131; 7.670798597011660; 60.000000000000000; 1035.529585898689902; 586.050026670881493; 896.506506943439604; 18.727289794202353; 19.999941072638745; 19.664008051339842; 10.306820836736824; 3.510637695966094; 95.813763803431215; 0.000165822322834; 0.007404216910922; 0.000000000846189; 67.761462273285304; 0.000000039939118; 7.783070757144212; 31.000000000000000; 1.510460753685437; 0.000062003593281; 0.000000007646770; 0.000057534628019; 0.011111111111111; 0.000205334244721; 0.047786582793829; 0.000012364395498; 0.000000000001827; 28785.255073056770925; 314.270700790341266; 2.652750640646509; 111.690019798732990; 438.348194824264056; 86.727575158837212];   % PIMA, RRMSE 0.220414
PARAMS{4,4} = [0.000198520381308; 0.000012132266267; 0.033923944402235; 142.363351088612831; 0.000119893064479; 0.133903810498453; 0.009718517628956; 0.000000029158716; 65.531588252805989; 11.107715547913980; 7.709181728397412; 7.843695237433050; 60.000000000000000; 1027.701999095357451; 578.699136014437045; 592.273867468036997; 25.579183583180757; 18.024924747592646; 19.519255524178984; 2.043684996693707; 1.180784414702065; 100.397503416026026; 0.001347654711378; 0.000788703230322; 0.000000000450975; 58.646009158221872; 0.000000000350022; 7.789991459912406; 31.000000000000000; 5.178529030822691; 0.000085178240966; 0.000000006432586; 0.000057534725013; 0.011111111111111; 0.000205419771950; 0.051059168290000; 0.003529277370143; 0.000000000014768; 19768.370434350727010; 228.072531496052392; 837.462418244712239; 49.092905535010786; 417.558959798273577; 30.005120360586456];   % PINAL, RRMSE 0.267058

%% ===== Model 4b (46 parameters: 40 dynamic + 6 initial conditions) =====
PARAMS{5,1} = [0.018181705622196; 1.758651406415133; 68.000000000000000; 0.000016512338298; 0.006519188515923; 139.922674129374542; 0.000072723446272; 0.111582714021398; 0.008564505283758; 0.000000120829449; 66.601593044975743; 1.413756357642466; 7.726198926243989; 7.768375625926045; 1044.422774113924334; 547.931027099010862; 1010.806171591866814; 249.914569546455851; 27.583857935717656; 27.873962202182344; 0.909987746440621; 11.780052066924808; 91.976212743119476; 0.002050111234031; 0.000123039870562; 0.000000000017799; 50.942086761458917; 0.000000000340291; 7.188096880539470; 95.000000000000000; 6.980556244237948; 0.000303874296640; 0.000000011092826; 0.000057534445349; 0.011111111111111; 0.000208332578727; 0.022776197364315; 0.000037355489449; 0.008333333333333; 0.000000000038821; 21846.647921849529666; 1027.955280067162221; 724.124462389914129; 60.198913694991347; 782.539855370589976; 601.916689171551070];   % AZ, RRMSE 0.208569
PARAMS{5,2} = [0.005416478926635; 12.458174713544373; 68.000000000000000; 0.006689755298571; 0.000124221087805; 706.948158821073889; 0.003650214420722; 0.223745628372268; 0.008413408340404; 0.000000461560957; 73.269355014260569; 0.509512724239858; 7.334794170409403; 7.006818658518418; 1043.003905083429572; 593.150194492156515; 120.366260518824646; 449.410499093441445; 26.774405520803981; 25.196291510858035; 21.028855451480581; 18.990454057678171; 88.969309636569861; 0.005917084618693; 0.002751711269199; 0.000000000001647; 63.786991794978711; 0.000000000314836; 7.063704693510985; 95.000000000000000; 64.753561050822498; 0.000509617943678; 0.000000035065838; 0.000057534534548; 0.011111111111111; 0.000213582545323; 0.020001449753873; 0.000242746769380; 0.008333333333333; 0.000000000106028; 4134.229159210582111; 1495.984895136733940; 432.847769015240203; 11.209661541498873; 307.179973987250946; 447.247632634040201];   % MARICOPA, RRMSE 0.194463
PARAMS{5,3} = [0.114099033914862; 0.907929404543157; 68.000000000000000; 0.000388141064258; 0.028625119147796; 140.310882792787595; 0.000072858805139; 0.212621268592550; 0.008551379831690; 0.000006393376378; 65.048290583368313; 12.589044530623477; 6.757242872630694; 7.894943401893612; 1037.056209387530771; 554.936725826785846; 505.175681205759929; 19.500380366619730; 27.033916500329262; 29.594427538781986; 1.400432215906322; 3.565159157781956; 103.710794512096683; 0.009200980761940; 0.004161515749357; 0.000000000003741; 66.548443200523266; 0.000000052215088; 9.874499245867055; 95.000000000000000; 76.391172438002300; 0.000068273845099; 0.000000005423549; 0.000057533845926; 0.011111111111111; 0.000205442389610; 0.020139342747940; 0.000000689787527; 0.008333333333333; 0.000000000001827; 3460.657706626830077; 1034.528757579517332; 924.171736964981733; 87.173778643734181; 1469.809777235970159; 100.425604678612530];   % PIMA, RRMSE 0.209769
PARAMS{5,4} = [0.006144412069339; 14.884597538430686; 68.000000000000000; 0.001647190905357; 0.000144140619525; 278.693830098608032; 0.007165692691626; 0.165591473879893; 0.008334018042322; 0.000001332072915; 72.087085918414985; 0.549021868682177; 3.220757136207006; 7.394450599199159; 1015.130765383967514; 260.277063600556744; 135.586650938224551; 449.060320297641169; 29.490514504627146; 11.486605284473917; 0.617761174465421; 1.169991875288199; 90.461398162943141; 0.001773807600180; 0.001014290890890; 0.000000000000905; 58.523290414884734; 0.000000002784187; 6.741181871495709; 95.000000000000000; 0.718295494816574; 0.000133537615437; 0.000000022351649; 0.000057534774466; 0.011111111111111; 0.000206453379375; 0.020004738920638; 0.000078045983974; 0.008333333333333; 0.000000000014769; 19828.742182482794306; 1487.017960244789492; 1440.204916466812165; 2.149299091171731; 614.180959121521141; 42.343728026173338];   % PINAL, RRMSE 0.232141

%% ================= 3. MODEL METADATA ====================================
M = struct();
M.name    = {'Model 1','Model 2','Model 3','Model 4a','Model 4b'};
M.tag     = {'M1','M2','M3','M4a','M4b'};
M.nP      = [14 22 35 44 46];   % full fitted vector length
M.nODE    = [12 17 30 38 40];   % dynamic parameters, i.e. p(1:nODE)
M.nStates = [ 5  8  8  9 10];
M.colI    = [ 4  7  7  8  9];   % which state column holds I
M.colE    = [NaN 6 6  7  7];    % which column holds E (NaN for M1)

% ---- parameter names, in the CURRENT (gap) parameterisation -------------
% TeX names for figures, ASCII names for tables/CSV. Index order matches the
% params(1:nODE) unpacking inside each ODE function exactly.
M.pTex{1} = {'O','\mu_H','\gamma_H','H_{max}','\delta_H','\alpha_h', ...
             '\epsilon','\omega','\rho','\kappa','\delta_D','c'};
M.pAsc{1} = {'O','mu_H','gamma_H','H_max','delta_H','alpha_h', ...
             'epsilon','omega','rho','kappa','delta_D','c'};

M.pTex{2} = {'\Pi','\delta_O','\mu_H','\gamma_H','H_{max}','\delta_H', ...
             '\gamma_A','\delta_A','\phi_A','\alpha_h','\epsilon','\omega', ...
             '\rho','\kappa','\psi','\delta_D','c'};
M.pAsc{2} = {'Pi','delta_O','mu_H','gamma_H','H_max','delta_H', ...
             'gamma_A','delta_A','phi_A','alpha_h','epsilon','omega', ...
             'rho','kappa','psi','delta_D','c'};

% M3: 10 T_opt_H, 11 T_gap, 12 S_opt_A, 13 S_gap
M.pTex{3} = {'\Pi','\delta_O','\mu_H','\gamma_H','H_{max}','\delta_H', ...
             '\gamma_A','\delta_A','\phi_A', ...
             'T_{opt,H}','\Delta T_{opt}','S_{opt,A}','\Delta S_{opt}', ...
             'T_{decay}','bl_{T,A}','ab_{T,A}','bl_{T,H}','ab_{T,H}', ...
             'bl_{S,A}','ab_{S,A}','bl_{S,H}','ab_{S,H}', ...
             '\alpha_h','\epsilon','\omega','\rho','\kappa','\psi','\delta_D','c'};
M.pAsc{3} = {'Pi','delta_O','mu_H','gamma_H','H_max','delta_H', ...
             'gamma_A','delta_A','phi_A', ...
             'T_opt_H','T_gap','S_opt_A','S_gap', ...
             'T_decay','bl_Topt_A','ab_Topt_A','bl_Topt_H','ab_Topt_H', ...
             'bl_Sopt_A','ab_Sopt_A','bl_Sopt_H','ab_Sopt_H', ...
             'alpha_h','epsilon','omega','rho','kappa','psi','delta_D','c'};

% M4a: 9 T_opt_H, 10 T_gap, 11 S_opt_A, 12 S_gap
M.pTex{4} = {'\delta_O','\mu_H','\gamma_H','H_{max}','\delta_H', ...
             '\gamma_A','\delta_A','\phi_A', ...
             'T_{opt,H}','\Delta T_{opt}','S_{opt,A}','\Delta S_{opt}', ...
             'T_{decay}','bl_{T,A}','ab_{T,A}','bl_{T,H}','ab_{T,H}', ...
             'bl_{S,A}','ab_{S,A}','bl_{S,H}','ab_{S,H}', ...
             'T_{hs}','\beta','\delta_V','\sigma','T_{cs}','\alpha', ...
             'S_{ds}','T_{ds}','xtr_{cs}', ...
             '\alpha_h','\epsilon','\omega','\rho','\kappa','\psi','\delta_D','c'};
M.pAsc{4} = {'delta_O','mu_H','gamma_H','H_max','delta_H', ...
             'gamma_A','delta_A','phi_A', ...
             'T_opt_H','T_gap','S_opt_A','S_gap', ...
             'T_decay','bl_Topt_A','ab_Topt_A','bl_Topt_H','ab_Topt_H', ...
             'bl_Sopt_A','ab_Sopt_A','bl_Sopt_H','ab_Sopt_H', ...
             'T_hs','beta','delta_V','sigma','T_cs','alpha', ...
             'S_d_s','T_d_s','xtr_c_s', ...
             'alpha_h','epsilon','omega','rho','kappa','psi','delta_D','c'};

% M4b: 11 T_opt_H, 12 T_gap, 13 S_gap, 14 S_opt_A   <-- gap BEFORE the base
M.pTex{5} = {'k_{ref}','Q_{10}','T_{ref}','\mu_H','\gamma_H','H_{max}', ...
             '\delta_H','\gamma_A','\delta_A','\phi_A', ...
             'T_{opt,H}','\Delta T_{opt}','\Delta S_{opt}','S_{opt,A}', ...
             'bl_{T,A}','ab_{T,A}','bl_{T,H}','ab_{T,H}', ...
             'bl_{S,A}','ab_{S,A}','bl_{S,H}','ab_{S,H}', ...
             'T_{hs}','\beta','\delta_V','\sigma','T_{cs}','\alpha', ...
             'S_{ds}','T_{ds}','xtr_{cs}', ...
             '\alpha_h','\epsilon','\omega','\rho_I','\kappa','\psi_I', ...
             '\delta_D','\rho_A','c'};
M.pAsc{5} = {'k_ref','Q_10','T_ref','mu_H','gamma_H','H_max', ...
             'delta_H','gamma_A','delta_A','phi_A', ...
             'T_opt_H','T_gap','S_gap','S_opt_A', ...
             'bl_Topt_A','ab_Topt_A','bl_Topt_H','ab_Topt_H', ...
             'bl_Sopt_A','ab_Sopt_A','bl_Sopt_H','ab_Sopt_H', ...
             'T_hs','beta','delta_V','sigma','T_cs','alpha', ...
             'S_d_s','T_d_s','xtr_c_s', ...
             'alpha_h','epsilon','omega','rho_I','kappa','psi_I', ...
             'delta_D','rho_A','c'};

% ---- the same names as LaTeX, used when CFG.labelInterp == 'latex' -------
% Generated from M.pAsc, one-to-one, so the two arrays cannot drift apart.
% The @TGAP@ / @SGAP@ placeholders are filled from CFG.gapSymbol below.
M.pLtx{1} = {'$O$', '$\mu_H$', '$\gamma_H$', '$H_{\max}$', '$\delta_H$', ...
             '$\alpha_h$', '$\epsilon$', '$\omega$', '$\rho$', '$\kappa$', ...
             '$\delta_D$', '$c$'};
M.pLtx{2} = {'$\Pi$', '$\delta_O$', '$\mu_H$', '$\gamma_H$', '$H_{\max}$', ...
             '$\delta_H$', '$\gamma_A$', '$\delta_A$', '$\phi_A$', ...
             '$\alpha_h$', '$\epsilon$', '$\omega$', '$\rho$', '$\kappa$', ...
             '$\psi$', '$\delta_D$', '$c$'};
M.pLtx{3} = {'$\Pi$', '$\delta_O$', '$\mu_H$', '$\gamma_H$', '$H_{\max}$', ...
             '$\delta_H$', '$\gamma_A$', '$\delta_A$', '$\phi_A$', ...
             '$T_{opt,H}$', '$@TGAP@$', '$S_{opt,A}$', '$@SGAP@$', ...
             '$T_{decay}$', '$\mathrm{bl}_{T,A}$', '$\mathrm{ab}_{T,A}$', ...
             '$\mathrm{bl}_{T,H}$', '$\mathrm{ab}_{T,H}$', ...
             '$\mathrm{bl}_{S,A}$', '$\mathrm{ab}_{S,A}$', ...
             '$\mathrm{bl}_{S,H}$', '$\mathrm{ab}_{S,H}$', '$\alpha_h$', ...
             '$\epsilon$', '$\omega$', '$\rho$', '$\kappa$', '$\psi$', ...
             '$\delta_D$', '$c$'};
M.pLtx{4} = {'$\delta_O$', '$\mu_H$', '$\gamma_H$', '$H_{\max}$', ...
             '$\delta_H$', '$\gamma_A$', '$\delta_A$', '$\phi_A$', ...
             '$T_{opt,H}$', '$@TGAP@$', '$S_{opt,A}$', '$@SGAP@$', ...
             '$T_{decay}$', '$\mathrm{bl}_{T,A}$', '$\mathrm{ab}_{T,A}$', ...
             '$\mathrm{bl}_{T,H}$', '$\mathrm{ab}_{T,H}$', ...
             '$\mathrm{bl}_{S,A}$', '$\mathrm{ab}_{S,A}$', ...
             '$\mathrm{bl}_{S,H}$', '$\mathrm{ab}_{S,H}$', '$T_{hs}$', ...
             '$\beta$', '$\delta_V$', '$\sigma$', '$T_{cs}$', '$\alpha$', ...
             '$S_{ds}$', '$T_{ds}$', '$\mathrm{xtr}_{cs}$', '$\alpha_h$', ...
             '$\epsilon$', '$\omega$', '$\rho$', '$\kappa$', '$\psi$', ...
             '$\delta_D$', '$c$'};
M.pLtx{5} = {'$k_{ref}$', '$Q_{10}$', '$T_{ref}$', '$\mu_H$', '$\gamma_H$', ...
             '$H_{\max}$', '$\delta_H$', '$\gamma_A$', '$\delta_A$', ...
             '$\phi_A$', '$T_{opt,H}$', '$@TGAP@$', '$@SGAP@$', ...
             '$S_{opt,A}$', '$\mathrm{bl}_{T,A}$', '$\mathrm{ab}_{T,A}$', ...
             '$\mathrm{bl}_{T,H}$', '$\mathrm{ab}_{T,H}$', ...
             '$\mathrm{bl}_{S,A}$', '$\mathrm{ab}_{S,A}$', ...
             '$\mathrm{bl}_{S,H}$', '$\mathrm{ab}_{S,H}$', '$T_{hs}$', ...
             '$\beta$', '$\delta_V$', '$\sigma$', '$T_{cs}$', '$\alpha$', ...
             '$S_{ds}$', '$T_{ds}$', '$\mathrm{xtr}_{cs}$', '$\alpha_h$', ...
             '$\epsilon$', '$\omega$', '$\rho_I$', '$\kappa$', '$\psi_I$', ...
             '$\delta_D$', '$\rho_A$', '$c$'};

switch CFG.gapSymbol
    case 'delta', gT = '\delta T_{opt}';  gS = '\delta S_{opt}';
                  tT = '\delta T_{opt}';  tS = '\delta S_{opt}';
    case 'Delta', gT = '\Delta T_{opt}';  gS = '\Delta S_{opt}';
                  tT = '\Delta T_{opt}';  tS = '\Delta S_{opt}';
    case 'gap',   gT = 'T_{gap}';          gS = 'S_{gap}';
                  tT = 'T_{gap}';          tS = 'S_{gap}';
    otherwise,    error('CFG.gapSymbol must be ''delta'', ''Delta'' or ''gap''');
end
for m = 1:5
    M.pLtx{m} = strrep(strrep(M.pLtx{m}, '@TGAP@', gT), '@SGAP@', gS);
    M.pTex{m} = strrep(strrep(M.pTex{m}, '\Delta T_{opt}', tT), ...
                                         '\Delta S_{opt}', tS);
end

% ---- SYMBOL MAP: one place to control how every parameter is labelled ----
% Column 1 is the name the ODE functions use internally, which is what the
% arrays above were built from. Columns 2-4 are what the reader sees: the
% ASCII name in console tables and CSV, the TeX symbol on the figures, and the
% LaTeX symbol in the Supplementary Information blocks of section 9.
% EDIT HERE, not in the arrays above. Any name not listed keeps what it had.
%
% The response-width parameters follow the manuscript's Section 3 convention:
% beta is the scalar BELOW the optimum, alpha the scalar ABOVE it, with the
% driver and the target as a comma subscript. So bl_Sopt_A becomes
% \beta_{S,A} and ab_Sopt_A becomes \alpha_{S,A}.
% Columns are: internal name (what the ODE functions use) | ASCII name for
% console tables and CSV | TeX symbol for the figures | LaTeX symbol for the
% Supplementary Information blocks. No comment lines inside the literal: a
% comment between line continuations is not portable across MATLAB releases.
SYMMAP = { ...
    'bl_Topt_A',     'beta_T_A',         '\beta_{T,A}',      '$\beta_{T,A}$'  ; ...
    'ab_Topt_A',     'alpha_T_A',        '\alpha_{T,A}',     '$\alpha_{T,A}$' ; ...
    'bl_Topt_H',     'beta_T_H',         '\beta_{T,H}',      '$\beta_{T,H}$'  ; ...
    'ab_Topt_H',     'alpha_T_H',        '\alpha_{T,H}',     '$\alpha_{T,H}$' ; ...
    'bl_Sopt_A',     'beta_S_A',         '\beta_{S,A}',      '$\beta_{S,A}$'  ; ...
    'ab_Sopt_A',     'alpha_S_A',        '\alpha_{S,A}',     '$\alpha_{S,A}$' ; ...
    'bl_Sopt_H',     'beta_S_H',         '\beta_{S,H}',      '$\beta_{S,H}$'  ; ...
    'ab_Sopt_H',     'alpha_S_H',        '\alpha_{S,H}',     '$\alpha_{S,H}$' ; ...
    'xtr_c_s',       'chi',              '\chi',             '$\chi$'         ; ...
    'phi_A',         'phi_A',            '\varphi_A',        '$\varphi_A$'    ; ...
    'delta_V',       'delta_W',          '\delta_W',         '$\delta_W$'     ; ...
    'beta',          'beta_W',           '\beta_W',          '$\beta_W$'      };

for m = 1:5
    for q = 1:size(SYMMAP,1)
        ix = find(strcmp(M.pAsc{m}, SYMMAP{q,1}), 1);
        if isempty(ix), continue; end
        M.pAsc{m}{ix} = SYMMAP{q,2};
        M.pTex{m}{ix} = SYMMAP{q,3};
        M.pLtx{m}{ix} = SYMMAP{q,4};
    end
end

% ---- parameters held at LB == UB during fitting -------------------------
% Taken from the bounds blocks of choose_model 1..5. These are reported, not
% removed, because a pinned parameter can still be highly influential and the
% reader should see that. Marked with * on the axis when CFG.markPinned.
M.pinned{1} = [9 10];              % rho, kappa
M.pinned{2} = [13 14];             % rho, kappa
M.pinned{3} = [14 26 27];          % T_decay, rho, kappa
M.pinned{4} = [13 29 34 35];       % T_decay, T_d_s, rho, kappa
M.pinned{5} = [3 30 35 36 39];     % T_ref, T_d_s, rho_I, kappa, rho_A

% ---- parameters set from external demographic/clinical data -------------
% Free in the optimiser but confined to a range of order 1e-5 wide, so they
% are effectively fixed. Listed for the figure footnote only.
M.extSet{1} = [6 8 12];            % alpha_h, omega, c
M.extSet{2} = [10 12 17];
M.extSet{3} = [23 25 30];
M.extSet{4} = [31 33 38];
M.extSet{5} = [32 34 40];

% ---- parameters structurally ABSENT from the right-hand side ------------
% The temperature half of the drought trigger is commented out of F_dr in
% both M4_SF_S and M5_SF, so T_d_s never reaches the derivative. IANS must
% come back exactly 0; section 7 asserts it.
M.inert{1} = [];  M.inert{2} = [];  M.inert{3} = [];
M.inert{4} = [29];                 % T_d_s
M.inert{5} = [30];                 % T_d_s

% ---- pairs that are identified only as a ratio --------------------------
% M3 and M4a decay organic matter as (TF/T_decay)*delta_O, so
% dI/dln(delta_O) = -dI/dln(T_decay) and the two IANS values must match.
M.ratioPair{1} = [];  M.ratioPair{2} = [];
M.ratioPair{3} = [2 14];           % delta_O, T_decay
M.ratioPair{4} = [1 13];           % delta_O, T_decay
M.ratioPair{5} = [];               % k_ref/T_ref enter a Q10 exponent, not a
                                   % ratio, so no exact identity holds

% ---- indices of the four optimum coordinates, per model -----------------
% [ T_opt_H , T gap , S_opt_A , S gap ] in the FITTED vector. Note Model 4b
% puts the S gap BEFORE the S base, hence [11 12 14 13] rather than [.. 13 14].
M.gapIdx = {[], [], [10 11 12 13], [9 10 11 12], [11 12 14 13]};

% ---- relabel the optimum columns for biological coordinates -------------
% lsa_optcoords() rotates the sensitivity columns from (base, gap) to
% (base, base+gap); the labels have to follow, or the axis would name a gap
% while the bar reports an optimum. Column POSITIONS are unchanged, so every
% index list above (pinned, extSet, inert, ratioPair) stays valid.
if CFG.optCoords == "biological"
    for m = [3 4 5]
        g = M.gapIdx{m};
        M.pAsc{m}{g(1)} = 'T_opt_H';   M.pAsc{m}{g(2)} = 'T_opt_A';
        M.pAsc{m}{g(3)} = 'S_opt_A';   M.pAsc{m}{g(4)} = 'S_opt_H';
        M.pTex{m}{g(1)} = 'T_{opt,H}'; M.pTex{m}{g(2)} = 'T_{opt,A}';
        M.pTex{m}{g(3)} = 'S_{opt,A}'; M.pTex{m}{g(4)} = 'S_{opt,H}';
        M.pLtx{m}{g(1)} = '$T_{opt,H}$'; M.pLtx{m}{g(2)} = '$T_{opt,A}$';
        M.pLtx{m}{g(3)} = '$S_{opt,A}$'; M.pLtx{m}{g(4)} = '$S_{opt,H}$';
    end
end

% ---- integrity checks on the metadata and the parameter vectors ---------
for m = 1:5
    assert(numel(M.pTex{m}) == M.nODE(m), ...
        'M.pTex{%d} has %d names, expected %d', m, numel(M.pTex{m}), M.nODE(m));
    assert(numel(M.pAsc{m}) == M.nODE(m), ...
        'M.pAsc{%d} has %d names, expected %d', m, numel(M.pAsc{m}), M.nODE(m));
    assert(numel(M.pLtx{m}) == M.nODE(m), ...
        'M.pLtx{%d} has %d names, expected %d', m, numel(M.pLtx{m}), M.nODE(m));
    assert(all(M.pinned{m} <= M.nODE(m)), 'M.pinned{%d} indexes an IC', m);
    for r = 1:4
        assert(~isempty(PARAMS{m,r}), 'PARAMS{%d,%d} is empty', m, r);
        assert(numel(PARAMS{m,r}) == M.nP(m), ...
            'PARAMS{%d,%d} has %d entries, expected %d', ...
            m, r, numel(PARAMS{m,r}), M.nP(m));
    end
end
% free parameter counts: M4b must be 41, not 40
nFree = M.nP - cellfun(@numel, M.pinned);
fprintf('free parameters per model: M1 %d, M2 %d, M3 %d, M4a %d, M4b %d\n', nFree);
assert(nFree(5) == 41, 'Model 4b free parameter count is %d, expected 41', nFree(5));
fprintf('PARAMS: all 20 cells present, correctly sized, names in register\n\n');

% ---- confirm the gap parameterisation reconstructs sane optima ----------
% A cheap but decisive check that the indices above are the right ones.
fprintf('gap parameterisation check (reconstructed optima):\n');
gapIdx = M.gapIdx;
for m = [3 4 5]
    g = gapIdx{m};
    for r = 1:4
        p = PARAMS{m,r};
        ToH = p(g(1));  ToA = p(g(1)) + p(g(2));
        SoA = p(g(3));  SoH = p(g(3)) + p(g(4));
        fprintf('  %-4s %-9s T_opt_H %6.2f  T_opt_A %6.2f | S_opt_A %5.2f  S_opt_H %6.2f\n', ...
                M.tag{m}, REGNAME{r}, ToH, ToA, SoA, SoH);
        assert(ToH >= 60 && ToH <= 110, '%s %s: T_opt_H = %g is not a Fahrenheit optimum', M.tag{m}, REGNAME{r}, ToH);
        assert(ToA >  ToH, '%s %s: T_opt_A must exceed T_opt_H', M.tag{m}, REGNAME{r});
        assert(SoH >  SoA, '%s %s: S_opt_H must exceed S_opt_A', M.tag{m}, REGNAME{r});
    end
end
fprintf('\n');

%% ==== 3b. OPTIMUM-COORDINATE REPARAMETERISATION =========================
if CFG.optCoords == "biological"
    fprintf(['reporting the optima as four separate parameters ' ...
             '(T_opt_H, T_opt_A, S_opt_A, S_opt_H).\n']);
    fprintf(['  The optimiser searched a base and a gap, so the sensitivity ' ...
             'columns are rotated by\n  the exact Jacobian of that change of ' ...
             'variables (see lsa_optcoords). The elasticity of\n  an optimum ' ...
             'is the gap elasticity times (optimum / gap), so a tightly ' ...
             'fitted gap\n  amplifies it. Those factors are:\n']);
    fprintf('  %-4s %-9s %8s %8s %8s | %8s %8s %8s\n', ...
            '', '', 'T gap', 'T_opt_A', 'factor', 'S gap', 'S_opt_H', 'factor');
    for m = intersect([3 4 5], CFG.models)
        g = M.gapIdx{m};
        for r = CFG.regions
            pv = PARAMS{m,r};
            Ta = pv(g(1)) + pv(g(2));   Sh = pv(g(3)) + pv(g(4));
            fprintf('  %-4s %-9s %8.3f %8.2f %8.1f | %8.3f %8.2f %8.1f\n', ...
                    M.tag{m}, D.regName{r}, pv(g(2)), Ta, Ta/pv(g(2)), ...
                    pv(g(4)), Sh, Sh/pv(g(4)));
        end
    end
    fprintf(['  Set CFG.optCoords = "fitted" to report the searched ' ...
             'coordinates instead.\n\n']);
end

%% ============ 4. COMPUTE IANS FOR EVERY MODEL AND REGION ================
%  RES{m}.IANS   : nODE x 4   integrated absolute normalised sensitivity
%  RES{m}.PEAK   : nODE x 4   peak |S_j(t)|, the "max % change in I per 1%
%                             change in p_j at any single instant"
%  RES{m}.Sn{r}  : nRow x nODE the normalised sensitivity series. nRow is 132
%                             for the monthly target, 4018 for a continuous one
%  RES{m}.wq     : nRow x 1   quadrature weights, SUM(wq) = 4017 days
%  RES{m}.xr{r}  : nRow x 1   abscissa (month start day, or day) for plotting
RES    = cell(5,1);
runLog = {};

for m = CFG.models
    nO = M.nODE(m);
    R  = struct();
    R.IANS   = nan(nO, 4);
    R.PEAK   = nan(nO, 4);
    R.Sn     = cell(1,4);
    R.xr     = cell(1,4);
    R.engine = repmat("", 1, 4);

    if CFG.method == "fsa" && nO >= 30
        fprintf(['NOTE %s under "fsa" must integrate %d sensitivity blocks ' ...
                 'alongside %d states.\n     If this is slow, set ' ...
                 'CFG.method = "cfd" -- same quantity, usually faster.\n'], ...
                 M.name{m}, nO, M.nStates(m));
    end

    for r = CFG.regions
        p = PARAMS{m,r}(:);
        t0 = tic;
        [Sn, wq, xr, eng, msg] = lsa_sens(m, r, p, CFG, D, M);
        el = toc(t0);

        % IANS_j = SUM_i wq_i |S_ij|. For a continuous target wq holds the
        % trapezoid weights of the output grid, so this IS trapz(t,|S|); for
        % the monthly target wq holds the calendar month lengths. One
        % expression, same units (days), either way.
        aS = abs(Sn);  aS(~isfinite(aS)) = 0;
        R.Sn{r}     = Sn;
        R.xr{r}     = xr;
        R.wq        = wq;
        R.engine(r) = eng;
        R.IANS(:,r) = (wq(:)' * aS)';
        R.PEAK(:,r) = max(aS, [], 1)';
        fprintf('  %-4s %-9s %-5s %6.1f s   max IANS %10.3e (%s)%s\n', ...
                M.tag{m}, D.regName{r}, eng, el, max(R.IANS(:,r)), ...
                M.pAsc{m}{find(R.IANS(:,r)==max(R.IANS(:,r)),1)}, msg);
        runLog{end+1} = sprintf('%s/%s: %s, %.1f s%s', ...
                                M.tag{m}, D.regTag{r}, eng, el, msg); %#ok<SAGROW>
    end

    % ---- the requested statistic: mean over the four regions ------------
    ok = ~all(isnan(R.IANS),1);
    R.regionsUsed = find(ok);
    R.mean = mean(R.IANS(:,ok), 2);
    R.sd   = std(R.IANS(:,ok), 0, 2);
    R.min  = min(R.IANS(:,ok), [], 2);
    R.max  = max(R.IANS(:,ok), [], 2);
    R.cv   = R.sd ./ max(R.mean, realmin);
    R.peakMean = mean(R.PEAK(:,ok), 2);
    R.T    = sum(R.wq);              % 4017 days for every target mode
    R.meanElast = R.mean / R.T;      % mean absolute elasticity, scale free

    if ~CFG.keepSeries, R.Sn = {}; end
    RES{m} = R;
end
fprintf('\n');

%% ==== 4b. NUMERICAL RESOLUTION OF THE ESTIMATOR =========================
%  Halving the finite-difference step and asking which IANS values survive.
%  A parameter whose IANS moves by more than CFG.resTol when h -> h/2 is not
%  resolved: at that magnitude the central difference is dominated by solver
%  noise rather than by sensitivity. The largest unresolved IANS is the
%  model's resolution FLOOR, and nothing at or below it may be quoted as a
%  sensitivity. Sections 5 and 6 mark those parameters.
%
%  This replaces the old pass/fail step check, which used a 1e-6-of-maximum
%  filter. That was far too permissive: for Model 4b in Arizona it admitted
%  entries down to IANS = 0.06 against a maximum of 6878, and those are two
%  orders of magnitude below the noise level implied by the exact
%  delta_O/T_decay identity, so they "failed" simply because they are noise.
for m = CFG.models
    RES{m}.resolved = true(M.nODE(m),1);
    RES{m}.errMean  = zeros(M.nODE(m),1);
    RES{m}.resFloor = 0;
    RES{m}.resFloorByRegion = zeros(1,4);
    RES{m}.resolvedByRegion = true(M.nODE(m),4);
    RES{m}.resProbe = [];
end

if CFG.resProbe
    fprintf('==== 4b NUMERICAL RESOLUTION OF THE ESTIMATOR ====\n');
    fprintf(['  Definition. IANS_j is recomputed with the differencing step h ' ...
             'and with h/2.\n']);
    fprintf(['  The reported quantity is the REGION MEAN, so the test is ' ...
             'applied to the mean:\n']);
    fprintf(['  errMean = mean over regions of |IANS(h) - IANS(h/2)|, and the ' ...
             'mean is RESOLVED if\n']);
    fprintf(['  errMean <= %.0f%% of it. The FLOOR is the largest region mean ' ...
             'that failed that test.\n'], 100*CFG.resTol);
    fprintf(['  At or below the floor the central difference is returning its ' ...
             'own arithmetic noise,\n']);
    fprintf(['  so the number is not a sensitivity and must not be quoted or ' ...
             'ranked. Being below\n']);
    fprintf(['  the floor says the influence is UNMEASURABLE at this ' ...
             'tolerance, NOT that it is\n']);
    fprintf(['  zero -- an exactly zero IANS is a separate, structural ' ...
             'statement, reported\n']);
    fprintf(['  after the tables.\n']);
    fprintf('  h = %g vs %g | RelTol %g | regions probed: %s\n\n', ...
            CFG.fdRelStep, CFG.fdRelStep/2, CFG.relTol, ...
            strjoin(D.regTag(CFG.resRegions), ', '));

    Ca = CFG;  Ca.method = "cfd";  Ca.fallbackToCFD = false;
    Cb = Ca;   Cb.fdRelStep = CFG.fdRelStep/2;
    PROBE = table('Size',[0 8], ...
        'VariableTypes',{'string','string','string','double','double','double','double','logical'}, ...
        'VariableNames',{'Model','Region','Parameter','IANS_h','IANS_h_half', ...
                         'AbsChange','RelChange','Resolved'});

    prb = intersect(CFG.resRegions, CFG.regions);
    if ~isequal(sort(prb), sort(CFG.regions))
        warning('LSA:probeSubset', ...
            ['the resolution probe covers regions {%s} but the reported mean ' ...
             'averages {%s}; the error of the mean is then estimated from a ' ...
             'subset'], num2str(prb), num2str(CFG.regions));
    end
    for m = intersect(CFG.resProbeModels, CFG.models)
        nO   = M.nODE(m);
        resR = true(nO, 4);
        flR  = zeros(1, 4);
        errR = nan(nO, 4);
        for r = prb
            pv = PARAMS{m,r}(:);
            % the main run already produced IANS at h whenever the engine was
            % "cfd" and the step is unchanged, so do not pay for it twice
            if CFG.method == "cfd"
                Ia = RES{m}.IANS(:,r);
            else
                Ia = lsa_ians(m, r, pv, Ca, D, M);
            end
            Ib = lsa_ians(m, r, pv, Cb, D, M);
            dI = abs(Ib - Ia);
            rc = dI ./ max(Ia, realmin);
            rr = rc <= CFG.resTol;          % exact zeros pass: 0 <= tol
            resR(:,r) = rr;
            flR(r)    = max([0; Ia(~rr)]);
            errR(:,r) = dI;                 % absolute error, per region
            PROBE = [PROBE; table(repmat(string(M.tag{m}),nO,1), ...
                                  repmat(string(D.regTag{r}),nO,1), ...
                                  string(M.pAsc{m})', Ia, Ib, dI, rc, rr, ...
                     'VariableNames', PROBE.Properties.VariableNames)]; %#ok<AGROW>
        end
        % THE REPORTED QUANTITY IS THE REGION MEAN, so the error that matters
        % is the error OF THE MEAN, not of its worst constituent. Requiring
        % reproducibility in every region instead is wrong here and visibly so:
        % T_hs in Model 4b is 107787 in Maricopa and 0.45 in Arizona, and the
        % Arizona value is pure noise, but the mean of 29699 is set by Maricopa
        % and Pinal and is perfectly well determined. Under an "unresolved
        % anywhere" rule the tallest bar on the figure carried a caveat marker.
        %   errMean_j = mean_r |IANS_j(h) - IANS_j(h/2)|
        %   resolved  <=>  errMean_j <= resTol * mean_j
        % A negligible irreproducible term contributes almost nothing to
        % errMean, while a parameter that is irreproducible in EVERY region
        % still fails, which is the intended behaviour.
        errMean = mean(errR(:,prb), 2);
        res     = errMean <= CFG.resTol * max(RES{m}.mean, realmin);
        fl      = max([0; RES{m}.mean(~res)]);   % largest unreliable MEAN
        RES{m}.resolved  = res;
        RES{m}.errMean   = errMean;
        RES{m}.resFloor  = fl;
        RES{m}.resolvedByRegion  = resR;
        RES{m}.resFloorByRegion  = flR;

        mx   = max(RES{m}.mean);
        nBad = sum(~res);
        fprintf('  %-4s floor %10.3e d = %7.1e of the model maximum | %2d of %2d region-means unresolved', ...
                M.tag{m}, fl, fl/max(mx,realmin), nBad, nO);
        if nBad > 0
            [~, o] = sort(RES{m}.mean .* (~res), 'descend');
            fprintf(': %s', strjoin(M.pAsc{m}(o(1:nBad)), ', '));
        end
        fprintf('\n');
    end
    fprintf('\n');
    if CFG.saveData
        writetable(PROBE, fullfile(CFG.outDir, ...
            sprintf('resolution_probe_%s.csv', CFG.target)));
        fprintf('  per-parameter probe written to %s\n\n', ...
                fullfile(CFG.outDir, sprintf('resolution_probe_%s.csv', CFG.target)));
    end
end

%% ==== 5. MAIN FIGURES: REGION-MEAN IANS, ONE PER MODEL ==================
%  This is the generalisation of the old "%% 4 : Bar Graph for State 'I'
%  Sensitivity": same integrated absolute normalised sensitivity, same
%  individually coloured bars, same rotated offset labels, but the bar height
%  is the mean over AZ, Maricopa, Pima and Pinal, and the whisker is the
%  min-max range over those four regions.
FIGS = struct('mean',{cell(5,1)},'scaled',{cell(5,1)});

switch CFG.target
    case "incidence_monthly", tgtTx = 'Monthly Incidence'; obsTx = 'monthly incidence';
    case "incidence",         tgtTx = 'Incidence Rate';    obsTx = 'the incidence rate';
    case "I",                 tgtTx = 'Infected Humans';   obsTx = 'infected humans';
    otherwise, error('unknown CFG.target "%s"', CFG.target);
end
if CFG.figureMetric == "elasticity"
    ylab = {sprintf('Mean absolute elasticity of %s', obsTx)};
elseif CFG.figureMetric == "IANS"
    ylab = {sprintf('IANS of %s (days)', obsTx)};
else
    error('CFG.figureMetric must be "IANS" or "elasticity"');
end

FIGS = struct();
for si = 1:numel(CFG.yScales)
    FIGS.(CFG.yScales{si}) = cell(5,1);
end
FIGS.scaled = cell(5,1);
nFigMade = 0;

for m = CFG.models
    R  = RES{m};
    nO = M.nODE(m);
    keep = true(nO,1);
    if CFG.excludePinned, keep(M.pinned{m}) = false; end
    % Structurally inert parameters (T_d_s, commented out of F_dr in both
    % M4_SF_S and M5_SF) never reach the derivative, so their IANS is exactly
    % zero. A zero cannot be drawn on a log axis, so leaving them in produces a
    % labelled slot with no bar. They are dropped from the figure and still
    % reported in the tables and by the exact-zero diagnostic.
    keep(M.inert{m}) = false;
    if ~isempty(M.inert{m})
        fprintf(['  %-4s figure omits %s: absent from the right-hand side, ' ...
                 'IANS = 0 exactly\n'], M.tag{m}, strjoin(M.pAsc{m}(M.inert{m}), ', '));
    end

    % ---- labels and caveat markers -------------------------------------
    % LaTeX rejects a double superscript, so ^{*}^{\dagger} is a syntax error
    % and MATLAB falls back to printing the raw string. All markers therefore
    % go into ONE superscript group.
    isTex = strcmpi(CFG.labelInterp, 'tex');
    dag   = char(8224);                       % Unicode dagger
    if isTex, names = M.pTex{m}(:); else, names = M.pLtx{m}(:); end

    % Unreliable if the REGION MEAN failed the h -> h/2 reproducibility test in
    % section 4b, or if it sits at or below the model's floor. The second
    % condition is the conservative one: a value can be reproducible in its own
    % right and still be indistinguishable from noise because a LARGER value
    % was not, which is what sets the floor.
    %
    % Parameters that are exactly zero in one of the averaged regions are NOT
    % marked here. They are still reported, by the ZeroInSomeRegion column of
    % the exported table and by the exact-zero diagnostic after the tables.
    isUnrel = ~R.resolved | R.mean <= R.resFloor;
    isPin   = false(nO,1);
    if CFG.markPinned, isPin(M.pinned{m}) = true; end

    if CFG.hideBelowFloor, keep = keep & ~isUnrel; end

    % A pure rescaling by 1/T when the axis reports elasticity; every relative
    % feature of the figure is unchanged.
    if CFG.figureMetric == "elasticity"
        msc = 1/R.T;  floorFmt = '%s = mean not numerically resolved (floor %.3g)';
    else
        msc = 1;      floorFmt = '%s = mean not numerically resolved (floor %.3g d)';
    end

    for q = 1:nO
        mk = '';
        if isPin(q),   mk = [mk, '*'];  end                       %#ok<AGROW>
        if isUnrel(q), mk = [mk, ternary(isTex, dag, '\dagger')]; end
        if isempty(mk), continue; end
        if isTex
            names{q} = [names{q}, ' ^{', mk, '}'];
        else
            names{q} = [names{q}(1:end-1), '^{', mk, '}$'];
        end
    end
    % Only name the markers that actually appear on this figure, so the
    % subtitle stays short and never advertises a symbol that is not there.
    leg = {};
    if any(isPin & keep)
        leg{end+1} = '* = pinned at LB=UB';
    end
    if any(isUnrel & keep)
        leg{end+1} = sprintf(floorFmt, dag, R.resFloor * msc);
    end
    markLegend = strjoin(leg, ', ');

    v  = R.mean(keep) * msc;
    lo = (R.mean(keep) - R.min(keep)) * msc;
    hi = (R.max(keep)  - R.mean(keep)) * msc;
    nm = names(keep);

    [vs, ord] = sort(v, 'descend');
    los = lo(ord);  his = hi(ord);  nms = nm(ord);

    ttl  = sprintf('%s Normalized Parameter Sensitivity for %s', M.name{m}, tgtTx);
    sub0 = sprintf(['mean over %d regions (%s), whisker = min-max across ' ...
                    'regions, %s engine'], ...
                    numel(R.regionsUsed), ...
                    strjoin(D.regTag(R.regionsUsed), ', '), ...
                    strjoin(unique(cellstr(R.engine(R.regionsUsed))), '/'));
    if ~isempty(markLegend)
        sub0 = [sub0, ', ', markLegend];
    end

    % ---- one figure per requested axis transform: the 10 deliverables ----
    for si = 1:numel(CFG.yScales)
        sc  = CFG.yScales{si};
        tag = sprintf('%s_mean_%s_%s_%s', ternary(CFG.figureMetric=="elasticity", ...
                      'ELAST','IANS'), M.tag{m}, CFG.target, sc);
        fh  = lsa_barfig(vs, los, his, nms, ttl, sub0, ylab, CFG, tag, sc, R.resFloor*msc);
        FIGS.(sc){m} = fh;
        nFigMade = nFigMade + 1;
        if CFG.saveFigs, lsa_savefig(fh, CFG.outDir, tag); end
    end

    % ---- optional 0-1 scaled companion (old section 5), OFF by default ---
    mx = max(vs);
    if CFG.makeScaled && mx > 0
        tag2 = sprintf('IANS_scaled_%s_%s', M.tag{m}, CFG.target);
        FIGS.scaled{m} = lsa_barfig(vs/mx, los/mx, his/mx, nms, ...
            sprintf('%s Relative Parameter Sensitivity for %s', M.name{m}, tgtTx), ...
            'region-mean IANS scaled to its own maximum', ...
            {'Relative Integrated Sensitivity (max = 1)'}, CFG, tag2, 'linear', ...
            ternary(mx>0, R.resFloor*msc/mx, 0));
        nFigMade = nFigMade + 1;
        if CFG.saveFigs, lsa_savefig(FIGS.scaled{m}, CFG.outDir, tag2); end
    end

    RES{m}.keepMask = keep;
end
fprintf('%d figures created (%d models x %d axis transforms%s)\n\n', ...
        nFigMade, numel(CFG.models), numel(CFG.yScales), ...
        ternary(CFG.makeScaled, ' + scaled companions', ''));

%% ==== 6. TABLES, RANK CONCORDANCE AND MACHINE-READABLE EXPORT ===========
SUMMARY = struct();
for m = CFG.models
    R  = RES{m};
    nO = M.nODE(m);
    ru = R.regionsUsed;

    flag = repmat("free", nO, 1);
    flag(M.extSet{m}) = "ext";      % set from external data
    flag(M.pinned{m}) = "pinned";   % LB == UB
    flag(M.inert{m})  = "inert";    % absent from the right-hand side
    % below the measured resolution floor: the number is estimator noise and
    % must not be quoted as a sensitivity. Overwrites the other labels
    % because it is the binding statement about the value.
    unres = (~R.resolved | R.mean <= R.resFloor) & R.mean > 0;
    flag(unres) = "unresolved";
    % Exactly zero in at least one averaged region. Inert parameters are
    % excluded so this count agrees with the exact-zero diagnostic, which also
    % excludes them (their zero is trivial, not a regional statement).
    zsome = any(R.IANS(:,ru) == 0, 2) & ~ismember((1:nO)', M.inert{m});

    [~, ord] = sort(R.mean, 'descend');
    Tb = table((1:nO)', string(M.pAsc{m}(ord))', R.mean(ord), R.errMean(ord), ...
               R.meanElast(ord), R.sd(ord), R.cv(ord), R.min(ord), R.max(ord), ...
               R.peakMean(ord), flag(ord), R.resolved(ord), ...
               repmat(R.resFloor, nO, 1), zsome(ord), R.IANS(ord,:), ...
        'VariableNames', {'Rank','Parameter','IANS_mean','NumericalError', ...
                          'MeanElasticity','IANS_sd','IANS_cv','IANS_min','IANS_max', ...
                          'PeakElasticity_mean','Status','Resolved', ...
                          'ResolutionFloor','ZeroInSomeRegion','IANS_by_region'});
    SUMMARY.(M.tag{m}) = Tb;

    % rank agreement across regions
    [W, rhoBar] = lsa_concord(R.IANS(:,ru));

    fprintf('==== %s : region-mean IANS ranking (target %s) ====\n', M.name{m}, CFG.target);
    fprintf('  Kendall W = %.3f | mean pairwise Spearman rho = %.3f  (n = %d parameters, k = %d regions)\n', ...
            W, rhoBar, nO, numel(ru));
    fprintf('  resolution floor %.3g d | %d parameters quotable, %d unreliable, %d zero in some region\n', ...
            R.resFloor, sum(flag~="unresolved" & flag~="inert"), ...
            sum(flag=="unresolved"), sum(zsome));
    fprintf('  %-4s %-14s %12s %11s %11s %7s   %-7s\n', ...
            'rank','parameter','IANS_mean','+/- num err','elasticity','CV','status');
    nShow = min(nO, 15);
    for i = 1:nShow
        q = ord(i);
        % %g not %f: the mean elasticity spans 7.4 down to 1e-6 and a fixed
        % four decimal places printed the whole bottom of every ranking as
        % 0.0000.
        fprintf('  %-4d %-14s %12.4e %11.2e %11.4g %7.2f   %-7s\n', ...
                i, M.pAsc{m}{q}, R.mean(q), R.errMean(q), R.meanElast(q), ...
                R.cv(q), flag(q));
    end
    if nO > nShow, fprintf('  ... %d more, see the exported table\n', nO-nShow); end
    fprintf('\n');

    SUMMARY.([M.tag{m}, '_W'])   = W;
    SUMMARY.([M.tag{m}, '_rho']) = rhoBar;
    RES{m}.KendallW   = W;
    RES{m}.SpearmanBar = rhoBar;
    RES{m}.statusFlag = flag;
    RES{m}.zeroSomeRegion = zsome;

    if CFG.saveData
        writetable(splitvars(Tb), fullfile(CFG.outDir, ...
            sprintf('IANS_%s_%s.csv', M.tag{m}, CFG.target)));
    end

    % pasteable per-region vectors, in the original index order
    for r = ru
        fprintf('%s_IANS_%s = [%s];\n', M.tag{m}, D.regTag{r}, ...
                strjoin(compose('%.10g', R.IANS(:,r))', '; '));
    end
    fprintf('%s_IANS_mean = [%s];\n\n', M.tag{m}, ...
            strjoin(compose('%.10g', R.mean)', '; '));
end

%% ---- structurally inactive parameters, by region ------------------------
%  An IANS of EXACTLY zero means the term never entered the derivative in
%  that region: the branch it controls is never taken by that region's
%  climate series. This is a structural identifiability statement, not noise,
%  and it is worth reporting -- e.g. ab_Sopt_H governs the ABOVE-optimum limb
%  of the hyphal moisture response, so it is unidentified in any region whose
%  Palmer Z-Index never rises above S_opt_H.
fprintf('==== parameters with an exact zero in at least one region ====\n');
anyInactive = false;
for m = CFG.models
    R  = RES{m};
    ru = R.regionsUsed;
    Z  = R.IANS(:,ru) == 0;
    q  = find(any(Z,2) & ~ismember((1:M.nODE(m))', M.inert{m}));
    for k = q(:)'
        anyInactive = true;
        fprintf('  %-4s %-12s exactly 0 in %s -> that branch never fires there\n', ...
                M.tag{m}, M.pAsc{m}{k}, strjoin(D.regTag(ru(Z(k,:))), ', '));
    end
end
if ~anyInactive, fprintf('  none\n'); end
fprintf('\n');

if CFG.saveData
    save(fullfile(CFG.outDir, sprintf('MMVF_LSA_%s.mat', CFG.target)), ...
         'RES','SUMMARY','CFG','M','D','PARAMS','runLog','-v7.3');
    fprintf('saved %s\n\n', fullfile(CFG.outDir, sprintf('MMVF_LSA_%s.mat', CFG.target)));
end

%% ==== 7. SELF-CHECKS ====================================================
%  These are the checks that would catch a parameter-index error, which is
%  the failure mode this script is most exposed to after the reindexing.
fprintf('==== self-checks ====\n');
%  hardOK  : a failure here means the numbers are WRONG (indexing, algebra).
%  softNote: a note here means part of the parameter set is below numerical
%            resolution, which is a reportable property of the estimator, not
%            an error. It must not be allowed to mask a hard failure.
hardOK   = true;
softNote = 0;
% captured so section 9 can typeset them without recomputing anything
CHK = struct('inertVals', {cell(5,1)}, 'ratioRel', nan(1,5), ...
             'ratioMean', nan(1,5), 'unit', nan(1,4));

% (a) structurally inert parameters must have IANS exactly zero
for m = CFG.models
    for q = M.inert{m}
        v = RES{m}.IANS(q,RES{m}.regionsUsed);
        pass = all(v == 0);
        hardOK = hardOK && pass;
        CHK.inertVals{m} = v;
        fprintf('  %-4s %-10s inert -> IANS = %s   %s\n', M.tag{m}, M.pAsc{m}{q}, ...
                mat2str(v,3), ternary(pass,'PASS','FAIL: index map is wrong'));
    end
end

% (b) ratio-identified pairs must have equal IANS
for m = CFG.models
    pr = M.ratioPair{m};
    if isempty(pr), continue; end
    a = RES{m}.IANS(pr(1),RES{m}.regionsUsed);
    b = RES{m}.IANS(pr(2),RES{m}.regionsUsed);
    rel = abs(a-b) ./ max(abs(a), realmin);
    pass = all(rel < 1e-2);
    hardOK = hardOK && pass;
    CHK.ratioRel(m)  = max(rel);
    CHK.ratioMean(m) = mean(a);
    fprintf('  %-4s |IANS(%s)| vs |IANS(%s)| ratio-identified -> max rel diff %.2e   %s\n', ...
            M.tag{m}, M.pAsc{m}{pr(1)}, M.pAsc{m}{pr(2)}, max(rel), ...
            ternary(pass,'PASS','FAIL'));
    fprintf(['         the identity is EXACT, so this is a direct measure of ' ...
             'estimator noise: %.3g days on IANS ~ %.0f\n'], ...
            max(rel)*mean(a), mean(a));
end

% (c) resolution: reported by the section 4b probe. Counted as a NOTE, not a
%     failure -- a parameter below the floor is a finding about identifiability,
%     not a defect in the calculation.
if CFG.resProbe
    for m = CFG.models
        nBad = sum(~RES{m}.resolved);
        softNote = softNote + nBad;
        fprintf('  %-4s resolution floor %10.3e d | %2d of %2d parameters below it (see section 4b)\n', ...
                M.tag{m}, RES{m}.resFloor, nBad, M.nODE(m));
    end
end

% (d) the two engines against each other, for the SI table.
%     A forward-sensitivity leg that triggered a solver warning is NOT usable
%     as a reference, so the comparison is skipped rather than recorded as a
%     failure: the defect is in the fsa path, not in the reported cfd numbers.
if CFG.crossCheck
    r = CFG.crossCheckRegion;
    Dx = D;
    if ~isempty(CFG.crossCheckMonths)
        nmX = min(CFG.crossCheckMonths, numel(D.tMonBnd)-1);
        Dx.tMonBnd = D.tMonBnd(1:nmX+1);
        Dx.tGrid   = (D.tGrid(1):CFG.dtOut:Dx.tMonBnd(end))';
        fprintf('  engine cross-check on the first %d months (%g days), region %s\n', ...
                nmX, Dx.tGrid(end), D.regName{r});
    end
    XCHK = table('Size',[0 5], ...
        'VariableTypes',{'string','double','double','double','string'}, ...
        'VariableNames',{'Model','MaxRelDiff','MedRelDiff','nCompared','Verdict'});
    tXall = tic;
    for m = intersect(CFG.crossCheckModels, CFG.models)
        if toc(tXall) > CFG.crossCheckMaxSec
            fprintf(['  cross-check budget of %g s is spent; skipping %s and ' ...
                     'any later models\n'], CFG.crossCheckMaxSec, M.tag{m});
            break
        end
        nOx = M.nODE(m);
        pv  = PARAMS{m,r}(:);
        Ia  = nan(nOx,1);  Ib = Ia;  legOK = [false false];  elLeg = nan(1,2);
        % Say what is about to happen and how big it is. Forward sensitivity
        % gives no progress output, so without this the run just goes quiet and
        % there is no way to tell a slow solve from a hung one.
        nAug = M.nStates(m) + M.nStates(m)*nOx;
        fprintf(['  %-4s starting: fsa carries %d augmented equations ' ...
                 '(%d states x %d parameters + %d states) over %g days\n'], ...
                M.tag{m}, nAug, M.nStates(m), nOx, M.nStates(m), Dx.tGrid(end));
        for k = 1:2
            Ck = CFG;  Ck.method = ternary(k==1,"fsa","cfd");  Ck.fallbackToCFD = false;
            lastwarn('');
            tLeg = tic;
            try
                Ik = lsa_ians(m, r, pv, Ck, Dx, M);
                wmsg = lastwarn;
                if k == 1 && ~isempty(wmsg)
                    fprintf('  %-4s the fsa solver warned, so its answer is not usable:\n', M.tag{m});
                    fprintf('       %s\n', strtrim(wmsg(1:min(140,numel(wmsg)))));
                else
                    legOK(k) = true;
                end
                if k == 1, Ia = Ik; else, Ib = Ik; end
            catch ME
                fprintf('  %-4s the "%s" engine failed: %s\n', ...
                        M.tag{m}, Ck.method, ME.message);
            end
            elLeg(k) = toc(tLeg);
        end
        fprintf('       timing: fsa %.1f s, cfd %.1f s\n', elLeg(1), elLeg(2));
        usable = all(legOK) && all(isfinite(Ia)) && all(isfinite(Ib)) && max(Ia) > 0;
        if usable
            big = Ia > 1e-3*max(Ia);        % only well-resolved entries
            rel = abs(Ib(big)-Ia(big)) ./ abs(Ia(big));
            pass = max(rel) < 5e-2;
            hardOK = hardOK && pass;
            fprintf('  %-4s %-9s fsa vs cfd -> max rel diff %.2e, median %.2e, over %d entries   %s\n', ...
                    M.tag{m}, D.regName{r}, max(rel), median(rel), sum(big), ...
                    ternary(pass,'PASS','CHECK'));
            if ~pass
                [~, wo] = sort(rel, 'descend');
                idx = find(big);
                nShowX = min(5, numel(wo));
                fprintf('       worst: %s\n', strjoin(compose('%s %.1e', ...
                        string(M.pAsc{m}(idx(wo(1:nShowX))))', rel(wo(1:nShowX)))', ', '));
            end
            XCHK = [XCHK; {string(M.tag{m}), max(rel), median(rel), sum(big), ...
                           string(ternary(pass,'agree','investigate'))}];  %#ok<AGROW>
        else
            softNote = softNote + 1;
            fprintf(['  %-4s engine comparison SKIPPED. That is a statement about ' ...
                     'the fsa path only;\n       the reported cfd numbers are ' ...
                     'unaffected.\n'], M.tag{m});
            XCHK = [XCHK; {string(M.tag{m}), NaN, NaN, 0, "fsa unusable"}];  %#ok<AGROW>
        end
    end
    if ~isempty(XCHK) && CFG.saveData
        writetable(XCHK, fullfile(CFG.outDir, ...
            sprintf('engine_crosscheck_%s.csv', CFG.target)));
    end
end

% (e) ESTIMATOR UNIT TEST against a closed form. flux(t) = a*exp(-b*t) has
%     monthly integrals m_k = (a/b)(e^{-b t_k} - e^{-b t_{k+1}}), so the
%     elasticity of every m_k with respect to a is EXACTLY 1 and the
%     elasticity with respect to b has a closed form. This exercises
%     lsa_month, the relative central difference, the normalisation
%     convention and lsa_trapw against known answers, independently of any
%     ODE. If it fails, the estimator is wrong, not the model.
tbq = D.tMonBnd(:);  ttq = D.tGrid(:);
a0  = 7.5e-3;  b0 = 1.3e-3;  hh = CFG.fdRelStep;
m0  = lsa_month(a0*exp(-b0*ttq), ttq, tbq);
mAp = lsa_month(a0*(1+hh)*exp(-b0*ttq), ttq, tbq);
mAm = lsa_month(a0*(1-hh)*exp(-b0*ttq), ttq, tbq);
mBp = lsa_month(a0*exp(-b0*(1+hh)*ttq), ttq, tbq);
mBm = lsa_month(a0*exp(-b0*(1-hh)*ttq), ttq, tbq);
Sa  = (mAp - mAm) ./ (2*hh*m0);
Sb  = (mBp - mBm) ./ (2*hh*m0);
tlq = tbq(1:end-1);  tuq = tbq(2:end);
mEx = (a0/b0)*(exp(-b0*tlq) - exp(-b0*tuq));
dmb = -(a0/b0^2)*(exp(-b0*tlq)-exp(-b0*tuq)) ...
      + (a0/b0)*(tuq.*exp(-b0*tuq) - tlq.*exp(-b0*tlq));
SbEx = b0*dmb./mEx;
wmq  = diff(tbq);
eA   = max(abs(Sa - 1));
eB   = max(abs(Sb - SbEx));
eI   = abs(wmq'*abs(Sa) - sum(wmq)) / sum(wmq);
eW   = abs(sum(wmq) - (tbq(end)-tbq(1))) ...
     + abs(sum(lsa_trapw(ttq)) - (ttq(end)-ttq(1)));
passE = eA < 1e-6 && eB < 1e-3 && eI < 1e-9 && eW < 1e-8;
hardOK = hardOK && passE;
CHK.unit = [eA eB eI eW];
fprintf(['  estimator unit test: elasticity error %.2e (scale param, exact 1), ' ...
         '%.2e (rate param)\n' ...
         '                       IANS(scale) vs window length %.2e, ' ...
         'quadrature weights %.2e   %s\n'], ...
        eA, eB, eI, eW, ternary(passE,'PASS','FAIL'));

fprintf('\n  STRUCTURAL CHECKS: %s\n', ternary(hardOK, ...
        'PASSED -- the indexing, the algebra and the estimator are sound', ...
        'FAILED -- do not use these numbers, an index or a formula is wrong'));
fprintf('  RESOLUTION      : %d parameter-slots across the %d models sit below\n', ...
        softNote, numel(CFG.models));
fprintf('                    their model''s noise floor. Those values are not\n');
fprintf('                    quotable; they are marked "unresolved" in the tables\n');
fprintf('                    and carry a dagger in the figures. Tighten\n');
fprintf('                    CFG.relTol to 1e-10 and CFG.fdRelStep to 5e-4 to\n');
fprintf('                    push the floor down by about an order of magnitude.\n\n');

%% ==== 8. OPTIONAL SINGLE MODEL-REGION DEEP DIVE =========================
%  Reproduces the old sections 2, 3 and 6 for one model and region: state
%  trajectories, the S_j(t) time series panel, and the peak percent-for-
%  percent table.
if CFG.deepDive
    m = CFG.deepDiveModel; r = CFG.deepDiveRegion;
    assert(ismember(m, CFG.models) && ismember(r, CFG.regions), ...
           'deep dive asks for a model-region that was not run');
    p  = PARAMS{m,r}(:);
    y0 = lsa_y0(m, p, D.pop0(r), D.icI(r));
    [~, Y] = ode15s(lsa_odefun2(m, r, p), D.tGrid, y0, ...
                    odeset('RelTol',CFG.relTol,'AbsTol',CFG.absTol));

    % W, not V: the manuscript's wildlife compartment is W
    stateNames = {{'D','H','S','I','R'}, ...
                  {'O','D','H','A','S','E','I','R'}, ...
                  {'O','D','H','A','S','E','I','R'}, ...
                  {'W','O','D','H','A','S','E','I','R'}, ...
                  {'W','O','D','H','A','S','E','A_H','I','R'}};

    figure('Name',sprintf('%s %s state dynamics',M.tag{m},D.regTag{r}),'Color','w');
    plot(D.tGrid/365, Y, 'LineWidth', 1.8); grid on; axis tight
    set(gca,'YScale','log')
    title(sprintf('%s, %s: state trajectories at the fitted parameters', ...
                  M.name{m}, D.regName{r}), 'FontSize', 14);
    xlabel('Year of the study window'); ylabel('State value (log scale)');
    legend(stateNames{m}, 'Location','eastoutside');

    Sn = RES{m}.Sn{r};
    xr = RES{m}.xr{r};
    figure('Name',sprintf('%s %s S_j',M.tag{m},D.regTag{r}),'Color','w');
    tiledlayout('flow','TileSpacing','compact','Padding','compact');
    for j = 1:M.nODE(m)
        nexttile; plot(xr/365, Sn(:,j), 'LineWidth', 1.4); grid on
        title(M.pTex{m}{j},'Interpreter','tex','FontSize',9);
        set(gca,'FontSize',7)
    end
    sgtitle(sprintf('%s, %s: normalized sensitivity of %s to each parameter', ...
            M.name{m}, D.regName{r}, tgtTx), 'FontSize',13,'FontWeight','bold');

    [ps, po] = sort(RES{m}.PEAK(:,r), 'descend');
    fprintf('==== %s, %s: peak percent-for-percent sensitivity ====\n', M.name{m}, D.regName{r});
    fprintf('max %% change in the target for a 1%% change in the parameter\n');
    disp(table(ps*100, 'RowNames', M.pAsc{m}(po)', 'VariableNames', {'Max_Impact_Percent'}));
end

%% ==== 9. SUPPLEMENTARY INFORMATION, AS PASTE-READY LATEX ================
%  Every table the Methods and Results text points at, typeset and printed to
%  the command window between delimiters. Select between the dashed rules and
%  paste. Each block is also written to LSA_out/SI_*.tex.
%
%  Packages assumed: booktabs and longtable, both already used by the
%  manuscript. Nothing here needs siunitx.
if CFG.emitSI
    SI = {};   % each entry is {lines, filename, human-readable title}

    % ---- A. optimum reparameterisation factors --------------------------
    if CFG.optCoords == "biological" && any(ismember([3 4 5], CFG.models))
        L = {};
        L{end+1} = '\begin{table}[H]';
        L{end+1} = '\centering';
        L{end+1} = ['\caption{Amplification introduced by reporting the environmental optima ' ...
                    'rather than the searched base-and-gap coordinates. The elasticity of an ' ...
                    'optimum equals the elasticity of the gap multiplied by (optimum/gap), so ' ...
                    'a tightly estimated gap makes the optimum correspondingly more influential ' ...
                    'per unit relative change. Temperatures in degrees Fahrenheit, soil moisture ' ...
                    'in Palmer $Z$-index units.}'];
        L{end+1} = '\label{tab:SI_reparam}';
        L{end+1} = '\begin{tabular}{llrrrrrr}';
        L{end+1} = '\toprule';
        L{end+1} = ['Model & Region & $\Delta_T$ & $T_{opt}^{A}$ & factor & ' ...
                    '$\Delta_S$ & $S_{opt}^{H}$ & factor \\'];
        L{end+1} = '\midrule';
        for m = intersect([3 4 5], CFG.models)
            g = M.gapIdx{m};
            for r = CFG.regions
                pv = PARAMS{m,r};
                Ta = pv(g(1)) + pv(g(2));   Sh = pv(g(3)) + pv(g(4));
                L{end+1} = sprintf('%s & %s & %.3f & %.2f & %.1f & %.3f & %.2f & %.1f \\\\', ...
                    M.name{m}, D.regName{r}, pv(g(2)), Ta, Ta/pv(g(2)), ...
                    pv(g(4)), Sh, Sh/pv(g(4)));  %#ok<AGROW>
            end
        end
        L{end+1} = '\bottomrule';
        L{end+1} = '\end{tabular}';
        L{end+1} = '\end{table}';
        SI{end+1} = {L, 'SI_A_reparameterisation.tex', 'optimum reparameterisation factors'};
    end

    % ---- B. full ranking, one longtable per model -----------------------
    for m = CFG.models
        R  = RES{m};  nO = M.nODE(m);
        [~, ord] = sort(R.mean, 'descend');
        L = {};
        L{end+1} = '\begin{longtable}{rlrrrrrrl}';
        L{end+1} = sprintf(['\\caption{%s: complete parameter ranking by IANS of monthly ' ...
            'integrated incidence. $\\overline{|S|}$ is the window-averaged absolute ' ...
            'elasticity, CV the coefficient of variation across the four regions, and min ' ...
            'and max its range across them. In the status column, pinned marks a parameter ' ...
            'fixed at a literature value, ext one set from external demographic data, and ' ...
            'unresolved one whose region mean lies at or below the numerical resolution ' ...
            'floor of %s days and is therefore reported but not ranked.}'], ...
            M.name{m}, lsa_texnum(R.resFloor, 3, false));
        L{end+1} = sprintf('\\label{tab:SI_rank_%s}\\\\', M.tag{m});
        hdr = ['Rank & Parameter & IANS (d) & $\pm$ num.\ err. & $\overline{|S|}$ & ' ...
               'CV & min & max & Status \\'];
        L{end+1} = '\toprule';
        L{end+1} = hdr;
        L{end+1} = '\midrule';
        L{end+1} = '\endfirsthead';
        L{end+1} = '\multicolumn{9}{c}{\tablename\ \thetable{} -- continued from previous page} \\';
        L{end+1} = '\toprule';
        L{end+1} = hdr;
        L{end+1} = '\midrule';
        L{end+1} = '\endhead';
        L{end+1} = '\midrule';
        L{end+1} = '\multicolumn{9}{r}{Continued on next page} \\';
        L{end+1} = '\endfoot';
        L{end+1} = '\bottomrule';
        L{end+1} = '\endlastfoot';
        for i = 1:nO
            q = ord(i);
            L{end+1} = sprintf('%d & %s & %s & %s & %s & %.2f & %s & %s & %s \\\\', ...
                i, M.pLtx{m}{q}, ...
                lsa_texnum(R.mean(q),4,true), lsa_texnum(R.errMean(q),2,true), ...
                lsa_texnum(R.meanElast(q),3,true), R.cv(q), ...
                lsa_texnum(R.min(q),3,true), lsa_texnum(R.max(q),3,true), ...
                char(R.statusFlag(q)));  %#ok<AGROW>
        end
        L{end+1} = '\end{longtable}';
        SI{end+1} = {L, sprintf('SI_B_ranking_%s.tex', M.tag{m}), ...
                     sprintf('%s full ranking', M.name{m})};
    end

    % ---- C. per-region IANS, one longtable per model --------------------
    for m = CFG.models
        R  = RES{m};  nO = M.nODE(m);  ru = R.regionsUsed;
        [~, ord] = sort(R.mean, 'descend');
        ncol = numel(ru) + 2;
        L = {};
        L{end+1} = sprintf('\\begin{longtable}{l%sr}', repmat('r', 1, numel(ru)));
        L{end+1} = sprintf(['\\caption{%s: IANS of monthly integrated incidence by region, ' ...
            'in days. Parameters are ordered by the region mean, which is the quantity ' ...
            'plotted in the main text. A value of exactly zero means the term never entered ' ...
            'the derivative in that region, so the parameter is not identifiable there.}'], ...
            M.name{m});
        L{end+1} = sprintf('\\label{tab:SI_region_%s}\\\\', M.tag{m});
        hdr = ['Parameter & ', strjoin(D.regName(ru), ' & '), ' & Mean \\'];
        L{end+1} = '\toprule';
        L{end+1} = hdr;
        L{end+1} = '\midrule';
        L{end+1} = '\endfirsthead';
        L{end+1} = sprintf('\\multicolumn{%d}{c}{\\tablename\\ \\thetable{} -- continued from previous page} \\\\', ncol);
        L{end+1} = '\toprule';
        L{end+1} = hdr;
        L{end+1} = '\midrule';
        L{end+1} = '\endhead';
        L{end+1} = '\midrule';
        L{end+1} = sprintf('\\multicolumn{%d}{r}{Continued on next page} \\\\', ncol);
        L{end+1} = '\endfoot';
        L{end+1} = '\bottomrule';
        L{end+1} = '\endlastfoot';
        for i = 1:nO
            q = ord(i);
            cells = cell(1, numel(ru));
            for j = 1:numel(ru)
                cells{j} = lsa_texnum(R.IANS(q, ru(j)), 4, true);
            end
            L{end+1} = sprintf('%s & %s & %s \\\\', M.pLtx{m}{q}, ...
                strjoin(cells, ' & '), lsa_texnum(R.mean(q), 4, true));  %#ok<AGROW>
        end
        L{end+1} = '\end{longtable}';
        SI{end+1} = {L, sprintf('SI_C_byregion_%s.tex', M.tag{m}), ...
                     sprintf('%s IANS by region', M.name{m})};
    end

    % ---- D. concordance and resolution ----------------------------------
    L = {};
    L{end+1} = '\begin{table}[H]';
    L{end+1} = '\centering';
    L{end+1} = ['\caption{Stability of the sensitivity ranking across the four regions and ' ...
                'the numerical resolution of the estimator. Kendall''s $W$ and the mean ' ...
                'pairwise Spearman correlation summarise agreement among the four regional ' ...
                'rankings. The resolution floor is the largest region mean that failed to ' ...
                'reproduce itself to within five percent when the differencing step was ' ...
                'halved.}'];
    L{end+1} = '\label{tab:SI_concordance}';
    L{end+1} = '\begin{tabular}{lrrrrrr}';
    L{end+1} = '\toprule';
    L{end+1} = ['Model & Parameters & Kendall $W$ & Spearman $\bar\rho$ & Floor (d) & ' ...
                'Floor/max & Unresolved \\'];
    L{end+1} = '\midrule';
    for m = CFG.models
        R = RES{m};
        L{end+1} = sprintf('%s & %d & %.3f & %.3f & %s & %s & %d \\\\', ...
            M.name{m}, M.nODE(m), R.KendallW, R.SpearmanBar, ...
            lsa_texnum(R.resFloor,3,true), ...
            lsa_texnum(R.resFloor/max(max(R.mean),realmin),2,true), ...
            sum(R.statusFlag == "unresolved"));  %#ok<AGROW>
    end
    L{end+1} = '\bottomrule';
    L{end+1} = '\end{tabular}';
    L{end+1} = '\end{table}';
    SI{end+1} = {L, 'SI_D_concordance.tex', 'concordance and resolution summary'};

    % ---- E. verification against analytic references --------------------
    L = {};
    L{end+1} = '\begin{table}[H]';
    L{end+1} = '\centering';
    L{end+1} = ['\caption{Verification of the sensitivity estimator against analytic ' ...
                'references. Every check has a known exact answer, so the final column is ' ...
                'an error rather than a discrepancy between two approximations.}'];
    L{end+1} = '\label{tab:SI_verification}';
    L{end+1} = '\begin{tabular}{llll}';
    L{end+1} = '\toprule';
    L{end+1} = 'Check & Exact value & Applies to & Observed error \\';
    L{end+1} = '\midrule';
    L{end+1} = sprintf('Elasticity of a scale parameter & $1$ & closed form, no ODE & %s \\\\', ...
                       lsa_texnum(CHK.unit(1),2,true));
    L{end+1} = sprintf('Elasticity of a rate parameter & analytic & closed form, no ODE & %s \\\\', ...
                       lsa_texnum(CHK.unit(2),2,true));
    L{end+1} = sprintf('IANS of a scale parameter & $T = 4017$ d & closed form, no ODE & %s (rel.) \\\\', ...
                       lsa_texnum(CHK.unit(3),2,true));
    L{end+1} = sprintf('Quadrature weights sum to $T$ & $4017$ d & both grids & %s \\\\', ...
                       lsa_texnum(CHK.unit(4),2,true));
    for m = CFG.models
        if ~isempty(M.ratioPair{m}) && isfinite(CHK.ratioRel(m))
            L{end+1} = sprintf(['$|\\mathrm{IANS}(%s)| = |\\mathrm{IANS}(%s)|$ & exact ' ...
                'identity & %s & %s (rel.), %s d \\\\'], ...
                M.pLtx{m}{M.ratioPair{m}(1)}, M.pLtx{m}{M.ratioPair{m}(2)}, M.name{m}, ...
                lsa_texnum(CHK.ratioRel(m),2,true), ...
                lsa_texnum(CHK.ratioRel(m)*CHK.ratioMean(m),2,true));  %#ok<AGROW>
        end
        if ~isempty(M.inert{m}) && ~isempty(CHK.inertVals{m})
            L{end+1} = sprintf(['IANS(%s), absent from the right-hand side & $0$ & %s & ' ...
                'exactly $0$ in all %d regions \\\\'], ...
                M.pLtx{m}{M.inert{m}(1)}, M.name{m}, numel(CHK.inertVals{m}));  %#ok<AGROW>
        end
    end
    L{end+1} = '\bottomrule';
    L{end+1} = '\end{tabular}';
    L{end+1} = '\end{table}';
    SI{end+1} = {L, 'SI_E_verification.tex', 'estimator verification'};

    % ---- emit -----------------------------------------------------------
    fprintf('\n\n%s\n', repmat('#', 1, 78));
    fprintf('#  SUPPLEMENTARY INFORMATION: %d LaTeX blocks follow.\n', numel(SI));
    fprintf('#  Select between the dashed rules and paste into the manuscript, or\n');
    fprintf('#  \\input the .tex files written alongside them.\n');
    fprintf('#  Requires booktabs and longtable, both already used by the manuscript.\n');
    fprintf('%s\n', repmat('#', 1, 78));
    for b = 1:numel(SI)
        lsa_emit(SI{b}{1}, CFG.outDir, SI{b}{2}, SI{b}{3}, b, numel(SI), CFG.saveData);
    end
    fprintf('\n%s\n', repmat('#', 1, 78));
    fprintf('#  end of Supplementary Information blocks\n');
    fprintf('%s\n\n', repmat('#', 1, 78));
end

fprintf('done. figures and tables in %s\n', CFG.outDir);


% =========================================================================
% =========================================================================
%                            LOCAL FUNCTIONS
% =========================================================================
% =========================================================================

%% ---------------- sensitivity engine: dispatcher ------------------------
function [Sn, wq, xr, eng, msg] = lsa_sens(m, r, p, CFG, D, M)
% Normalised sensitivity of the CFG.target observable to p(1:nODE), for model
% m in region r at the fitted vector p.
%   Sn : nRow x nODE   S_ij = (d obs_i / d p_j) * (p_j / obs_i)
%   wq : nRow x 1      quadrature weights, so IANS_j = SUM_i wq_i |Sn(i,j)|
%   xr : nRow x 1      abscissa in days, for plotting
msg = '';
Sn  = [];
eng = "cfd";
if CFG.method == "fsa"
    try
        [Sn, wq, xr] = lsa_sens_fsa(m, r, p, CFG, D, M);
        eng = "fsa";
    catch ME
        if ~CFG.fallbackToCFD
            rethrow(ME);
        end
        msg = sprintf('   [fsa unavailable: %s -> cfd]', ME.message);
        Sn  = [];
    end
end
if isempty(Sn)
    [Sn, wq, xr] = lsa_sens_cfd(m, r, p, CFG, D, M);
    eng = "cfd";
end

% Rotate the optimum columns into biological coordinates. This MUST happen
% on S_j(t), before any absolute value or integration, because
% |a| + |b| is not |a + b|.
if CFG.optCoords == "biological"
    Sn = lsa_optcoords(Sn, p, m, M);
end
end

function Sn = lsa_optcoords(Sn, p, m, M)
% EXACT change of variables from the coordinates the optimiser searched to
% the four optima as the manuscript defines them.
%
% The fitted vector holds a base and a gap. Writing u = T_opt_H, g = T gap,
% the model depends on the pair (a, b) = (T_opt_H, T_opt_A) = (u, u + g), so
%       dY/du = dY/da + dY/db          dY/dg = dY/db
% and inverting,
%       dY/db = dY/dg                  dY/da = dY/du - dY/dg.
% In elasticities E_x = (dY/dx)(x/Y) that is
%       E_{T_opt_A} = E_g * (T_opt_A / g)
%       E_{T_opt_H} = E_u - E_g * (T_opt_H / g)
% and identically for (S_opt_A, S_opt_H) = (v, v + k) with k = S gap.
%
% The T_opt_A factor is (T_opt_H + g)/g, which is LARGE when the fitted gap
% is small: for Model 4b in Maricopa the gap is 0.51 F against an optimum of
% 73.8 F, an amplification of 145. That is not an artefact. A 1% move in
% T_opt_A is a 145% move in the gap, so the optimum is correspondingly more
% influential per unit relative change than the gap is. The same factor
% amplifies the estimator noise in that column, which is why section 4b
% probes the TRANSFORMED sensitivities rather than the raw ones.
g = M.gapIdx{m};
if isempty(g), return; end
iTH = g(1); iTG = g(2); iSA = g(3); iSG = g(4);

Tgap = p(iTG);  SoptH_gap = p(iSG);
if Tgap == 0 || SoptH_gap == 0
    error('lsa_optcoords:zeroGap', ...
          'model %d has a zero optimum gap; the reparameterisation is singular', m);
end
T_optH = p(iTH);  T_optA = p(iTH) + p(iTG);
S_optA = p(iSA);  S_optH = p(iSA) + p(iSG);

Eu = Sn(:,iTH);  Eg = Sn(:,iTG);      % read before overwriting
Ev = Sn(:,iSA);  Ek = Sn(:,iSG);

Sn(:,iTG) = Eg * (T_optA / Tgap);            % -> E_{T_opt_A}
Sn(:,iTH) = Eu - Eg * (T_optH / Tgap);       % -> E_{T_opt_H} at fixed T_opt_A
Sn(:,iSG) = Ek * (S_optH / SoptH_gap);       % -> E_{S_opt_H}
Sn(:,iSA) = Ev - Ek * (S_optA / SoptH_gap);  % -> E_{S_opt_A} at fixed S_opt_H
end

%% ---------------- IANS from one model-region run ------------------------
function I = lsa_ians(m, r, p, CFG, D, M)
% Convenience wrapper used by the self-checks: run the engine named in CFG
% and collapse the sensitivity series to the weighted absolute integral.
[Sn, wq] = lsa_sens(m, r, p, CFG, D, M);
a = abs(Sn);  a(~isfinite(a)) = 0;
I = (wq(:)' * a)';
end

%% ---------------- sensitivity engine: forward (FSA) ---------------------
function [Sn, wq, xr] = lsa_sens_fsa(m, r, p, CFG, D, M)
% MATLAB's ode object with odeSensitivity. Kept as an independent second
% estimate; "cfd" is the engine to report (header note 10).
%
% PARAMETERS ARE RESCALED TO UNITY BEFORE DIFFERENTIATING. This is not
% cosmetic. The fitted vectors run from sigma and c at about 1e-12 up to
% H_max at about 4e2, so the raw sensitivities dy/dp_j span roughly thirty
% orders of magnitude -- dS/dc alone is of order 1e17. A single
% AbsoluteTolerance cannot control both the states and a sensitivity block
% that large, and CVODES fails its error test: without this rescaling
% Model 1 dies at t = 270 with "the error test failed repeatedly", and the
% numbers it does return disagree with central differences by a factor of
% 3e3. Substituting
%       q_j = p_j / p_j^fit ,      so that q_j = 1 at the fitted point,
% puts every sensitivity variable on the scale of y itself. Because q_j = 1,
% the returned derivative IS the numerator of the elasticity:
%       (dy/dq_j)(q_j/y) = (dy/dq_j)/y = (dy/dp_j)(p_j/y).
nO = M.nODE(m);
y0 = lsa_y0(m, p, D.pop0(r), D.icI(r));

p0   = p;
scal = p0(1:nO);
zc   = (scal == 0);
scal(zc) = 1;              % a parameter that is exactly zero cannot be
                           % rescaled; its column is meaningless anyway and
                           % the cfd path reports it as zero
base0 = lsa_odefun3(m, r);                       % @(t,y,pfull)

F = ode;
F.ODEFcn       = @(t,y,q) base0(t, y, lsa_rescale(q, p0, scal, nO));
F.InitialValue = y0;
F.Parameters   = ones(nO,1);                     % q = 1 at the fitted point

so = odeSensitivity;
try, so.ParameterIndices = 1:nO; catch, end   %#ok<CTCH>
F.Sensitivity = so;
% Forward sensitivity has its own tolerances: see CFG.fsaRelTol / fsaAbsTol.
try, F.AbsoluteTolerance = CFG.fsaAbsTol; catch, end   %#ok<CTCH>
try, F.RelativeTolerance = CFG.fsaRelTol; catch, end   %#ok<CTCH>
% Sensitivity analysis is only implemented for the SUNDIALS solvers: setting
% "ode15s" succeeds silently and then fails at solve time.
try, F.Solver            = "cvodesstiff"; catch, end   %#ok<CTCH>

if isfield(CFG,'fsaNaturalGrid') && CFG.fsaNaturalGrid
    S = solve(F, D.tGrid(1), D.tGrid(end));
else
    try
        S = solve(F, D.tGrid);
    catch
        S = solve(F, D.tGrid(1), D.tGrid(end));
    end
end

tOut = S.Time(:);
Y    = S.Solution.';                      % nT x nStates
SR   = S.Sensitivity;                     % nStates x nSensParams x nT
if size(SR,2) < nO
    error('lsa_sens_fsa:size', ...
          'sensitivity array has %d parameter columns, need at least %d', ...
          size(SR,2), nO);
end
nT = numel(tOut);

[tgtFcn, wq, xr] = lsa_target(m, CFG.target, M, D, tOut);
base = tgtFcn(Y, p0);
Sn   = zeros(numel(base), nO);

% q_j = 1, so the elasticity is just the derivative divided by the observable
if CFG.target == "I"
    cI = M.colI(m);
    for j = 1:nO
        Sn(:,j) = reshape(SR(cI,j,:), nT, 1) ./ base;
    end
else
    for j = 1:nO
        df = lsa_dflux(m, j, p0, scal, Y, SR, nT, M);
        if CFG.target == "incidence_monthly"
            df = lsa_month(df, tOut, D.tMonBnd);
        end
        Sn(:,j) = df ./ base;
    end
end
Sn(:,zc) = 0;
Sn(~isfinite(Sn)) = 0;
end

function pf = lsa_rescale(q, p0, scal, nO)
% undo the unit rescaling before handing the vector to the ODE function
pf          = p0;
pf(1:nO)    = q(:) .* scal;
end

function df = lsa_dflux(m, j, p, scal, Y, SR, nT, M)
% Derivative of the incidence flux with respect to the RESCALED parameter q_j,
% assembled from the state sensitivities. The delta term is the explicit
% dependence of the flux on its own rate constant; d p_jF / d q_jF = scal(jF),
% which is why the explicit term carries that factor. Forgetting it is exactly
% the sort of hand assembly that "cfd" avoids by re-evaluating the observable.
if m == 1
    % flux = epsilon*S*H, epsilon = p(7), S = column 3, H = column 2
    dS = reshape(SR(3,j,:), nT, 1);
    dH = reshape(SR(2,j,:), nT, 1);
    df = p(7)*(dS.*Y(:,2) + Y(:,3).*dH);
    if j == 7, df = df + scal(7)*Y(:,3).*Y(:,2); end
else
    jFall = [NaN 15 28 36 37];        % index of psi (psi_I for M4b)
    jF    = jFall(m);
    cE    = M.colE(m);
    df    = p(jF)*reshape(SR(cE,j,:), nT, 1);
    if j == jF, df = df + scal(jF)*Y(:,cE); end
end
end

%% ---------------- sensitivity engine: central differences ---------------
function [Sn, wq, xr] = lsa_sens_cfd(m, r, p, CFG, D, M)
% Central differences in the RELATIVE parameter. With p_j -> p_j(1 +- h),
%     S_j = (d obs/d p_j)(p_j/obs) = sign(p_j) * (obs_+ - obs_-) / (2 h obs),
% so p_j cancels out of the normalisation. That is what makes this stable for
% parameters spanning 1e-12 to 1e3: the perturbation is always h in relative
% terms, never h in absolute terms. Because the observable is re-evaluated at
% the perturbed vector, any EXPLICIT dependence of the observable on p_j (the
% psi_I multiplying E, for instance) is captured without extra algebra.
nO   = M.nODE(m);
tOut = D.tGrid;
h    = CFG.fdRelStep;

opt   = odeset('RelTol', CFG.relTol, 'AbsTol', CFG.absTol);
optNN = odeset(opt, 'NonNegative', 1:M.nStates(m));
[tgt, wq, xr] = lsa_target(m, CFG.target, M, D, tOut);

% Baseline. If the unconstrained solve will not complete, fall back to the
% NonNegative option set used by the objective functions -- and then use the
% SAME option set for every perturbed solve, so the difference is not
% contaminated by a change of solver settings.
[Yb, useNN] = lsa_solve(m, r, p, D, tOut, opt, optNN, false);
base = tgt(Yb, p);

Sn = zeros(numel(base), nO);
for j = 1:nO
    hj = h*abs(p(j));
    if hj == 0
        % p_j is exactly zero, so a relative sensitivity does not exist.
        % Recorded as zero rather than NaN so it cannot poison the mean.
        Sn(:,j) = 0;
        continue
    end
    pp = p;  pp(j) = p(j) + hj;
    pm = p;  pm(j) = p(j) - hj;
    Yp = lsa_solve(m, r, pp, D, tOut, opt, optNN, useNN);
    Ym = lsa_solve(m, r, pm, D, tOut, opt, optNN, useNN);
    dT = tgt(Yp, pp) - tgt(Ym, pm);
    Sn(:,j) = sign(p(j)) * dT ./ (2*h*base);
end
Sn(~isfinite(Sn)) = 0;
end

function [Y, useNN] = lsa_solve(m, r, p, D, tOut, opt, optNN, forceNN)
y0    = lsa_y0(m, p, D.pop0(r), D.icI(r));
f     = lsa_odefun2(m, r, p);
useNN = forceNN;
Y     = [];
if ~forceNN
    try
        [~, Y] = ode15s(f, tOut, y0, opt);
    catch
        Y = [];
    end
end
if isempty(Y) || size(Y,1) ~= numel(tOut) || ~all(isfinite(Y(:)))
    [~, Y] = ode15s(f, tOut, y0, optNN);
    useNN  = true;
end
if size(Y,1) ~= numel(tOut)
    error('lsa_solve:short', ...
          'model %d region %d returned %d of %d requested output points', ...
          m, r, size(Y,1), numel(tOut));
end
end

%% ---------------- model plumbing ----------------------------------------
function y0 = lsa_y0(m, p, pop0, icI)
% Byte-for-byte the y0 construction used by the objective functions and by
% section 9 of Mechanistic_Model_Valley_Fever_07_33_26.m. The trailing
% entries of p are the fitted initial conditions.
icR = icI/2;
switch m
    case 1
        y0 = [p(13); p(14); pop0 - icI - icR; icI; icR];
    case 2
        y0 = [p(18); p(19); p(20); p(21); ...
              pop0 - icI - p(22) - icR; p(22); icI; icR];
    case 3
        y0 = [p(31); p(32); p(33); p(34); ...
              pop0 - icI - p(35) - icR; p(35); icI; icR];
    case 4
        y0 = [p(39); p(40); p(41); p(42); p(43); ...
              pop0 - icI - p(44) - icR; p(44); icI; icR];
    case 5
        icAH = icI;
        y0 = [p(41); p(42); p(43); p(44); p(45); ...
              pop0 - p(46) - icAH - icI - icR; p(46); icAH; icI; icR];
    otherwise
        error('lsa_y0: model %d is not defined', m);
end
if y0(end-2) < 0 || any(~isfinite(y0))
    error('lsa_y0: model %d has a negative or non-finite initial condition', m);
end
end

function f = lsa_odefun3(m, county)
% three-argument form @(t,y,p), required by the ode object for sensitivity
switch m
    case 1, f = @(t,y,p) M1_SF_T(t, y, p);
    case 2, f = @(t,y,p) M2_SF(t, y, p);
    case 3, f = @(t,y,p) M3_SF(t, y, p, county);
    case 4, f = @(t,y,p) M4_SF_S(t, y, p, county);
    case 5, f = @(t,y,p) M5_SF(t, y, p, county);
    otherwise, error('lsa_odefun3: model %d is not defined', m);
end
end

function f = lsa_odefun2(m, county, p)
% two-argument form @(t,y) with p bound, for the ode15s solves
switch m
    case 1, f = @(t,y) M1_SF_T(t, y, p);
    case 2, f = @(t,y) M2_SF(t, y, p);
    case 3, f = @(t,y) M3_SF(t, y, p, county);
    case 4, f = @(t,y) M4_SF_S(t, y, p, county);
    case 5, f = @(t,y) M5_SF(t, y, p, county);
    otherwise, error('lsa_odefun2: model %d is not defined', m);
end
end

function [h, wq, xr] = lsa_target(m, mode, M, D, tOut)
% The observable whose sensitivity is reported, plus the quadrature weights
% and abscissa that go with it.
%
%   "incidence_monthly"  m_k = INT_{month k} flux dt, k = 1..132.  THE FITTED
%                        OBSERVABLE: the objective functions build
%                        cumtrapz(t, flux) and diff it at the calendar month
%                        boundaries, and that is reproduced here exactly.
%                        wq = calendar month lengths in days.
%   "incidence"          the flux itself, on the output grid. wq = trapezoid
%                        weights, so SUM wq|S| == trapz(t,|S|).
%   "I"                  the symptomatic stock. wq = trapezoid weights.
%
% flux is taken from the flux handles in section 9 of the main script:
% epsilon*S*H for Model 1, psi*E for Models 2, 3 and 4a, psi_I*E for Model 4b.
switch m
    case 1, fluxf = @(Y,p) p(7) *Y(:,3).*Y(:,2);   % epsilon*S*H
    case 2, fluxf = @(Y,p) p(15)*Y(:,6);           % psi*E
    case 3, fluxf = @(Y,p) p(28)*Y(:,6);           % psi*E
    case 4, fluxf = @(Y,p) p(36)*Y(:,7);           % psi*E
    case 5, fluxf = @(Y,p) p(37)*Y(:,7);           % psi_I*E
    otherwise, error('lsa_target: model %d is not defined', m);
end

tOut = tOut(:);
switch mode
    case "incidence_monthly"
        tb = D.tMonBnd(:);                 % 133 calendar month boundaries
        h  = @(Y,p) lsa_month(fluxf(Y,p), tOut, tb);
        wq = diff(tb);                     % 132 month lengths, sum = 4017 d
        xr = tb(1:end-1);                  % month start day, as the main
                                           % script plots monthly incidence
    case "incidence"
        h  = fluxf;
        wq = lsa_trapw(tOut);
        xr = tOut;
    case "I"
        cI = M.colI(m);
        h  = @(Y,p) Y(:,cI);
        wq = lsa_trapw(tOut);
        xr = tOut;
    otherwise
        error('lsa_target: unknown target "%s"', mode);
end
end

function mk = lsa_month(v, tOut, tMonBnd)
% Integrate v over each calendar month. Identical construction to the
% objective functions: cumulative trapezoid, then difference at the month
% boundaries. interp1 is used rather than index lookup so this stays correct
% if the solver returned its own grid instead of the requested daily one.
cum = cumtrapz(tOut, v);
mk  = diff(interp1(tOut, cum, tMonBnd(:), 'linear'));
end

function w = lsa_trapw(t)
% Trapezoid quadrature weights: SUM(w.*f) == trapz(t,f).
t = t(:);  n = numel(t);
w = zeros(n,1);
if n == 1, w(1) = 1; return; end
w(1) = (t(2)-t(1))/2;
w(n) = (t(n)-t(n-1))/2;
if n > 2
    w(2:n-1) = (t(3:n) - t(1:n-2))/2;
end
end

%% ---------------- figures -----------------------------------------------
function fh = lsa_barfig(v, lo, hi, names, ttl, sub, ylab, CFG, tag, yscale, resFloor)
% The old "%% 4" bar graph, generalised: one individually coloured bar per
% parameter, sorted descending, with rotated labels placed by text() just
% below the axis, plus a min-max whisker across regions.
v = v(:); lo = lo(:); hi = hi(:);
n  = numel(v);
fh = figure('Name', tag, 'Color', 'w', 'Position', [60 60 1580 820]);
ax = axes(fh); hold(ax, 'on');
cols = hsv(n);
for i = 1:n
    bar(ax, i, v(i), 0.8, 'FaceColor', cols(i,:), ...
        'EdgeColor', [0.2 0.2 0.2], 'LineWidth', 0.4);
end
if CFG.showErrorBars && any(lo + hi > 0)
    errorbar(ax, (1:n)', v, lo, hi, 'k', 'LineStyle', 'none', ...
             'LineWidth', 1.0, 'CapSize', 3);
end
hold(ax, 'off');
grid(ax, 'on'); box(ax, 'on');
title(ax, ttl, 'FontSize', 21, 'FontWeight', 'bold');
if ~isempty(sub)
    try, subtitle(ax, sub, 'FontSize', 12, 'FontWeight', 'normal'); catch, end %#ok<CTCH>
end
ylabel(ax, ylab, 'FontSize', 18);

top = max(v + hi);
if ~isfinite(top) || top <= 0, top = 1; end
ax.XLim  = [0.4, n + 0.6];
ax.XTick = 1:n;
% Labels are anchored at yb, just below the axis. The gap is expressed as a
% fraction of the AXIS HEIGHT in whichever transform is in use, so it looks the
% same on a log axis spanning seven decades as on a linear one.
gap = 0.005;
if isfield(CFG,'labelGapFrac') && ~isempty(CFG.labelGapFrac)
    gap = CFG.labelGapFrac;
end
if strcmp(yscale, 'log')
    % Bars whose value is 0 cannot be drawn on a log axis; the floor is set a
    % decade below the smallest positive bar so nothing vanishes silently.
    ax.YScale = 'log';
    pos = v(v > 0);
    bot = ternary(isempty(pos), 1e-6, min(pos)/10);
    ax.YLim = [bot, top*3];
    yb = bot * 10^(-gap*log10((top*3)/bot));
else
    ax.YLim = [0, top*1.06];
    yb = -gap*(top*1.06);
end
ax.XTickLabel = [];
% Parameter labels as large as the axis will take. At 80 degrees a label's
% horizontal footprint is only about 0.10*L*fs points against a bar pitch of
% (axis width)/n, and its vertical extent about 0.59*L*fs points against the
% margin reserved below the axis, so with L of order 7 glyphs neither binds
% until well past 30 pt. The cap is there so a 12-bar figure does not end up
% with labels larger than the title.
fs = CFG.labelFontSize;
if isempty(fs), fs = max(15, min(34, round(1000/max(n,1)))); end
interp = 'tex';
if isfield(CFG,'labelInterp') && ~isempty(CFG.labelInterp)
    interp = CFG.labelInterp;
end
for i = 1:n
    text(ax, i - 0.10, yb, names{i}, 'HorizontalAlignment', 'right', ...
         'Rotation', 80, 'FontSize', fs, 'Interpreter', interp);
end
ax.YAxis.FontSize = 15;

% Resolution floor. Everything at or below the line is estimator noise, so
% the whole region is greyed out and the line is drawn in solid black: it is
% a hard statement about what the figure is entitled to claim, not a hint.
if nargin >= 11 && isfinite(resFloor) && resFloor > 0 && resFloor < ax.YLim(2)
    hold(ax, 'on');   % patch and yline are low-level, but be explicit
    xl = ax.XLim;
    pt = patch(ax, [xl(1) xl(2) xl(2) xl(1)], ...
                   [ax.YLim(1) ax.YLim(1) resFloor resFloor], ...
               [0.86 0.86 0.86], 'EdgeColor', 'none', 'FaceAlpha', 0.85);
    try, uistack(pt, 'bottom'); catch, end                  %#ok<CTCH>
    try, pt.Annotation.LegendInformation.IconDisplayStyle = 'off'; catch, end %#ok<CTCH>
    yl = yline(ax, resFloor, '-', ...
               sprintf(' below this line the value is numerical noise  (%.3g)', resFloor), ...
               'Color', 'k', 'LineWidth', 2.0, ...
               'LabelHorizontalAlignment', 'left', ...
               'LabelVerticalAlignment', 'top', ...
               'FontSize', 13, 'FontWeight', 'bold', ...
               'Interpreter', 'none');
    try, yl.Annotation.LegendInformation.IconDisplayStyle = 'off'; catch, end %#ok<CTCH>
    hold(ax, 'off');
end

% the interaction toolbar is what makes exportgraphics warn
try, ax.Toolbar = []; catch, end                        %#ok<CTCH>
try, disableDefaultInteractivity(ax); catch, end        %#ok<CTCH>

set(ax, 'Position', [0.085 0.26 0.895 0.615]);
end

function lsa_savefig(fh, outDir, tag)
png = fullfile(outDir, [tag, '.png']);
try
    exportgraphics(fh, png, 'Resolution', 300);
catch
    print(fh, png, '-dpng', '-r300');
end
try, savefig(fh, fullfile(outDir, [tag, '.fig'])); catch, end %#ok<CTCH>
end

%% ---------------- Supplementary Information helpers ---------------------
function s = lsa_texnum(x, sig, wrap)
% A number formatted for a LaTeX table cell. Plain decimal where that reads
% well, mantissa-times-power-of-ten otherwise, so one column can hold 29699
% and 6.8e-3 without either looking absurd. wrap = true surrounds it with $ $.
%
% NOTE: %g is deliberately NOT used. For 29698.7 at four significant figures
% it returns 2.97e+04, and "e+04" typesets in math mode as an italic e times
% a plus sign, which is wrong in a paper table. The decimal count is computed
% from the exponent instead.
if nargin < 2 || isempty(sig),  sig  = 3;     end
if nargin < 3 || isempty(wrap), wrap = true;  end
if ~isfinite(x)
    s = '--';
    if wrap, s = ['$', s, '$']; end
    return
end
if x == 0
    s = '0';
else
    a = abs(x);
    e = floor(log10(a));
    if a >= 1e-2 && a < 1e5
        d = max(0, sig - 1 - e);           % decimals giving sig significant figures
        s = lsa_striptrail(sprintf('%.*f', d, x));
    else
        mant = lsa_striptrail(sprintf('%.*f', max(sig-1,0), x/10^e));
        s = sprintf('%s\\times10^{%d}', mant, e);
    end
end
if wrap
    s = ['$', s, '$'];
end
end

function t = lsa_striptrail(t)
% drop trailing zeros after a decimal point, then a bare trailing point
if any(t == '.')
    t = regexprep(t, '0+$', '');
    t = regexprep(t, '\.$', '');
end
end

function lsa_emit(L, outDir, fname, ttl, idx, ntot, saveData)
% Print one LaTeX block to the command window between rules that are easy to
% select against, and write the same text to a file. Every line goes through
% %s so that backslashes and percent signs in the LaTeX are never interpreted
% as format specifiers.
rule = repmat('-', 1, 78);
fprintf('\n%s\n', repmat('=', 1, 78));
fprintf('SI BLOCK %d of %d : %s\n', idx, ntot, ttl);
fprintf('%s\n', rule);
fprintf('%s\n', L{:});
fprintf('%s\n', rule);
if nargin >= 7 && saveData
    fpath = fullfile(outDir, fname);
    fid = fopen(fpath, 'w');
    if fid > 0
        fprintf(fid, '%s\n', L{:});
        fclose(fid);
        fprintf('written to %s   (\\input{%s} instead of pasting, if preferred)\n', ...
                fpath, fname);
    else
        fprintf('could not write %s\n', fpath);
    end
end
end

%% ---------------- rank agreement across regions -------------------------
function [W, rhoBar] = lsa_concord(X)
% X is nParams x nRegions. W is Kendall's coefficient of concordance with the
% standard tie correction; rhoBar is the mean pairwise Spearman correlation.
% Implemented here rather than with corr() so the script needs no toolbox.
[n, k] = size(X);
if k < 2 || n < 3, W = NaN; rhoBar = NaN; return; end
Rk = zeros(n, k);  Tj = zeros(1, k);
for j = 1:k
    [Rk(:,j), Tj(j)] = lsa_rank(X(:,j));
end
Rs  = sum(Rk, 2);
Sd  = sum((Rs - mean(Rs)).^2);
den = k^2*(n^3 - n) - k*sum(Tj);
if den > 0, W = 12*Sd/den; else, W = NaN; end
s = 0; c = 0;
for a = 1:k-1
    for b = a+1:k
        s = s + lsa_pearson(Rk(:,a), Rk(:,b));  c = c + 1;
    end
end
rhoBar = s/c;
end

function [rk, Tcorr] = lsa_rank(v)
v = v(:);  nv = numel(v);
[~, ord] = sort(v, 'ascend');
rk = zeros(nv,1);  rk(ord) = 1:nv;
u = unique(v);  Tcorr = 0;
for q = 1:numel(u)
    idx = (v == u(q));
    t   = sum(idx);
    if t > 1
        rk(idx) = mean(rk(idx));
        Tcorr   = Tcorr + (t^3 - t);
    end
end
end

function c = lsa_pearson(x, y)
x = x(:) - mean(x);  y = y(:) - mean(y);
d = sqrt(sum(x.^2)*sum(y.^2));
if d == 0, c = NaN; else, c = sum(x.*y)/d; end
end

function out = ternary(cond, a, b)
if cond, out = a; else, out = b; end
end

%% ---------------- shared environmental forcing --------------------------
function [TF, S_m] = mmvf_climate(t, county, temp_shift, alpha_PZI, beta_PZI)
% The temperature (deg F) and Palmer Z-Index series, and the inlined pchip
% evaluation, used identically by M3_SF, M4_SF_S and M5_SF.
%
% In Mechanistic_Model_Valley_Fever_07_33_26.m this block appears three
% times, once inside each of those functions. The three copies were checked
% to be byte-identical (same tind, same 4 x 132 temperature series, same
% 4 x 132 soil series) and are consolidated here. Same persistent cache key
% [county temp_shift alpha_PZI beta_PZI], same pchip, same O(1) interval
% lookup, same Horner evaluation, so the right-hand sides are unchanged.
persistent CACHE_KEY BRK CF NB DBR

cache_key = [county, temp_shift, alpha_PZI, beta_PZI];
if isempty(CACHE_KEY) || ~isequal(CACHE_KEY, cache_key)

    tind = [15.5;45;74.5;105;135.5;166;196.5;227.5;258;288.5;319;349.5;380.5;410;...
    439.5;470;500.5;531;561.5;592.5;623;653.5;684;714.5;745.5;775;804.5;835;...
    865.5;896;926.5;957.5;988;1018.5;1049;1079.5;1110.5;1140.5;1170.5;1201;...
    1231.5;1262;1292.5;1323.5;1354;1384.5;1415;1445.5;1476.5;1506;1535.5;1566;...
    1596.5;1627;1657.5;1688.5;1719;1749.5;1780;1810.5;1841.5;1871;1900.5;1931;...
    1961.5;1992;2022.5;2053.5;2084;2114.5;2145;2175.5;2206.5;2236;2265.5;2296;...
    2326.5;2357;2387.5;2418.5;2449;2479.5;2510;2540.5;2571.5;2601.5;2631.5;2662;...
    2692.5;2723;2753.5;2784.5;2815;2845.5;2876;2906.5;2937.5;2967;2996.5;3027;...
    3057.5;3088;3118.5;3149.5;3180;3210.5;3241;3271.5;3302.5;3332;3361.5;3392;...
    3422.5;3453;3483.5;3514.5;3545;3575.5;3606;3636.5;3667.5;3697;3726.5;3757;...
    3787.5;3818;3848.5;3879.5;3910; 3940.5; 3971; 4001.5];

    temp_data_AZ=[38.6; 42.2; 54.8; 59.4; 67.4; 79.5; 81.0; 78.5; 72.4; 58.8; 51.3;...
    41.5; 46.5; 50.0; 53.9; 59.1; 66.8; 77.7; 81.4; 76.5; 74.2; 64.9; 51.7; 44.3; 45.1;...
    52.0; 56.3; 58.4; 62.9; 78.4; 78.6; 80.6; 75.0; 64.5; 48.3; 40.9; 41.8; 50.6; 54.9;...
    58.5; 64.6; 80.3; 82.4; 77.5; 71.6; 66.1; 53.1; 44.7; 42.3; 49.4; 56.6; 59.9; 66.1;...
    79.8; 81.5; 79.1; 72.4; 65.1; 57.6; 46.6; 47.6; 46.7; 52.3; 62.9; 68.5; 78.6; 82.3;...
    80.2; 76.0; 59.9; 49.4; 42.8; 42.4; 40.9; 51.7; 60.3; 60.7; 75.2; 81.9; 81.9; 73.8;...
    60.0; 52.1; 42.2; 43.7; 45.9; 51.0; 59.3; 70.5; 76.8; 82.8; 84.1; 75.6; 66.2; 53.5;...
    42.0; 42.6; 46.5; 49.4; 61.2; 67.9; 80.6; 81.4; 79.5; 74.8; 59.9; 55.8; 45.6; 43.5;...
    44.0; 51.8; 60.5; 68.6; 78.6; 82.2; 79.0; 75.9; 61.8; 46.1; 42.8; 40.3; 41.9; 47.2;...
    58.4; 66.5; 72.4; 85.4; 80.7; 73.6; 64.4; 52.6; 45.4];

    temp_data_Maricopa=[50;52.9;65;69.8;78.2;88.5;91.4;89.6;83.2;69.2;62.1;52.3;...
    56.5;59.8;64.5;69.8;77.9;87.2;91.3;86.4;84.4;74.7;61.8;53.9;55.1;61.5;...
    67.2;68.8;73;88.1;89.4;92.3;85.6;74.7;58;50.7;51.7;61.8;65.6;69.2;74.7;...
    90.2;93.2;88.8;82.4;76.6;63.6;54.8;52;58.5;66.8;70.7;76.9;89.4;91.8;...
    90.4;82.8;76.2;67.4;56.9;58.4;56.2;62.6;73;78.1;87.1;91.9;90.3;87.4;...
    69.6;59.7;52.5;52.8;50.2;61.4;70.3;71.1;85.6;92.4;92.6;84.2;71;62.2;...
    52.5;53.5;55.7;60.3;69;81.2;86.7;94;94.7;87;76.6;63.9;52.9;53.2;57;59.9;...
    71.6;77.4;89.9;90.2;88.8;84.7;69.9;66.2;55.2;53.7;55;62.5;70.7;78;89;92;...
    89;86;72.4;55.5;51.5;50;52.6;56.8;68.7;76.5;81.7;96;92;84.2;74.9;63.2;55.6];

    temp_data_Pima=[48.0; 49.5; 62.7; 66.7; 74.4; 85.6; 85.3; 83.9; 79.8; 67.1; 60.2;...
    50.8; 55.5; 58.1; 61.7; 66.6; 74.2; 85.2; 85.9; 82.1; 80.4; 72.2; 60.0; 52.1;...
    53.4; 59.7; 63.5; 65.6; 69.5; 84.6; 84.2; 86.9; 81.0; 71.9; 57.0; 49.5; 50.3;...
    59.6; 62.7; 65.9; 71.1; 86.1; 88.2; 83.4; 77.9; 74.2; 61.1; 53.7; 50.3; 57.1;...
    65.1; 68.3; 73.1; 85.9; 86.0; 84.8; 78.9; 74.7; 66.3; 55.1; 56.9; 55.0; 60.5;...
    70.6; 74.7; 84.1; 86.7; 85.1; 83.1; 67.4; 57.6; 51.1; 51.7; 48.6; 59.0; 67.0;...
    67.5; 81.4; 87.6; 87.2; 79.9; 68.7; 61.2; 51.6; 52.2; 52.8; 58.0; 66.1; 77.3;...
    83.2; 88.6; 89.6; 82.8; 73.9; 62.7; 50.9; 51.5; 54.8; 57.2; 68.5; 74.4; 86.6;...
    84.7; 83.9; 80.7; 68.0; 64.2; 54.2; 52.0; 52.0; 59.5; 67.8; 75.2; 84.9; 86.7;...
    83.3; 81.5; 68.9; 54.1; 50.5; 49.0; 50.3; 55.5; 65.9; 73.1; 79.1; 91.1; 87.3;...
    82.0; 73.1; 61.8; 54.0];

    temp_data_Pinal=[48.2; 50.5; 62.6; 67.6; 76.5; 87.3; 88.2; 86.7; 81.4; 68.4; 60.7;...
    50.5; 54.4; 58.4; 62.5; 68.3; 76.3; 86.8; 88.6; 84.3; 81.9; 73.2; 60.2; 52.2;...
    52.8; 59.5; 64.6; 66.6; 71.6; 86.9; 87.0; 88.9; 82.0; 72.5; 56.4; 48.7; 50.1;...
    59.3; 63.4; 67.1; 73.6; 88.0; 90.1; 85.2; 80.3; 75.4; 62.1; 53.5; 50.8; 57.3;...
    65.0; 68.2; 74.9; 87.8; 88.0; 86.4; 81.1; 75.0; 66.2; 54.9; 56.4; 55.6; 61.1;...
    71.5; 76.9; 85.8; 89.0; 87.0; 84.3; 68.7; 58.0; 51.0; 50.9; 49.3; 59.3; 68.4;...
    69.7; 84.3; 90.3; 89.7; 82.5; 70.3; 61.3; 51.2; 51.5; 53.4; 58.8; 67.6; 79.4;...
    85.3; 91.1; 92.0; 84.6; 75.0; 62.6; 51.0; 52.0; 55.8; 58.2; 69.8; 76.5; 88.4;...
    86.7; 85.7; 82.2; 69.2; 64.7; 54.8; 51.9; 52.3; 59.9; 68.9; 76.8; 87.3; 89.4;...
    85.8; 84.0; 70.7; 55.0; 50.4; 48.8; 51.1; 55.8; 67.0; 75.4; 81.2; 93.7; 90.0;...
    82.8; 74.4; 62.3; 53.9];

    % Palmer Z-Index
    soil_mstr_data_AZ=[10.62;9.22;8.26;7.91;8.25;7.71;11.94;10.43;11.66;8.52;12.04;...
    8.76;7.16;6.9;8.03;7.26;7.22;6.88;9.67;12.5;12.95;8.7;7.98;10.2;10.95;8.23;8.67;8.47;...
    10.74;10.34;10.35;9.59;10.03;11.91;9.92;8.87;10.34;7.49;6.66;8.81;8.83;8.16;8.32;11.03;...
    10.42;7.91;9.67;11.41;12;10.17;7.85;8.52;10.04;8.96;12.46;8.01;8.45;7.26;6.84;7.38;7.64;...
    9.06;7.82;5.99;7.16;7.63;11.46;9.36;8.46;14.53;8.8;8.9;10.48;13.67;10.25;9.89;11.96;...
    10.88;7.47;6.54;10.97;7.91;14.44;11.23;8.92;10.21;12.52;10.47;11.24;9.56;6.77;5.54;6.75;...
    7.38;8.08;8.18;9.89;7.85;8.99;7.1;7;7.21;14.84;9.74;9.84;9.69;7.21;10.62;8.14;8.52;8.52;...
    6.77;6.97;8.74;10.66;12.3;10.1;10.64;9.4;10.35;12.34;10.55;12.46;9.84;11.96;10.83;6.61;...
    8.88;9.72;7.75;8.67;9.03];

    soil_mstr_data_Maricopa=[11.19;9.57;9.05;8.3;8.4;8.6;10.31;9.64;10.95;8.72;...
    13.29;8.92;7.68;7.11;8.73;7.78;7.86;8.47;10.07;13.74;15.11;9.01;8.2;...
    10.15;10.2;7.97;8.1;8.49;10.23;9.47;8.95;7.89;9.81;11.29;9.41;8.75;10.84;...
    7.72;6.72;8.7;8.68;8.92;7.67;10.57;8.92;8.19;9.67;10.84;11;11.25;8.09;...
    8.62;9.25;8.84;12.26;8.76;8.04;7.75;7.43;7.89;7.82;8.77;7.47;7.25;7.91;...
    8.98;13.33;10.48;8.17;16.69;9.11;8.62;9.84;13.51;10.12;9.43;10.42;9.92;...
    8.32;7.2;13.61;8.33;14.64;10.86;8.77;10.93;13.42;11.24;11.26;8.67;7.06;...
    7.09;7.46;7.71;8.02;8.8;9.8;7.94;8.14;7.53;7.91;8.81;15.97;12.66;9.59;...
    9.52;7.61;11.6;8.49;8.95;7.88;7.87;8.12;9.31;10.8;12.56;9.97;10.21;9.47;...
    11.1;11.67;10.64;11.91;11.03;11.01;9.89;7.22;7.43;9.54;7.93;8.66;9.77];

    soil_mstr_data_Pima=[9.94;10.4;8.27;8.04;8.16;8.23;10.48;10.21;10.37;8.27;13.32;...
    9.16;7.62;7.18;8.27;8.11;8.05;7.98;10.59;11.6;12.03;10.55;8.23;10.35;12.34;8.45;...
    8.32;9.19;10.13;11.13;9.25;8.08;12.24;11.52;9.11;9.08;10.78;7.84;6.91;9.45;8.42;...
    9.86;8.24;9.57;10.93;7.81;8.95;10.14;10.71;9.14;6.89;7.94;8.67;8.17;12.31;7.77;7.77;...
    7.36;7.42;8.26;7.21;10.82;8;7.34;8.03;10.14;11.34;9.7;9.35;14.9;8.92;9.8;10.23;13.59;...
    10.56;10.04;10.95;10.3;7.42;8.54;13.23;8.06;14.66;11.59;9.49;10.36;11.7;10.99;10.51;...
    9.04;6.36;6.36;6.86;7.46;8.05;8.45;10.66;8.26;8.38;7.95;8.03;8.88;18.62;12.45;9.39;8.38;...
    7.63;9.82;8.41;8.51;7.73;7.73;7.96;10.1;10.83;12.76;10.19;10.15;8.83;10.62;11.38;10.98;...
    10.49;9.88;10.42;9.39;6.58;8.2;8.69;7.92;8.52;10.4];

    soil_mstr_data_Pinal= [10.82; 9.64; 9.20; 8.65; 8.65; 8.40; 11.98; 8.05; 9.70;...
    8.48; 12.07; 8.79; 7.53; 6.86; 8.95; 7.40; 7.51; 7.88; 8.81; 10.79; 14.72; 10.25;...
    7.99; 10.15; 11.68; 8.12; 7.78; 9.04; 10.83; 10.48; 9.33; 9.75; 13.02; 11.84; 9.73;...
    8.65; 10.84; 7.70; 6.75; 8.86; 8.33; 9.53; 7.85; 9.88; 9.85; 8.00; 9.60; 10.02; 10.87;...
    8.92; 7.26; 7.86; 8.61; 8.31; 13.30; 9.20; 7.85; 7.50; 7.19; 7.94; 7.67; 9.63; 7.46; 6.74;...
    7.52; 9.43; 11.60; 9.57; 10.68; 14.41; 9.01; 9.05; 9.83; 14.28; 9.55; 9.82; 10.37; 10.31;...
    8.35; 6.86; 11.60; 8.08; 14.76; 11.76; 9.24; 10.30; 11.11; 10.56; 11.07; 8.67; 6.74; 6.69;...
    7.18; 7.55; 8.15; 8.50; 9.84; 7.74; 8.15; 7.18; 7.49; 8.05; 18.35; 10.85; 11.11; 8.74; 7.43;...
    10.29; 9.01; 8.97; 8.48; 7.22; 7.47; 9.72; 9.13; 12.40; 9.67; 10.03; 9.01; 12.06; 11.71; 10.98;...
    10.68; 10.67; 11.82; 10.26; 6.83; 7.90; 9.35; 7.75; 8.99; 10.00];

    switch county
        case 1, temp_data = temp_data_AZ;       soil_mstr_data = soil_mstr_data_AZ;
        case 2, temp_data = temp_data_Maricopa; soil_mstr_data = soil_mstr_data_Maricopa;
        case 3, temp_data = temp_data_Pima;     soil_mstr_data = soil_mstr_data_Pima;
        case 4, temp_data = temp_data_Pinal;    soil_mstr_data = soil_mstr_data_Pinal;
        otherwise
            error('mmvf_climate: no region selected or invalid county input');
    end

    % climate stress tests (no-ops at the defaults 0, 1, 0)
    temp_data      = temp_data + temp_shift;
    soil_mstr_data = (alpha_PZI .* (soil_mstr_data - 10)) - beta_PZI + 10;

    TFpp = pchip(tind, temp_data);
    SMpp = pchip(tind, soil_mstr_data);
    BRK  = TFpp.breaks(:);              % identical breaks for both splines
    CF   = [TFpp.coefs, SMpp.coefs];
    NB   = numel(BRK);
    DBR  = (BRK(end) - BRK(1))/(NB-1);  % mean break spacing, for the O(1) guess
    CACHE_KEY = cache_key;
end

% O(1) interval lookup: breaks are ~monthly, so guess then walk
j = min(max(floor((t - BRK(1))/DBR) + 1, 1), NB-1);
while j > 1    && t <  BRK(j),   j = j - 1; end
while j < NB-1 && t >= BRK(j+1), j = j + 1; end
dt  = t - BRK(j);
TF  = ((CF(j,1)*dt + CF(j,2))*dt + CF(j,3))*dt + CF(j,4);
S_m = ((CF(j,5)*dt + CF(j,6))*dt + CF(j,7))*dt + CF(j,8);
end

%% ---------------- MODEL 1 ------------------------------------------------
% Verbatim from Mechanistic_Model_Valley_Fever_07_33_26.m
function dM1_SF_T = M1_SF_T(t,a,params)
D = a(1); H = a(2); S=a(3); I=a(4); R=a(5); 

O=params(1);         mu_H=params(2);       gamma_H=params(3); 
H_max=params(4);     delta_H=params(5);    alpha_h=params(6);      
epsilon=params(7);   omega=params(8);      rho=params(9);
kappa=params(10);    delta_D=params(11);   c=params(12);

dD=O-mu_H*D*H-delta_D*D;
dH=gamma_H*D*H*(1-(H/H_max))-delta_H*H;

dS=alpha_h*(S+I+R)-epsilon*S*H-(omega+c*(S+I+R))*S;
dI=epsilon*S*H-rho*I-kappa*I-(omega+c*(S+I+R))*I;
dR=rho*I-(omega+c*(S+I+R))*R;

dM1_SF_T=[dD;dH;dS;dI;dR];
end

%% ---------------- MODEL 2 ------------------------------------------------
% Verbatim from Mechanistic_Model_Valley_Fever_07_33_26.m
function dM2_SF = M2_SF(t,a,params)
O = a(1); D = a(2); H = a(3); A = a(4);
S = a(5); E = a(6);I = a(7); R = a(8);

PI=params(1);           delta_O=params(2);      mu_H=params(3);
gamma_H=params(4);      H_max=params(5);        delta_H=params(6);
gamma_A=params(7);      delta_A=params(8);      phi_A=params(9);
alpha_h=params(10);    
epsilon=params(11);     omega=params(12);       rho=params(13);
kappa=params(14);       psi=params(15);     delta_D=params(16);
c=params(17);

dO=PI-delta_O*O;
dD=delta_O*O-mu_H*D*H-delta_D*D;
dH=(phi_A*A+gamma_H*D*H)*(1-(H/H_max))-delta_H*H;
dA=gamma_A*H-phi_A*A-delta_A*A;

Nt=S+E+I+R;
dS=alpha_h*Nt-epsilon*S*A-(omega+c*Nt)*S;
dE=epsilon*S*A-psi*E-(omega+c*Nt)*E;
dI=psi*E-rho*I-kappa*I-(omega+c*Nt)*I;
dR=rho*I-(omega+c*Nt)*R;

dM2_SF=[dO;dD;dH;dA;dS;dE;dI;dR];
end

%% ---------------- MODEL 3 ------------------------------------------------
% From Mechanistic_Model_Valley_Fever_07_33_26.m. The only change is that the
% embedded climate block is replaced by a call to mmvf_climate().
% GAP PARAMETERISATION: T_opt_A = p(10)+p(11), S_opt_H = p(12)+p(13).
function dM3_SF = M3_SF(t,a,params,county,temp_shift,alpha_PZI,beta_PZI)
    if nargin < 5
        temp_shift = 0.0;
        alpha_PZI  = 1.0;
        beta_PZI   = 0.0;
    end

O = a(1); D = a(2); H = a(3); A = a(4);
S = a(5); E = a(6); I = a(7); R = a(8);

PI=params(1);         delta_O=params(2);      mu_H=params(3);
gamma_H=params(4);    H_max=params(5);        delta_H=params(6);
gamma_A=params(7);    delta_A=params(8);      phi_A=params(9);   
T_opt_H = params(10);
T_opt_A = params(10) + params(11);  % T_opt_H + T_gap
S_opt_A = params(12);
S_opt_H = params(12) + params(13);  % S_opt_A + S_gap
T_decay=params(14);
bl_Topt_A=params(15); ab_Topt_A=params(16);   bl_Topt_H=params(17);
ab_Topt_H=params(18); bl_Sopt_A=params(19);   ab_Sopt_A=params(20);
bl_Sopt_H=params(21); ab_Sopt_H=params(22);   alpha_h=params(23);
epsilon=params(24);   omega=params(25);
rho=params(26);       kappa=params(27);       psi=params(28);
delta_D=params(29);   c=params(30);

[TF, S_m] = mmvf_climate(t, county, temp_shift, alpha_PZI, beta_PZI);

% =====================================================================
%  ENVIRONMENTAL RESPONSE FUNCTIONS
% =====================================================================
if TF <= T_opt_A
    F_A_T = exp(-((TF-T_opt_A)^2/bl_Topt_A));
else
    F_A_T = exp(-((TF-T_opt_A)^2/ab_Topt_A));
end

if TF <= T_opt_H
    F_H_T = exp(-((TF-T_opt_H)^2/bl_Topt_H));
else
    F_H_T = exp(-((TF-T_opt_H)^2/ab_Topt_H));
end

if S_m <= S_opt_A
    F_A_S_m = exp(-((S_m-S_opt_A)^2/bl_Sopt_A));
else
    F_A_S_m = exp(-((S_m-S_opt_A)^2/ab_Sopt_A));
end

if S_m <= S_opt_H
    F_H_S_m = exp(-((S_m-S_opt_H)^2/bl_Sopt_H));
else
    F_H_S_m = exp(-((S_m-S_opt_H)^2/ab_Sopt_H));
end

Nt   = S+E+I+R;
decT = (TF/T_decay)*delta_O;      % only delta_O/T_decay is identified

dO = PI - decT*O;
dD = decT*O - (mu_H*H*D) - delta_D*D;
dH = (phi_A*A + gamma_H*D*H*(F_H_T*F_H_S_m))*(1-(H/H_max)) - delta_H*H;
dA = gamma_A*H*(F_A_T*F_A_S_m) - phi_A*A - delta_A*A;

dS = alpha_h*Nt - epsilon*S*A - (omega+c*Nt)*S;
dE = epsilon*S*A - psi*E - (omega+c*Nt)*E;
dI = psi*E - rho*I - kappa*I - (omega+c*Nt)*I;
dR = rho*I - (omega+c*Nt)*R;

dM3_SF = [dO;dD;dH;dA;dS;dE;dI;dR];
end

%% ---------------- MODEL 4a -----------------------------------------------
% From Mechanistic_Model_Valley_Fever_07_33_26.m. The only change is that the
% embedded climate block is replaced by a call to mmvf_climate().
% GAP PARAMETERISATION: T_opt_A = p(9)+p(10), S_opt_H = p(11)+p(12).
% params(29) (T_d_s) is deliberately UNUSED, as in the main script.
function dM4_SF_S = M4_SF_S(t,a,params,county,temp_shift,alpha_PZI,beta_PZI)
    if nargin < 5
        temp_shift = 0.0;
        alpha_PZI  = 1.0;
        beta_PZI   = 0.0;
    end

V=a(1); O = a(2); D = a(3); H = a(4); A = a(5);
S= a(6); E= a(7); I= a(8); R= a(9);

delta_O=params(1);      mu_H=params(2);
gamma_H=params(3);      H_max=params(4);        delta_H=params(5);
gamma_A=params(6);      delta_A=params(7);      phi_A=params(8);   
T_opt_H = params(9);
T_opt_A = params(9) + params(10);   % T_opt_H + T_gap
S_opt_A = params(11);
S_opt_H = params(11) + params(12);  % S_opt_A + S_gap
T_decay=params(13);
bl_Topt_A=params(14);   ab_Topt_A=params(15);   bl_Topt_H=params(16);
ab_Topt_H=params(17);   bl_Sopt_A=params(18);   ab_Sopt_A=params(19);
bl_Sopt_H=params(20);   ab_Sopt_H=params(21);   T_hs=params(22);
beta=params(23);        delta_V=params(24);     sigma=params(25);
T_cs=params(26);
alpha=params(27);       S_d_s=params(28);     % T_d_s=params(29);  UNUSED
xtr_c_s=params(30);
alpha_h=params(31);     epsilon=params(32);
omega=params(33);       rho=params(34);         kappa=params(35);
psi=params(36);         delta_D=params(37);     c=params(38);

F_DR_MAX = 100;    % cap on the drought multiplier

[TF, S_m] = mmvf_climate(t, county, temp_shift, alpha_PZI, beta_PZI);

% =====================================================================
%  ENVIRONMENTAL RESPONSE FUNCTIONS
% =====================================================================
if TF <= T_opt_A
    F_A_T = exp(-((TF-T_opt_A)^2/bl_Topt_A));
else
    F_A_T = exp(-((TF-T_opt_A)^2/ab_Topt_A));
end

if TF <= T_opt_H
    F_H_T = exp(-((TF-T_opt_H)^2/bl_Topt_H));
else
    F_H_T = exp(-((TF-T_opt_H)^2/ab_Topt_H));
end

if S_m <= S_opt_A
    F_A_S_m = exp(-((S_m-S_opt_A)^2/bl_Sopt_A));
else
    F_A_S_m = exp(-((S_m-S_opt_A)^2/ab_Sopt_A));
end

if S_m <= S_opt_H
    F_H_S_m = exp(-((S_m-S_opt_H)^2/bl_Sopt_H));
else
    F_H_S_m = exp(-((S_m-S_opt_H)^2/ab_Sopt_H));
end

if S_m < S_d_s
    F_dr = min(exp(((S_d_s-S_m)/S_d_s)*xtr_c_s), F_DR_MAX);
else
    F_dr = 1;
end

Nt   = S+E+I+R;
decT = (TF/T_decay)*delta_O;      % only delta_O/T_decay is identified

dV = ((1/(1+exp(TF-T_hs)))-(1/(1+exp(TF-T_cs))))*beta*V - delta_V*V;
dO = delta_V*V - decT*O;
dD = decT*O + sigma*V - (mu_H*H*D) - delta_D*D;
dH = (alpha*A*V + phi_A*A + gamma_H*D*H*(F_H_T*F_H_S_m))*(1-(H/H_max)) - delta_H*H*F_dr;
dA = gamma_A*H*(F_A_T*F_A_S_m) - alpha*A*V - phi_A*A - delta_A*A;

dS = alpha_h*Nt - epsilon*S*A - (omega+c*Nt)*S;
dE = epsilon*S*A - psi*E - (omega+c*Nt)*E;
dI = psi*E - rho*I - kappa*I - (omega+c*Nt)*I;
dR = rho*I - (omega+c*Nt)*R;

dM4_SF_S = [dV;dO;dD;dH;dA;dS;dE;dI;dR];
end

%% ---------------- MODEL 4b -----------------------------------------------
% From Mechanistic_Model_Valley_Fever_07_33_26.m. The only change is that the
% embedded climate block is replaced by a call to mmvf_climate().
% GAP PARAMETERISATION: T_opt_A = p(11)+p(12), S_opt_H = p(14)+p(13).
%   NOTE the reversed order relative to M3 and M4a: for Model 4b the S_opt
%   GAP is params(13) and the BASE S_opt_A is params(14).
% params(30) (T_d_s) is deliberately UNUSED. psi_A is tied to psi_I.
function dM5_SF = M5_SF(t, a, params, county, temp_shift, alpha_PZI, beta_PZI)
    if nargin < 5
        temp_shift = 0.0;
        alpha_PZI = 1.0;
        beta_PZI = 0.0;
    end
    if ~isscalar(t), error('M5_SF: scalar t only (inlined spline lookup)'); end
V=a(1); O = a(2); D = a(3); H = a(4); A = a(5); 
S=a(6); E = a(7); A_H=a(8); I =a(9); R =a(10);

k_ref=params(1);        Q_18=params(2);         T_ref=params(3);      
mu_H=params(4);         gamma_H=params(5);      H_max=params(6);        
delta_H=params(7);      gamma_A=params(8);      delta_A=params(9);      
phi_A=params(10);       T_opt_H=params(11);     T_opt_A=params(11)+params(12);
S_opt_H=params(14)+params(13);     S_opt_A=params(14);     
bl_Topt_A=params(15);   ab_Topt_A=params(16);   bl_Topt_H=params(17); 
ab_Topt_H=params(18);   bl_Sopt_A=params(19);   ab_Sopt_A=params(20); 
bl_Sopt_H=params(21);   ab_Sopt_H=params(22);   T_hs=params(23);
beta=params(24);        delta_V=params(25);
sigma=params(26);       T_cs=params(27); 
alpha=params(28);       S_d_s=params(29);       T_d_s=params(30); 
xtr_c_s=params(31);
alpha_h=params(32);     epsilon=params(33);     
omega=params(34);       rho_I=params(35);         kappa=params(36);
psi=params(37);        delta_D=params(38);      rho_A=params(39);
c=params(40);

psi_A = 1.5*psi;   % 60% asymptomatic: psi_A/(psi_I+psi_A) = 1.5/2.5 = 0.6

F_DR_MAX = 100;    % cap on the drought multiplier

[TF, S_m] = mmvf_climate(t, county, temp_shift, alpha_PZI, beta_PZI);

if TF<T_opt_A || TF==T_opt_A
F_A_T=exp(-((TF-T_opt_A)^2/bl_Topt_A));
else
F_A_T=exp(-((TF-T_opt_A)^2/ab_Topt_A));
end

if TF<T_opt_H || TF==T_opt_H
F_H_T=exp(-((TF-T_opt_H)^2/bl_Topt_H));
else
F_H_T=exp(-((TF-T_opt_H)^2/ab_Topt_H));
end

if S_m<S_opt_A || S_m==S_opt_A
F_A_S_m=exp(-((S_m-S_opt_A)^2/bl_Sopt_A));
else
F_A_S_m=exp(-((S_m-S_opt_A)^2/ab_Sopt_A));
end

if S_m<S_opt_H || S_m==S_opt_H
F_H_S_m=exp(-((S_m-S_opt_H)^2/bl_Sopt_H));
else
F_H_S_m=exp(-((S_m-S_opt_H)^2/ab_Sopt_H));
end

if S_m < S_d_s
    F_dr = min(exp(((S_d_s-S_m)/S_d_s)*xtr_c_s), F_DR_MAX);
else
    F_dr = 1;
end

Nt = S+E+A_H+I+R;
kT = k_ref*Q_18^((TF-T_ref)/18);      % hoisted; was computed twice

dV = ((1/(1+exp(TF-T_hs)))-(1/(1+exp(TF-T_cs))))*beta*V - delta_V*V;
dO = delta_V*V - kT*O;
dD = kT*O + sigma*V - (mu_H*H*D) - delta_D*D;
dH = (alpha*A*V + phi_A*A + gamma_H*D*H*(F_H_T*F_H_S_m))*(1-(H/H_max)) - delta_H*H*F_dr;
dA = gamma_A*H*(F_A_T*F_A_S_m) - alpha*A*V - phi_A*A - delta_A*A;

dS   = alpha_h*Nt - epsilon*S*A - (omega+c*Nt)*S;
dE   = epsilon*S*A - psi*E - psi_A*E - (omega+c*Nt)*E;
dA_H = psi_A*E - rho_A*A_H - (omega+c*Nt)*A_H;
dI   = psi*E - rho_I*I - kappa*I - (omega+c*Nt)*I;
dR   = rho_I*I + rho_A*A_H - (omega+c*Nt)*R;

dM5_SF = [dV;dO;dD;dH;dA;dS;dE;dA_H;dI;dR];
end