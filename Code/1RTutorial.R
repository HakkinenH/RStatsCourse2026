

#############
# VERY BASIC R TUTORIAL
# Simple operations in R
#############

#Clear your previous work. Don't worry about this line yet, it just cleans up R's temp memory! Run it if you like
rm(list=ls())

#####################THINGS R CAN DO##############################

#anything with a # mark is a comment. It is not run as code
#anything else is a code line, that can be execuated with Run (keyboard shortcut cntrl+enter)

#R can do sums, run the following lines to see answers
#answers are shown below in the console
2+2
2*5
2^8
2/4
pi*11.3


#you can 'save' values to use later.  <- means assign. Whatever is on the left is created, whatever on right is the value
#in the below example we 'create' an object called a and it was a value of 2
#note that is gets saved in your environment (see top right in RStudio). This is like a temporary memory of things that have been saved
a <- 2
print(a)
print(a+2)
#OMG it's a function. print() will print whatever is in the brackets. () brackets always refer to functions

#you can assign things other than numbers! Words have to be saved using quote marks ""
b <- "example"
print(b)
print(b+2) #this will return an error! You cannot add a number to a letter, the types do not match

#in programming objects have a class. Think of it as a data type like in statistics (numerical, categorical etc.)
#items can be numeric, characters or combined. There are others, but we will cover those later
class(b)
class(a)

#you can create lists of numbers or words (i.e. lists of numeric values and character values)
list1 <- c(0,1,6,3,7,8)
print(list1)

list2 <- c("A","B","C","D","E","F")
print(list2)

#you can combine lists into a dataframe, like a spreadsheet. 
#A dataframe has both rows and columns (two dimensions)
df1 <- data.frame(list1,list2)
colnames(df1)<-c("numFrogs","Pond")
print(df1)

#you can navigate a dataframe with subsetting. Some examples:
#select a columns with $
df1$numFrogs
#select a column with []. Square brackets always mean subset!
df1[, 1]
#select row 3, column 1
df1[3, 1]
#select row 1,2,3, column1
df1[1:3, 1]
#multiple rows 1,2,3, column1 by pi
pi * df1[1:3, 1]


#you can check values with logical checks
q <- 5

#does q equal exactly 5?
q == 5
#is q less than 5?
q < 5
#is q greater than 5?
q > 5

#the same thing can be done with characters
r <- "dog"
r == "dog"
r == "cat"

#you can search for values in a list or dataframe using logical checks
pet_list <- c("dog","dog","cat","frog","scorpion","dog","unicorn")
pet_list == "dog"
pet_list[pet_list == "dog"]


#making a fake data frame for later use
pet_list2 <- c("dog","cat","frog","scorpion","unicorn")
num2<-c(540,860,65,2,1000494)
df2 <- data.frame(pet_list2,num2)
colnames(df2)<-c("PetType","number")
df2

#I want to know what the median number of pets is!
median(df2$number)

#I want to know how many pets were owned by more than 100 people
df2[df2$number > 100, ]


#we can plot data
hist(df1$numFrogs)


#R comes with a series of inbuilt datasets, used for examples.
#the following line calls one into our current session
data(InsectSprays)
#let's look at the some few lines with head()
head(InsectSprays)
#note that in the top right, a dataframe name "InsectSprays" now appears

#with a larger dataset we can now do more complicated plots and analyses
#let's do some simple descriptive statistics
class(InsectSprays$count) # count column is numeric (count)
class(InsectSprays$spray) # count column is factor (category)
summary(InsectSprays$count)
#the median number of insects killed by a spray is 7, the mean is 9.5

#make a boxplot showing the number of insects killed per spray
#we use a formula! Count (y) as predicted by spray (x)
boxplot(count ~ spray, data = InsectSprays, col = "lightgray")
#note we did not use InsectSprays$count in the above line, just "count". 
#this is because we specifiy data=InsectSprays, then the formula looks in the specific dataframe

#this produces the same plot but is a little longer
boxplot(InsectSprays$count ~ InsectSprays$spray, col = "lightgray")

#remember: R is stupid, it needs to know the dataframe to look in, and then the column
#just stating the column name OR the dataframe is not sufficient, you need both!

