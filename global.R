library(shinydashboard)
library(shiny)
library(tidyverse)
library(ggplot2)
library(readr)
library(RColorBrewer)
library(DT)
library(plotly)

df <- read_csv("AppleStore.csv")
df = df[, c(-1,-2,-5,-8,-10, -11)]
colnames(df) = c("Name", "Size(byte)", "Price", "Number of Rating", "Rating Score", 
                 "Content Rating", "Genre", "Number of Supported Device", "Number of Screenshots", "Number of Supported Languages", "VPP_lic")
df$`Free/Paid` = ifelse(df$Price == 0, "Free", "Paid")
df$`Content Rating` = as.factor(df$`Content Rating`)
#df$Genre = as.factor(df$Genre)
df$VPP_lic = as.factor(df$VPP_lic)
df$`Free/Paid` = as.factor(df$`Free/Paid`)
df$`Size(MB)` = df$`Size(byte)`/1000000
