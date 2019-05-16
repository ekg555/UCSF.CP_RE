# DATE RegEx

# PREV		REGEX: "[ADFJMNOSadfjmnos]([a-z]){2,8}[\\.]{0,}[,]{0,}[[:space:]]{0,}[0-9]{0,}[[:space:]]{0,}[12][0-9]{1,}"
# CURRENT 	REGEX: "[ADFJMNOSadfjmnos]([a-z]){2,8}[:space:]{0,}[0-9]{0,},{0,}([:space:]){0,}[12][0-9]{3}"

library(stringr)

see <- function(rx) str_view_all(paste("1,500,000. | 4,982 Junei, 2012 10-1-2012 H74093 | H74093",
										"July July", 
										" jul 1 1929  aug, 24 1932",
										" Augustus 4, 2020 jul05 2022", sep='<br>'), rx )
										
see("[ADFJMNOSadfjmnos]([a-z]){2,8}[:space:]{0,}[0-9]{0,},{0,}([:space:]){0,}[12][0-9]{3}")

