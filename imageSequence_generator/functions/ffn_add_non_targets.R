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
    slice_head(n = n_non_target_cat) %>%
    # Randomly shuffle the rows
    slice(sample(n()))    
  
  non_target_imgs$typi_bin <- "non_target"
  
  # ..............................................................................
  # Take a random sample of the typical and untypical images as CATEGORIZATION targets.
  # ..............................................................................
  cat_non_target   <- non_target_imgs
  
  
  cat_non_target$cond_cat <- "non_target"
  cat_non_target$cond_mem <- ""
  
  

  cat_non_target <- cat_non_target %>% slice(sample(n()))
  
  
  # ..............................................................................
  # Return both lists.
  # ..............................................................................
  return(cat_non_target)
  
  

}
