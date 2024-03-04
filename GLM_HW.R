# Generalized Linear Models Homework
# March 1st 2024

# Tasks: 
#   1) Make a glm for my hypothesis
#   2) Draw and discuss at least one of each of the following: 
#       a) A diagnostic plot
#       b) An inferential plot (e.g., a coefficient plot, or something from emmeans or effects)

# Hypothesis: The PFOS levels from starling eggs found in the Brantford landfill 
#             are significantly higher than those found in other landfills. 

# # Loading packages: 
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


# Creating a generalized linear model based on Average PFOS per landfill site

glmland <- glm(Average_PFOS~Site, data=landfilldata, family = poisson(link = "log"))
# Running this gave me a warning for each point. I checked out the warning message, 
# and I think that it was freaking out because the response variable was a non-integer? 

# Changing my response variable from numeric to integer: 

landfilldata_int <- landfilldata |> mutate(Average_PFOS = as.integer(Average_PFOS))
  
# And running glm() again: 
glmland_int <- glm(Average_PFOS~Site, data=landfilldata_int, family = poisson(link = "log"))

# The warning messages went away, great! 

# Explaining some choices that I made: 
#   Choice of family: Poisson. Since my data deals with independant counts, using 
#   the Poisson family is most appropriate. 
#   Choice of link function: Log. This is the link function that naturally pairs
#   with Poisson. 

########

# Draw and discuss a diagnostic plot

check_model(glmland_int)

# The diagnostic plot of this data seem to suggest that this data is not best described
# by this model. Going through each plot...

#   For the posterior predictive check, I expected the data to present as a curve
#   but it instead modeled as a histogram. I'm not sure if I did something wrong, 
#   but I tried running the glm with numeric and integer values and the outcome 
#   was the same. Regardless, when I compare the observed and modeled data, I see 
#   that the model predicts no PFAS values ranging from ~250-750, and 1000+. In reality, 
#   the observed data includes points in these ranges. This model is not accurately
#   capturing the shape of the data. 
 
#   To double-check this, I ran: 

check_predictions(glmland_int)

#   ...and the output message said that the "model may not capture the variation of the data." 

#   The overdispersion plot also seems to indicate that the model may not be the 
#   best. Although the observed residual variance seems to match the predictive
#   line at lower predicted means, the observed residual variance seems to increase 
#   along the x-axis. The model may be a worse fit at greater PFOS values. 

#   The influential observations plot is tough to read. When I print the plot, 
#   I can't see any indication of Cook's distance or any of my points. I know what
#   the plot should roughly look like, with most points inside the contour lines 
#   to indicate that no one point is far from what the model predicts. I used the 
#   "check_outliers()" function:  

check_outliers(glmland_int, method = "cook")

#   ...and it gave me a list of 22 outliers. These points seem to correspond with 
#   the PFOS data for a few of the landfills (e.g., Brantford, Calgary), which are 
#   known to be contaminated sites with elevated PFOS levels. 

print(landfilldata_int, n = 57)

#   Finally, the observed points fall along the line in the normality of residuals plot. 


# Draw and discuss an inferential plot

e1 <- (emmeans(glmland_int, spec =~ Site))
plot(e1)

# This plot helps emphasize that the Brantford landfill seems to have elevated
# PFOS levels compared to other sites. The Brantford site does not overlap at all 
# with the other sites. 

plot(pairs(e1)) + geom_vline(xintercept = 0, lty = 2)

