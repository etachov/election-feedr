
library(dplyr) # general data manipulation
library(XML) # parse the xml feed
library(countrycode) # convert country names to country codes. working with country names always gets messy so i like to convert to codes ASAP.

## parse the raw xml from IFES's Election Guide RSS feed into the R data type XMLInternalDocument
feed_raw <- xmlParse("http://www.electionguide.org/feed/calendar/upcoming", encoding = "UTF-8")

## make a list of the nodes we want to pull out
node_list <- c("//item/title", "//item/link", "//item/description", "//item/pubDate")

## helper function using xpathSApply to extact the value from each node using xmlValue
nodeGet <- function(x) {
  x <- xpathSApply(feed_raw, x, xmlValue)
  x
}

## apply the function to the list of nodes and turn the result into a data.frame
elect_raw <- as.data.frame(lapply(node_list, nodeGet)) 

## set the names using the original list
names(data_raw) <- gsub("//item/", "", node_list)


## clean up the data with some regex and dplyr
elect <- data_raw %>%
  mutate(country = gsub(":.*", "", title),
         iso3c = countrycode(country, "country.name", "iso3c"),
         elect.type = gsub(".*:", "", title),
          # remove the html from the description
         description = gsub("<.*?>|&nbsp;", "", description),
          # because i always forget the symbols for the format function http://statmethods.net/input/dates.html
         date = as.Date(pubDate, format = "%a, %d %b %Y")) %>%
  select(country, iso3c, elect.type, date, description, link)


## subset the list by a vector of countries if you have a specific focus: 
countries_interest <- countrycode(c("Iran", "United Kingdom"), "country.name", "iso3c")

elect %>%
  filter(iso3c %in% countries_interest)










