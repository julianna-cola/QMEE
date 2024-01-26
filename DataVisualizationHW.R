# Data Visualization Assignment 
# Jan 26 2024

# Goals: Make some ggplots using my data. 
# Discuss the following: 
#     What I am trying to show 
#     Some choices that I made 
#     The basis of these choices

# Setting up and loading the data
library(ggplot2)
library(tidyverse)
library(forcats)
library(directlabels)

EUST_Data <- read_csv(("BIO708_EUST_Data_Set.csv"), col_types=cols())
summary(EUST_Data)

# Making a couple quick corrections to the data, including:

# 1) Renaming columns to make them suitable for R
EUST_Data <- rename(EUST_Data, Year = "...2", 
                    Land_Use = "Land Use", 
                    Average_PFSA = "Average of ∑PFSA",
                    Average_PFOS = "Average of PFOS",
                    Average_PFCA = "Average of ∑PFCA",
                    Average_PFCAs_Per_PFAAs = "Average%PFCA/Total PFAAs"
)

# 2) Changing characters to factors
EUST_Data <- EUST_Data %>% mutate(across(c(Site, Year, Land_Use), as.factor))

# Looking good! 

# With this data, there are a few key things that I could visualize: 
#   1) In our most recent egg collection year, how did the amount of PFOS vary 
#      across the different sites? And how does this compare to land use? 


# To answer this question, I first filtered out a subset of my data. It only 
# contained data from 2022 and only included the site, land use, and average PFOS.

# I sorted the sites in descending order, since I thought it would be more interesting 
# when presented visually. 


PFOS_2022_data <- (EUST_Data 
                   %>% filter(Year == 2022)
                   %>% select(Site, Land_Use, Average_PFOS)
                   %>% mutate(Site=fct_reorder(Site, -Average_PFOS))
)

# Then I made a bar plot displaying the average PFOS per site. Comparing the sites
# along a common y-axis scale makes it easier to compare PFOS levels between sites, and 
# makes it very obvious that the Brantford location has extremely elevated PFOS levels. 
# This aligns with concepts presented in the Cleveland hierarchy, which states that 
# position along a common scale is one of the best ways to present comparison data. 

# As well, I filled the bars based on land use type (landfill, industrial, rural). 
# By doing so, one could look at the graph and notice that the landfill and industrial sites
# generally have elevated PFOS concentrations, while rural locations have reduced concentrations. 
# This aligns with the idea that PFASs are anthropogenic pollutants and are in higher concentrations
# near human activity.

# Couple aesthetic adjustments for the axis. I rotated the labels 90 degrees so 
# they fit better along the x axis. As well, I right aligned them all, which I 
# thought looked cleaner. 

PFOS_2022 <- print(ggplot(PFOS_2022_data)
              + aes(Site, Average_PFOS, fill=Land_Use)
              + geom_col()
              + labs (y = "Average PFOS (ng/g)", fill = "Land Use")
              + theme_minimal()
              + theme(axis.text.x = element_text(angle = 90, hjust = 1))
)

# We can repeat th is method of subsetting the data from a given year and 
# visualizing the amount of contaminant per location for other PFASs as well. 
# For example, for PFCAs: 

PFCA_2022_data <- (EUST_Data 
                   %>% filter(Year == 2022)
                   %>% select(Site, Land_Use, Average_PFCA)
                   %>% mutate(Site=fct_reorder(Site, -Average_PFCA))
)

PFCA_2022 <- print(ggplot(PFCA_2022_data)
                   + aes(Site, Average_PFCA, fill=Land_Use)
                   + geom_col()
                   + labs (y = "Average PFCAs (ng/g)", fill = "Land Use")
                   + theme_minimal()
                   + theme(axis.text.x = element_text(angle = 90, hjust = 1))
)

# We can also swap out the years and visualize the data in a similar way. 

####

# One more question to ask: 
#   2) How do PFAS levels change over time at a given site? 

# First, we convert years back to a numeric value from a factor.
EUST_year_numeric <- EUST_Data %>% mutate(Year = as.numeric(as.character(Year)))

# Reorder sites in order of descending PFOS levels. This'll help the legend and the 
# graph align better. 
reorder <- EUST_year_numeric %>% mutate(Site=fct_reorder(Site,-Average_PFOS))
head(reorder)


# Now, we can make a line graph over time displaying how PFOS levels change. I adjusted
# to a log scale because many of the values were squished at the bottom and hard to read. 
PFOS_Over_Time <- print(ggplot(reorder)
                        + aes(Year, Average_PFOS, colour=Site)
                        + theme_bw()
                        + geom_point()
                        + geom_line()
                        + labs (y = "Average PFOS (ng/g)")
                        + scale_y_log10()
)
# The above line graph is a little crowded. I tried adding direct labels to 
# this figure, but I think that it looked even more crowded: 

last.bumpup <- list("last.points","bumpup")
print(PFOS_Over_Time
      + expand_limits(x=2026)  
      + geom_dl(aes(label=Site), method="last.bumpup") 
      + theme(legend.position="none")
)


# To fix this crowding, we can sort each site by land use and display the data in 
# three separate panels. The figure becomes more legible and comparisons between 
# sites are still easy to make, even across different land use types. 

PFOSbyFacets <- PFOS_Over_Time+facet_wrap(~Land_Use)
print(PFOSbyFacets)

# Pretty! 

####

# One last question we can try to visualize is: 
#   3) How do average PFOS levels change over time based on land use types? 


# We can make a table of Year and Land Use, then calculate the average PFOS per land use
# type per year. 
LandUseData1 <- print(EUST_Data
  %>% group_by (Year, Land_Use)
  %>% summarize (Mean_PFOS = mean(Average_PFOS))
) 

# Then, we change year back to a numeric value and order mean PFOS levels in descending order. 
LandUseData2 <- (LandUseData1 %>% mutate(Year = as.numeric(as.character(Year)))
         %>% mutate(Land_Use=fct_reorder(Land_Use,-Mean_PFOS))
)


# Finally, we can plot! Labelling by colour makes it clear which land use type is which. 
# As well, this type of graph makes it very clear that landfills seem to have elevated
# PFAS levels. 

print(ggplot(LandUseData2)
      + aes(Year, Mean_PFOS, colour=Land_Use)
      + theme_bw()
      + geom_point()
      + geom_line()
      + labs (y = "Average PFOS (ng/g)", fill = "Land Use")
)

# I can repeat this but with a log scale: 
LandUseVis <- print(ggplot(LandUseData2)
              + aes(Year, Mean_PFOS, colour=Land_Use)
              + theme_bw()
              + geom_point()
              + geom_line()
              + labs (y = "Average PFOS (ng/g)", fill = "Land Use")
              + scale_y_log10()
)

# Since we only have three lines, I think it might be best to remove the legend
# and use direct labels instead: 
print(LandUseVis
      + expand_limits(x=2024)  
      + geom_dl(aes(label=Land_Use), method="last.bumpup") 
      + theme(legend.position="none")
)

# Looks good! 

# Overall, this script was used to visualize: 
# 1) PFOS abundance per site in 2022 (which can be applied to any year/contaminant type)
# 2) How do PFOS levels change per site over the course of a decade? 
# 3) How do average PFOS levels compare between land use types over a decade? 
