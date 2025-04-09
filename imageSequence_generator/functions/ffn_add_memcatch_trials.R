
ffn_add_memcatch_trials <- function(available_catch_files, vars, mem_old_and_new){
  
  
  # -------------------------------------------------------------------------
  # Now add the catch trials.
  # -------------------------------------------------------------------------
  selected_catch_files <- available_catch_files[sample(.N, vars$n_catch_trials), ]
  catch <- data.frame(stimulus = basename(selected_catch_files$filename), cond_mem = "catch")
  catch <- catch %>% mutate(stimulus = paste("stimuli", stimulus, sep = "/"))
  catch <- catch %>% mutate(cond_mem = "catch")
  
  # Determine when the catch trial should appear. This should happen somewhere
  # within the middle 50% of trials.
  N            <- nrow(mem_old_and_new)
  start_index  <- ceiling(N * 0.20) + 1 # Start at 25% of N
  end_index    <- floor(N * 0.80)         # End at 75% of N
  random_indices <- sort(sample(start_index:end_index, size = vars$n_catch_trials, replace = FALSE))
  
  
  # Create a copy of mem_old_and_new to insert catch rows
  mem_old_new_and_catch <- mem_old_and_new
  
  # Insert catch rows at the selected indices
  for (i in seq_along(random_indices)) {
    idx <- random_indices[i]
    row_to_insert <- catch[i, , drop = FALSE]  # Take the current row from 'catch'
    
    # Split and reassemble the data frame with the new row inserted
    mem_old_new_and_catch <- bind_rows(
      slice(mem_old_new_and_catch, 1:(idx - 1)),  # Rows before the insertion point
      row_to_insert,                              # Catch trial row to insert
      slice(mem_old_new_and_catch, idx:n())       # Rows after the insertion point
    )
  }
  
  
  return(mem_old_new_and_catch)
  
}