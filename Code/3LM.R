

#####################################################
# LINEAR MODELS
#####################################################

#This file provides a worked examples of:
  #Linear Regression (normal distribution response ~ continuous)
  #More complex linear regression example with plots and multiple variables

#it also has some notes on:
  #Non-parametric tests
  #testing for normality
  #Standardised variables


######################################################

#Clear your previous work
rm(list=ls())

if(!require("rstudioapi")) install.packages("rstudioapi")
#set your working directory
#I'm lazy so I autodetect where this file is and set it one level higher
#if this fails for any reason, set setwd manually to the folder path
curpath<-dirname(rstudioapi::getSourceEditorContext()$path)
curpath
setwd(curpath)
#go up a level out of the code folder for neatness
setwd("../")

#load packages
source("./code/0Packages.R")

#read in your datafile
limpets<- read.table("Data/Limpets_2018.txt", header=T)
#check it loaded properly
View(limpets)



#we want to check if limpet diameter correlates with the size of their nearest neighbour
#our basic formula is dia~nndia (names taken from df)
#our response variable:
hist(limpets$dia)
#continous and approximately normal

#our predictor variable:
hist(limpets$nndia)
#continuous, and skewed. Distribution doesn't normally matter in predictor variables
#just needs to not have massive outliers!

#we have a [continuous (normal) ~ continuous] structure
#the appropriate test is a linear regression


################### CONTINUOUS RESPONSE AND PREDICTOR (LINEAR REGRESSION) ############################################


#does the size of a limpet's neighbour affect the size of the focal limpet?
plot(limpets$nndia, limpets$dia, xlab="Nearest Limpet Diameter (mm)", ylab="Focal Limpet Diameter (mm)")

#this plot is a bit messy so I'm going to make a neater one!
#in R there are two major ways of creating plots: the base approach and through ggplot
#ggplot is a lot prettier but also very fiddly! 
ggplot(limpets, aes(nndia, dia)) +
  geom_point() +
  xlab("Nearest Limpet Diameter (mm)") +
  ylab("Focal Limpet Diameter (mm)") +
  theme_bw()



#We think diameter of neightbour may correlate, so let's test it with a linear regression!
#a correlation test would also be acceptable if we don't think there's a causative link (i.e. x does not cause y)

#run lm
model2<-lm(dia~nndia, data=limpets)

#put four plots in the same window
par(mfrow=c(2,2))
#check the model
plot(model2)
#do residuals look ok?
#residuals can tell you a lot of info about your model.
#In effect you are fitting a line of best fit to your data, but no line is perfect
#residuals represent how far your data points are from your line of best fit
#points will either be above your line (positive) or below (negative)
#you want your line to go straight through the middle of your data so plot your residuals to find this out
#I recommend doing some reading on this, but bottom line is 
#top left plot should be symmetrical around 0 (50% positive residualand 50% negative)
#top right plot should lie approximately on the diagonal line
#if your residuals look ok your model probably fits quite well!

#reset back to only one plot in the same window
par(mfrow=c(1,1))

#check output
summary(model2)

#what can we conclude?
#nndia has a significant relationship with dia (p<2.2e-16 which is 0.000000000000000022). P value is less than 0.05 so we reject the null
#equation of our straight line is dia= 29.95 + 0.28*nndia
#intercept is 29.95 (when nndia is 0, dia is 29.95)
#slope of the relationship is 0.288. So for every 1mm nndia increases, dia increases by 0.288
#R-squared is 0.058, which is very small. 
#A R-squared of 1 would mean all points lie on the line of best fit
#A R-squared of 0 means all points are miles away from the line of best fit
#From this we conclude that as neighbouring limpet diameter increases the diameter of the focal limpet also increases
#however this relationship is quite weak, even though it is significant.

#make a new and improved plot
plot(limpets$nndia, limpets$dia,
     col="blue", cex=0.6,
     xlab="Neighbour Diameter (mm)",
     ylab="Focal Limpet Diameter (mm)")
abline(model2)



################### A MORE COMPLEX LINEAR REGRESSION EXAMPLE ############################################

#the above example looked at a single predictor
#but linear models can look at a lot more than that!
#we can look at multiple effects at once, and how they may interact

#As a more complex example, we will look at the Sky Whale data


### LOAD AND EXPLORE DATA
df1<-read.delim("Data/SkyWhales_2024.txt", sep=" ")

#check data has loaded properly
# View(df1)
head(df1) #does this look as we expect?
dim(df1) #dimensions of data

#check summary, what is numeric, what is categorical? Any count data?
summary(df1)
#spotted an issue: site should be categorical (i.e. factor)
df1$site<-as.factor(df1$site)

#plot an example set of possibly correlated variables
#do sky whales get larger linearly as they age?
ggplot(df1, aes(age, length_m)) +
  geom_point() +
  xlab("Estimated age (years)") +
  ylab("Whale length (m)")
#some signs of positive correlation, but a lot of variability in the data

ggplot(df1, aes(magic_thaums, length_m)) +
  geom_point() +
  ylim(0,90)+
  xlab("Ambiant Magic (thaums)") +
  ylab("Whale length (m)")
#much stronger correlation by the looks of things

#1) DESIGN OUR MODEL
#check the distribution of the reponse variables
hist(df1$length_m)
#nearly normal!
#so we will use a model based around a normal distribution

#what are our predictive variables and what type of data are they?: 
# age (continuous), magic_thaums (continuous), location (categorical)
#so our full model will be:
#length_m ~ age+magic_thaums+location


### 2) DO PREDICTORS CORRELATE?
#this is a new step we haven't worried about before
#when you have multiple predictors, we have to check they don't correlate too much
#if they do then the model cannot distinguish what is causing the correlation
#check with a spearman correlation
cor(df1$age, df1$magic_thaums) #low, >0.5 is a warning, >0.7 is a big problem, this is fine!
#checking for lack of cross factoring with categorical is tricky, but boxplot is a useful way to check, should ideally be overlapping to some degree
boxplot(df1$age~df1$location)
boxplot(df1$magic_thaums~df1$location)
#all looks good to me


### 3) RUN THE MODEL
#our full model is Whale Length ~ age + environmental background magic + location
#I have chosen to use unscaled variables here but we could always change this later
lm1 <- lm(length_m ~ age+magic_thaums+location, data = df1)


### 4) RESIDUAL CHECKS
#check the model fit and residuals!
par(mfrow=c(2,2)); plot(lm1)

#they look good! But to be sure, we can have a look at some more diagnostics
par(mfrow=c(1,1)); 
car::qqPlot(lm1, id=FALSE)
#definitely a good fit! The residuals nearly all fall within an expected random distribution (blue shading)

#there are many ways to visualise residuals and other diagnostics of model fit
#they all show the same thing but in different ways
resid_panel(lm1)
# to create the multi-panel plot
dplots <- sjPlot::plot_model(lm1, type="diag")
((dplots[[1]] + dplots[[2]])/ dplots[[3]]) 

#and yet another way!
check_model(lm1, check = c("linearity", "homogeneity", "qq", "normality"))
#a minor issue with normality of residuals, but not substantial

### 5) MODEL OUTPUT
#I say the model passes! A good set of normally distributed residuals with no major issues

summary(lm1)

#so for every year of age, length increases by 0.02. However, this is not significant so we discard that conclusion!
#and for every thaum of magic, length increases by 0.06, this is a significant trend p<0.001
#there is no significant difference in length between E and W locations (p=0.68)

#in addition we can generate confidence intervals around our parameters
#in frequentist statistics we draw from a "sampling distribution" to estimate how confident we can be
#this is dependent on the sample size, the degrees of freedom, and a number of other factors
#in practical terms it states that we can be 95% confidence our "true" parameter estimates list within these two figures
confint(lm1)
#note that while the lower and upper founds are very similar for magic, they are larger for age, and very large for location!

#####
#EXTENSION: PLOTTING
#We have previously looked at line of best fit
#this is great, but sometimes we want to add confidence intervals or Standard Error markers
#to show uncertainty around our findings.

#this is more complicated in R, but if you're interested here is an example:

#we can make predictions to tell us what to expect (on average)
#if we found a whale and we know its age and location, but not its length, could we predict it?
newdata <- data.frame(age = 60, magic_thaums=462, location =c("E", "W"))
predict(lm1, newdata, interval = "prediction", level = 0.95)

#interpretation: a 60y old whale at a 462 background Thaum in Site E would be 45.05m in length on average
#a 60y old whale at a 462 background Thaum in Site W would be 44.62m in length on average


#let's make some general predictions and plot them!
predage=seq(min(df1$age), max(df1$age), length=100)
predmag=seq(min(df1$magic_thaums), max(df1$magic_thaums), length=100)
predloc=c("W", "E")



#we create a dataframe where age and location are held constant, but magic varies
#this is a simple way to build a line of best fit for complex models
#for simplicity, we will only plot for location W
newdata1 <- data.frame(age = median(df1$age), magic_thaums=predmag, location="W")
head(newdata1)
#this is a dataframe with "theoretical" data at fixed intervals, we use this to build a line of best fit

#then we build predictions using the predict() function
predict.mean <- cbind(newdata1, predict(lm1, newdata1, interval = "confidence"))
predict.ind <- cbind(newdata1, predict(lm1, newdata1, interval = "prediction"))


#plot correlation between age and whale length, including confidence and prediction intervals
# red is confidence intervals, black is prediction interval
ggplot(df1, aes(magic_thaums, length_m)) +geom_point() + 
  geom_line(data=predict.mean, aes(magic_thaums, lwr), color="red", linetype = "dashed") +
  geom_line(data=predict.mean, aes(magic_thaums, upr), color="red", linetype = "dashed") +
  geom_line(data=predict.ind, aes(magic_thaums, lwr), color="black", linetype = "dashed") +
  geom_line(data=predict.ind, aes(magic_thaums, upr), color="black", linetype = "dashed") +
  geom_line(data = predict.mean, aes(magic_thaums, fit)) +
  xlab("Ambiant Magic Concentration (thaums)") + ylab("Length (m)")

#SIDE NOTE: prediction and confidence intervals are different concepts
#confidence intervals: how confident are we that the true mean lies within this margin?
#on our plot, the mean is 95% likely to be within the red lines for any given value of magic

#prediction intervals: if we picked a random individual how confident are we that they would fall within this margin?
#if we picked an invidual at magic x, we are 95% certain its length would be between the black lines.

#they have different applications, in general confidence intervals are more useful for model interpretation.





#######HOW TO TELL IF DATA ARE NORMAL##################
#in our previous example we used a histogram and judged by eye. It looks pretty normally distributed!
#with large sample sizes this is fine

#with smaller sample (n<50) we might need to check more formally
#let's create an example dataset which is much smaller
#these are random, so they might not be representative of the whole population
smallset<-sample(limpets$dia,size=30)
#can you work out what this is doing?


hist(smallset,breaks=15)

#is this normal? run a shapiro wilks test
shapiro.test(smallset)

#The null hypothesis is that the data is normal.
#so if you find a significant result it means the data is NON-NORMAL


#a shapiro wilks test is not very good with large sample sizes so only use with small!

#an alternative test is the K-S test (Kolmogorov-Smirnov test)
#which also has limitations!

#generally I recommend using your eyes! (and residual tests)


##########NORMALISING PARAMETERS########
##########AKA STANDARDISING PARAMETERS ##########
############ AKA the magic z-scores ############

#sometimes we are interested more than one predictor
model4<-lm(dia ~ nndia + salinity, data=limpets)
par(mfrow=c(2,2));plot(model4);par(mfrow=c(1,1))
summary(model4)

#What can we interpret from the model?
#both salinity and nndia signficantly affect dia (salinity p-value = < 2e-16; nndia p-value = 2.45e-12)
#nndia has a positive effect on dia (slope = 0.110291), and salinity has a positive effect (slope =0.059307)

#so which one is more important? i.e. has a greater effect?
#nndia is measured in mm and salinity is measured in pph
range(limpets$nndia)
range(limpets$salinity)

#one is in the range of tens, and the other in hundreds!
#both are significant but for every 1 that salinity increases, dia increases by 0.05
#and for every 1 that nndia increases, dia increases by 0.11
#nndia has the bigger number, but does it have a bigger effect?
#really hard to tell, because units are not comparable! is a 0.1 increase in nndia more important than a 10-fold increase in salinity?

#one solution is to standarise and use z-scores

limpets$salinity_z<- (limpets$salinity - mean(limpets$salinity)) / sd(limpets$salinity)
limpets$nndia_z<- (limpets$nndia - mean(limpets$nndia)) / sd(limpets$nndia)

hist(limpets$salinity_z)
hist(limpets$nndia_z)
#everything is now standardised, the mean is 0 and the units are now standard deviations
#so if a sample has a salinity_z score of 2, that means it is two standard deviations above the mean
#and if a sample has a nndia_z score of -1 it means it is one standard deviation below the mean
#the original units are lost, but now everything is on the same scale and can be compared on a level playing field

model5<-lm(dia ~ nndia_z + salinity_z, data=limpets)
summary(model5)

#because the units are not comparable we can compare relative effect sizes
#as shorthand we can say which of the significant variables has more larger effect on our response 
#looking at the results salinity is clearly more important! 
#for every one SD that salinity increases, dia increases by 9.9176



##############################################################
### EXERCISE LM!
##############################################################

#this is a dataset of wild birds (of a single species) confiscated from an illegal live market
#we are interested in what sets the market value of these birds

bdm<-read.csv("data/BirdMarket_lm.csv")
head(bdm)
#weight: weight of birds in grammes
#primary length: length of primary feather (prized in decorations) in cm
#colour: colour intensity as an ordinal scale, 1 is the brightest plumage, 8 is the dullest
#value: quoted price of bird on market ($)

#TASK: build a linear model, investigating what are possible drivers of bird value sold illegally


#Remember the steps to follow
# What are your goals? To describe? To predict? To explain? What do you expect to find?
# Look at your data, what type is it? Categorical? Continuous? Binomial?
# What distribution does your data have? 
# Pick a model (or make a shortlist) (SPOILER: it's a linear model)
# What assumptions does the chosen model have? Does your data meet them?
# Run the model
# Check the model fits properly
# Make conclusions on what the model tells you. What is significant, what is not? What are the effect sizes?
# Make at least one output plot showing what you think is the most interesting conclusion
