library(dplyr)
library(datapkg)

##################################################################
#
# Processing Script for Business Formations by Town
# Created by Jenna Daly
# On 04/12/2018
#
##################################################################

#Setup environment
sub_folders <- list.files()
raw_location <- grep("raw", sub_folders, value=T)
path_to_raw <- (paste0(getwd(), "/", raw_location))
raw_file <- dir(path_to_raw, recursive=T, pattern = ".csv")

formations_df <- read.csv(paste0(path_to_raw, "/", raw_file), stringsAsFactors=F, header=T, check.names=F)

formations_df$Variable <- "Business Formations"
formations_df$`Measure Type` <- "Number"

#Group by town, add up all formations
formations_df_calc <- unique(formations_df %>% 
  filter(Type == "All Business Entities") %>% 
  group_by(Town) %>% 
  mutate(Value = sum(Value, na.rm=T)) %>% 
  select(Town, FIPS, Year, `Measure Type`, Variable, Value) %>% 
  arrange(Town))

# Write to File
write.table(
  formations_df_calc,
  file.path(getwd(), "data", "business_formations_town.csv"),
  sep = ",",
  row.names = F,
  na = "-9999"
)
