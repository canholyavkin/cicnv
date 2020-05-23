# Packages ----------------------------------------------------------------
library(valr)
library(dplyr)
library(stringr)
source("./src/evidence_functions.R")
source("./src/create_db.R")

# Data Import & Cleaning --------------------------------------------------
x <- "16: 28,808,554 - 29,070,564"

loss_1(x)
loss_2a(x)
loss_2b(x)
loss_2c1(x)
