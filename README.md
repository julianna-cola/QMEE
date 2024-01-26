# QMEE
for BIO708

# Assignment Three: Data Visualization

The file for this assignment can be found in `DataVisualizationHW.R`. It uses the data file `BIO708_EUST_Data_Set.csv` for all analyses.  

# Assignment Two: Data Management

`DataManagementHW_PartOne.R` aims to analyze and alter an imported data set. The data is analyzed for problems, assigned the correct classes, and altered slightly to make it more readable and useful for further analysis. This script also saves an .rds file of the altered data.

`DataManagementHW_PartTwo.R` loads the .rds script and does some simple plots and calculations. 

Both scripts can be found in the main branch of the QMEE directory. In the future, this data can be used to analyze spatial and temporal trends in PFASs across Canada. Since the data spans about ten years, it would be possible to see if the passing of time has had any effect on PFASs. As well, we can see if certain land use types or sites have elevated PFAS levels. This may help us understand which sites and land use types are the most polluted and may need careful monitoring in the future. 

# Assignment One: Describing Biological Data

Per- and polyfluoroalkyl substances (PFASs) are ecological contaminants of great concern due to their ubiquity, persistence, and potential for biotoxic effects. Recent efforts to better understand the terrestrial distribution of these chemicals have used bird eggs as an indicator of PFAS pollution. In particular, European starling (_Sturnus vulgaris_) eggs have been shown to be a good indicator of terrestrial PFAS abundance. This data set describes the PFAS composition of European starling eggs collected from nest boxes throughout Canada between 2009 and 2022. Eggs were collected from a total of 17 sites; however, each site was not sampled every year. Each site was classified based on one of three land use types: industrial, rural, or landfill. Each row describes a given pool of eggs that was collected at the listed site in the listed year. 


The following data was recorded for each pool of eggs:
 
  Site name
  
  Year
  
  Land use type (one of industrial, landfill, or rural)
  
  Average concentration of all PFSAs (a category of PFAS) in ng/g wet weight
  
  Average concentration of all PFCAs (a category of PFAS) in ng/g wet weight
  
  Average concentration of PFOS (a category of PFAS) in ng/g wet weight


This data set can be used to evaluate a variety of biological questions, including: 
  
   How do PFAS concentrations compare across different sites? 
   
   Does land use type impact PFAS concentrations in eggs? 
       Example: Do landfills display different levels of PFASs/PFCAs/PFSAs/PFOS? 
   
   How does PFAS concentration in eggs change over time? 
   
   What percent of all PFSAs is accounted for by PFOS (a type of PFSA)? 
   
