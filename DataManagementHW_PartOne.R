# Data Management Assignment 

# Setting up...

library(tidyverse)
library (readr)
library(dplyr)

setwd("../QMEE")
EUST_Data <- as_tibble(read.csv("../QMEE/BIO708_EUST_Data_Set.csv"))

# Note: "EUST" is an abbreviation of "European Starling"
# This data looks at the average PFAS concentration from European starling eggs 
# across Canada. There are some abbreviations that would be helpful to know, including: 
    # PFAS = per- and polyfluoroalkyl substances
    # PFSA = perfluorosulfonic acid
    # PFCA = perfluorocarboxylic acid
    # PFOS = perfluorooctane sulfonate (a type of PFSA)


# Now that the data is loaded in, let's look at its structure. 
str(EUST_Data)
# We have 147 observations of 7 variables. These variables include: 
    # Site
    # Year 
    # Land Use Type 
    # Average PFSAs per egg
    # Average PFOS per egg
    # Average PFCAs per egg
    # Average proportion of PFCAs to total PFASs

# We can also do a quick check for parsing problems...
problems(EUST_Data)
# ...and nothing pops up! How lovely. 

# However, by looking at the structure, I've noticed a couple of formatting things I want to 
# change right off the bat: 
    # 1) The column title for "Year" is currently "X" and some column titles are (frankly) ugly
    # 2) I want site, year, and land use to be factor classes and not characters/intergers


# Let's fix it!

# Changing column titles
new_columns <- c(Year = "X", 
               Land_Use = "Land.Use",
               Average_PFSAs = "Average.of..PFSA",
               Average_PFOS = "Average.of.PFOS",
               Average_PFCAs = "Average.of..PFCA", 
               Average_Proportion_PFCAs = "Average.PFCA.Total.PFAAs")
EUST_Data <- rename(EUST_Data, all_of(new_columns))

# Changing variable classes
EUST_Data <- (EUST_Data 
              %>% mutate(Site=as.factor(Site))
              %>% mutate(Year=as.factor(Year))
              %>% mutate(Land_Use=as.factor(Land_Use))
)

#Now, if we double-check our column names and classes, everything looks great!
str(EUST_Data)

# Let me look at the summary of this data...
summary(EUST_Data)

# Within the summary, I've noticed that there seems to be some inputs with really 
# elevated PFAS levels. I know that these should be from the Brantford and Calgary 
# locations, so let me double-check that this input is correct. 

max_check <- (EUST_Data
      %>% count(Site, Average_PFSAs, Average_PFCAs, Average_PFOS)
      %>% arrange(desc(Average_PFSAs))
)
print(max_check, n = 15)

# Looks like these elevated values were all recorded from either Calgary or Brantford. 
# Great! 

# Note: I tried using this line of code:

# (EUST_Data
#  %>% count(Site, Average_PFSAs, Average_PFCAs, Average_PFOS)
#  %>% arrange(desc(Average_PFSAs))
#  %>% print(n = 15)

# to print out more rows, but it only ever showed me ten rows. Something I 
# should learn how to fix in the future!

# Quickly, I want to check that the site names were inputted correctly and that there are
# no accidental spelling errors (e.g., Langley and Langeley)

print(EUST_Data
      %>% group_by(Site)
      %>% summarize(count = n())
)
# Cool! I've got the 17 sites I expected. Let me repeat this with the other classes. 

print(EUST_Data
      %>% group_by(Year)
      %>% summarize(count = n())
)

print(EUST_Data
      %>% group_by(Land_Use)
      %>% summarize(count = n())
)

# Year and Land Use also look great. I think that pretty much sums up my visual check of the 
# data. Everything looks clean! 



# There is a column of data that I want to add. Since I have the average sum of PFOS and PFSAs, 
# I want to see what proportion of all PFSAs are accounting for by PFOS. To do so: 


EUST_Data <- (EUST_Data
              %>% mutate(PFOS_per_PFSAs = Average_PFOS / Average_PFSAs)
)

# I can use this data later to make a histogram.


# Now, let me make some quick plots to visualize the data and check for further errors. 
print(ggplot(EUST_Data, aes(x=Average_PFSAs))
      + geom_histogram()
)
# Like I expected, most sites have PFSAs levels under 100ng/g ww. I can double-check this with the 
# other two columns as well. 

print(ggplot(EUST_Data, aes(x=Average_PFCAs))
      + geom_histogram()
)

print(ggplot(EUST_Data, aes(x=Average_PFOS))
      + geom_histogram()
)

# I get the same shape as the original histogram, with most values being very low and the 
# contaminated sites having extremely high values. 

# Overall, my data looks clean and is in the form I want it in. I: 
    # Checked its structure
    # Checked for problems
    # Altered the columns, titles, and classes to my liking
    # Made sure there were no strange values or spelling mistakes in each factor
    # Made 3 plots to check the distribution of the data

# Now, I can save this as an .rds file. 
saveRDS(EUST_Data, "EUST_Data.rds") 
