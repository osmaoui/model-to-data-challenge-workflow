#!/usr/bin/env cwl-runner
#
# download a submitted file from Synapse and return the downloaded file
#adapted from: https://github.com/Sage-Bionetworks/SynapseWorkflowExample/blob/master/downloadSubmissionFile.cwl
cwlVersion: v1.0
class: CommandLineTool
baseCommand: grun.py #(expected command is grun.py -n "filename" -c "singularity exec...")

inputs:
  - id: submissionId
    type: int
  - id: synapseConfig
    type: File
  - workingDir:
    label: file to working directory that contain the input file
    type: string


requirements:

#step
#integrate this with the get_submission.cwl
#checking the extensiion --> maybe can integrate in get_submission.cwl to write the command there, and exxecute in this step?
#if sif : grun.py -n "filename" -c "singularity exec *.sif" -q "highmem.q"
#if zip: check the script type --> grun.py -n "filename" -c "singularity exec *.sif Rscript/python/other *.R/*py" -q "highmem.q"
#output written in workingDir/filename/output/scores.csv
#