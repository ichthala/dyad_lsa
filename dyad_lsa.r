library(LSAfun)

# NOTE: You will need to change this filepath to wherever 
# your TASA space is
load("../../dyad_lsa/TASA.rda")

# Set up initial variables
# NOTE: All files in the current working directory 
# must be dyad files in the expected format
all_dyad_filenames <- list.files()
total_dyads_count <- length(all_dyad_filenames)
dyad_ids <- vector(mode = "character", length = total_dyads_count)
dyad_cosine_sims <- vector(mode = "numeric", length = total_dyads_count)

for (i in 1:total_dyads_count) {
  # Read in CSV and split it into each user's data
  filename <- all_dyad_filenames[i]
  chat <- read.csv(filename)
  chat$ID <- as.factor(chat$ID)
  splitchat <- split(chat, chat$ID)
  
  # Add this dyad's ID to the results vector
  dyad_ids[i] <- chat$dyad[1]

  # Skip if the dyad had fewer than 2 (human) users
  userchats = splitchat[!(names(splitchat) %in% c("SERVER"))]
  
  if (length(names(userchats)) < 2) {
    warning(paste(filename, "had fewer than 2 users. Skipping dyad."))
    next
  }

  # Concatenate each user's text into one big string 
  id1 = names(userchats)[1]
  id2 = names(userchats)[2]

  user1text <- paste(userchats[[id1]]$text, collapse = " ")
  user2text <- paste(userchats[[id2]]$text, collapse = " ")
  
  if (user1text == "") {
    warning(paste("User", id1, "of", filename, "had no text. Skipping dyad."))
  }
  else if (user2text == "") {
    warning(paste("User", id2, "of", filename, "had no text. Skipping dyad."))
  }
  else {
    # Calculate text similarity
    cosine_sim = costring(user1text, user2text, TASA, TRUE)
    
    # Add cosine sim to the results vector
    dyad_cosine_sims[i] <- cosine_sim
  }
}

# Write results to file
dyads_and_cosine_sims <- data.frame("dyad" = dyad_ids,
                                   "cosine_sim" = dyad_cosine_sims,
                                   stringsAsFactors = FALSE)

results_filename <- paste("dyad_cosine_similarities_", as.integer(Sys.time()), ".csv", sep = "")

write.csv(dyads_and_cosine_sims, file = results_filename, row.names = FALSE)
