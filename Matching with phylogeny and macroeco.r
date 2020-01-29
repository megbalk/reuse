

setwd("C:\\Users\\DFraser\\Dropbox\\Manuscripts\\Body mass rules\\")

library(ape)

tree<-read.nexus("Fully_resolved_phylogeny_1.nex")

elton_data<-read.csv("Elton_traits1.0.csv",header=T)
matches<-intersect(elton_data$X,tree[[1]]$tip.label)

diffs<-setdiff(elton_data$X,tree[[1]]$tip.label)

# Read in the mammal distribution data

library(sp)
library(maptools)
library(rgdal)

maps<-readOGR("TERRESTRIAL_MAMMALS.shp")
names<-maps$binomial
names<-unique(names)

matches<-intersect(names,elton_data$X.3)
mismatches<-setdiff(names,elton_data$X.3)

# Matching with the phylogeny

write.csv(matches,"Matched names with distributions.csv")
matches<-read.csv("Matched names with distributions.csv",header=T)
matches2<-intersect(matches$x,tree[[1]]$tip.label)

# Fixing issues with taxonomy

taxonomy<-read.csv("Synonyms.csv",header=T,row.names=1)

replacements<-matrix(ncol=1,nrow=length(mismatches))
rownames(replacements)<-mismatches

for(j in 1:ncol(taxonomy)){
  print(j)
  for(k in 1:nrow(taxonomy)){
    for(i in 1:length(mismatches)){
      if(mismatches[i]==taxonomy[k,j]){
        replacements[i,1]<-rownames(taxonomy)[k]
      }else{next}
    }
  }
}

write.csv(replacements,"Taxonomic replacements.csv")






# Need to make a gridded map

# Read in the mammal distribution data
# library(sp)
# library(maptools)
# library(rgdal)
# 
# maps<-readOGR("TERRESTRIAL_MAMMALS.shp")
# names<-maps$binomial
# names<-unique(names)
# 
# # Need to turn this into a grid.
# library(maptools)
# library(sp)
# library(raster)
# library(SDMTools)
# 
# 
# data(wrld_simpl)
# world <- crop(wrld_simpl, extent(-170, -15, -60, 90))
# wgs1984.proj <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
# behrmannCRS <- CRS("+proj=cea +lat_ts=30")
# world<-spTransform(world, behrmannCRS)
# 
# r <- raster(world)
# res(r) <- 50000
# r[] <- rnorm(ncell(r))
# plot(r)
# plot(world, add=T)
# r[] <- 0
# 
# world.raster <- rasterize(world, r)
# world.raster[world.raster>=1] <- 1
# world.raster[world.raster==0] <- NA
# plot(world.raster)
# 
# Americas_grid<-rasterToPolygons(world.raster)
# Americas_grid<-as(Americas_grid, "SpatialPolygons")
# plot(Americas_grid)
# 
# coords<-coordinates(Americas_grid)
# coords<-SpatialPoints(coords,proj4string=CRS("+proj=cea +lat_ts=30"))
# longlatcoor<-spTransform(coords,CRS("+proj=longlat"))
# coords<-coordinates(longlatcoor)
# 
# write.csv(coords,"Americas grid coordinates.csv")
# 
# # get rid of the extra cells (west coast of Africa)
# # How to read out each species in the IUCN distribution data?
# 
# setwd("C:\\Users\\dfraser\\Dropbox\\Manuscripts\\Defining diet\\Shapefiles\\")
# 
# for(i in 1:length(names)){
#   print(i)
#   temp<-maps[maps$binomial==names[i],]
#   writeOGR(temp,".",names[i],driver="ESRI Shapefile")
# }
# 
# files <- list.files(pattern=".shp",recursive=TRUE,full.names=TRUE)
# 
# PA_table<-matrix(ncol=length(files),nrow=length(Americas_grid))
# colnames(PA_table)<-files
# 
# system.time(for(z in 1:length(files)){
#   print(paste("Species",z,"of 5406"))
#   flush.console()
#   map<-readOGR(files[z])
#   #proj4string(map) <- wgs1984.proj
#   map <- spTransform(map, behrmannCRS)
#   map<-as(map,"SpatialPolygons")
#   for(y in 1:length(Americas_grid)){
#     if(is.na(over(Americas_grid[y],map))) {PA_table[y,z]<-0} else {PA_table[y,z]<-1} # put 0 and 1 here
#   }
# })
# 
# write.table(PA_table,"Behrmann projection 50 by 50 Sept 14.txt")

# Already ran for a different project

# Calculate commonly used metrics for functional diversity (Oliveira paper)

# PAtable<-read.csv("Behrmann projection 50 by 50 Sept 17.csv",header=T,row.names=1)
# coords<-read.csv("Americas grid coordinates.csv",header=T,row.names=1)
# PAtable[,1:2]<-coords
# write.csv(PAtable,"Behrmann projection 50 by 50 April 24 2019.csv")

library(FD)

PAtable<-read.csv("Behrmann projection 50 by 50 April 24 2019.csv",header=T,row.names=1)
coords<-PAtable[,1:2]
PAtable<-PAtable[,3:ncol(PAtable)]

traits<-read.csv("Elton_traits2.0.csv",header=T)
BMs<-as.numeric(traits$BodyMass.Value)

BMdist<-dist(traits$BodyMass.Value)



###






