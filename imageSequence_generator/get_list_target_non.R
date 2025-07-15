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
library(purrr)

# -----------------------------------------------------------------------------
# Set the directories.
# -----------------------------------------------------------------------------
dirs <- list()

dirs$main <- ("C:/Users/User/MATLAB/TypiTarget/")

# Directory where to find the image files of target and non target category
dirs$images_target <- paste(dirs$main, "/stimuli_target/supermarket_resized", sep="")
dirs$images_nontarget <- paste(dirs$main, "/stimuli_nontarget/bathroom_resized", sep="")

# Directory where to find the image files of standard, target and non target category
# for training sequence
dirs$images_train_standard <- paste(dirs$main, "/stimuli_training_standard", sep="")
dirs$images_train_target <- paste(dirs$main, "/stimuli_training_target", sep="")
dirs$images_train_nontarget <- paste(dirs$main, "/stimuli_training_nontarget", sep="")

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

image_list_train_standard    <- list.files(path = dirs$images_train_standard, recursive = TRUE, pattern = "\\.jpg$", full.names = TRUE)
image_list_train_target    <- list.files(path = dirs$images_train_target, recursive = TRUE, pattern = "\\.jpg$", full.names = TRUE)
image_list_train_nontarget    <- list.files(path = dirs$images_train_nontarget, recursive = TRUE, pattern = "\\.jpg$", full.names = TRUE)

# produce data frame/tibble for each category
df_image_target           <- data.frame(matrix(ncol = 10, nrow = length(image_list_target)))
colnames(df_image_target) <- desired_order
df_image_target           <- as_tibble(df_image_target)
df_image_target$stimulus  <- image_list_target
df_image_target$stimulus  <- gsub("^.*/", "", df_image_target$stimulus)
# df_image_target$stimulus  <- gsub(pattern = "(.*)\\..*$", replacement = "\\2", df_image_target$stimulus)
# df_image_target$stimulus  <- file_sans_ext(df_image_target$stimulus)
df_image_target$category  <- 'target'
df_image_target           <- df_image_target %>% replace(is.na(.), 0)

df_image_nontarget           <- data.frame(matrix(ncol = 10, nrow = length(image_list_nontarget)))
colnames(df_image_nontarget) <- desired_order
df_image_nontarget           <- as_tibble(df_image_nontarget)
df_image_nontarget$stimulus  <- image_list_nontarget
df_image_nontarget$stimulus  <- gsub("^.*/", "", df_image_nontarget$stimulus)
df_image_nontarget$category  <- 'nontarget'
df_image_nontarget           <- df_image_nontarget %>% replace(is.na(.), 0)

#dataframes for training stimuli
df_train_standard           <- data.frame(matrix(ncol = 10, nrow = length(image_list_train_standard)))
colnames(df_train_standard) <- desired_order
df_train_standard           <- as_tibble(df_train_standard)
df_train_standard$stimulus  <- image_list_train_standard
df_train_standard$stimulus  <- gsub("^.*/", "", df_train_standard$stimulus)
df_train_standard$category  <- 'restaurant'
df_train_standard           <- df_train_standard %>% replace(is.na(.), 0)

df_train_target           <- data.frame(matrix(ncol = 10, nrow = length(image_list_train_target)))
colnames(df_train_target) <- desired_order
df_train_target           <- as_tibble(df_train_target)
df_train_target$stimulus  <- image_list_train_target
df_train_target$stimulus  <- gsub("^.*/", "", df_train_target$stimulus)
df_train_target$category  <- 'nontarget'
df_train_target           <- df_train_target %>% replace(is.na(.), 0)

df_train_nontarget           <- data.frame(matrix(ncol = 10, nrow = length(image_list_train_nontarget)))
colnames(df_train_nontarget) <- desired_order
df_train_nontarget           <- as_tibble(df_train_nontarget)
df_train_nontarget$stimulus  <- image_list_train_nontarget
df_train_nontarget$stimulus  <- gsub("^.*/", "", df_train_nontarget$stimulus)
df_train_nontarget$category  <- 'nontarget'
df_train_nontarget           <- df_train_nontarget %>% replace(is.na(.), 0)

# write data tables as excel files
write_xlsx(df_image_target, "stimuli_info_target_new.xlsx", col_names = TRUE)
write_xlsx(df_image_nontarget, "stimuli_info_nontarget_new.xlsx", col_names = TRUE)


# write training data tables as excel files
write_xlsx(df_train_standard, "stimuli_training_standard.xlsx", col_names = TRUE)
write_xlsx(df_train_target, "stimuli_training_target.xlsx", col_names = TRUE)
write_xlsx(df_train_nontarget, "stimuli_training_nontarget.xlsx", col_names = TRUE)

dirs$files <- paste(dirs$main, "/imageSequence_generator", sep="")

stim_files <- list.files(path = dirs$files, recursive = TRUE, pattern = "\\.xlsx$") %>%
  map_dfr(read_excel)
stim_files_combined <- setNames(lapply(stim_files, read.xlsx), stim_files)
write_xlsx(stim_files, "stimuli_info_complete.xlsx")
