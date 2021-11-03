library(shinytest)
expect_pass(testApp(usethis::proj_get(), suffix = osName()))

# TODO: Add these:
# https://rstudio.github.io/shinytest/articles/shinytest.html