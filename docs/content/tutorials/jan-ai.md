# Jan.ai Integration

Use [Jan.ai](https://jan.ai/) as a desktop AI client with TULIP.

## Prerequisites

- Jan.ai installed ([download](https://jan.ai/download))
- An SRAM application token to use as your TULIP API key. See [Request Access](../getting-started/access.md).
- Access to the TU Delft network (or eduVPN)

## Setup

### 1. Add TULIP as a Model Provider

1. Open Jan.ai
2. Go to **Settings** (gear icon)
3. Click the **+** button next to **MODEL PROVIDERS**
4. Enter a **Name** (e.g., `TULIP Chat` or `TULIP Code`)
5. Enter your SRAM application token in the **API Key** field.
6. Enter the **Base URL** for your use case:
   - Chat models: `https://api.tulip.tudelft.nl/chat/v1`
   - Code models: `https://api.tulip.tudelft.nl/code/v1`
7. Click **Reload** to fetch available models

### 2. Select a Model

1. Choose a model from the list
2. The model must match the endpoint you configured (see [Available Models](../getting-started/model-mapping.md))

### 3. Configure Parameters

TULIP only supports a subset of parameters. Delete all others to avoid errors.

1. Go to **Settings** → **Assistants**
2. Click **Edit** on **Jan (default)**
3. Under **Parameters**, delete all except:
   - **Temperature**
   - **Top K**
   - **Top P**

!!! warning "Parameter Errors"
    TULIP does not support parameters like `frequency_penalty` or `presence_penalty`. Delete these if present.

## Usage

1. Start a new chat
2. Select your TULIP model from the model dropdown
3. Start chatting

## Troubleshooting

### Connection timeout

Verify you are on the TU Delft network or connected via [eduVPN](https://tudelft.eduvpn.nl/portal/home).

### "Invalid parameter" or similar errors

Go to **Settings > Assistants > Parameters** and delete all parameters except `temperature`, `top_k`, and `top_p`.

### Model not found

Ensure the model ID matches exactly what TULIP provides. See [Available Models](../getting-started/model-mapping.md).

## References

- [Jan.ai Documentation](https://www.jan.ai/docs)
- [Jan.ai Model Parameters](https://www.jan.ai/docs/desktop/model-parameters)
