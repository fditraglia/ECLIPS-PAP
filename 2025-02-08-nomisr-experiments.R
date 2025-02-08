library(nomisr)
library(tidyverse)

# Using an API is optional but recommended for large downloads

# Read API key directly from .Renviron
nomis_api_key(check_env = TRUE)

# Uncomment if you want to enter your key manually in the console:
# nomis_api_key()

# Uncomment to check that the key is set
# Sys.getenv("NOMIS_API_KEY")


# Search household-level data from the 2021 UK Census 
census_search <- nomis_search(
  description = "*2021*census*household*",
  keywords = "Household"
)

# Display the names and ids of the search results:
census_search |> 
  select(id, name.value, description.value) |> 
  print(n = 100)

# Show only rows with "child" in the name
census_search |> 
  select(id, name.value, description.value) |> 
  filter(str_detect(name.value, "child"))

# Source: https://www.nomisweb.co.uk/
# Leeds Local Authority in Yorkshire and The Humber (GSS code E08000035)


### STEP 1: Pick a Dataset and Check Metadata ###

# For example, let's choose the QS118EW table:
dataset_id <- "NM_518_1"

# Check the metadata to see available filters and variables.
# This step will let you see if there is an age filter (e.g. "AGE", "CHILD_AGE", etc.)
meta <- nomis_get_metadata(dataset_id)
print(meta)

# Retrieve the codelist for the CELL dimension for dataset NM_518_1
cell_codes <- nomis_codelist("NM_518_1", "cell")

# Inspect the first few rows
head(cell_codes)

# Define the cell code for the age range of interest.
# For example, for households with one dependent child aged 0 to 4
child_cells <- "2" # notice that it's character data

kids_geography <- nomis_get_metadata("NM_518_1", "geography", "TYPE")
kids_geography |> 
  print(n = 100)
