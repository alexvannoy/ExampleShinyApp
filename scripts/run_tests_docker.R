
reporters <- c(
  testthat::JunitReporter$new(file = "./scripts/results/report.xml"),
  testthat::ProgressReporter$new(),
  testthat::FailReporter$new()
)

options(warn = 2)

devtools::test(
  reporter = testthat::MultiReporter$new(reporters = reporters),
  stop_on_failure = TRUE
)

cov <- devtools::test_coverage(
  show_report = FALSE,
  quiet = TRUE
)

covr::report(x = cov, file = "./scripts/results/covr.html", browse = FALSE)

