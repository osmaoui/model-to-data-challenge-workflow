# model-to-data-challenge-workflow
This repository will serve as a template for the `CWL` workflow and tools required to set up a `model-to-data` challenge infrastructure.

For more information about the tools, please head to [ChallengeWorkflowTemplates](https://github.com/Sage-Bionetworks/ChallengeWorkflowTemplates)


## Requirements
* `pip3 install cwltool`
* A synapse account / configuration file.  Learn more [here](https://docs.synapse.org/articles/client_configuration.html#for-developers)
* A Synapse submission to a queue.  Learn more [here](https://docs.synapse.org/articles/evaluation_queues.html#submissions)


## Testing the workflow locally

```bash
cwltool workflow.cwl --submissionId 12345 \
                      --adminUploadSynId syn12345 \
                      --submitterUploadSynId syn12345 \
                      --workflowSynapseId syn12345 \
                      --synaspeConfig ~/.synapseConfig
```
