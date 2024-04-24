#!/usr/bin/env Rscript
# load libraries
library(tidyverse)
library(survminer)
library(survival)
library(microbiome)
library(magrittr)
library(randomForestSRC)
library(ResourceSelection)
library(GGally)
set.seed(198657)

args=(commandArgs(TRUE))
PARAM <- list()
#this argument is to specify the path of input folder
#the input folder structure is similar to DreamHF.zip both for synthetic and real dataset
PARAM$folder.R <- paste0(args[1])
foldername <- paste0(args[2])
#one output file (score.csv) has to be created in Team_Name_Submission_Number folder
PARAM$folder.data <- paste0(PARAM$folder.R, "/")
PARAM$folder.result <- paste0(PARAM$folder.data, foldername,"/output/")

#load data

# load data
print("Load data")
S.test <- read.csv(file = paste0(PARAM$folder.data,
                                 "test/pheno_test.csv"),
                   row.names=1,)
S.train <- read.csv(file = paste0(PARAM$folder.data,
                                  "train/pheno_training.csv"),
                   row.names=1,)

O.test <- read.csv(file = paste0(PARAM$folder.data,
                                 "test/readcounts_test.csv"),
                   row.names=1,)
O.train <- read.csv(file = paste0(PARAM$folder.data,
                                  "train/readcounts_training.csv"),
                    row.names=1,)

endpoints <- c("Event_time", "Event")

# SCORING ONLY

# read score file for test data
scores <- read.csv(file = paste0(PARAM$folder.result,
                                  "scores.csv"))
collect.rsf <- data.frame()

# Harrells C *******************************************************************
labels=df.test[samples]
labels$SampleID<- rownames(df.test)

# range the predicted values
# only apply 0-1 when it is not all 0s
if (length(unique(scores$Score))==1){
  scores$Score=scores$Score
} else {
  scores$Score = range01(scores$Score)
}

# Align the user provided scores with the true event times
true.scores <- as.numeric(labels[scores$SampleID,"Event_time"])
# remove NAs  for us, not valid for participants, check if scores contain NA?
#scores <- scores %>%  drop_na()
eventinfo <- as.numeric(labels[scores$SampleID,"Event"])

# Calculate Harrell's C statistics
C <- Hmisc::rcorr.cens(scores$Score, true.scores, outx=FALSE)
print(C)

# Hoslem test *****************************************************************
# run with event info not event time
hoslem.test <- hoslem.test(eventinfo, scores$Score)
collect.rsf <- rbind(collect.rsf, hoslem.test$p.value)

collect.rsf <- cbind(C["C Index"][[1]], collect.rsf)
colnames(collect.collect.rsf) <- c("HarrellC", "hoslem.test")

# Write the scoring table for evaluation
write.csv(collect.rsf, file=paste0(PARAM$folder.result,
                         "stats.csv"),
          quote=FALSE, row.names=FALSE)