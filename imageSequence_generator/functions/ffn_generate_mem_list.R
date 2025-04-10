
ffn_generate_mem_list <- function(available_images, current_category, vars, input_list_cat_task) {
  
  cat_targets <- subset(input_list_cat_task, cond_cat == "target" | cond_cat == "standard" | cond_cat == "non_target")
  cat_targets <- cat_targets %>% mutate(cond_mem = "old")
  
  n_standard_mem <- round(vars$n_typical * vars$p_novel)
  n_untypical_mem <- (vars$n_trials_per_block - vars$n_typical) * vars$p_novel
  n_target_mem <- round(vars$n_target * vars$p_novel)
  n_non_target_mem <- round(vars$n_target_non * vars$p_novel)
  
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
  typical_imgs <- typical_imgs %>% mutate(cond_mem = "new")
  
  typical_imgs$typi_bin <- "typical"
  
  
  untypical_imgs <- available_images %>%
    # Filter rows where category matches current_category
    filter(category == current_category) %>%
    # Take n_untypical rows with the smallest numbers in the column typicality
    arrange(typicality) %>%
    slice_head(n = n_untypical_cat) %>%
    # Randomly shuffle the rows
    slice(sample(n()))
  untypical_imgs <- untypical_imgs %>% mutate(cond_mem = "new")
  
  untypical_imgs$typi_bin <- "untypical"
  
  un_typ_imgs <- rbind(typical_imgs, untypical_imgs)
  
  n_target_mem <- available_images %>%
    # Filter rows where category matches current_category
    filter(category == vars$category_target) %>%
    # Take n_target rows
    slice_head(n = n_target_mem) %>%
    ungroup()
  n_target_mem <- n_target_mem %>% mutate(cond_mem = "new")
  
  n_non_target_mem <- available_images %>%
    # Filter rows where category matches current_category
    filter(category == vars$category_non_target) %>%
    # Take n_target rows
    slice_head(n = n_non_target_mem) %>%
    ungroup()
  n_non_target_mem <- n_non_target_mem %>% mutate(cond_mem = "new")
  
  n_mem_target_non <- rbind(n_target_mem, n_non_target_mem)
  n_mem_target_non <- n_mem_target_non %>% slice(sample(n()))
  n_mem_all        <- rbind(un_typ_imgs, n_mem_target_non)
  n_mem_all        <- n_mem_all %>% slice(sample(n()))
  
  return(n_mem_all)
}