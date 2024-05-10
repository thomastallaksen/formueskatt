library(tidyverse)
library(readr)
library(stringr)
library(ggmap)

formuesskatt_kommuner_2022 <- read_delim("Formuesskatt kommuner 2022.csv", 
                                         delim = ";", escape_double = FALSE, trim_ws = TRUE)

data <- formuesskatt_kommuner_2022 %>%
  mutate(
    Kommunenummer = substr(Kommune, 1, 4), # Ekstraherer de fire første tegnene
    Kommunenavn = gsub("\\(2020-2023\\)", "", Kommune), # Fjerner årstallene i parentes
    Kommunenavn = trimws(substr(Kommunenavn, 6, nchar(Kommunenavn))) # Fjerner de første fem tegnene og trimmer
  ) %>%
  mutate(
    Formueskatt = as.numeric(gsub(" ", "", Formueskatt)) * 1000, # Fjerner mellomrom og konverterer til numerisk
    Helsefagarbeidere = as.numeric(gsub(" ", "", Helsefagarbeidere)), # Konverterer til numerisk og trimmer
    Sykepleiere = as.numeric(gsub(" ", "", Sykepleiere)) # Konverterer til numerisk og trimmer
  ) %>%
  select(Kommunenummer, Kommunenavn, Formueskatt, Helsefagarbeidere, Sykepleiere) %>%
  mutate(
    Land = "Norge",
    Sted = paste(Kommunenavn, Land, sep = ", ")
  )

write.csv(data, "data.csv")




