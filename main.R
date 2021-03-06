# Main project file
# December 4, 2018 BBL

library(drake)  # 6.1.0
pkgconfig::set_config("drake::strings_in_dots" = "literals")

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
theme_set(theme_bw())
library(lubridate)

# Load our functions
source("picarro-functions.R")

do_filedigest <- function(dir) digest::digest(list.files(dir)) # helper function

plan <- drake_plan(
  
  # Sample information
  # core_data = ...
  
  # Picarro data from drydown cores
  # We digest the filename list to detect when something changes in the licor_data directory
  raw_licor_data = target(command = read_picarro_dir("data/picarro/"),
                          trigger = trigger(change = do_filedigest("data/picarro/"))),

  # Valve map file linking Picarro `MPVPosition` field to cores
  # valve_map = ...
  # Current file is at https://drive.google.com/drive/folders/161AKxqSyOPf6yomqnQNmMDDl3gCAysyq?usp=sharing
  
  # Compute per-sample change rate (ppmCO2/s and ppbCH4/s)
  # summary_data = ...
  
  # Link with core data via valvemap
  # summary_data_cores = ...
  
  # Compute fluxes
  # flux_data = ...
  
  # --------------------------------------------------------------------------------------------------------
  # Webpage diagnostics report
  diagnostics_report = rmarkdown::render(
    knitr_in("diagnostics.Rmd"),
    output_file = file_out("diagnostics.html"),
    quiet = TRUE)
  
)

# Now type `make(plan)` at command line
