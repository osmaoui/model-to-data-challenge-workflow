#!/usr/bin/env cwl-runner
#
# download a submitted file from Synapse and return the downloaded file
#adapted from: https://github.com/Sage-Bionetworks/SynapseWorkflowExample/blob/master/downloadSubmissionFile.cwl
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

inputs:
  - id: submissionId
    type: int
  - id: synapseConfig
    type: File

arguments:
  - valueFrom: downloadSubmissionFile.py
  - valueFrom: $(inputs.submissionId)
    prefix: -s
  - valueFrom: results.json
    prefix: -r
  - valueFrom: $(inputs.synapseConfig.path)
    prefix: -c
  - valueFrom: $(inputs.workingDir)
    prefix: -d

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: downloadSubmissionFile.py
        entry: |
          #!/usr/bin/env python
          import synapseclient
          import argparse
          import json
          import os
          from challengeutils import utils
          parser = argparse.ArgumentParser()
          parser.add_argument("-s", "--submissionId", required=True, help="Submission ID")
          parser.add_argument("-r", "--results", required=True, help="download results info")
          parser.add_argument("-c", "--synapseConfig", required=True, help="credentials file")
          parser.add_argument("-d", "--workingdir", required=True, help="working directory path")
          args = parser.parse_args()
          syn = synapseclient.Synapse(configPath=args.synapseConfig)
          syn.login()
          directory = os.mkdir(args.workingdir+"/"+"submission"+args.submissionId)
          sub = syn.getSubmission(args.submissionId, downloadLocation=directory)
          if sub.entity.concreteType!='org.sagebionetworks.repo.model.FileEntity':
            raise Exception('Expected FileEntity type but found '+sub.entity.entityType)
          file = os.listdir(directory)
          prefix = file.split(".")[0]
          suffix = file.split(".")[1]
          dirnew = args.workingdir+"/"+prefix
          if suffix == "sif" or suffix=="zip":
            os.rename(directory,dirnew)
          else:
            utils.change_submission_status(syn, args.submissionId, "INVALID")
          raise Exception('Expected ".zip" or ".sif" file,but found other type')
          result = {'entityId':sub.entity.id,'entityVersion':sub.entity.versionNumber,'submission.name':prefix}
          with open(args.results, 'w') as o:
            o.write(json.dumps(result))

#modify
outputs:
  - id: filePath
    type: File
    outputBinding:
      glob: $("submission-"+inputs.submissionId)
  - id: entity
    type:
      type: record
      fields:
      - name: id
        type: string
        outputBinding:
          glob: results.json
          loadContents: true
          outputEval: $(JSON.parse(self[0].contents)['entityId'])
      - name: version
        type: int
        outputBinding:
          glob: results.json
          loadContents: true
          outputEval: $(JSON.parse(self[0].contents)['entityVersion'])