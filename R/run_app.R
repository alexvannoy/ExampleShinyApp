#'
#' run_app
#'
#' @description A function that runs the web app
#'
#' @include shallow_ping.R
#' @include deep_ping.R
#' @export
#'
run_app <- function() {
  app <- RestRserve::Application$new()

  app$add_get(path = "/api/health/shallow_ping", FUN = shallow_ping)
  app$add_get(path = "/api/health/deep_ping", FUN = deep_ping)

  app$add_openapi(path = "/openapi.yaml", file_path = file.path(usethis::proj_get(), "inst", "openapi.yaml"))
  app$add_swagger_ui(path = "/api", path_openapi = "/openapi.yaml", use_cdn = TRUE)

  backend <- RestRserve::BackendRserve$new()
  backend$start(app, http_port = 8080L)
}
