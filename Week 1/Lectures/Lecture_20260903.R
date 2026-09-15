set.seed(20260812)
n <- 100
x1 <- rnorm(n)
x2 <- x1 + 1e-6 * rnorm(n)
X_task <- cbind(1, x1, x2)
y_task <- 1 + x1 + x2 + rnorm(n, sd = 0.1)

kappa(X_task)
kappa(crossprod(X_task))
b1_task <- qr.solve(X_task, y_task)

y2 <- y_task
y2[1] <- y2[1] + 0.01

b2_task <- qr.solve(X_task, y2)

cbind(
  original = b1_task,
  perturbed = b2_task,
  difference = b2_task - b1_task
)

fit1_task <- as.vector(X_task %*% b1_task)
fit2_task <- as.vector(X_task %*% b2_task)
c(
  max_coefficient_change = max(abs(b2_task - b1_task)),
  max_fitted_value_change = max(abs(fit2_task - fit1_task))
)
