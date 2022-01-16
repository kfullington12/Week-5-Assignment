# Using the dplyr package, use the 6 different operations to analyze/transform the data - 
# GroupBy, Summarize, Mutate, Filter, Select, and Arrange 
library(readxl)
library(plyr)
library(dplyr)

housing <- read_excel('week-7-housing.xlsx')
colnames(housing)[colnames(housing) == "Sale Price"] <- "Sale_Price"
# I changed the column name to make it easier for me to work with

housing %>% group_by(zip5) %>% summarize(AvgPrice=mean(Sale_Price))
# This finds the average sale price for each zip code and prints out the result

housing2 <- housing
housing2 %<>% select(Sale_Price, zip5) %>% mutate(Lot_to_Living_ratio=housing$sq_ft_lot/housing$square_feet_total_living)
# Select chooses which columns to print, mutate creates a new column by dividing the square feet of the lot by the square feet of living space

housing %>% group_by(zip5) %>% summarize(AvgPrice=mean(Sale_Price)) %>% arrange(zip5)
# group_by selects the zip code column to print, summarize creates a new column (AvgPrice) calculating the mean price per zip code, and arrange sets the result in zip code order

housing %>% select(Sale_Price, zip5, bedrooms, bath_full_count) %>% filter(bedrooms >= 2, bath_full_count >= 2) %>% arrange(desc(Sale_Price))
# select chooses the columns to print, filter chooses only bedrooms 2 and above and bathrooms 2 and above, arrange(desc) prints them in order of highest price to lowest price

# Using the purrr package – perform 2 functions on your dataset.  You could use zip_n, keep, discard, compact, etc.
library(purrr)

city_list %>% modify_if(is.factor, as.character)

price_list <- housing$Sale_Price
price_list %>% discard(function(x) x < 10000)
# I created a list based on the Sale_Price column, then discarded any prices below 10,000)

# Use the cbind and rbind function on your data set
housing_pre_1950 <- housing %>% select(Sale_Price, zip5, bedrooms, year_built) %>% filter(housing$year_built < 1950) %>% arrange(Sale_Price)
housing_post_1950 <- housing %>% select(Sale_Price, zip5, bedrooms, year_built) %>% filter(housing$year_built >= 1950) %>% arrange(Sale_Price) %>% slice(1:166)
built_1950_to_2016 <- rbind(housing_pre_1950, housing_post_1950)
# I made two data frames, one for housing pre 1950 and one for housing post 1950, then sliced off some rows so the two would match
# Then I used rbind to put the two lists together into one data frame


Sale_Price_Col <- housing$Sale_Price
Zip5_Col <- housing$zip5
Bedrooms <- housing$bedrooms
Year_Built <- housing$year_built
cbind(Price = Sale_Price_Col, 'Zip Code' = Zip5_Col, Bedrooms = Bedrooms, 'Year Built' = Year_Built)
# I created four sets of data based on some columns. Then I used cbind to put them together and named each column



# Split a string, then concatenate the results back together

libary(stringr)

sale_date_list <- str_split(string = housing$`Sale Date`, pattern = "-")
# First I made a list using str_split based on Sale Date and separated the numbers by the -
sale_date_matrix <- data.frame(Reduce(rbind, sale_date_list))
# Next I made a matrix/data frame using reduce and rbind
names(sale_date_matrix) <- c("Year", "Month", "Day")
# Third, I named the new columns in the matrix
housing <- cbind(housing, sale_date_matrix)
# Then I used cbind to attach the sale_date matrix to the housing data frame
housing$Year <- as.numeric(as.character(housing$Year))
housing$YMonth <- as.numeric(as.character(housing$Month))
housing$Day <- as.numeric(as.character(housing$Day))
# Finally I turned all the entries into numeric entries

