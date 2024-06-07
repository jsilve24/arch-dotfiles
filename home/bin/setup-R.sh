#!/bin/sh

yay -S r tcl tk libgit2 gcc-fortran libxls openmp udunits
pacman -S openssl-1.1 # needed for phyloseq for some reason
R CMD BATCH /home/jds6696/bin/setup-R.R
