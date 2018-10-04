library(LSAfun)

# NOTE: You will need to change this filepath to wherever 
# your TASA space is
load("../../dyad_lsa/TASA.rda")

# Set up initial variables
# NOTE: All files in the current working directory 
# must be dyad files in the expected format
all_dyad_filenames <- list.files()
total_dyads_count <- length(all_dyad_filenames)
dyad_ids <- c(total_dyads_count)
dyad_cosine_sims <- c(total_dyads_count)

for (i in 1:total_dyads_count) {
  # Read in CSV and split it into each user's data
  filename <- all_dyad_filenames[i]
  chat <- read.csv(filename)
  chat$ID <- as.factor(chat$ID)
  splitchat <- split(chat, chat$ID)
  
  # Skip if the dyad had fewer than 2 (human) users
  userchats = splitchat[!(names(splitchat) %in% c("SERVER"))]
  
  if (length(names(userchats)) < 2) {
    print(paste(filename, "had fewer than 2 users. Skipping dyad."))
    next
  }

  # Concatenate each user's text into one big string 
  id1 = names(userchats)[1]
  id2 = names(userchats)[2]

  user1text <- paste(userchats[[id1]]$text, collapse = ' ')
  user2text <- paste(userchats[[id2]]$text, collapse = ' ')
  
  if (user1text == "") {
    print(paste("User", id1, "of", filename, "had no text. Skipping dyad."))
  }
  else if (user2text == "") {
    print(paste("User", id2, "of", filename, "had no text. Skipping dyad."))
  }
  else {
    # Calculate text similarity
    cosine_sim = costring(user1text, user2text, TASA, TRUE)
    
    # Add values to the results vectors
    print(cosine_sim)
  }
}

# Write results table to file

# write.table(x, "dyad_cosine_similarities.csv", ",")
