# get list of all available images of target and non target stimuli
# and add them to list of standard (typicality) stimuli
# list will be used to set up image sequence for pilot (three stimulus paradigm)

rm(list = ls(all.names = TRUE))

# -----------------------------------------------------------------------------
# Load packages.
# -----------------------------------------------------------------------------
library(dplyr)
library(tidyverse)
library(readxl)
library(data.table)
library(writexl) # We use this package for writing for compatibility
# The correct write functions should use an underscore in write_xlsx.


# -----------------------------------------------------------------------------
# Set the directories.
# -----------------------------------------------------------------------------
dirs <- list()

dirs$main <- ("C:/Users/User/MATLAB/TypiTarget/TypiBall")

# Directory where to find the image files of target and non target category
dirs$images <- paste(dirs$main, "/stimuli", sep="")

image_list <- list.files(path = dirs$images, recursive = TRUE, pattern = "\\.jpg$", full.names = TRUE)

df_image <- data.frame()
