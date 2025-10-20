



polls24 <- read.csv("https://raw.githubusercontent.com/Lfirenzeg/msds607labs/main/president_polls.csv")
head(polls24)


polls24k <- read.csv("~/Downloads/generic_ballot_polls.csv")
head(polls24k)
polls24k$end_date <- as.Date(polls24k$end_date, format="%m/%d/%y")
range(polls24k$end_date)

silver24 <- read.csv("~/Downloads/silver24.csv")

# Extract start date from "Dates" column (before dash or en dash)
silver24$Start_Date <- sub("[-–].*", "", silver24$Dates)
silver24$Start_Date <- trimws(silver24$Start_Date)
# Add the year (assumed 2024)
silver24$Start_Date <- paste0(silver24$Start_Date, "/24")

# Convert to Date type
silver24$Start_Date <- as.Date(silver24$Start_Date, format = "%m/%d/%y")

# Check result
head(silver24[, c("Dates", "Start_Date")])

# 1) extract first group of digits (may include commas), remove commas, convert to numeric
silver24$samplesize <- as.numeric(gsub(",", "",
                                       sub(".*?([0-9,]+).*", "\\1", silver24$Sample)
))

# 2) extract trailing letters (sample type), or NA if none
silver24$sampletype <- ifelse(grepl("[A-Za-z]+\\s*$", silver24$Sample),
                              sub(".*?([A-Za-z]+)\\s*$", "\\1", silver24$Sample),
                              NA)

# quick check
head(silver24[, c("Sample", "samplesize", "sampletype")])

silver24 <- subset(silver24, Contest != "National")



path <- "~/Downloads/sliverstate24"

# List all CSV files in that folder
files <- list.files(path, pattern = "\\.csv$", full.names = TRUE)

# Read and combine them
silver24 <- do.call(rbind, lapply(files, read.csv, stringsAsFactors = FALSE))


# Extract start date from "Dates" column (before dash or en dash)
silver24$Start_Date <- sub("[-–].*", "", silver24$Dates)
silver24$Start_Date <- trimws(silver24$Start_Date)
# Add the year (assumed 2024)
silver24$Start_Date <- paste0(silver24$Start_Date, "/24")

# Convert to Date type
silver24$Start_Date <- as.Date(silver24$Start_Date, format = "%m/%d/%y")

# Check result
head(silver24[, c("Dates", "Start_Date")])

# 1) extract first group of digits (may include commas), remove commas, convert to numeric
silver24$samplesize <- as.numeric(gsub(",", "",
                                       sub(".*?([0-9,]+).*", "\\1", silver24$Sample)
))

silver24$sampletype <- trimws(sub(".*?([A-Za-z]+)@@.*", "\\1", silver24$Sample))


# quick check
head(silver24[, c("Sample", "samplesize", "sampletype")])


range(silver24$Start_Date)

silver24$daystoelection <- as.Date("11/5/24", format="%m/%d/%y") - silver24$Start_Date
range(silver24$daystoelection)

write.csv(silver24, "silver24.csv")
silver24$state <- silver24$Contest
silver24full <- merge(silver24, elecresults24, by = "state")
write.csv(silver24full, "silver24.csv")
#https://www.natesilver.net/p/nate-silver-2024-president-election-polls-model 

silver24full <- silver24full %>% select(state, daystoelection, samplesize, sampletype, Influence, Harris, Trump, colnames(elecresults24))
silver24full$Harris <- silver24full$Harris/100
silver24full$Trump <- silver24full$Trump/100
