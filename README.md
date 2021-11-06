# ExampleShinyApp
This is primarily an R repo that holds a tiny R shiny app to be used in my Kubernetes learning experience. However, it should also function as a passable template for other R shiny apps.

# test.bat
## build
Running `test build` will build the image `r-shinyapp:dev` that houses the web-app.

## run-bash
Running `test run-bash` will build the image `r-shinyapp:dev` with a bash entrypoint to help debug internal issues

## web-app
Running `test web-app` will build the image `run-r-shinyapp` that runs the web app on `localhost:8888`. 

# Use Cases
- Fork this repo
- Add whatever functions and stuff you need in `/R/`
- Change the name of the package if you want, but that changes in a lot of places, so good luck.

