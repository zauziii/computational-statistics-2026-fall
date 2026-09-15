##### TASK1 #####


n <- 1e5

set.seed(20260901)
xo <- rnorm(n, 0, 1)

set.seed(20260901)
xb <- rnorm(n, 10**12, 1)

var2pass <- function(x) {
  n <- length(x)
  xbar <- mean(x)
  sum((x-xbar)**2) / (n-1)
}

var1pass <- function(x) {
  n <- length(x)
  (sum((x**2) - sum(x)**2/n))/(n-1)
}

varwelford <- function(x) {
  n <- length(x)
  m <- 0
  M2 <- 0
  
  for (i in seq_along(x)) {
    delta <- x[i]- m
    m <- m + delta / i
    delta2 <- x[i]- m
    M2 <- M2 + delta * delta2
  }
  
  M2 / (n- 1)
}


library(microbenchmark)
microbenchmark(
    two_pass = var2pass(xo),
    one_pass = var1pass(xo),
    welford = varwelford(xo),
    R_var = var(xo)
  )

microbenchmark(
  two_pass = var2pass(xb),
  one_pass = var1pass(xb),
  welford = varwelford(xb),
  R_var = var(xb)
)

##### TASK: decode an 8-bit float #####
