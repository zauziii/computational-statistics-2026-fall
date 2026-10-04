# Computational Statistics — Course Repository

Personal notes, R code, and assignments for **MAST32001 Computational Statistics** (5 ECTS),
Master's Programme in Mathematics and Statistics, University of Helsinki.

> "Implementing statistical theory as computer code — and all the issues that arise in doing so."

## Course Facts

| | |
| --- | --- |
| **Course code** | MAST32001 |
| **Credits** | 5 ECTS |
| **Institution** | University of Helsinki |
| **Language** | English |
| **Programming language** | R (with Rcpp / RStudio) |

## Topics at a Glance

| Week | Lectures | Theme |
| --- | --- | --- |
| 1 | 1–2 | Floating-point arithmetic & numerical linear algebra |
| 2 | 3–4 | Random number generation & Monte Carlo methods |
| 3 | 5–6 | Permutation tests, the bootstrap & the jackknife |
| 4 | 7–8 | Bootstrap for structured data, prediction & cross-validation |
| 5 | 9–10 | Bayesian inference & Markov chain Monte Carlo |

## Directory Structure

```
.
├── Week 1/                 # Lec 1–2
│   ├── Lectures/           # Slides / lecture R scripts
│   ├── Exercises/          # Weekly exercises
│   └── Summary/            # Weekly recap
├── Week 2/                 # Lec 3–4
│   ├── Exercises/
│   └── Summary/
├── Week 3/                 # Lec 5–6
├── Week 4/                 # Lec 7–8
├── Week 5/                 # Lec 9–10
└── README.md               # This file
```

Each week follows the same layout: `Exercises/` holds the worked assignments
(`.Rmd` / `.qmd`), `Summary/` holds a short written recap, and (where available)
`Lectures/` holds the accompanying R code.

---

## Week 1

### Lecture 1 — Variance, Algorithms, and Floating-Point Arithmetic
- Why computational statistics matters: mathematically equivalent formulas can behave very differently on a computer.
- Variance: definitions, basic properties, and why the sample variance divides by n − 1 (degrees-of-freedom correction).
- Three ways to compute sample variance: the two-pass algorithm, the one-pass computational formula, and Welford's online algorithm.
- Empirical comparison in R: on data shifted by 10^12, the one-pass formula collapses to 0 due to catastrophic cancellation, while two-pass and Welford remain accurate.
- Floating-point arithmetic: IEEE double precision, machine epsilon, relative precision, rounding error, overflow/underflow.
- Stable practices: log-likelihoods instead of products, tail-specific functions (`lower.tail = FALSE`), the log-sum-exp trick, and careful summation order.

### Lecture 2 — Numerical Linear Algebra
- Why linear algebra is the core computational language of statistics.
- Solve $Ax = b$ directly with `solve(A, b)`; avoid forming the explicit inverse.
- Matrix norms and the condition number: $\sigma_{max} / \sigma_{min}$; well-conditioned vs ill-conditioned problems.
- Conditioning is a property of the problem; stability is a property of the algorithm.
- Matrix decompositions: LU (with partial pivoting), Cholesky for symmetric positive-definite matrices, QR for least squares, and SVD / thin SVD for rank and near-singularity diagnostics.
- Least squares: forming $X^T X$ squares the condition number, which is why QR is preferred over the normal equations.
- Multicollinearity: individual coefficients can be highly unstable while fitted values remain accurate.
- Useful R functions: `crossprod` / `tcrossprod`, `solve`, `qr.solve`, `chol`, `svd`, `kappa`, `norm`.

---

## Week 2

### Lecture 3 — Random Number Generation
- Physical randomness (coin tosses, radioactive decay, atmospheric/thermal noise) vs pseudo-random number generators (PRNGs): the former is irreproducible, the latter is a deterministic machine with an internal state, an update rule $S_{n+1}=T(S_n)$, an output function, and a seed.
- Linear congruential generators, $X_{n+1}=(aX_n+c)\bmod m$, whose period is bounded by the modulus $m$; a long period alone is not enough — a good generator also needs approximately uniform marginals, weak dependence, and good high-dimensional behavior.
- Use vetted generators such as R's Mersenne-Twister rather than hand-rolled LCGs; $U(0,1)$ draws are the fundamental building block for every other distribution.
- Inverse transform sampling via the probability integral transform, $X=F^{-1}(U)$ (e.g. exponential, $X=-\log(U)/\lambda$), with the unit interval split at cumulative probabilities for discrete distributions.
- Distributional identities: $e^X$ is lognormal; $Z^2$ is $\chi^2_1$; $\text{Gamma}(1,\lambda)$ is exponential; a ratio of independent Gammas gives a Beta; $Z/\sqrt{V/\nu}$ is Student's t; and two independent chi-squares form an F statistic.
- Box–Muller: the polar form of the bivariate normal turns two uniforms into two independent $N(0,1)$ draws.
- Acceptance–rejection sampling: with an envelope $f(x)\le c\,g(x)$, draw $Y\sim g$ and accept with probability $f(Y)/(c\,g(Y))$; the expected number of proposals per accepted draw is $c$, and the proposal must have tails at least as heavy as the target (worked example: normal target, Cauchy proposal).
- Checking generators: histograms against the theoretical density, Q–Q plots, empirical CDFs, and successive-pair scatter plots — correct marginals do not imply independence.

### Lecture 4 — Monte Carlo Methods
- The Monte Carlo principle: estimate an expectation $\theta=E[h(X)]$ by the sample mean $\hat\theta=\frac{1}{m}\sum_{i=1}^m h(X_i)$ over independent draws from $f$.
- Large-sample behavior: the strong law gives consistency, $\operatorname{Var}(\hat\theta)=\sigma_h^2/m$ gives the $m^{-1/2}$ rate, and the CLT justifies intervals $\hat\theta\pm1.96\,s/\sqrt{m}$.
- Distinguish statistical sampling error (finite observed data) from Monte Carlo error (finite number of simulations); increasing $m$ reduces only the latter.
- Examples: integrating $x^4$ and $\sin x$ over finite intervals, higher-dimensional integrals, and estimating $\pi$ from points inside a unit quarter-circle; halving the Monte Carlo standard error requires four times as many draws.
- Simulation studies as statistical experiments: estimate bias, variance and MSE via the bias–variance decomposition, confidence-interval coverage (a Bernoulli proportion with its own Monte Carlo SE), and test power.
- Importance sampling as a variance-reduction technique: rewrite $I=E_g\!\left[h(X)\,\frac{f(X)}{g(X)}\right]$ with a proposal $g$ placed where the integrand contributes most.
- Multivariate simulation: capture dependence, not just marginals. Spherically symmetric vectors split into a radius $R=\lVert X\rVert_2$ and a direction $U=X/R$ uniform on $\mathbb{S}^{p-1}$; normalize a $N_p(0,I_p)$ draw to get a uniform direction by rotational invariance.
- Elliptical distributions: $X=\mu+RAU$ with shape $\Sigma=AA^\top$, so (using the Cholesky/eigen decomposition from Lecture 2) generate $X=\mu+AZ$ with $Z\sim N_p(0,I_p)$; the normal case has $R^2\sim\chi^2_p$, and heavier radial laws give heavier-tailed elliptical distributions.

---

## Week 3

### Lecture 5 — Permutation and Randomization Tests
- The question a permutation test asks: how unusual is the observed result under the null hypothesis?
- The null determines which labels or observations are interchangeable; a valid test uses only rearrangements that are equally likely under that null.
- The permutation p-value is the proportion of valid rearrangements whose statistic is at least as extreme as the observed one.
- Exact permutation tests, large-sample approximations, and Monte Carlo permutation tests.
- Examples: two-sample location tests, the Wilcoxon rank-sum test, the Kruskal–Wallis test, Spearman correlation, and tests of independence (shuffle one variable against another when assumptions allow).
- "Distribution-free" is not assumption-free: the data must be exchangeable, the shuffling must match the design, and the statistic must target the effect of interest (e.g. neither Pearson nor Spearman detects a U-shaped relationship).

### Lecture 6 — The Bootstrap and Jackknife for iid Data
- Nonparametric bootstrap: treat the empirical distribution as an estimate of the population and draw samples of the same size **with replacement**; each bootstrap sample contains about 63% of the original observations at least once (the 0.632 result).
- Recompute the statistic for every bootstrap sample to estimate standard error and bias and to build confidence intervals — normal, percentile, and basic intervals.
- The iid bootstrap assumes independent, identically distributed observations; other designs call for different resampling, and the choice of statistic matters.
- Failure case: bootstrapping the sample maximum to estimate the upper endpoint of a uniform — a bootstrap draw can never exceed the largest observed value, so its uncertainty is not captured.
- Jackknife: leave out one observation at a time and recompute, with no randomness (hence deterministic and often faster), to estimate standard errors and bias and to flag influential observations.
- The recurring lesson: resampling still depends on assumptions — understand how the data were collected before deciding what to shuffle or resample.

---

## Week 4

### Lecture 7 — Bootstrap for Hypothesis Tests and Regression
- Bootstrap hypothesis tests resample **as if the null were true**: either fit a model under the null and simulate new data from it, or shift/resample the data so its mean matches the null value; contrast this with permutation tests, which exploit symmetry and require no estimated parameters.
- Residual bootstrap: keep the $x$ values fixed and resample the errors — appropriate when the design is fixed and errors are homoscedastic.
- Pairs bootstrap: resample whole $(x,y)$ pairs together — appropriate when the predictors are random.
- Wild bootstrap for heteroscedastic errors: keep each residual tied to its own $x$ and randomly flip its sign.
- Block bootstrap for time series: resample whole contiguous blocks rather than individual points so that temporal dependence is preserved.

### Lecture 8 — Prediction Error and Cross-Validation
- Training error is optimistic: scoring a model on the same data used to fit it overstates its performance.
- Prediction error decomposes into irreducible noise, squared bias (model too simple), and variance (estimate unstable across data sets); increasing flexibility lowers bias but raises variance, giving a U-shaped test-error curve.
- K-fold cross-validation: partition the data into folds, fit on all but one fold, evaluate on the held-out fold, and rotate so every point is predicted once; leave-one-out CV is the extreme case, with a shortcut for linear regression that avoids refitting $n$ times.
- Model-selection bias: choosing the "best" of many models by CV is itself a form of overfitting (the winner is partly lucky). Remedies include nested cross-validation, preventing test data from leaking into preprocessing, and information criteria (AIC/BIC) that penalize extra parameters.
- The CV scheme must match the problem: for time series only forward (rolling) prediction is valid, and for grouped/clustered data whole groups must be held out.

---

## Week 5

### Lecture 9 — Bayesian Inference and Conjugate Priors
- Bayes' rule: $\text{posterior}\propto\text{prior}\times\text{likelihood}$; the prior expresses beliefs before seeing data, the likelihood measures fit, and the marginal likelihood normalizes the posterior into a proper distribution (and can be hard to compute).
- Building a likelihood: choose a sampling model, write the density for one observation, multiply over observations, and drop terms that do not involve the parameter (worked for normal and Poisson data).
- Conjugate priors: a normal prior with normal data gives a normal posterior, and a Gamma prior with Poisson data gives a Gamma posterior.
- The posterior mean is a compromise between the prior mean and the sample mean, weighted by the information each contributes.

### Lecture 10 — Markov Chain Monte Carlo (MCMC)
- Why MCMC: when the posterior cannot be computed or sampled directly, construct a Markov chain of dependent draws that represents the posterior after a sufficiently long run.
- Markov-chain fundamentals: stationarity, detailed balance, irreducibility, aperiodicity, and autocorrelation — high autocorrelation means the number of effectively independent draws is far below the iteration count.
- Metropolis–Hastings: propose a candidate and accept or reject it (the chain stays put on rejection); the normalizing constant cancels in the acceptance ratio, and working on the log scale avoids numerical problems.
- Validated the sampler on a Poisson–Gamma model whose exact posterior is known; both too-small and too-large proposal steps lead to poor mixing.
- Bayesian linear regression by MCMC (intercept, slope, and error SD); centering the predictor (e.g. the `cars` data) weakens correlation between intercept and slope and helps the chain move.
- Diagnostics: trace plots, $\hat R$ (R-hat), effective sample size (ESS), and Monte Carlo standard error (MCSE).

---

## Getting Started

### Prerequisites
- R ≥ 4.x and RStudio (or any editor with Quarto support).
- Common packages used across the weeks:

```r
install.packages(c("tidyverse", "patchwork", "quarto"))
```

### Rendering the notes
- R Markdown (`.Rmd`) files render with `rmarkdown::render("file.Rmd")` or the RStudio **Knit** button.
- Quarto (`.qmd`) files render with `quarto render file.qmd` (PDF output additionally requires a TeX installation; some Week 2 summaries use the Typst engine via `format: typst`).
- Set a seed (e.g. `set.seed(...)`) before simulation-based code to reproduce results exactly.

## License

Study notes only. All course materials (slides, textbooks, exercise sheets) remain the
property of the course instructor and authors. The original notes and code here are
shared for personal educational use.