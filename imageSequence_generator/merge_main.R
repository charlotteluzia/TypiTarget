
smart_merge_three <- function(list1, list2, list3) {
  sources <- list(list1, list2, list3)
  indices <- c(1, 1, 1)
  result <- list()
  last_used <- NA
  
  total_len <- length(list1) + length(list2) + length(list3)
  
  for (k in 1:total_len) {
    # Find which sources still have elements left and are not the last used
    candidates <- which(indices <= sapply(sources, length) & seq_along(sources) != last_used)
    
    if (length(candidates) == 0) {
      # If no alternative, have to repeat the last one
      candidates <- which(indices <= sapply(sources, length))
    }
    
    # Choose the candidate with the most remaining elements
    remaining_counts <- sapply(candidates, function(i) length(sources[[i]]) - indices[i] + 1)
    chosen <- candidates[which.max(remaining_counts)]
    
    result <- c(result, sources[[chosen]][[indices[chosen]]])
    indices[chosen] <- indices[chosen] + 1
    last_used <- chosen
  }
  
  return(result)
}

a <- list("a1", "a2", "a3")
b <- list("b1", "b2", "b3", "b4")
c <- list("c1", "c2")

merged <- smart_merge_three(a, b, c)
print(merged)

smart_merge_three <- function(list1, list2, list3, strict = TRUE) {
  sources <- list(list1, list2, list3)
  indices <- c(1, 1, 1)
  usage_counts <- c(0, 0, 0)
  result <- list()
  last_used <- NA
  
  total_len <- sum(sapply(sources, length))
  
  for (k in 1:total_len) {
    available <- which(indices <= sapply(sources, length))
    candidates <- setdiff(available, last_used)
    
    if (length(candidates) == 0) {
      candidates <- available  # fallback to any if only one left
    }
    
    if (strict) {
      # Choose the candidate used the least so far
      min_use <- min(usage_counts[candidates])
      candidates <- candidates[usage_counts[candidates] == min_use]
    }
    
    # Random tie-breaker among eligible candidates
    chosen <- sample(candidates, 1)
    
    result <- c(result, sources[[chosen]][[indices[chosen]]])
    indices[chosen] <- indices[chosen] + 1
    usage_counts[chosen] <- usage_counts[chosen] + 1
    last_used <- chosen
  }
  
  return(result)
}
a <- list("a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9","a10",
          "a11","a12","a13","a14","a15","a16")
b <- list("b1", "b2")
c <- list("c1", "c2")

merged <- smart_merge_three(a, b, c, strict = TRUE)
print(merged)

