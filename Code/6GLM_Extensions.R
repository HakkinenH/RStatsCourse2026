
#############
# GENERALISED LINEAR MODEL (extensions)
# data transformations, quadratics and interactions
#############


#Clear your previous work
rm(list=ls())


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

#############
### LOAD AND EXPLORE DATA
#############


#read in data
gala<-read.csv("data/gala.csv")

#we are interested in how area predicts species diversity, what is the relationship?
plot(gala$Area, gala$Species)
#obviously non-linear! This cannot be modelled easily, due to the high outliers

#from previous experience, I know that the logArea is more likely to linearly correlate with diversity
#I will attempt a transformation to see if it makes the data more linear
#what does that look like?
gala$logarea<-log10(gala$Area)
plot(gala$logarea, gala$Species)
#still not linear! An obvious curve

#check distribution of response data
hist(gala$Species, breaks=20)
#not normally distributed. this looks like a curve

#what do we do with this? Well we have a lot of choices
#based on our quick transformation above, I think transformation is the wrong choice

#but let's look at a quick example where a data transformation can help!

#############
### Data transformations
#############


#sometimes data does not fit a distribution neatly
df1<-read.csv("Data/Succession.txt")
plot(df1$days, df1$population)

#this data is clearly curved, and has issues with heteroskedascity (uneven variance). 
#If we fit a linear regression to it then we will have issues
model_raw <- lm(population ~ days, data = df1)
summary(model_raw)
plot(df1$days, df1$population, pch = 19)
abline(model_raw, col = "red", lwd = 2)

#Our residuals look ok, but I think there are issues here with even variance across our predictor
plot(model_raw)

#How do we fix this? We actually have lots of options:
#we could pick a different distribution
#we could add a quadratic term to fit a curve (see below)
#OR we could transform the data.

#we are going to do the last one. This is quick and easy
#common transformations include log(), log10(), sqrt()
df1$log_population <- log10(df1$population)

#let's build a model with logged data
model_log <- lm(log_population ~ days, data = df1)

#plot data
plot(df1$days, df1$log_population, pch = 19)
abline(model_log, col = "blue", lwd = 2)
#this looks a lot more sensible, data are less curved, line goes right through the middle

#when looking at the model summary, remember this is Logged response data
summary(model_log)


# Plots for comparison
par(mfrow = c(1, 2))
plot(df1$days, df1$population, pch = 19, main = "Raw Data")
abline(model_raw, col = "red", lwd = 2)

plot(df1$days, df1$log_population, pch = 19, main = "Log-Transformed Response")
abline(model_log, col = "blue", lwd = 2)
par(mfrow = c(1, 1))


#############
### Quadratics
#############

#let's go back to our gala data
plot(gala$Area, gala$Species)
#we know this is not going to work in a linear model
#and our logged approach didn't work much better
plot(gala$logarea, gala$Species)
#so what can we do now?

#in this case we have multiple options
#but one option is to use a quadratic, and other polynomials
#this allows us to account for curves in the data

#example: a linear relationship
x<-1:20
y<-4+0.5*x
plot(x,y)

#example: a quadratic relationship
x<-1:20
y<-4+0.5*x+1.4*(x^2)
plot(x,y)

#in this equation we have a linear x term and a quadratic x term

#if we want to model this, one way is to explictly include a squared term in the model
gala$logarea.squared <- gala$logarea^2
lm.poly <- lm(Species ~ logarea + logarea.squared, data = gala)
plot(lm.poly) #acceptable
summary(lm.poly)

#we now have a parameter for both logarea and logarea squared

#but a better option would be to use the poly() function
#this is better practice as we can use it to make more complicated polynomials in future (e.g. cubed)
lm.poly1.raw <- lm(Species ~ poly(logarea, 2, raw = TRUE), data = gala)
plot(lm.poly1.raw)
#residuals are not great, but we will carry on for now
summary(lm.poly1.raw)

#what do we conclude?
#both the linear and the quadratic term are significant, evidence the model should be curved

#we can compare to a strictly linear model and see if it is the same or worse than our quadratic
lm.raw <- lm(Species ~ logarea, data = gala)
AIC(lm.raw, lm.poly1.raw)
#we cover model comparisons later, but in short AIC judges model performance. The lower the better
#an alternative way to compare models is an ANOVA! Do they perform significantly differently?
anova(lm.raw, lm.poly1.raw)
#polynomial model is definitely better


#let's make a plot to see the relationship
ggplot(gala, aes(x=logarea, y=Species)) + geom_point(size=3)+
  geom_smooth(method="lm", formula=y~poly(x,2), se=TRUE)  
#looks pretty good! It fits the data well!

#we can compare to the linear model
ggplot(gala, aes(x=logarea, y=Species)) + geom_point(size=3)+
  geom_smooth(method="lm", formula=y~x, se=TRUE)  

#SIDE NOTE: choosing a non-linear approach
#there are many ways to model non-linear data in GLMs.
#you can use non-linear distributions, quadratics, splines, cubic splines, GAMs, or Segmented and piecewise regression
#all of these are good approaches, and which one you want to use is up to you. In many cases they will give the same answer
#just from a different angle!
#if in doubt, go for a simpler approach, and preferably one you understand
#my go-to order if I think something is nonlinear is:
# 1) quadratics and polynomials
#if that doesn't work: 2) non-linear distributions
#if that doesn't work: 3) GAMs
#if that doesn't work: 4) splines and piecewise regression
#if that doesn't work: 5) whatever funky non-parametric test I can get to work
#if that doesn't work: ???) [this has so far never happened, but I would assume the data are cursed]




#############
### Interactions
#############

#the following dataset is from  Zuur et al. (2009) 
#containing abundances of ∼ 75 invertebrate species measured on various beaches along the Dutch Coast. 
#The data were originally published in GM Janssen & Mulder (2004) and Gerard Janssen & Mulder (2005).

#Richness = species richness (i.e., the number of species counted).
#NAP = height of the sample site (relative to sea level). Lower values indicate sites closer to or further below sea level, which implies more time spent submerged.
#Beach = a unique identifier for the specific beach where the observation occurred

RIKZdat<-read.csv("data/RIKZdat.csv")
head(RIKZdat)
#week should be categorical not numerical, we will force it to be interpreted as such
RIKZdat$week<-as.factor(RIKZdat$week)

#look at the data
plot(RIKZdat$week, RIKZdat$Richness)
plot(RIKZdat$NAP, RIKZdat$Richness)

#check response variable
hist(RIKZdat$Richness)
#non-normal data, possible that a normal distribution will be a bad fit
#BUT, the relationship between NAP and Richness is clearly linear
#maybe we should try it anyway?

#we are interested in if the week and the height of the site explains diversity
#we will start with a normal linear model
lm1 <- lm(Richness ~ NAP + week, data = RIKZdat)
plot(lm1)
#model fits badly! The q-q plot is messed up
#why? 
#let's look at residuals
ggplot(fortify(lm1)) + 
  geom_point(aes(x = .fitted, y = .resid, col = week)) +
  geom_hline(yintercept = 0)+theme_bw() +  scale_colour_colorblind()
#we can see what's happening here, nearly all the large residuals are from week 1
#and the other weeks look like they are grouped in separate areas
#this indicates there might be an interaction
summary(lm1)

#what do our model without an interaction look like?
# add the fitted values to our RIZK data
RIKZdat$predy <- predict(lm1)


# plot using ggplot
ggplot(data = RIKZdat,
       aes(x = NAP, y = Richness, color = week)) +
  geom_point() + geom_line(aes(y = predy)) +
  scale_colour_colorblind()
#confirms what we saw in the residuals, the model fits weeks 2 and 3 ok, but the other weeks are poor
#what does it mean if the effect of NAP varies by week? That is the definition of an interaction

#let's add an interaction
lmfit.inter <- lm(Richness ~ NAP * week, data = RIKZdat)
#Richness ~ NAP * week is equivalent to Richness ~ NAP + week +NAP:weekm but simplified
#always include a linear effect AND an interaction!

plot(lmfit.inter)
#residuals are still poor
#at this point I would probably look at GLM options, but let's plot it just to see what happens

#plot interaction
#simple way
interact_plot(lmfit.inter, pred = NAP, modx = week, plot.points = TRUE)
#more in depth way
ggplot(fortify(lmfit.inter), aes(NAP, Richness, col = week))+
  geom_line(aes(NAP, .fitted, col = week)) + geom_point() +
  scale_colour_colorblind()



#we see now the lines vary by week, so an interaction has been retained in the model
#what does this mean?
summary(lmfit.inter)

#NAP:week4 has a significant interaction
#we should interpret this with caution as there 5 data points in week 5
table(RIKZdat$week)

#but let's see if can make sense of this output
#week 1 is the baseline
#at NAP=0, richness will be 11.41. For every unit of NAP, richness decreases by -1.90
#at at NAP =1.2 in week 1, we would expect richness = 11.40561 + (-1.90016 * 1.2) = 9.13

#so what about for week 4?
#at NAP = 1.2 in week 4 we would expect:
# richness = 11.40561 + [cat effect of week 4] + [lin effect of NAP]*x + [interactive effect of NAP:week4]*x
# richness = 11.40561 + 1.37721 +(-1.90016*1.2) + (-7.00002*1.2)
# richness = 2.10

#after looking at the models, I might suspect we need a curve in the data
#I could try a quadratic (or other polynomial)
#but given it's count data I will try a negative binomial and see how it looks
nbfit.inter <- MASS::glm.nb(Richness ~ NAP * week, data = RIKZdat)
#you may get an error saying the iteration limit reached
#this can happens if our data doesn't really conform to a NB, it may be closer to Poisson or underdispersion
#for now we will ignore, the residuals will tell us if there's an issue in model fit anyway

#check residuals!
plot(nbfit.inter)
#looks a bit problematic so far, let's look at some other plots
residualPlot(nbfit.inter, main = "Negative Binomial model")
residualPlots(nbfit.inter, plot = T)
simulateResiduals(nbfit.inter, plot = TRUE)
#some issues but a lot better!

summary(nbfit.inter)

#as a general rule we should only build a plot for the ranges of the data
#this is different depending on each week!
#so we build our predictions based on the NAP range of each week
newdatw1 <- data.frame(NAP = seq(-1.4, 1.2, length = 500), week = 1)
newdatw2 <- data.frame(NAP = seq(-1, 1.8, length = 500), week = 2)
newdatw3 <- data.frame(NAP = seq(-1, 2.3, length = 500), week = 3)
newdatw4 <- data.frame(NAP = seq(-0.6, 1.65, length = 500), week = 4)

newdat<-rbind(newdatw1, newdatw2, newdatw3, newdatw4)

newdat$week<-as.factor(newdat$week)
dy <- predict(nbfit.inter, type = "resp", se.fit = T,newdata = newdat)


# Combine and plot
newdat <- cbind(newdat, dy = dy$fit)

ggplot(newdat, aes(NAP, dy, col=week)) + geom_line() +
  geom_point(data=RIKZdat, aes(NAP, Richness, col=week))+
  xlab("NAP") + ylab("Richness")
#the trend for week 4 looks dodgy based on our knowledge of ecology, but it fits the data well!

#what works better in terms of AIC?
AIC(nbfit.inter, lmfit.inter)
#NB model is much better!


#what conclusions can we draw?
#I would say there is generally a negative effect of NAP on Richness
#BUT we should be very cautious about the week and interaction effect
#why? because our sample size per week is very low
#we might have just fit a model that explains noise in the data.
#despite the p values and model fit, I would conclude it is more likely we have just seen random variation
#across weeks, it's probably not systemic

#this is a good example of where adding a load of complexity gives a "statistically" good model
#but doesn't make a lot of ecological sense. And always favour your common sense!



##############################################################
### EXERCISE Quadratics and Interactions!
##############################################################



states<-read.csv("data/deerPredation2.csv")
head(states)
#population is the total size of a deer population across US national parks
#birthrate is the averagte per capita breeding rate per breeding season
#prediationrate is the average predation rate per breeding season
#precipitation is total rainfall across breeding season (mm)


#we expect there to be an interaction between predation and birth rate
#predation may have a bigger impact if the birth rate is low!

#in addition, with a basic plot you might see evidence of a non-linear effect between precipitation and population
#you could transform this to make it linear OR you could add a quadratic function to the linear model!


##TASK: build a GLM to investigate how birth rate, predation and precipitation affect deer population size
#investigate if an interaction is needed between predation rate and birthrate
#investigate if a polynomial is needed for precipitation


#Remember the steps to follow
# What are your goals? To describe? To predict? To explain? What do you expect to find?
# Look at your data, what type is it? Categorical? Continuous? Binomial?
# What distribution does your data have? 
# Pick a model (or make a shortlist)
# What assumptions does the chosen model have? Does your data meet them?
# Run the model
# Check the model fits properly

# Make conclusions on what the model tells you. What is significant, what is not? What are the effect sizes?
# Make at least one output plot showing what you think is the most interesting conclusion




