
library(dplyr) # general data manipulation
library(XML) # parse the xml feed
library(countrycode) # convert country names to country codes. working with country names always gets messy so i like to convert to codes ASAP.

## parse the raw xml from IFES's Election Guide RSS feed into the R data type XMLInternalDocument
feed_raw <- xmlParse("http://www.electionguide.org/feed/calendar/upcoming", encoding = "UTF-8")

## make a list of the nodes we want to pull out
node_list <- as.list(c("//item/title", "//item/link", "//item/description", "//item/pubDate"))

## helper function using xpathSApply to extact the value from each node using xmlValue
nodeGet <- function(x) {
  x <- xpathSApply(feed_raw, x, xmlValue)
  x
}

## apply the function to the list of nodes and turn the result into a data.frame
data_raw <- as.data.frame(lapply(node_list, nodeGet)) 

## set the names using the original list
names(data_raw) <- gsub("//item/", "", unlist(node_list))

## make a vector of countries we want to check the feed data against
## in practice i read a list of countries in from our internal database, but this works for an example
country_filter <- c("ARG", "BLR")

## clean up the data with some regex/dplyr
data <- data_raw %>%
  mutate(country = gsub(":.*", "", title),
         iso3c = countrycode(country, "country.name", "iso3c"),
         elect.type = gsub(".*:", "", title),
         # remove the html from the description
         description = gsub("<.*?>|&nbsp;", "", description),
         # because i always forget the symbols for the format function http://statmethods.net/input/dates.html
         date = as.Date(pubDate, format = "%a, %d %b %Y")) %>%
  select(country, iso3c, elect.type, date, description, link) %>%
  # filter down to only the country we care about
  # if you want all upcoming elections cut this line out
  filter(iso3c %in% country_filter)

## write the data out to csv file with the date accessed in the title
write.csv(data, paste("upcoming_elections", paste(Sys.Date(), ".csv", sep = ""), sep = "_"), row.names = F)






