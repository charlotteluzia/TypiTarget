# code to generate image sequence for each subject in which image name, category:
# standard, target, non target; includes meta data such as typicality ratings
# to determine 

rm(list = ls(all.names = TRUE))

# -----------------------------------------------------------------------------
# Load packages.
# -----------------------------------------------------------------------------
library(dplyr)
library(readxl)
library(data.table)
library(writexl) # We use this package for writing for compatibility w. PsychoPy
# The correct write functions should use an underscore in write_xlsx.

vars <- list()
vars$n_subjects              <- 1 # Get input files for so many subjects.
vars$n_sets                  <- 10 # We generate only 20 different sets of input files with many duplicates to arrive at n_subjects input files. 
vars$categories              <- c('bedroom', 'kitchen', 'living_room') # Use these scene categories.
vars$category_target         <- c('supermarket')
vars$category_non_target     <- c('bathroom')
vars$img_extension           <- 'png' #'jpg' or 'png', no dot required. The jpg files are much smaller.

vars$n_trials_per_block      <- 100

vars$n_blocks_per_category   <- 1 # Use multiple blocks for each category.
vars$p_novel                 <- 1 # Proportion of new images in the memory block.
vars$n_novel                 <- ceiling(vars$p_novel * vars$n_targets_per_block)
vars$n_catch_trials          <- 4 # Number of catch trials in each memory block

vars$stim_prop               <- c(0.8)
vars$target_non_prop         <- c(0.1)
# vars$un_typ_prop             <- c(0.2, 0.8)
vars$n_typical               <- vars$stim_prop * vars$n_trials_per_block
vars$n_target_non            <- vars$target_non_prop * vars$n_trials_per_block


# -----------------------------------------------------------------------------
# Generate input files for each subject.
# -----------------------------------------------------------------------------

# IMPORTANT: 
# Set a seed for reproducibility. 
# If you run this script multiple times, make sure to always execute this line
# so that the seed is re-initialized. This makes sure that everyone who every
# executes this script will always get the same random selection of images and
# the same order of trials.
set.seed(48149) # ZIP code of our institute ;-) 



# Generate input files for all subjects.
source(file.path(dirs$functions, "fn_three_stim_and_mem.R"))

# Outer loop: Continue until we reach the desired number of subjects
subject_count <- 0

for (isubject in seq(1, vars$n_subjects)) {
  
  print(sprintf("Generating files for subject %d.", isubject))
  fn_three_stim_and_mem(vars, dirs, isubject)
  
  }


print("Done!")