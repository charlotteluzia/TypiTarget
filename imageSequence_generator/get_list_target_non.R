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

dirs$main <- ("C:/Users/User/MATLAB/TypiTarget/")

# Directory where to find the image files of target and non target category
dirs$images_target <- paste(dirs$main, "/stimuli_target", sep="")
dirs$images_nontarget <- paste(dirs$main, "/stimuli_nontarget", sep="")

# which columns our excel file should have
desired_order <- c("category", 
                   "stimulus",
                   "conceptual", 
                   "perceptual",
                   "rt", "n",
                   "typicality",
                   "p_typicality",
                   "p_conceptual",
                   "p_perceptual")

# get names of target and non target images
image_list_target    <- list.files(path = dirs$images_target, recursive = TRUE, pattern = "\\.jpg$", full.names = TRUE)
image_list_nontarget <- list.files(path = dirs$images_nontarget, recursive = TRUE, pattern = "\\.jpg$", full.names = TRUE)


# produce data frame/tibble for each category
df_image_target           <- data.frame(matrix(ncol = 10, nrow = length(image_list_target)))
colnames(df_image_target) <- desired_order
df_image_target           <- as_tibble(df_image_target)
df_image_target$stimulus  <- image_list_target
df_image_target$stimulus  <- gsub("^.*/", "", df_image$stimulus)
df_image_target$category  <- 'target'
df_image_target           <- df_image_target %>% replace(is.na(.), 0)

df_image_nontarget           <- data.frame(matrix(ncol = 10, nrow = length(image_list_nontarget)))
colnames(df_image_nontarget) <- desired_order
df_image_nontarget           <- as_tibble(df_image_nontarget)
df_image_nontarget$stimulus  <- image_list_nontarget
df_image_nontarget$stimulus  <- gsub("^.*/", "", df_image_nontarget$stimulus)
df_image_nontarget$category  <- 'nontarget'
df_image_nontarget           <- df_image_nontarget %>% replace(is.na(.), 0)

# write data tables as excel files
write_xlsx(df_image_target, "stim_info_target.xlsx", col_names = TRUE)
write_xlsx(df_image_nontarget, "stim_info_nontarget.xlsx", col_names = TRUE)
  
