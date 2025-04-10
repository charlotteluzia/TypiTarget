ffn_add_target_cat <- function(available_images, this_block, vars){
  
  # Add a set of target images to an already existing set of standard images for
  # the three stimulus categorization task. 
  
  # ..............................................................................
  # Calculate how many images we need for the categorization task + the memory task.
  # ..............................................................................
  n_target_cat <- vars$n_target_non
  n_target_mem_novel <- round(vars$n_target_non * vars$p_novel)
  
  
  # ..............................................................................
  # Select the required number of images.
  # ..............................................................................
  target_imgs <- available_images %>%
    # Filter rows where category matches current_category
    filter(category == vars$category_target) %>%
    # Take n_target rows
    slice_head(n = n_target_cat) %>%
    # Randomly shuffle the rows
    slice(sample(n()))    
  
  target_imgs$typi_bin <- "target"
  
  # ..............................................................................
  # Take a random sample of the typical and untypical images as CATEGORIZATION targets.
  # ..............................................................................
  cat_target   <- target_imgs 
  
  
  cat_target$cond_cat <- "target"
  cat_target$cond_mem <- ""
  
  
  
  cat_target <- cat_target %>% slice(sample(n()))
 
  
  # ..............................................................................
  # Return both lists.
  # ..............................................................................
  return(cat_target)
  
  
  
}
