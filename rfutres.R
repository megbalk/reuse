install.packages("devtools")
devtools::install_github("futres/rfutres")
library(rfutres)

df <- futres_data(fromYear = 2000, toYear = 2010, limit=2)

print(df$data)

print(df$number_possible)

traits <- futres_traits() #error 502

print(traits[2,])
