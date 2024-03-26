# Bayesian Statistics Assignment 
# 15 March 2024

# Goals: 
#   Install JAGS and either rjags or R2jags
#   Use jags to fit a Bayesian model to your data, in some way that at least roughly makes sense. 
#   Discuss your prior assumptions, and compare your simple fit to an analogous frequentist fit. 

# Loading in packages
library(tidyverse)
library(coda) # required for rjags 
library(rjags)
library(lme4)
library(brms)

# Loading in data
load("EUST_Clean.rda")
tail(EUST_Data)


# The results from the last liner model assignment suggested that my data should 
# have a substantial amount of negative values. Since this isn't possible, I want 
# to try log transforming my data first before doing anything with it.

EUST_new <- EUST_Data |> mutate(log_PFOS = log(Average_PFOS)
)

# Creating a Model
a1 <- log_PFOS ~ 1 + Site + 1 + Land_Use + (1 + 1|Year)

# Right now, I'm only interested in how the PFOS levels at each site differ. I know
# that land use type might influence this which is why I included it above, but since
# there are only three levels I included it as a fixed effect. I'm not sure 
# if I formatted everything correctly though. 

# Prior Predictive Simulation
get_prior(a1, EUST_new) 

# When I ran this, the output table looked different from the one generated in class. 
# Instead of listing Site and Land Use as groups, it listed each different site and land
# use under the coefficient column. I wasn't really sure how to fix this. 

# Adjusting Priors 
b_prior <- c(set_prior("normal(2, 1)", "Intercept"),
             set_prior("normal(0, 10)", "b")
)

# I'm really not sure why this isn't working. Is it because it's categorical predictors? 

test_prior <- function(p) {
  capture.output(
    b <- brm(a1, EUST_new, prior = p,
             seed = 101,              ## reproducibility
             sample_prior = 'only',   ## for prior predictive sim
             chains = 1, iter = 500,  ## very short sample for convenience
             silent = 2, refresh = 0  ## be vewy vewy quiet ...
    )
  )
  p_df <- EUST_new |> add_predicted_draws(b)
  ## 'spaghetti plot' of prior preds
  gg0 <- ggplot(p_df,aes(Days, .prediction, group=interaction(Subject,.draw))) +
    geom_line(alpha = 0.1)
  print(gg0)
  invisible(b) ## return without printing
}

test_prior(b_prior)

# Fitting a Bayesian model

a_lmer <- lmer(a1, EUST_new)

# Trying with default settings, since I really struggled with figuring out priors. 
b_reg <- brm(a1, EUST_new, seed = 101)

# I waited a really long time for this to work, but I wasn't getting any outputs. 
# Sorry if this is super messy. 

mcmc_trace(b_reg, regex_pars= "b_|sd_")

# This output plots for each site, so I definitely did something wrong. I know in the example, 
# days were not a categorical value and were numeric. This is probably where the 
# issue stems from? What happens if I try to do this with numeric data...

EUST_try <- 







# Comparing to an analogous frequentist fit
m1 <- lmer(log_PFOS ~ 1 + Site + 1+ Land_Use + (1 + 1|Year), data = EUST_new)
check_model(m1)

# Frequentist fit doesn't look toooo bad. There looks to be a lot more variance
# among the lowest vales, but the PPC, linearuty check, and influential observation 
# plots all look alright. 

# Sorry for not getting this right, I'm going to try and see if I can 
# understand this better in the future. 
