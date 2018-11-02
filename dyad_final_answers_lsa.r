library(LSAfun)

# NOTE: You will need to change this filepath to wherever 
# your TASA space is
load("/Users/Alice/Desktop/Code/r_scripts/dyad_lsa/TASA.rda")
setwd("/Users/Alice/Desktop/Code/r_scripts/dyad_data/")

all_answers <- read.csv('dyad_final_answers.csv')

all_answers$dyad <- as.factor(all_answers$dyad)
answers_by_dyad <- split(all_answers, all_answers$dyad)

dyad_count = length(answers_by_dyad)
dyad_ids = vector(mode = "numeric", length = dyad_count)
q1_sims = vector(mode = "numeric", length = dyad_count)
q2_sims = vector(mode = "numeric", length = dyad_count)
q3_sims = vector(mode = "numeric", length = dyad_count)
q4_sims = vector(mode = "numeric", length = dyad_count)
q5_sims = vector(mode = "numeric", length = dyad_count)
q6_sims = vector(mode = "numeric", length = dyad_count)
avg_lss = vector(mode = "numeric", length = dyad_count)

for (i in 1:dyad_count) {
  answers <- answers_by_dyad[i]
  dyad_id = names(answers)[1]
  dyad_ids[i] = dyad_id
  only_answers = answers[[dyad_id]]

  # Check that dyad has 2 partners
  if (length(only_answers$Q1) == 2) {
    q1_sims[i] = costring(toString(only_answers$Q1[1]), toString(only_answers$Q1[2]), TASA, TRUE)
    q2_sims[i] = costring(toString(only_answers$Q2[1]), toString(only_answers$Q2[2]), TASA, TRUE)
    q3_sims[i] = costring(toString(only_answers$Q3[1]), toString(only_answers$Q3[2]), TASA, TRUE)
    q4_sims[i] = costring(toString(only_answers$Q4[1]), toString(only_answers$Q4[2]), TASA, TRUE)
    q5_sims[i] = costring(toString(only_answers$Q5[1]), toString(only_answers$Q5[2]), TASA, TRUE)
    q6_sims[i] = costring(toString(only_answers$Q6[1]), toString(only_answers$Q6[2]), TASA, TRUE)
  
    avg_lss[i] = mean( c(q1_sims[i], q2_sims[i], q3_sims[i], q4_sims[i], q5_sims[i], q6_sims[i]) )
  }
  else {
    # Dyad only has 1 partner, so set everything to NA
    q1_sims[i] = NA
    q2_sims[i] = NA
    q3_sims[i] = NA
    q4_sims[i] = NA
    q5_sims[i] = NA
    q6_sims[i] = NA
    
    avg_lss[i] = NA
  }
}

dyad_answers_lss <- data.frame("dyad" = dyad_ids,
                          "q1_lss" = q1_sims,
                          "q2_lss" = q2_sims,
                          "q3_lss" = q3_sims,
                          "q4_lss" = q4_sims,
                          "q5_lss" = q5_sims,
                          "q6_lss" = q6_sims,
                          "avg_lss" = avg_lss,
                          stringsAsFactors = FALSE)


results_filename <- paste("dyad_answers_lss_", as.integer(Sys.time()), ".csv", sep = "")
write.csv(dyad_answers_lss, file = results_filename, row.names = FALSE)
