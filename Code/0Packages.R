

#this file installs and checks all packages needed for this repo
#run this file first if this is your first time using any of these files!

#############
# INSTALLS AND DEPENDENCIES
#############


#run this file to install all the packages you need
if(!require("chisq.posthoc.test")) install.packages("chisq.posthoc.test")
if(!require("ggplot2")) install.packages("ggplot2")
if(!require("ggResidpanel")) install.packages("ggResidpanel")
if(!require("patchwork")) install.packages("patchwork")
if(!require("sjPlot")) install.packages("sjPlot")
if(!require("performance")) install.packages("performance")
if(!require("see")) install.packages("see")
if(!require("boot")) install.packages("boot")
if(!require("car")) install.packages("car")
if(!require("DHARMa")) install.packages("DHARMa")
if(!require("lme4")) install.packages("lme4")
if(!require("ggeffects")) install.packages("ggeffects")
if(!require("gratia")) install.packages("gratia")
if(!require("ggthemes")) install.packages("ggthemes")
if(!require("abe")) install.packages("abe")
if(!require("MuMIn")) install.packages("MuMIn")
if(!require("glmnet")) install.packages("glmnet")
if(!require("glmm")) install.packages("glmm")
if(!require("MASS")) install.packages("MASS")
if(!require("nlme")) install.packages("nlme")
if(!require("interactions")) install.packages("interactions")
if(!require("mgcv")) install.packages("mgcv")
if(!require("sp")) install.packages("sp")


### FOR THOSE INTERESTED IN BAYESIAN STATS:
#NOTE: the following are only necessary if you want to run the Bayesian JAGs example script
#these are more involved and may require admin rights!
#only run if you want to work through the Bayesian examples
#load (or install) packages required
if(!require("mcmcplots")) install.packages("mcmcplots")
if(!require("MCMCvis")) install.packages("MCMCvis")



#now check they all load
library(chisq.posthoc.test)
library(abe) 
library(MuMIn)
library(glmnet)
library(lme4)
library(glmm)
library(MASS)
library(nlme)
library(ggResidpanel)
library(patchwork) 
library(sjPlot)
library(ggplot2) # for plots
library(performance)
library(see)
library(boot)
library(car)
library(DHARMa)
library(mgcv)
library(ggeffects)
library(gratia)
library(ggthemes)
library(interactions)
library(sp)


#file cleanup:
#there are a lot of packages here, check if we can remove any of them
#run check on which packages are actually used in coding repo
#commented out for neatness
# packageload <- c("chisq.posthoc.test", "ggplot2", "ggResidpanel",
#                  "patchwork", "sjPlot", "performance",
#                  "see", "boot", "car",
#                  "DHARMa", "lme4", "ggeffects",
#                  "gratia", "ggthemes", "abe",
#                  "MuMIn", "glmnet", "glmm",
#                  "MASS", "nlme", "interactions",
#                  "mgcv", "sp")

# Find which packages do used functions belong to ----
# library(NCmisc)
# used.functions1 <- NCmisc::list.functions.in.file(filename = "./code/1RTutorial.R", alphabetic = FALSE) |> print()
# used.functions2 <- NCmisc::list.functions.in.file(filename = "./code/2BasicTests.R", alphabetic = FALSE) |> print()
# used.functions3 <- NCmisc::list.functions.in.file(filename = "./code/3LM.R", alphabetic = FALSE) |> print()
# used.functions4 <- NCmisc::list.functions.in.file(filename = "./code/4GLM_count.R", alphabetic = FALSE) |> print()
# used.functions5 <- NCmisc::list.functions.in.file(filename = "./code/5GLM_binomial.R", alphabetic = FALSE) |> print()
# used.functions6 <- NCmisc::list.functions.in.file(filename = "./code/6GLM_Extensions.R", alphabetic = FALSE) |> print()
# used.functions7 <- NCmisc::list.functions.in.file(filename = "./code/7Nonparametric.R", alphabetic = FALSE) |> print()
# used.functions8 <- NCmisc::list.functions.in.file(filename = "./code/8GAM.R", alphabetic = FALSE) |> print()
# used.functions9 <- NCmisc::list.functions.in.file(filename = "./code/9GLMM.R", alphabetic = FALSE) |> print()
# used.functions10 <- NCmisc::list.functions.in.file(filename = "./code/10GLM_spatialautocorrelation.R", alphabetic = FALSE) |> print()
# used.functions11 <- NCmisc::list.functions.in.file(filename = "./code/11ModelComparisons.R", alphabetic = FALSE) |> print()
# 
# 
# pack1<-c(used.functions1, used.functions2, used.functions3,
#          used.functions4, used.functions5, used.functions6,
#          used.functions7, used.functions8, used.functions9, 
#          used.functions10, used.functions11)
# usedPack<-names(pack1)
# used.functions<-unique(usedPack)
# 
# # Find which loaded packages are not used ----
# used.packages <- used.functions  |> grep(pattern = "package:", value = TRUE) |> gsub(pattern = "package:", replacement = "") |> print()
# 
# unused.packages <- packageload[!(packageload %in% used.packages)] |> print()


