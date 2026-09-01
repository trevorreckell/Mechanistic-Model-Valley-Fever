# Mechanistic Model Hierarchy for Valley Fever

MATLAB code and data for a hierarchy of mechanistic ODE models forecasting
coccidioidomycosis (Valley fever) incidence in Arizona, together with the three
statistical baselines they are benchmarked against.

Accompanies:

> Reckell, T., Sterner, B., Engelthaler, D. M., & Jevtić, P. A Mechanistic Model
> Hierarchy for Valley Fever: Wildlife Reservoir Dynamics Improve Forecasts Over
> Climate-Only Baselines. *[journal, year]*.

---

## Repository contents

| File | Description |
|---|---|
| `Mechanistic_Models_VF.m` | Main script. All five mechanistic models, the fitting and forecasting routines, the Diebold–Mariano comparison, and the plotting sections. |
| `Tamerius_Comrie_Model.m` | Statistical baseline 1: linear regression on concurrent temperature and PM<sub>10</sub> with precipitation lagged 18 and 24 months. |
| `NBGLM_VF_8_24_26.m` | Statistical baseline 2: negative binomial distributed-lag GLM with degree-3 Almon crossbasis terms over 25 monthly lags. |
| `XGBoost_Allregions_8_24_26.m` | Statistical baseline 3: gradient-boosted regression trees, 300 trees of depth 3. |
| `MMVF_LSA_8_28_26.m` | Local sensitivity analysis. Computes the Integrated Absolute Normalized Sensitivity (IANS) of monthly incidence to every dynamic parameter. |
| `az-coccidioidomycosis-surveillance-data-*.xlsx` | Source surveillance data: monthly confirmed coccidioidomycosis cases for Arizona and Maricopa, Pima and Pinal counties. |
| `LICENSE.md` | License. |

---

## Running the main script

`Mechanistic_Models_VF.m` is a single script with a `choose_model` switch near
the top. Set it and run.

| `choose_model` | What it does |
|---|---|
| `0` | Population model. Calibrates human demography against county census series. Used by all other models. |
| `1` | Model 1. Fungal growth on decayed organic matter, exposure proportional to hyphae. |
| `2` | Model 2. Adds arthroconidia as the explicit exposure route and a latent period. |
| `3` | Model 3. Adds temperature and soil moisture forcing on hyphal growth and spore production. |
| `4` | Model 4a. Adds the wildlife reservoir, defecation input, wildlife colonization and drought mortality. |
| `5` | Model 4b. Adds a Q<sub>10</sub> organic decay function and an asymptomatic human compartment. |
| `8` | Modified Diebold–Mariano comparison of every mechanistic model against all three statistical baselines, with Holm correction. |
| `9` | Plots the full-sample fits for all models and baselines. |
| `10` | Plots the expanding-window forecasts. |

Sections `1` through `5` run the particle swarm fit for the selected model.
Sections `8` through `10` consume already-fitted parameter vectors and do not
refit.

### Requirements

- MATLAB (developed on R2023b or later; earlier releases likely work)
- **Global Optimization Toolbox** — `particleswarm`
- **Optimization Toolbox** — `optimoptions`
- **Statistics and Machine Learning Toolbox** — `corr`, `tcdf`, `tinv`

The ODE solvers (`ode15s`, `ode45`, `ode23`), interpolation (`pchip`) and
`fminbnd` are all base MATLAB.

### Runtime

A single particle swarm fit of Model 4a or 4b across the parameter space takes
on the order of days on a compute cluster. Sections `1` through `5` write
`bestSoFar_M<n>_<region>_<fit|for>.mat` checkpoints as they go, so a run can be
resumed. Sections `8` through `10` run in minutes.

---

## Fitted parameter vectors are not included

The parameter vectors produced by the particle swarm fits are **not distributed
in this repository.** Sections `8`, `9` and `10` contain shape-preserving
placeholders where they belong:

```matlab
% index: PARAMS{model,region}; model 1..5 = M1,M2,M3,M4a,M4b;
% region 1..4 = arizona, maricopa, pima, pinal.
% vector lengths: m1 14, m2 22, m3 35, m4a 44, m4b 46.
PARAMS{1,1} = { [] ; [] ; [] };   % m1 (14)
```

Two forms appear. Section `8` and section `10` use the three-window form, one
vector per expanding-window forecast year (fit through 2020, 2021, 2022).
Section `9` uses the single full-sample form, fitted over all 132 months.

Paste a vector between any pair of brackets and the surrounding code runs
unchanged. Parameter order for each model is given in the
`ORDER:` comments and in the parameter tables of the paper's Supplementary
Information.

Sections `3`, `4` and `5` also contain `seed_*` placeholders that supply a warm
start to the optimizer:

```matlab
seed_AZ       = [];
seed_MARICOPA = [];
```

Leaving a seed empty cold-starts that region, which is a supported path. Filling
one in makes it particle 1 of the initial swarm.

---

## Data

Monthly case counts and county population series are **embedded directly in the
preamble** of `Mechanistic_Models_VF.m`. Monthly mean temperature and the
Palmer Z-index are embedded inside the ODE functions and interpolated with a
piecewise cubic Hermite polynomial. The script therefore reads no external data
file.

The surveillance spreadsheet in this repository is the source of record for the
case data, provided so that the embedded values can be checked. Case counts are
non-integer because weekly reports are allocated to calendar months.

Sources:

- **Cases** — Arizona Department of Health Services surveillance data
- **Temperature and Palmer Z-index** — NOAA Climate Prediction Center
- **PM<sub>10</sub>** — US EPA, Download Daily Data
- **Population** — US Census Bureau county estimates

Soil moisture is the Palmer Z-index. The models integrate an internally offset
series shifted by `+10` so all values are positive; values reported in the paper
have that offset removed. Temperatures are in degrees Fahrenheit, so the
Q<sub>10</sub> exponent is divided by 18 rather than 10.

---

## Outputs

| File | Written by |
|---|---|
| `bestSoFar_M<n>_<region>_<fit\|for>.mat` | Sections 1–5, optimizer checkpoints |
| `DM_MDM_results_3baselines.mat` | Section 8 |
| `MDM_tables_for_manuscript.mat` | Section 8, the values reported in the paper |

---

## Citation

If you use this code, please cite the paper above. To cite this repository
directly, use the archived release DOI:

```
[INSERT ZENODO DOI]
```

---

## License

See `LICENSE.md`.
