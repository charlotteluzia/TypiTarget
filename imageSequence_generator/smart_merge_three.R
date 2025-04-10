smart_merge_three <- function(list1, list2, list3, prefer = "longest", mode = "smart") {
  sources <- list(list1, list2, list3)
  indices <- c(1, 1, 1)
  result <- list()
  last_used <- NA
  current_rr <- 1  # for round-robin
  
  total_len <- sum(sapply(sources, length))
  
  for (k in 1:total_len) {
    available <- which(indices <= sapply(sources, length))
    
    if (mode == "roundrobin") {
      # Round-robin mode: find next available index not equal to last_used
      tries <- 0
      repeat {
        if (tries > length(sources)) break  # fallback
        current_rr <- (current_rr %% length(sources)) + 1
        if (current_rr %in% available && current_rr != last_used) break
        tries <- tries + 1
      }
      chosen <- current_rr
    } else {
      # Smart mode
      candidates <- available[available != last_used]
      if (length(candidates) == 0) {
        candidates <- available  # fallback if only last_used is left
      }
      
      if (prefer == "random") {
        chosen <- sample(candidates, 1)
      } else {  # prefer = "longest"
        remaining_counts <- sapply(candidates, function(i) length(sources[[i]]) - indices[i] + 1)
        chosen <- candidates[which.max(remaining_counts)]
      }
    }
    
    result <- c(result, sources[[chosen]][[indices[chosen]]])
    indices[chosen] <- indices[chosen] + 1
    last_used <- chosen
  }
  
  return(result)
}

a <- list("a1", "a2", "a3")
b <- list("b1", "b2", "b3", "b4")
c <- list("c1", "c2")


# Prefer longest, smart scheduling
# opt1 <- smart_merge_three(a, b, c, prefer = "longest", mode = "smart")

# Random selection among eligible sources
opt2 <- smart_merge_three(a, b, c, prefer = "random", mode = "smart")

# Round-robin cycling, avoiding immediate repeats
# opt3 <- smart_merge_three(a, b, c, mode = "roundrobin")

##-------------------------------------------###############
merge_with_constraints_prefer_list1 <- function(list1, list2, list3) {
  sources <- list(list1, list2, list3)
  indices <- c(1, 1, 1)
  result <- list()
  last_used <- NA  # 1 = list1, 2 = list2, 3 = list3
  
  total_len <- sum(sapply(sources, length))
  
  for (i in 1:total_len) {
    available <- which(indices <= sapply(sources, length))
    
    # Enforce constraints: avoid consecutive use of list2 or list3
    if (last_used == 2) {
      available <- setdiff(available, 2)
    }
    if (last_used == 3) {
      available <- setdiff(available, 3)
    }
    
    # Prefer list1 if available
    if (1 %in% available) {
      chosen <- 1
    } else if (2 %in% available) {
      chosen <- 2
    } else if (3 %in% available) {
      chosen <- 3
    } else {
      # fallback if nothing else available (even if repeating)
      fallback <- which(indices <= sapply(sources, length))
      chosen <- fallback[1]
    }
    
    result <- c(result, sources[[chosen]][[indices[chosen]]])
    indices[chosen] <- indices[chosen] + 1
    last_used <- chosen
  }
  
  return(result)
}
list1 <- as.list(1:15)
list2 <- list("A", "B", "C", "D")
list3 <- list("X", "Y")

merged <- merge_with_constraints_prefer_list1(list1, list2, list3)
print(merged)

