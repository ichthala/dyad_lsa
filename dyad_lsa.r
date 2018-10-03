chat <- read.csv("dyad6.csv")
chat$ID <- as.factor(chat$ID)
splitchat <- split(chat, chat$ID)

id1 = names(splitchat)[1]
id2 = names(splitchat)[2]

user1text <- paste(splitchat[[id1]]$text, collapse = ' ')
user2text <- paste(splitchat[[id2]]$text, collapse = ' ')

costring(user1text, user2text, TASA, TRUE)
