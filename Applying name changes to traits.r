
setwd("C:\\Users\\dfraser\\Dropbox\\Manuscripts\\Body mass rules\\")

# cut the futres database down to this, must use a function to combine columns
futres_agg<-aggregate(measurementValue~replacements,data=futres,FUN=mean)
write.csv(futres_agg,"Futres aggregated by updated species.csv")

IUCN_synonyms<-read.csv("IUCN_Synonyms_clean.csv")
  
trait_data<-read.csv("Futres.csv")


Fun_IUCN_synonyms<-function(trait_data,species_names_column,IUCN_synonyms){
  trait_names<-trait_data[,species_names_column]
  new_names<-c()
  for(i in 1:length(trait_names)){
    trait_match<-which(IUCN_synonyms$synonym==trait_names[i])
    if(length(trait_match)>1){
      print("it's happened!") # I was worried there might be two or more results (it never happened)
    }
    if(length(trait_match)>0){
      new_names[i]<-IUCN_synonyms$accepted_name[trait_match]
    }else{
      new_names[i]<-trait_names[i]
    }
  }
  return(new_names)
}

replacements<-Fun_IUCN_synonyms(trait_data,10,IUCN_synonyms)

trait_data_new<-cbind(trait_data,replacements)
write.csv(trait_data_new,"Futres with name changes.csv")

###

# What taxa are missing from the datasets that are in the distribution dta

occ<-read.csv("Global occurrence matrix December 2021.csv")
phylacine<-read.csv("PHYLACINE with name changes.csv")
pantheria<-read.csv("PanTHERIA with name changes.csv")
futres<-read.csv("Futres aggregated by updated species.csv")
elton<-read.csv("Elton traits 3.0 with name changes.csv")

all_species<-c(phylacine$replacements,pantheria$replacements,elton$replacements,futres$replacements)
all_species<-unique(all_species)
all_species<-na.omit(all_species)
matches<-intersect(colnames(occ),all_species) # 5165
diffs<-setdiff(colnames(occ),all_species) # 501
write.csv(diffs,"Taxa missing from all databases.csv")


# match with other databases

#Phylacine
matches<-intersect(futresnames,phylacine$replacements) #522

# Pantheria
matches<-intersect(futresnames,pantheria$replacements) #515

# Elton Traits
matches<-intersect(futresnames,elton$replacements) #428

# implications for how we build the entire database of traits
# compare body mass estimates for these overlapping taxa

# Matching with the COMBINE database

occ<-read.csv("Global occurrence matrix December 2021.csv")
COMBINE<-read.csv("COMBINE database reported.csv")

matches<-intersect(colnames(occ),COMBINE$iucn2020_binomial)
diffs<-setdiff(colnames(occ),matches)
diffs<-setdiff(colnames(occ),COMBINE$iucn2020_binomial)

# Replace the subspecies etc. with the proper name

replace<-read.csv("Diffs between occurrences and COMBINE database - Diffs between occurrences and COMBINE database.csv")

# replace the names in the mammal occurrences

occ_names<-colnames(occ)

for(i in 1:nrow(replace)){
  print(i)
  for(j in 1:length(occ_names)){
    if(occ_names[j]==replace[i,1]){
      occ_names[j]<-replace[i,2]
    }
  }
}

# Now check for matches

matches<-intersect(occ_names,COMBINE$iucn2020_binomial)
diffs<-setdiff(occ_names,COMBINE$iucn2020_binomial) # only one Hyosugo_musciculus

colnames(occ)<-occ_names
write.csv(occ,"Global occurrence matrix January 2022.csv")



###