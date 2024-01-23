# This is the "separate script that reads in your .rds file and does something with it"

# Reading .rds file
EUST_Data_Part_Two <- readRDS("EUST_Data.rds")
library(tidyverse)

# One thing we can do is see if land use has an effect on PFAS levels. 
# As a calculation: 

(EUST_Data_Part_Two
  %>% group_by (Land_Use)
  %>% summarize (mean_PFSAs = mean(Average_PFSAs))
)

# Mean industrial PFSAs = 108 ng/g ww
# Mean landfill PFSAs = 246 ng/g ww
# Mean rural PFSAs = 9.03 ng/g ww
# This is interesting! Maybe human activity/proximity leads to elevated PFSAs levels. 

# We can repeat this with some of our other PFAS data: 

(EUST_Data_Part_Two
  %>% group_by (Land_Use)
  %>% summarize (mean_PFOS = mean(Average_PFOS))
)
# Mean industrial PFSAs = 93.9 ng/g ww
# Mean landfill PFSAs = 226 ng/g ww
# Mean rural PFSAs = 8.40 ng/g ww

(EUST_Data_Part_Two
  %>% group_by (Land_Use)
  %>% summarize (mean_PFCAs = mean(Average_PFCAs))
)
# Mean industrial PFSAs = 31.3 ng/g ww
# Mean landfill PFSAs = 181 ng/g ww
# Mean rural PFSAs = 8.58 ng/g ww

# Overall, it seems like landfills have elevated PFAS levels across the board.

# We can also visualize this with a boxplot: 

print(gg1 <- ggplot(EUST_Data_Part_Two, aes(x=Land_Use, y=Average_PFSAs)) +
      ## BMB: I prefer filled plots: https://clauswilke.com/dataviz/avoid-line-drawings.html
      geom_boxplot(fill = "gray") + 
      theme_classic() + 
      labs(y="Average Sum of PFSAs (ng/g ww)") + 
      scale_x_discrete(name='Site',labels = c('Industrial', 'Landfill', 'Rural'))
)

# Looks like there are a lot of elevated outliers for the industrial and landfill land use
## types.

## BMB: careful about the meaning of 'outliers' in a box plot --
## a box plot may also make things look much more sensible ...

gg1 + scale_y_log10()

# One other quick thing we can visualize is how prevalent PFOS are compared to the 
# total amount of PFSAs: 

print(ggplot(EUST_Data_Part_Two, aes(x=PFOS_per_PFSAs))
      + geom_histogram()
)

# Looks like PFOS make up anywhere from around 70% to 100% of the total PFSA profile. 

## BMB: nice job! 2.25
