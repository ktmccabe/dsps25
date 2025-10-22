## ----include=FALSE, echo=FALSE, warning=FALSE, message=FALSE, eval=FALSE----
# 
# 
# 
# 
# library(tidyverse)
# elecresults <- read.csv("https://raw.githubusercontent.com/fivethirtyeight/election-results/refs/heads/main/election_results_presidential.csv")
# elecresults24 <- elecresults %>%
#   filter(
#     cycle == 2024,
#     stage == "general",
#     candidate_name %in% c("Donald Trump", "Kamala Harris"),
#     ballot_party %in% c("DEM", "REP"),
#     state != "Puerto Rico"
#   ) %>%
#   select(state_abbrev, state, candidate_name, percent) %>%
#   pivot_wider(
#     names_from = candidate_name,
#     values_from = percent,
#     names_sep = "_"
#   )
# elecresults24$dem_percent2024 <- elecresults24$`Kamala Harris`/100
# elecresults24$rep_percent2024 <- elecresults24$`Donald Trump`/100
# elecresults24 <- elecresults24 %>% select(-c(`Kamala Harris`, `Donald Trump`))
# ev_table <- tribble(
#     ~state_abbrev, ~ev_total,
#     "AL", 9,  "AK", 3,  "AZ", 11, "AR", 6,  "CA", 54,
#     "CO", 10, "CT", 7,  "DE", 3,  "DC", 3,  "FL", 30,
#     "GA", 16, "HI", 4,  "ID", 4,  "IL", 19, "IN", 11,
#     "IA", 6,  "KS", 6,  "KY", 8,  "LA", 8,  "ME", 2, "M1", 1, "M2", 1,
#     "MD", 10, "MA", 11, "MI", 15, "MN", 10, "MS", 6,
#     "MO", 10, "MT", 4,  "NE", 2, "N1", 1, "N2", 1, "N3", 1,  "NV", 6,  "NH", 4,
#     "NJ", 14, "NM", 5,  "NY", 28, "NC", 16, "ND", 3,
#     "OH", 17, "OK", 7,  "OR", 8,  "PA", 19, "RI", 4,
#     "SC", 9,  "SD", 3,  "TN", 11, "TX", 40, "UT", 6,
#     "VT", 3,  "VA", 13, "WA", 12, "WV", 4,  "WI", 10,
#     "WY", 3
#   ) %>%
#   distinct(state_abbrev, .keep_all = TRUE)
# 
# elecresults24 <- merge(elecresults24, ev_table, by="state_abbrev")
# 
# 
# results2020$state_abbrev <- ifelse(results2020$stateid == "NE1", "N1",
#                                    ifelse(results2020$stateid == "NE2", "N2",
#                                           ifelse(results2020$stateid == "NE3", "N3",
#                                                  ifelse(results2020$stateid == "ME2", "M2",
#                                                         ifelse(results2020$stateid == "ME1", "M1",
#                                                                as.character(results2020$stateid) )))))
# results2020$called2016 <- ifelse(results2020$margin2016 <0, "R", "D")
# results2020$called2020 <- results2020$called
# results2020$dem_percent2020 <- results2020$dem_percent
# results2020$rep_percent2020 <- results2020$rep_percent
# 
# results2020sub <- results2020 %>% select(state_abbrev, called2020,
#                                          dem_percent2020,
#                                          rep_percent2020,
#                                          called2016)
# table(results2020$called2016, results2020$called)
# elecresults24 <- merge(elecresults24, results2020sub, by="state_abbrev")
# 
# 
# elecresults24$called2024 <- ifelse(elecresults24$rep_percent2024 > elecresults24$dem_percent2024, "R","D")
# 
# write.csv(elecresults24, "data/elecresults24.csv")


## ----include=F-------------------------------------------------------
results2024 <- read.csv("data/elecresults24.csv", stringsAsFactors = T)


## ----eval=F----------------------------------------------------------
# results2024 <- read.csv("elecresults24.csv", stringsAsFactors = T)
# results2024 <- read.csv("https://raw.githubusercontent.com/ktmccabe/teachingdata/refs/heads/main/elecresults24.csv", stringsAsFactors = T)


## --------------------------------------------------------------------
sum(results2024$ev_total[results2024$called2024 == "R"])
sum(results2024$ev_total[results2024$called2024 == "D"])


## --------------------------------------------------------------------
results2024$predicted2024 <- results2024$called2020


## --------------------------------------------------------------------
mean(results2024$predicted2024 == results2024$called2024)


## --------------------------------------------------------------------
table(predicted=results2024$predicted2024, actual = results2024$called2024)


## --------------------------------------------------------------------
results2024$state[results2024$predicted2024 != results2024$called2024]


## ----warning=F, message=F, include=FALSE, echo=FALSE, eval=FALSE-----
# 
# #original
# polls24 <- read.csv("https://raw.githubusercontent.com/Lfirenzeg/msds607labs/main/president_polls.csv")
# 
# polls24sub <- polls24 %>% filter(office_type == "U.S. President")
# 
# polls24sub <- polls24sub %>%
#   filter(
#     candidate_name %in% c("Donald Trump", "Kamala Harris", "Joe Biden"),
#     party %in% c("REP", "DEM"),
#     election_date == "11/5/24",
#     state != "Puerto Rico" & state != ""
#   ) %>%
#   select(state, poll_id, candidate_name, pct, pollster, start_date,
#          election_date, question_id, sample_size, population) %>%
#   pivot_wider(
#     names_from = candidate_name,
#     values_from = pct,
#     names_sep = "_"
#   )
# 
# polls24sub <- merge(polls24sub, elecresults24, by = "state")
# polls24sub$start_date <- as.Date(polls24sub$start_date, format = "%m/%d/%y")
# polls24sub$daystoelection <- as.Date("11/5/24",  format = "%m/%d/%y") - polls24sub$start_date
# range(polls24sub$daystoelection, na.rm=T)
# polls24sub$Harris <- polls24sub$`Kamala Harris`/100
# polls24sub$Trump <- polls24sub$`Donald Trump`/100
# polls24sub$samplesize <- polls24sub$sample_size
# polls24sub$sampletype <- polls24sub$population
# polls24sub <- polls24sub %>% select(state, poll_id,Harris, Trump, pollster, daystoelection,election_date, question_id, samplesize,sampletype, colnames(elecresults24))
# 
# write.csv(polls24sub, file="polls24sub.csv")


## ----include=F, eval=F-----------------------------------------------
# polls24swing <- read.csv("data/silver24.csv")
# polls24all <- read.csv("polls24sub.csv")
# polls24allsub <- subset(polls24all, daystoelection < 200)
# polls24allsub$X <- 1:nrow(polls24allsub)
# polls24swing <- polls24swing %>% select(names(polls24swing)[names(polls24swing) %in% names(polls24allsub) ])
# varnams <- names(polls24allsub)[names(polls24allsub) %in% names(polls24swing)]
# polls24allsub <- polls24allsub %>% select(varnams)
# 
# polls24bothsources <- rbind(polls24swing, polls24allsub)
# polls24bothsources <- subset(polls24bothsources, is.na(Harris) == F)
# write.csv(polls24bothsources, "data/polls24bothsources.csv")
# 


## ----eval=F----------------------------------------------------------
# polls24 <- read.csv("polls24bothsources.csv")
# polls24 <- read.csv("https://raw.githubusercontent.com/ktmccabe/teachingdata/refs/heads/main/polls24bothsources.csv")


## ----include=F-------------------------------------------------------
polls24 <- read.csv("data/polls24bothsources.csv")



## --------------------------------------------------------------------
polls24$pollmargin24 <- polls24$Trump - polls24$Harris
polls24$resultmargin24 <- polls24$rep_percent2024 - polls24$dem_percent2024


## --------------------------------------------------------------------
## Iteration vector
states <- unique(polls24$state)
states


## --------------------------------------------------------------------
## Subset to just Arizona
states[1]

subdata <- subset(polls24, state == states[1])

## Further subset to the "latest polls"
subdata <- subset(subdata, daystoelection < 15 | 
                      daystoelection == min(subdata$daystoelection) )


## --------------------------------------------------------------------
## Find the margin for the actual result
result.marginAZ <- mean(subdata$resultmargin24)
result.marginAZ
## Find the margin for our prediction
polls.marginAZ <- mean(subdata$pollmargin24)
polls.marginAZ
## Allocate votes for Biden according to the margin
trumpvotesAZ <- ifelse(mean(subdata$pollmargin24) > 0, 
                            unique(subdata$ev_total), 0)
trumpvotesAZ


## --------------------------------------------------------------------
## Iteration vector
states <- unique(polls24$state)

## Container vectors
polls.margin24 <- result.margin24 <- trumpvotes_pred <- trumpvotes_act <- 
  rep(NA, length(states))

names(polls.margin24) <- names(result.margin24) <- 
  names(trumpvotes_pred) <- names(trumpvotes_act)  <-as.character(unique(states))


## --------------------------------------------------------------------
## Loop
for(i in 1:length(states)){
  subdata <- subset(polls24, state == states[i] )
  subdata <- subset(subdata, daystoelection < 15 | 
                      daystoelection == min(subdata$daystoelection) )
  result.margin24[i] <- mean(subdata$resultmargin24)
  polls.margin24[i] <- mean(subdata$pollmargin24)
  trumpvotes_pred[i] <- ifelse(mean(subdata$pollmargin24) > 0, 
                            unique(subdata$ev_total), 0)
  trumpvotes_act[i] <- ifelse(mean(subdata$resultmargin24) > 0, 
                            unique(subdata$ev_total), 0)
 }
sum(trumpvotes_pred) # predicted
sum(trumpvotes_act) # predicted



## --------------------------------------------------------------------
## Subset only states without polling data for Harris
elecresults_noncomp <- subset(results2024, (! state %in% states))

## predicted EV
trumpvotes_lesscomp_pred <- ifelse(elecresults_noncomp$called2020 == "R", elecresults_noncomp$ev_total, 0) 
names(trumpvotes_lesscomp_pred) <- elecresults_noncomp$state

## actual EV
trumpvotes_lesscomp_result <- ifelse(elecresults_noncomp$called2024 == "R", elecresults_noncomp$ev_total, 0) 
names(trumpvotes_lesscomp_result) <- elecresults_noncomp$state



# predicted Trump votes from less competitive states vs. actual
sum(trumpvotes_lesscomp_pred) 
sum(trumpvotes_lesscomp_result) 


## --------------------------------------------------------------------
predictedEV <- c(trumpvotes_lesscomp_pred,trumpvotes_pred)
sum(predictedEV)
actualEV <- c(trumpvotes_lesscomp_result, trumpvotes_act)
sum(actualEV)


## --------------------------------------------------------------------
## Calculate Bias (Predicted Trump - True Trump)
predictionerror <- polls.margin24 -result.margin24 
bias <- mean(predictionerror)
bias

## Root Mean Squared Error
sqrt(mean((predictionerror)^2))


## --------------------------------------------------------------------
## Histogram of Prediction Errors to Show Bias
hist(predictionerror, 
     xlab = "Prediction Error (Predicted Trump Margin - Actual)",
     main = "Histogram of Prediction Error in Latest Polls")
abline(v=mean(predictionerror), col="red",lwd=2)
abline(v=0, col="blue", lwd=2)


## --------------------------------------------------------------------
actualwins <- ifelse(trumpvotes_act > 0, "Trump Won", "Harris Won")
predictedwins <- ifelse(trumpvotes_pred > 0, "Trump Won", "Harris Won")


## --------------------------------------------------------------------
table(predictedwins, actualwins)


## --------------------------------------------------------------------
actualwins[actualwins != predictedwins]
trumpvotes_act[actualwins != predictedwins]

