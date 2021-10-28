#'
#' shallow_ping
#'
#' @description A function that performs a shallow health ping
#'
#' @param .req A RestRserve::Request instance
#' @param .res A RestRserve::Response instance
#'
#' @return The .res object
#'
shallow_ping <- function(.req, .res) {
  .res$set_body(jsonlite::toJSON(
    list("Health" = "Healthy",
         "DateTime" = Sys.time()),
    auto_unbox = TRUE
  ))
  return(.res)
}
