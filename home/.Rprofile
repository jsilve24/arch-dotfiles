## Set CRAN Mirror:
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cloud.r-project.org/"
  options(repos = r)
})

## Turn off save workspace prompt
# Create hidden environment
.env <- new.env()
# Define new q() function
.env$q <- function(save = "no", ...) {
  quit(save = save, ...)
}
# Attach hidden environment
attach(.env, warn.conflicts = FALSE)


## Other stuff
options(crayon.enabled=FALSE,
        browser="qutebrowser",
        # attempt to get eldoc and eglot to work nicer together for R
        languageserver.rich_documentation = FALSE)
