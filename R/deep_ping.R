#'
#' deep_ping
#'
#' @description A function that performs a deep health ping
#'
#' @param .req A RestRserve::Request instance
#' @param .res A RestRserve::Response instance
#'
#' @return The .res object
#'
deep_ping <- function(.req, .res) {
  # TODO: Call a service here
  # TODO: Logic health of service
  .res$set_body(jsonlite::toJSON(
    list(
      "ShallowPing" = list("Health" = "Healthy",
                           "DateTime" = Sys.time()),
      "ServiceStatus" = list(
        # TODO: Fix this health
        "Health" = "Healthy",
        # TODO: Add a message
        "Details" = paste0("Some Message Here")
      ),
      # TODO: Add dependencies
      "Dependencies" = list()
    ),
    auto_unbox = TRUE
  ))
  return(.res)
}
