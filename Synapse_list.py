#!/usr/bin/env python
#adapted from: https://github.com/Sage-Bionetworks/SynapseWorkflowExample/blob/master/downloadSubmissionFile.cwl
#list submission and create the directory accordingly
import synapseclient
syn = synapseclient.Synapse()
syn.login()
import os
from challengeutils import utils
import time
timestr = time.strftime("%Y%m%d")
import pandas as pd

submissions = syn.tableQuery("SELECT * FROM syn27130808 WHERE status NOT IN ('INVALID', 'CLOSED')").asDataFrame()

# Find duplicate submissions based on entityid.
duplicate_subs = submissions.loc[
  submissions
    .sort_values(['entityid', 'createdOn'])  # sort by entity, then by date
    .duplicated(subset=['entityid'])         # get duplicates based on entity value
, 'id'].tolist()  # only keep the `id` values and put them into a list

# Update the status of duplicate submissions to CLOSED.
for sub_id in duplicate_subs:
  utils.change_submission_status(syn, sub_id, "CLOSED")

## update the status of not .sif and .zip into INVALID

# Only evaluate new unique submissions.
to_download = (
  submissions[~submissions.id.isin(duplicate_subs)]  # remove rows where `id` is found in `duplicate_subs`
  .query("status == 'RECEIVED'")                     # filter for rows where `status` is RECEIVED
)

querydf = pd.DataFrame(to_download)
#save file to record the downloaded file in that date --> store in temporary download location
##append file name


##STEP BELOW ONLY IF THE DOWNLOADING WORKFLOW CANNOTT BE SET-UP
#listing the ID with RECEIVED status and download the files to the temporary location
#based on submission ID, change the temporary dir locations and ID later
ID=syn.getSubmissions(9615016,status="RECEIVED")
for r in ID:
  syn.get(r['entityId'],downloadLocation=.)


#make folder based on the file names
#mv the file
files = os.listdir(.)
inp_dir = working_dir
for i in files:
  prefix = i.split(".")[0]
  suffix = i.split(".")[1]
  if suffix == "sif" or suffix=="zip":
    os.mkdir(inp_dir+"/"+prefix)
    os.replace((./i), (workdir))
  else:
    continue
    print("This file is not accepted:",i)

#HOMEWORK
##update the status of not .sif and .zip into INVALID
##Can I get the file name from entityID?
##linking the file name to the entityID/submissionID so that it is easier to annotate the submission status later