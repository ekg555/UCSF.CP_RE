# Adapted from http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know
# makes a text-cloud
#
# 

setwd('C:/Users/ekonagaya/Desktop')
tdy <- format(Sys.Date(), format="%Y-%m-%d") #today

# INSTALL
# get GhostScript 9.26  & Install on Desktop/Program Files/gs9.26
# https://ghostscript.com/download/gsdnld.html

# Pandoc for table-printing
# http://pandoc.org/installing.html

# install.packages("tm")  # for text mining
# install.packages("SnowballC") # for text stemming
# install.packages("wordcloud") # word-cloud generator 
# install.packages("RColorBrewer") # color palettes

# install.packages('extrafont')	# fonts
# install.packages('gridExtra') # table printing
# install.packages('stargazer') # table printing

Sys.setenv(PATH = paste("C:\\Rtools\\bin", Sys.getenv("PATH"), sep=";"))
Sys.setenv(BINPREF = "C:\\Rtools\\mingw_$(WIN)\\bin\\")
Sys.setenv(R_ZIPCMD= 'C:/Users/ekonagaya/Desktop/Rtools/bin/zip')
Sys.setenv(R_GSCMD = "C:/Users/ekonagaya/Desktop/Program Files/gs9.26/bin/gswin64c.exe") # link up Ghostscript for PDF printing
# Sys.getenv()

loadfonts()

# LOAD
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(extrafont)
library(gridExtra)



# CHOOSE FILE OPTION
text <- readLines(file.choose())  # Pick a txt file w/ words (INCLUDE HEADER)
if (text[1] == 'DoOccS') { text <- text[-1] } # Remove Header if 1st word is 'DoOccS'

# filePath <- "http://www.sthda.com/sthda/RDoc/example-files/martin-luther-king-i-have-a-dream-speech.txt"
# text <- readLines(filePath)

# Load the data as a CORPUS
docs <- Corpus(VectorSource(text))

inspect(docs)

# TRANSFORMATION using tm_map() to replace special characters w/ space)
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")


# DATA CLEANING (-STOP WORDS [e.g. 'the'], -NUMBERS, -PUNCTUATIONS, -WHITE_SPACE, TEXT STEMS 
# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector = CUSTOM STOP-WORDS
docs <- tm_map(docs, removeWords, c("renovation", "space", "room", "rooms", "install", "new", "installation", "occupancy", "replacement", "center", "remodel", "area", "building", "improvement", "improvements", "remodeling")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)



dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)


# SET SEED FOR RANDOM-POSITIONS & WORD-CLOUD
fname <- paste0("DoOccS ALL CofOs ",tdy,".pdf")
pdf(fname)
set.seed(1234)
windowsFonts(A = windowsFont("Garamond"))
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
text(labels="Description of Occupied Space", x=0.51, y=0.96, family='Garamond', cex=2)
text(labels=gsub(".pdf","", fname), x=0.5, y=0.925, family='Garamond', cex=1)
  
		  
# FREQUENT TERMS occurs atleast 4 times
findFreqTerms(dtm, lowfreq = 4)

# corr. w/ term(s), min_r=.3
findAssocs(dtm, terms = "office", corlimit = 0.3) # space
findAssocs(dtm, terms = "laboratory", corlimit = 0.3) # support
findAssocs(dtm, terms = "clinic", corlimit = 0.1) # nothing @ 0.3, a mess @ 0.1

head(d, 20)
barplot(d[1:20,]$freq, las = 2, names.arg = d[1:20,]$word, cex.names = 0.8,
        col ="lightblue", main ="Description of Occupied Space (ALL): Most frequent words",
        ylab = "Word frequencies")
		
dev.off()		
embed_fonts(fname) # EMBED FONTS (Brand it on so it's not substituted)
write.csv(d,gsub(".pdf",".csv",fname), row.names=F)


# ZIP ALL FILES
files2zip <- dir()[grep(gsub(".pdf","",fname),dir())]
zip(zipfile = gsub(".pdf",".zip",fname), files = files2zip)

if (!dir.exists("Archive")) { dir.create("Archive") }
file.copy( gsub(".pdf",".zip",fname), file.path("Archive") )
file.remove( files2zip,".zip") )
unlink( gsub(".pdf",".zip",fname), recursive = T)

setwd("Archive")
shell.exec(dir(pattern=gsub(".pdf",".zip",fname)))

# COUNT by line
# sapply(strsplit(text[1], " "), length)
