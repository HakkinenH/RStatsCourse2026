
#####################################################
# BASIC STATISTICAL TESTS
#####################################################

#This file provides some worked examples of:
  #t-tests (normal distribution response ~ 2 categories)
  #ANOVA (normal distribution response ~ >2 categories)
  #Chi-Squared (count response ~ >=2 categories)


######################################################

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

#read in your datafile
limpets<- read.table("Data/Limpets_2018.txt", header=T)
#check it loaded properly
View(limpets)





#######COMPARE TWO CATEGORIES (t-test) ################
#we want to know if limpet diameter was different between right and left sides of the beach

head(limpets)
#identify your response, what do you want to predict?
#in this case diameter (dia columns)
#check if it's normal
hist(limpets$dia)

#what are your predictors?
#these do NOT need to be normal, but it's worth checking for crazy outliers
# in this case it is left or right (rl column)

boxplot(limpets$dia ~ limpets$rl)
#SO we have a:
# -continuous normal response
# -and a categorical predictor with 2 categories.

#Which test do we use????

#well we have options! We could assume this is a normal distribution
#normal distibution -> linear model
#or we can assume this fits a Student's t-distribution
#t-distribution -> t-test


#as an example let's use a t-test
#at this point you should check the assumptions of a t-test (go and check notes)
#I think they are met so I will run a t-test
#our formula is already written as y~x (y as predicted by x)
#so we are interested in diameter as predicted by rl (left or right)
#note we don't have to use the $ here! You can if you want to (see line 44 and 45, it does the same thing)
#instead we specify the dataframe in the data= argument
modelT<-t.test(dia ~ rl, data=limpets)
modelT<-t.test(limpets$dia ~ limpets$rl)

#now check the model output What is significant?
modelT
#p<0.05 so we reject the null hypothesis
#there is a significant difference between limpets on the left and limpets on the right
#on the left the mean limpet is 44.45mm in diameter, on the right the mean limpet diameter is 27.98
#so limpets on the left are bigger!





#######Compare many categories (ANOVA) ################
#now we want to test if limpet diameter varied by site!
#identify your response, what do you want to predict (i.e. what did you measure)?
#it's diameter again!
#we know it's normal through our histogram

#what are your predictors?
#in this case it's site!
#site is a category (i.e. factor) but we recorded it using numbers, so this needs converting
#we convert the datatype (class) from integer (aka numeric) to a factor (aka categorical)
#always be sure if the data is numeric or categorical! If you're not sure then see Tutorial 1 or lecture material
class(limpets$site)
limpets$site<-as.factor(limpets$site)
class(limpets$site)

plot(limpets$dia ~ limpets$site)

#SO we have a:
# -continuous normal response
# -and a categorical predictor with multiple categories.
#Which test do we use???
#As before we have options.
#but in this case we will use a linear model with multiple categories
#AKA an ANOVA (for historical reasons this has a special name)


#an ANOVA!
#check the assumptions of an anova (go and check notes)
#run the anova!
model1<-aov(dia ~ site, data=limpets)
#model_lm<-lm(dia ~ site, data=limpets)
#note that the above do very similar things! lm gives a breakdown of site by site, which is often too much detail
#for now we will just use aov()

#CHECK MODEL FIT
plot(model1)
#we have to check that the model fits our data well so we check the residuals.
#residuals should be normal and 50% postive and 50% negative. 
#if residuals do not look like this then we may have fitted the wrong model 
#e.g. data is non-normal/non-linear but we tried to fit a linear model anyway
#See lecture material for more notes!

#now check the model itself. Does limpet diameter significantly vary amongst sites?
summary(model1)




###############SIMPLE COUNTS AT MULTIPLE SITES (CHI-SQUARED TESTS)##############


#what if we wanted to test something else?
#for example, are there more limpets at some locations than others?
#we have a second dataset recording limpets at different types of beaches
df2 <- read.delim("data/Limpet_habitat.txt", sep=",", stringsAsFactors = TRUE)
df2
#At each beach we recorded if a rockpool had any limpets in or not
#so if we measured 30 rockpools at protected beaches, we recorded 12 with limpets and 18 without

#at a glance we see the proportion of sites with limpets present is higher in protected (12/30)
#and unprotected (25/40), than beaches near industrial sites (8/30)
#BUT is this statistically significant?

#so our response is count of limpets (split into presence and absences)
#our predictor is habitat type (categorical)
#we can analyse this with a Chi distribution and a Chi-squared test

#a chi-squared test is both very simple and quite unusual
#it makes a very large assumption that our data fits a chi-squared distribution
#this is a MASSIVE assumption, but luckily nearly all count surveys (e.g. bird surveys) do actually fit this assumption
#to see why take a look at a chi-squared distribution
# Plot a chi-square distribution with 5 degrees of freedom
curve(dchisq(x, df = 5), from = 0, to = 20, 
      main = "Chi-Square Distribution (df=5)",
      ylab = "Density", xlab = "x", col = "blue", lwd = 2)
#can add some more if we like
curve(dchisq(x, df = 8), from = 0, to = 30, col = "red", add = TRUE)
curve(dchisq(x, df = 12), from = 0, to = 30, col = "green", add = TRUE)
# Add legend
legend("topright", legend=c("df=4", "df=8", "df=12"), 
       col=c("red", "blue", "green"), lwd=2)

#as you can see a chi-squared is very flexible, but assumes generally that most samples are close to 0
#for example if you sample ponds for salamanders, probably most ponds will have 0, several will have 1-2 and a few will have >2
#this basically matches the assumptions of a chi-squared
#and since the distribution is very flexible, it works in most cases
#AS LONG AS it's count data, separated by different categories.

#for very small samples, there is a similar variant called Fisher's Exact test
#which is designed specifically to be accurate for small samples

#with that theory out the way, let's actually run a chi-squared test
df2
# we want to see if number of limpets varies by habitat.
# We have presence and absence data for rockpools, so we can account for sampling effort
tab <- xtabs(count ~ presence + habitat, data = df2)
#xtabs is not a statistical function, it neatens our table in a clearer form for chi tests
tab

# Chi-squared test of independence
Xsq<-chisq.test(tab)

#this is a very simple test, but is a bit unusual
#because we have so little data we assume there is an "expected" count
#then we compare to an "observed" count
Xsq$observed   # observed counts (same as M)
Xsq$expected   # expected counts under the null
Xsq$residuals  # Pearson residuals
Xsq$stdres     # standardized residuals

#Chi squared tests in cases like this are very powerful
#we don't have to check residuals, because they are always acceptable
#so we can just look at the answer
Xsq
#so we conclude there IS a significant difference in the number of limpets across sites


#BUT we don't actually know which sites have more limpets
#so we run something known as a post-hoc test, that reveals more details
chisq.posthoc.test(t(tab), method = "bonferroni")
#a Bonferonni correction, adjusts the calculation to account for multiple testing
#this is a complex topic, but basically doing multiple tests on the same data
#increases the chances of false positives, so we have to account for it

#from this we conclude there are more limpets than expected at unprotected sites (0.02)
#as compared to protected and industrial sites
#there is no statistical difference between the number of limpets at protected and industrial sites

#63% of unprotected sites have limpets
#40% of protected sites have limpets
#27% of industrial sites have limpets

#this shows how judging by eye can be misleading, it looks like protected and industrial sites may differ
#but our test shows there is not enough evidence to conclude this
#we might need more sampling to find a difference (i.e. go out into the rockpools and count more limpets)



##############################################################
### EXERCISE TIME!
##############################################################

#the following is a dataset of mite diversity in moss habitats in different conditions
#we want to focus on one aspect of this. Does moss coverage change across our three sites (representing an elevational gradiant)
#prcnt_area is ground cover of sampling area covered by moss (i.e. our response variable)
#ElSite is site number, 1 being the lowest, and 3 being the highest in altitude

#your task is to find out if moss coverage significantly changes across our three sites
#use the code throughout the rest of the file to help you

#answer each question and fill in the code
#I have provided some lines as hints for you

#read in the file:
m1<-read.csv("Data/clutch.csv")
head(m1)

#define your statistical model,
#Q: What is your response variable, what data type is it?
#

#Q: What is your predictor variable, what data type is it?
#

#Q: Check the classes of these variables in R, are they correct? If not, then change them to correct type
#HINT: remember continuous data is listed as "numeric" or "integer" in R. Non-ordered categorical variables are "factor"
class(m1$ElSite)
class(m1$prcnt_area)


#make a quick plot of you model data, can you see any differences just by eye?
boxplot(prcnt_area~ElSite, data=s1)


#Q: check the distribution of your response variable with a histogram. What distribution does it look like?
#

#Q: What test would be appropriate to run here?
#

#Q: Design and run the model. Are there significant differences between different sites?


#Q: Check residuals of the model, does it look like it is performing well?


#Q: Write a sentence describing your results, as you would for a technical report or a scientific journal
#



