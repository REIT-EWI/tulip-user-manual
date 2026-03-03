# Data Handling and Model Behavior

## Inference-Only Operation

TULIP-hosted models operate strictly in inference mode.

* Model weights are static.
* No fine-tuning or online learning occurs.
* User input does not modify the model.
* Prompts are not used to retrain or improve models.

## Session Memory

Models process only the content provided within the current request.

* There is no cross-session memory.
* The system does not retain conversational state once a request completes.
* Each API call is stateless unless the client explicitly sends prior context.

## Data Persistence

TULIP does not store prompts or responses for training purposes.

* The platform does not retain user input as part of model behavior.
* Any persistence of prompts or responses depends on how the calling application handles logging or storage.
* Users deploying applications on top of TULIP are responsible for reviewing their own data storage policies.

## External Data Sharing

All inference is performed locally within TU Delft infrastructure.

* No user data is transmitted to external model providers.
* No data is used for model training outside TU Delft.