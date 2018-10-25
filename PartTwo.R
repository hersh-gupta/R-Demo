#####Tidyverse Introduction####
#The tidyverse is a set of inter-operational packages that use a similar syntax
#Uses pipe operator to '%>%' to pass objects to functions


#####Install Packages####
#Only needed to be done once
#Packages are stored in installation directory
install.packages("tidyverse")
install.packages("tidymodels")

#####Load Packages####
library(tidyverse)
library(tidymodels)

#####dplyr#####
#Main dplyr verbs: select, filter, mutate, group_by, summarize, arrange
#Pipe in the results of one verb to another

#These are the same:
MonthTemps %>%
  filter(Winter == TRUE)

filter(MonthTemps, Winter == TRUE)

#What is are the average temperature for the winter months vs the non-winter months?
MonthTemps %>% #Start with the dataframe, pipe it into the following
  select(1:4) %>% #Select columns/variables you want 
  group_by(Winter) %>% #Group by the Winter variable
  summarize(Avg_Low = mean(LowTemps),
            Avg_High = mean(HighTemps)) #Calculate the averages using mean()


#####ggplot#####
#Highly customizeable plotting package
#Call ggplot(data, aes(x,y)) + geom_{}
#Uses '+' rather than '%>%', but works the same way

ggplot(data = MonthTemps, aes(x = Months, y = HighTemps)) +
  geom_point()

ggplot(data = MonthTemps, aes(x = reorder(Months, HighTemps), y = HighTemps)) +
  geom_point() +
  labs(title = "High Temperatures over Time", x = "Months", y = "Temperatures (deg F)") +
  theme_minimal()

#####Real Example####

#Load data
countries <- read_csv("Countries.csv")

#What does the data look like?
View(countries)
glimpse(countries)

#Create a plot of the GDP Per Capita and Life Expectancy
ggplot(countries, aes(gdpPercap, lifeExp)) + 
  geom_point() 

#Make a cleaner plot
ggplot(countries, aes(gdpPercap, lifeExp)) + 
  geom_point(alpha = 0.3) + #alpha sets the opacity of each point
  scale_x_log10(labels = scales::dollar) + #use log-scale on x axis, and format it to dollars
  geom_smooth(method = "lm") + #line of best fit using a linear model (lm)
  labs(x = "GDP Per Capita", y = "Life Expectancy in Years",
       title = "Economic Growth and Life Expectancy",
       subtitle = "Data points are country-years",
       caption = "Source: Gapminder.") #add plot labels

#####Modeling in R#####
#Use the lm() function to create a model
#The formula is specified by y ~ x: "Y is modeled by X"

model <- lm(formula = lifeExp ~ log(gdpPercap) + pop, data = countries)

#Get the model results
summary(model) #Full summary of model
tidy(model) #Model coefficient summary metrics
glance(model) #Model fit metrics
augment(model) #Observation-level metrics

#Plot model coefficients
tidy(model, conf.int = T) %>%
  ggplot(aes(x = term, y = estimate, ymin = conf.low, ymax = conf.high)) + 
    geom_pointrange() + 
    coord_flip() 

#Plot model residuals vs fitted
augment(model) %>%
  ggplot(aes(x = .fitted, y = .resid)) + 
  geom_point()
