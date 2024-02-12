# Linear Models Homework
# Tasks: 
#   1) Formulate a clear hypothesis about the data
#   2) Make a linear model for your hypothesis
#   3) Draw and discuss at least one of each of the following: 
#       a) Diagnostic Plot
#       b) Inferential Plot


# 1) Formulate a clear hypothesis about the data

# Hypothesis: The PFOS levels from starling eggs found in the Brantford landfill 
#             are significantly higher than those found in other landfills. 

# 2) Make a linear model for your hypothesis

# Loading packages: 
library(performance)
library(tidyverse)
library(emmeans)
library(ggplot2); theme_set(theme_bw())
library(dotwhisker)

# Loading in data. This .rda file contains a cleaned set of my original data.
# The cleaned dataframe is called "EUST_Data"

load("EUST_Clean.rda")

# For this hypothesis, I just want to look at landfills, so I'll quickly filter 
# out other land use types 

landfilldata <- filter(EUST_Data, Land_Use == "Landfill")

# Creating a linear model based on Average PFOS per landfill site

lmland <- lm(Average_PFOS~Site, data=landfilldata)
summary(lmland)


# 3) Draw and discuss at least one of each of the following: 
#     a) Diagnostic Plot

check_model(lmland)

# The diagnostic plot of this data seem to suggest that this data is not best described
# by a linear model. Going through each plot...

#   The model-predicted curves in posterior predictive check do not align with 
#   the observed data. For one, the maximum observed values far exceed any values 
#   that the model predicts. Although both the observed and predicted values peak
#   at about the same place, the overall shapes of the curves are very dissimilar. 
#   To double-check this, I ran: 

check_predictions(lmland)

#   The linearity plot also seems to indicate that a linear model may not be the 
#   best fit for this data. Although the reference line is flat and horizontal, the 
#   actual points (especially those on the higher end) do not fall closely along this
#   line. Running the line of code below output a message that said heteroscedasticity
#   was detected. This means that the variance is not constant throughout the data.   

check_heteroscedasticity(lmland)

#   The homogeneity of variance plot shows a curved reference line, when an ideal
#   line should be roughly straight. This supports the notion that there is likely 
#   some heteroscedasticity in the data.

#   The influential observations plot is tough to read. When I print the plot, 
#   I can't see any indication of Cook's distance or any of my points. I know what
#   the plot should roughly look like, with most points inside the contour lines 
#   to indicate that no one point is far from what the model predicts. I used the 
#   "check_outliers()" function, but it came back as no outliers detected. 

check_outliers(lmland, method = "cook")

#   Finally, the normality of residuals plot suggests that points at the extremes of 
#   the data (especially the negative extreme) are not well-predicted by the linear 
#   model. Even points in the middle of the data don't fit nicely along the line, 
#   suggesting that the residuals of the data are not normally distributed. Checking
#   the normality with the line of code below supports the idea that the residuals 
#   are not normally distributed. 

check_normality(lmland)

#     b) Inferential Plot

e1 <- (emmeans(lmland, spec =~ Site))
plot(e1)

# This plot helps emphasize that the Brantford landfill seems to have elevated
# PFOS levels compared to other sites. The Brantford site does not overlap at all 
# with the other sites. 

plot(pairs(e1)) + geom_vline(xintercept = 0, lty = 2)

# This pairwise-comparison site reinforces the hypothesis. 
