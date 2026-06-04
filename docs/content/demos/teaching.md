# Teaching support demos

These examples show a few simple ways TULIP can support teaching-oriented workflows, such as rewriting course content, checking policy-like information, and searching supporting materials with embeddings.

The curl commands are the easiest path for live demos because they keep setup light and make the request payload visible on screen. Python snippets are included where they add something useful, such as showing a streaming interaction or a slightly richer workflow.

Before running the demos, set the `.env` file to the right capability/model pair:

- for chat and workflow demos: `TUDELFT_TULIP_CAPABILITY=chat` and `TUDELFT_TULIP_MODEL_ALIAS=chat`
- for the embedding demo: `TUDELFT_TULIP_CAPABILITY=embed` and `TUDELFT_TULIP_MODEL_ALIAS=embed`

<!-- markdownlint-disable MD033 -->

<details>
<summary>If you have not cloned the repo and are working with Python, create common.py next to the example</summary>

```python title="common.py" linenums="1"
--8<-- "./examples/common.py"
```

</details>

## Demos

### Ex 1: Teaching content rewrite

- input: document snippet → output: summary / rewritten text
- show:
  - streaming (important for UX)
  - latency expectations
- endpoint: `/chat/v1`

Prompt:

```bash
Rewrite the following into a clear, student-friendly web page section:

"Our assessment policy ensures that all evaluations are aligned with course learning objectives. Students must demonstrate competency across theoretical understanding and practical application. Appeals can be submitted within 5 working days."

Make it:
- simpler language
- structured with headings
- include bullet points
```

Basic curl:

```bash
bash examples/curl-teaching-content-rewrite.sh
```

<details>
<summary>Show curl-teaching-content-rewrite.sh</summary>

```bash title="curl-teaching-content-rewrite.sh" linenums="1"
--8<-- "./examples/curl-teaching-content-rewrite.sh"
```

</details>

And streaming:

```bash
pixi run python examples/python_teaching_rewrite_stream.py
```

<details>
<summary>Show python_teaching_rewrite_stream.py</summary>

```python title="python_teaching_rewrite_stream.py" linenums="1"
--8<-- "./examples/python_teaching_rewrite_stream.py"
```

</details>

### Ex 2. Tool use or workflow automation

- A course coordinator asks a question about appeals or assessment rules.
- The assistant first checks a trusted policy source.
- It then drafts a plain-language answer for the course page or staff mailbox.

Demo script:

```bash
pixi run python examples/python_teaching_policy_workflow.py
```

<details>
<summary>Show python_teaching_policy_workflow.py</summary>

```python title="python_teaching_policy_workflow.py" linenums="1"
--8<-- "./examples/python_teaching_policy_workflow.py"
```

</details>

### Ex 3. Embeddings as the next step

Make it concrete with a search scenario:

- Imagine a lecturer asks: "Where does it say whether group work is allowed in assessment?"
- The system searches across course guides, policy pages, and FAQ content using semantic similarity, not exact keywords.
- It returns the most relevant text chunks, which can then be cited or summarized.

Demo script:

```bash
pixi run python examples/python_teaching_embedding_search.py
```

<details>
<summary>Show python_teaching_embedding_search.py</summary>

```python title="python_teaching_embedding_search.py" linenums="1"
--8<-- "./examples/python_teaching_embedding_search.py"
```

</details>

What it shows:

- one user question
- a small set of policy-like text chunks
- embedding-based ranking of the most relevant passages

<!-- markdownlint-enable MD033 -->