
## Core System Packages
install.packages(c("tidyverse", "devtools", "Rcpp",
                   "languageserver", "lintr", "usethis"), repos="http://cran.us.r-project.org")

## Install my packages
library(devtools)
install_github("jsilve24/driver", repos="http://cran.us.r-project.org")
install_github("jsilve24/fido", repos="http://cran.us.r-project.org")
install_github("jsilve24/philr", repos="http://cran.us.r-project.org")

## Some other utility packages from github
install_github("milesmcbain/breakerofchains", repos="http://cran.us.r-project.org")

## Bioconductor
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos="http://cran.us.r-project.org")

install.packages(c("boot", "Matrix"))
BiocManager::install("ALDEx2")
BiocManager::install("DESeq2")
BiocManager::install("phyloseq")

## Other assorted packages
install.packages(c("glmnet"), repos="http://cran.us.r-project.org")
install.packages(c("parallel"), repos="http://cran.us.r-project.org")

