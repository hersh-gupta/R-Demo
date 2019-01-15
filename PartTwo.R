#####Tidyverse Demo####
#The tidyverse is a set of inter-operational packages that use a similar syntax

#####Install Packages####
#Only needed to be done once
#Packages are stored in installation directory, separate from the project directory
install.packages("tidyverse")
install.packages("jsonlite")
install.packages("scales")

#####Load Packages####
#Specific packages contain specific functions
#Must be loaded everytime
library(tidyverse)
library(jsonlite)
library(scales)

#####Download and Inspect Data####
#Data on Crime Incidents in the Last 30 Days from DC Open Data Portal

#Import from DC Opendata Portal API
#Use fromJSON(“url”) function to convert and convert json file to list
#Save as data_json
data_json <- fromJSON("https://opendata.arcgis.com/datasets/dc3289eab3d2400ea49c154863312434_8.geojson")

#Extract only the properties dataset - we don't need geometries 
incidents <- data_json$features$properties

#Alternatively you can import dataset from csv file
incidents <- read_csv("CrimeIncidents_30days.csv")

#Look at datatypes and open dataset in viewer
glimpse(incidents)
View(incidents)

#####Data Manipulation with the TidyVerse####

#####dplyr#####
#Main dplyr verbs: filter, arrange, mutate, select, group_by, summarize

filter(incidents, SHIFT == "DAY")  #Take the dataset, and return rows where SHIFT column is (==) "DAY"

arrange(incidents, WARD) #Sort the dataset by WARD in decreasing order

mutate(incidents, Date = as.Date(REPORT_DAT)) #Convert the character column to date format

select(incidents, OFFENSE, WARD) #Return only the OFFENSE and WARD columns

#Pipes %>%: pipe in the results of one function to another

#These are the same
filter(incidents, SHIFT == "DAY")  

incidents %>%
  filter( SHIFT == "DAY")  

#Chain together as many pipes as you want
#Can you figure out what’s happening here?
incidents %>%
  mutate(incidents, Date = as.Date(REPORT_DAT))  %>%
  arrange(incidents, Date) 

#Convert the character column to date format
incidents %>%
  mutate(Date = as.Date(REPORT_DAT)) 

#Return only the OFFENSE and WARD columns
incidents %>%
  select(OFFENSE, WARD) 

#How many of each offense? n() gives you the number of rows
incidents %>%
  group_by(OFFENSE) %>%
  summarize(count = n())

#What about the proportion each offense?
incidents %>%
  group_by(OFFENSE) %>%
  summarize(count = n()) %>%
  mutate(prop = count/sum(count))


#What if you wanted the proportion and percentage of each offense as separate columns?
#Proportion and percentage each offense
incidents %>%
  group_by(OFFENSE) %>%
  summarize(count = n()) %>%
  mutate(prop = count/sum(count), pct = prop*100)


#Are certain offense more likely to occur at different shifts (day, evening, midnight)?
#What would we need to answer this?

#Rate of each offense by shift
incidents %>%
  group_by(SHIFT, OFFENSE) %>%
  summarize(n = n()) %>%
  group_by(SHIFT) %>%
  mutate(pct = n/sum(n))

#Save this result as a separate dataframe using the <- operator
incidents_summary <- incidents %>%
  group_by(SHIFT, OFFENSE) %>%
  summarize(n = n()) %>%
  group_by(SHIFT) %>%
  mutate(pct = n / sum(n))


#How can we visualize this data?
incidents_summary 

#ggplot package is used for plotting
ggplot(incidents_summary, aes(SHIFT, pct, fill = OFFENSE)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = scales::percent(pct)), position = position_stack(vjust = 0.5)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Crime Incidents by Shift and Offense Category",  
       subtitle = "in the last 30 days",  y = "",  x = "Shift") +
  theme_minimal()

#Are certain offense more likely to occur at different shifts (day, evening, midnight)?
#Is there a statistically significant relationship between shifts and offenses?
#What’s the strength of the relationship between shifts and offenses?

#Chi-square test is built into R
chisq.test(incidents$SHIFT, incidents$OFFENSE, simulate.p.value = T)

#Package for additional statistical tests
require("vcd")

vcd::assocstats(table(incidents$OFFENSE, incidents$SHIFT))




