
ffn_get_typ_and_untyp_standards <- function(available_images, current_category, this_block, vars) {
  
  
  # target_all <- available_images %>%
  #   # Filter rows where category matches current_category
  #   filter(category == current_category) %>%
  #   # Split the data into groups
  #   group_by(!!sym(vars$binning_variable)) %>%
  #   # Select a random sample of 2 rows from each group
  #   #sample_n(size = vars$n_targets_percentile) %>%
  #   # Select N rows with the highest values of typicality
  #   slice_max(typicality, n = vars$n_targets_percentile/2, with_ties = FALSE) %>%
  #   # Bind with N rows with the lowest values of typicality
  #   bind_rows(slice_min(available_images %>% filter(category == current_category) %>% 
  #                         group_by(!!sym(vars$binning_variable)), typicality, n = vars$n_targets_percentile/2, with_ties = FALSE)) %>%    # Ungroup to avoid grouping affecting other operations later
  #   ungroup()
  # 
  # target_all$cond_cat <- "target"
  # target_all$cond_mem <- ""
  # 
  # return(target_all)
  
  # ..............................................................................
  # Calculate how many images we need for the categorization task
  # ..............................................................................
  n_typical_cat <- vars$n_typical
  
  n_untypical_cat <- vars$n_trials_per_block - vars$n_typical
  
  
  # ..............................................................................
  # Select the required number of images.
  # ..............................................................................
  typical_imgs <- available_images %>%
    # Filter rows where category matches current_category
    filter(category == current_category) %>%
    # Take n_typical rows with the largest numbers in the column typicality
    arrange(desc(typicality)) %>%
    slice_head(n = n_typical_cat) %>%
    # Randomly shuffle the rows
    slice(sample(n()))    
  
  typical_imgs$typi_bin <- "typical"
  
  
  untypical_imgs <- available_images %>%
    # Filter rows where category matches current_category
    filter(category == current_category) %>%
    # Take n_untypical rows with the smallest numbers in the column typicality
    arrange(typicality) %>%
    slice_head(n = n_untypical_cat) %>%
    # Randomly shuffle the rows
    slice(sample(n()))
  
  untypical_imgs$typi_bin <- "untypical"
  
  
  # ..............................................................................
  # Take a random sample of the typical and untypical images as CATEGORIZATION targets.
  # ..............................................................................
  cat_typical   <- typical_imgs
  cat_untypical <- untypical_imgs
  
  cat_all <- bind_rows(cat_typical, cat_untypical)
  
  cat_all$cond_cat <- "standard"
  cat_all$cond_mem <- ""

  cat_all <- cat_all %>% slice(sample(n()))
  return(cat_all)
  
}
