fn_three_stim_and_mem <- function(vars, dirs, isubject, block_order){
  
  source(file.path(dirs$functions, "ffn_get_typ_and_untyp_standards.R"))
  source(file.path(dirs$functions, "ffn_add_targets.R"))
  source(file.path(dirs$functions, "ffn_add_non_targets.R"))
  source(file.path(dirs$functions, "ffn_add_memcatch_trials.R"))
  source(file.path(dirs$functions, "ffn_add_metadata_to_list.R"))
  source(file.path(dirs$functions, "ffn_write_list_as_excel.R"))
  
  # -------------------------------------------------------------------------
  # Initialize variables and load image information.
  # -------------------------------------------------------------------------
  
  # Specify the desired order of columns for the output files.
  desired_order <- c("subject_id",
                     "task",
                     "block_total",
                     "block_scene",
                     "trial_block",
                     "trial_total", 
                     "target_cat",
                     "category", 
                     "cond_cat",
                     "cond_mem",
                     "correct_answer",
                     "stimulus",
                     "conceptual",
                     "perceptual",
                     "typicality",
                     "typi_bin")
  
  
  # Get a list of all available images from the target scene categories.
  available_images          <- read_xlsx(sprintf("%s/stimuli_info_140.xlsx", dirs$images))
  available_images$stimulus <- gsub("^.*/", "", as.character(available_images$stimulus))
  setDT(available_images)
  available_images <- available_images %>% mutate(stimulus = paste("stimuli", stimulus, sep = "/"))
  
  
  # Get a list of available catch trial images.  
  available_catch_files <- list.files(path = sprintf("%s/", dirs$images), pattern = "catch*", full.names = FALSE)
  available_catch_files <- data.table(filename = available_catch_files)
  available_catch_files <- available_catch_files %>% mutate(filename = paste("stimuli", filename, sep = "/"))
  
  
  # We need to keep track of how many category blocks we are generating.
  # Initialize a named list to store counts for each category. We will use this
  # table to create an additional Excel file to tell PsychoPy which conditions to
  # present in which order.
  block_order_table    <- data.frame(row_index = 1:ncol(block_order))
  category_counts      <- list()
  
  nblocks              <- ncol(block_order)
  category_occurrences <- numeric(nblocks)
  
  for (category in vars$categories) {category_counts[[category]] <- 0}
  
  ntrials_total     <- 0
  
  # Generate the order of category blocks.
  all_category_blocks <- rep(vars$categories, vars$n_blocks_per_category)
  nblocks             <- length(all_category_blocks)
  
  # -------------------------------------------------------------------------
  # Generate the input list for both task by iterating through all category
  # blocks.
  # -------------------------------------------------------------------------
  target_all          <- list()
  distractors_all     <- list()
  input_list_mem_task <- list()
  input_list_cat_task <- list()
  
  # ............................................................................
  # RUN ACROSS BLOCKS.
  # ............................................................................
  for (iblock in seq_along(all_category_blocks)) {
    
    print(sprintf("Selecting stimuli for block %d.", iblock))
      
    current_category <- all_category_blocks[iblock]  
    
    # ..........................................................................
    # Select the required number of standard (typical and untypical), target and
    # non target images for the categorization
    # ..........................................................................
    standards[[iblock]] <- ffn_get_typ_and_untyp_standards(available_images, current_category, vars)
    available_images <- available_images[!stimulus %in% unique(standards[[iblock]]$stimulus)]
    
    targets[[iblock]] <- ffn_add_targets(available_images, current_category, vars)
    available_images <- available_images[!stimulus %in% unique(targets[[iblock]]$stimulus)]
    
    non_targets[[iblock]] <- ffn_add_targets(available_images, current_category, vars)
    available_images <- available_images[!stimulus %in% unique(non_targets[[iblock]]$stimulus)]
    
    input_list_cat_task[[iblock]] <- rbindlist(list(standards[[iblock]], targets[[iblock]]))
    input_list_cat_task[[iblock]] <- rbindlist(list(input_list_cat_task[[iblock]], non_targets[[iblock]]))
    
    # Randomize the order of lines in selected_images
    tmp = input_list_cat_task[[iblock]]
    input_list_cat_task[[iblock]] <- tmp[sample(.N), ]
   
    # ..........................................................................
    # Select the required number of standard (typical and untypical), target and
    # non target images for the memory task
    # ..........................................................................
    input_list_mem_task[[iblock]] <- ffn_generate_mem_list(available_images, current_category, vars, standards[[iblock]], targets[[iblock]], non_targets[[iblock]])
  }
  random_block_order <- sample(1:nblocks)
  
  # We need to keep track of how many category blocks we are generating.
  # Initialize a named list to store counts for each category. We will use this
  # table to create an additional Excel file to tell PsychoPy which conditions to
  # present in which order.
  block_order_table <- data.frame(row_index = 1:nblocks)
  
  category_counts <- list()
  for (category in vars$categories) {category_counts[[category]] <- 0}
  category_occurrences <- numeric(nblocks)
  
  ntrials_total  <- 0
  
  
  for (iblock in random_block_order) {
    
    current_category <- all_category_blocks[iblock]
    
    # Update information for the block order table for this iteration.  
    category_counts[[current_category]] <- category_counts[[current_category]] + 1
    category_occurrences[iblock]        <- category_counts[[current_category]]
    column_name <- paste(current_category, category_occurrences[iblock], sep = "_")
    block_order_table[[column_name]] <- ifelse(1:nblocks == iblock, 1, 0)
    
    # Add meta-data for CATEGORIZATION task, update trial count, and save.
    input_list_cat_task[[iblock]] <- ffn_add_metadata_to_list(input_list_cat_task[[iblock]], "categorization", current_category, category_occurrences, iblock, desired_order, ntrials_total)
    ntrials_total <- ntrials_total + nrow(input_list_cat_task[[iblock]])
    ffn_write_list_as_excel(input_list_cat_task[[iblock]], dirs, isubject, "categorization", current_category, category_occurrences[iblock])
    
    # Add meta-data for MEMORY task, update trial count, and save.
    input_list_mem_task[[iblock]] <- ffn_add_metadata_to_list(input_list_mem_task[[iblock]], "memory", current_category, category_occurrences, iblock, desired_order, ntrials_total)
    ntrials_total <- ntrials_total + nrow(input_list_mem_task[[iblock]])
    ffn_write_list_as_excel(input_list_mem_task[[iblock]], dirs, isubject, "memory", current_category, category_occurrences[iblock])
    
    # Now that we have all information for this subject finalized, we use this
    # info for generating another "anti-subject" for which target and lure images
    # are switched. All anti-subjects have even numbers, i.e. subject id +1.
    anti_list <- list()
    anti_list <- ffn_generate_anti_subject(input_list_cat_task[[iblock]], input_list_mem_task[[iblock]])
    anti_list$catlist_new$subject_id <- 1000 + anti_list$catlist_new$subject_id
    anti_list$memlist_new$subject_id <- 1000 + anti_list$memlist_new$subject_id
    
    ffn_write_list_as_excel(anti_list$catlist_anti, dirs, isubject+1, "categorization", current_category, category_occurrences[iblock])
    ffn_write_list_as_excel(anti_list$memlist_anti, dirs, isubject+1, "memory", current_category, category_occurrences[iblock])
    
  }
  
  
  # -------------------------------------------------------------------------
  # Save the block order table.
  # -------------------------------------------------------------------------
  block_order_table$row_index <- NULL
  filename = sprintf("%s/%d_scenecat_block_order.xlsx", dirs$input_files, isubject)
  write_xlsx(block_order_table, filename, col_names =TRUE)
  
  filename = sprintf("%s/%d_scenecat_block_order.xlsx", dirs$input_files, isubject+1)
  write_xlsx(block_order_table, filename, col_names =TRUE)
  
  
  
}
    
  
    
    
  #   # ..........................................................................
  #   # Now add the catch trials to the memory block, then remove from available catch images.
  #   # ..........................................................................
  #   mem_old_new_and_catch <- ffn_add_memcatch_trials(available_catch_files, vars, mem_old_and_new)
  #   available_catch_files <- available_catch_files[!filename %in% unique(mem_old_new_and_catch$stimulus)]
  #   
  #   
  #   # ..........................................................................
  #   # select target images for "categorization" and "memory"
  #   # ..........................................................................
  #   targets_all <- ffn_add_targets(available_images, this_block, vars)
  #   
  #   cat_targets <- targets_all$cat_target
  #   mem_targets <- targets_all$mem_target
  #   
  #   available_images <- available_images[!stimulus %in% unique(cat_targets$stimulus)]
  #   available_images <- available_images[!stimulus %in% unique(mem_targets$stimulus)]
  #   
  #   
  #   # ..........................................................................
  #   # select non target images for "categorization" and "memory"
  #   # ..........................................................................
  #   non_targets_all <- ffn_add_targets(available_images, this_block, vars)
  #   
  #   cat_non_targets <- non_targets_all$cat_non_target
  #   mem_non_targets <- non_targets_all$mem_non_target
  #   
  #   available_images <- available_images[!stimulus %in% unique(cat_non_targets$stimulus)]
  #   available_images <- available_images[!stimulus %in% unique(mem_non_targets$stimulus)]
  #   
  #   
  #   # ..........................................................................
  #   # Update the block order table.
  #   # ..........................................................................
  #   category_counts[[this_target_category]]    <- category_counts[[this_target_category]] + 1
  #   category_occurrences[iblock]        <- category_counts[[this_target_category]]
  #   column_name                         <- paste(this_target_category, category_occurrences[iblock], sep = "_")
  #   block_order_table[[column_name]]    <- ifelse(1:nblocks == iblock, 1, 0)
  #   
  #   
  #   # ..........................................................................
  #   # Add meta-data for CATEGORIZATION task, update trial count, and save.
  #   # ..........................................................................
  #   cat_targets_and_distractors <- ffn_add_metadata_to_list(cat_targets_and_distractors, "categorization", isubject, this_target_category, category_occurrences, iblock, desired_order, ntrials_total)
  #   ffn_write_list_as_excel(cat_targets_and_distractors, dirs, isubject, "categorization", this_target_category, category_occurrences[iblock])
  #   
  #   ntrials_total <- ntrials_total + nrow(cat_targets_and_distractors)
  #   
  #   # ..........................................................................
  #   # Add meta-data for MEMORY task, update trial count, and save.
  #   # ..........................................................................
  #   mem_old_new_and_catch <- ffn_add_metadata_to_list(mem_old_new_and_catch, "memory", isubject, this_target_category, category_occurrences, iblock, desired_order, ntrials_total)
  #   ffn_write_list_as_excel(mem_old_new_and_catch, dirs, isubject, "memory", this_target_category, category_occurrences[iblock])
  #   
  #   ntrials_total <- ntrials_total + nrow(cat_targets_and_distractors)
  #   
  # }   
  # 
  # 
  # # -------------------------------------------------------------------------
  # # Save the block order table.
  # # -------------------------------------------------------------------------
  # block_order_table$row_index <- NULL
  # filename = sprintf("%s/%d_scenecat_block_order.xlsx", dirs$input_files, isubject)
  # write_xlsx(block_order_table, filename, col_names =TRUE)
  
  }

