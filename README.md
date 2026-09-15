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

## Directory Structure

```
.
├── Week 1/                 # Lec 1–2
│   ├── Lectures/           # Slides
│   ├── Exercises/          # Weekly exercises
│   └── Summary/            # Weekly recap
├── Week 2/                 # Lec 3–4
├── Week 3/                 # Lec 5–6
├── README.md               # This file
└── .gitattributes
```

---

## Week 1

### Lecture 1 — Variance, Algorithms, and Floating-Point Arithmetic
- Why computational statistics matters: mathematically equivalent formulas can behave very differently on a computer.
- Variance: definitions, basic properties, and why the sample variance divides by n − 1 (degrees-of-freedom correction).
- Three ways to compute sample variance: the two-pass algorithm, the one-pass computational formula, and Welford's online algorithm.
- Empirical comparison in R: on data shifted by 10^12, the one-pass formula collapses to 0 due to catastrophic cancellation, while two-pass and Welford remain accurate.
- Floating-point arithmetic: IEEE double precision, machine epsilon, relative precision, rounding error, overflow/underflow.
- Stable practices: log-likelihoods instead of products, tail-specific functions (lower.tail = FALSE), the log-sum-exp trick, and careful summation order.

### Lecture 2 — Numerical Linear Algebra
- Why linear algebra is the core computational language of statistics.
- Solve $Ax = b$ directly with `solve(A, b)`; avoid forming the explicit inverse.
- Matrix norms and the condition number: $σ_{max} / σ_{min}$; well-conditioned vs ill-conditioned problems.
- Conditioning is a property of the problem; stability is a property of the algorithm.
- Matrix decompositions: LU (with partial pivoting), Cholesky for symmetric positive-definite matrices, QR for least squares, and SVD / thin SVD for rank and near-singularity diagnostics.
- Least squares: forming $X^T X$ squares the condition number, which is why QR is preferred over the normal equations.
- Multicollinearity: individual coefficients can be highly unstable while fitted values remain accurate.
- Useful R functions: `crossprod` / `tcrossprod`, `solve`, `qr.solve`, `chol`, `svd`, `kappa`, `norm`.

---

## Week 2 — 

### Lecture 3 — 


### Lecture 4 — 


---

## Week 3 — 

### Lecture 5 — 
- **Topic:** 
- **Slides:** 
- **Reading:** 
- **Exercises:**
- **Exercise session (Thu):** 

### Lecture 6 — 
- **Topic:** 
- **Slides:** 
- **Reading:** 
- **Assignment presentations (Thu afternoon):** 

---


## Progress

- [x] **Week 1** — 
- [ ] **Week 2** — 
- [ ] **Week 3** — 

## License

Study notes only. All course materials (slides, textbooks) remain the property of the course instructor and authors.
