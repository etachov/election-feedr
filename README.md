# election-feedr

This script (1) pulls upcoming elections from IFES' [Election Guide](http://www.electionguide.org/) Calendar, (2) filter the elections against a vector of countries supplied by the user to produce a final list of upcoming elections in countries of interest.

I use this script to keep tabs on upcoming elections in countries where [MDIF](http://www.mdif.org) has investments. When an election takes place, we like to evaluate how our client's coverage compares to other media sources. We visualize the results in our [Election StoryMap](http://www.mdif.org/client-election-coverage/) feature. 

## Next Steps: 
* Replace the .csv write out with code that updates a Google Sheet using the great [googlesheet](https://github.com/jennybc/googlesheets) package.
* Refactor the whole nodeGet section. This can be smoother and it's a problem I encounter semi-regularly so worth it to spend some time on.

