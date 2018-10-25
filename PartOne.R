#####Overview of Base R#####

#Execute line-by-line by pressing Ctrl+Enter at the end of the line
#Select multiple or partial lines and press Ctrl+Enter to execute code in selection

#Basic Arithmetic

6 * 7

12 / 3

#Sequences
1:10

#Repetition
rep(x = "Hello", times = 10)

#Variable Assignment
#See stored variables in the Environment pane of the right

y <- 6

x <- 7

y + x

y * x

#Vectors
#Think of these as columns
#Use the c() function to create a vector

Months <- c("Jan", "Feb", "Mar", "Apr", "May", "June")

HighTemps <- c(43, 47, 56, 67, 76, 85)

LowTemps <- c(25, 27, 35, 44, 54, 63)

Winter <- c(TRUE, TRUE, TRUE, FALSE, FALSE, FALSE)


#Vector Types
str(Months)
str(HighTemps)
str(LowTemps)
str(Winter)


#Vector Operations
median(HighTemps)

(HighTemps - 32) * 5/9
HighTemps_C <- (HighTemps - 32) * 5/9


#Functions
#Here we ceate a function, convert() that takes the argument x and applies a conversion formula
convert <- function(x){
  (x-32)*5/9
}

convert(LowTemps)

#We assign the results of the conversion to a new vector
LowTemps_C <- convert(LowTemps)

#Data Frame
MonthTemps <- data.frame(Months, HighTemps, LowTemps, Winter, HighTemps_C, LowTemps_C)

MonthTemps
summary(MonthTemps)

#Accessing vectors in dataframe
MonthTemps$Months

mean(MonthTemps$HighTemps)

summary(MonthTemps$LowTemps)

#Indexing dataframes

#Use "[row,column]" to index a dataframe
#Third column (Index columns by either numeric position or name)
MonthTemps[,3]
MonthTemps[,"LowTemps"]

MonthTemps[,3] == MonthTemps[,"LowTemps"]

#Second row
MonthTemps[2,]

#Second row, third column value
MonthTemps[2,3]

#Base-R Plot
plot(MonthTemps$Months, MonthTemps$HighTemps)
abline(h = mean(MonthTemps$HighTemps))
title("Average High Temperatures by Month")


#Save the dataframe as a csv
write.csv(x = MonthTemps, file = "Monthly Temperatures.csv")
