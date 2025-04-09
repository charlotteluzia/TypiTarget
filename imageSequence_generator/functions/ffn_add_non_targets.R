ffn_add_non_target_cat <- function(available_images, this_block, vars){
  
  # Add a set of non target images to an already existing set of standard and 
  # target images for the three stimulus categorization task. 
  
  # ..............................................................................
  # Calculate how many images we need for the categorization task + the memory task.
  # ..............................................................................
  n_non_target_cat <- vars$n_target_non
  n_non_target_mem_novel <- round(vars$n_target_non * vars$p_novel)
  
  
  # ..............................................................................
  # Select the required number of images.
  # ..............................................................................
  non_target_imgs <- available_images %>%
    # Filter rows where category matches non target category
    filter(category == vars$category_non_target) %>%
    # Take n_non_target rows
    slice_head(n = n_non_target_cat + n_non_target_mem_novel) %>%
    # Randomly shuffle the rows
    slice(sample(n()))    
  
  non_target_imgs$typi_bin <- "non_target"
  
  # ..............................................................................
  # Take a random sample of the typical and untypical images as CATEGORIZATION targets.
  # ..............................................................................
  cat_non_target   <- non_target_imgs   %>% slice(1:n_non_target_cat)
  
  
  cat_non_target$cond_cat <- "non_target"
  cat_non_target$cond_mem <- ""
  
  
  # ..............................................................................
  # Take the remaining images as novel stimuli for the MEMORY task
  # ..............................................................................
  mem_non_target   <- non_target_imgs  
  mem_non_target$cond_mem <- ""
  
  
  mem_non_target <- mem_non_target %>%
    mutate(cond_mem = case_when(
      row_number() %in% 1:n_target_cat ~ "old",    
      row_number() %in% (n_target_cat + 1):(n_target_cat + n_target_mem_novel) ~ "new",        
      TRUE ~ cond_mem
    ))
  
  
  mem_non_target$cond_cat <- ""
  
  
  # ..............................................................................
  # Shuffle both lists.
  # ..............................................................................
  cat_non_target <- cat_non_target %>% slice(sample(n()))
  mem_non_target <- mem_non_target %>% slice(sample(n()))
  
  
  # ..............................................................................
  # Return both lists.
  # ..............................................................................
  return(list(cat_non_target = cat_non_target, mem_non_target = mem_non_target))
  
  

}
