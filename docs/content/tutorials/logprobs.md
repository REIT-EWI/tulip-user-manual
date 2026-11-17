# Log probabilities

TULIP supports retrieving log probabilities for both input (prompt) tokens and generated tokens. The examples below demonstrate these capabilities using the OpenAI-compatible API. Prompt-token log probabilities can be used to calculate text perplexity, while output log probabilities allow inspection of generated-token probabilities.

--8<-- "./docs/content/tutorials/includes/setup.md:setup"

## Prompt-token log probabilities

Via `/v1/completions`, `prompt_logprobs`, and `nvext`

=== "Bash"
    ```bash title="curl-logprobs-prompt.sh" linenums="1"
    --8<-- "./examples/curl-logprobs-prompt.sh"
    ```
    Run:
    ```bash
    bash examples/curl-logprobs-prompt.sh
    ```
!!! success "Success looks like"
    One entry per prompt token; first null; remaining entries contain valid log probabilities.

## Batch prompt-token log probabilities

=== "Bash"
    ```bash title="curl-logprobs-prompt-batch.sh" linenums="1"
    --8<-- "./examples/curl-logprobs-prompt-batch.sh"
    ```
    Run:
    ```bash
    bash examples/curl-logprobs-prompt-batch.sh
    ```

!!! warning "Known limitation"
    - *Known limitation (current TULIP deployment):* Batch completions return multiple choices, but `nvext.prompt_logprobs` contains only one prompt's log probabilities. Submit prompts individually when calculating perplexity.

## Output log probabilities

Via `/v1/chat/completions`, `logprobs`

=== "Bash"
    ```bash title="curl-logprobs-output.sh" linenums="1"
    --8<-- "./examples/curl-logprobs-output.sh"
    ```
    Run:
    ```bash
    bash examples/curl-logprobs-output.sh
    ```

!!! success "Success looks like"
    One entry per generated token; each entry contains a valid log probability.

## Top-k log probabilities

Via `/v1/chat/completions`, `top_logprobs`

=== "Bash"
    ```bash title="curl-logprobs-output-top.sh" linenums="1"
    --8<-- "./examples/curl-logprobs-output-top.sh"
    ```
    Run:
    ```bash
    bash examples/curl-logprobs-output-top.sh
    ```

!!! success "Success looks like"
    One entry per generated token, containing its log probability and up to 5 top-token alternatives.
