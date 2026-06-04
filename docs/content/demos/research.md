# Research workflow demos

These examples show a few simple ways TULIP can support research-oriented workflows, such as analysing transcript-style text, working against a small codebook, and searching text collections with embeddings.

The examples are intentionally narrow and cautious. TULIP does not provide transcription, qualitative-analysis software, or project-level ethics/data-governance clearance. It provides local text-inference building blocks that can be integrated into researcher-controlled workflows.

Before running the examples, set the `.env` file to the right capability/model pair:

- for chat and workflow demos: `TUDELFT_TULIP_CAPABILITY=chat` and `TUDELFT_TULIP_MODEL_ALIAS=chat`
- for the embedding demo: `TUDELFT_TULIP_CAPABILITY=embed` and `TUDELFT_TULIP_MODEL_ALIAS=embed`

<!-- markdownlint-disable MD033 -->

<details>
<summary>If you have not cloned the repo and are working with Python, create common.py next to the example</summary>

```python title="common.py" linenums="1"
--8<-- "./examples/common.py"
```

</details>

## Ex 1: Research text analysis

- input: transcript or research-text excerpt → output: structured draft analysis
- endpoint: `/chat/v1`
- show:
  - visible request payload
  - local text inference
  - cautious structured output
  - latency expectations

Example transcript prompt:

```bash
Analyse the following interview-style transcript excerpt.

Return:
1. A short neutral summary.
2. Candidate themes or labels.
3. Evidence snippets from the text.
4. Uncertainties or follow-up questions.
5. Anything that should not be inferred from this excerpt alone.

Do not invent information. Keep interpretation cautious.

Transcript:
"Interviewer: What made you decide to use the tool?
Participant: At first I used it because others in the group were trying it. It helped me summarise notes quickly, but I was unsure whether I could paste sensitive material into it. I also found that the output sounded confident even when it missed important context."
```

Basic curl:

```bash
bash examples/curl-research-transcript-analysis.sh
```

<details>
<summary>Show curl-research-transcript-analysis.sh</summary>

```bash title="curl-research-transcript-analysis.sh" linenums="1"
--8<-- "./examples/curl-research-transcript-analysis.sh"
```

</details>

And streaming:

```bash
pixi run python examples/python_research_transcript_analysis_stream.py
```

<details>
<summary>Show python_research_transcript_analysis_stream.py</summary>

```python title="python_research_transcript_analysis_stream.py" linenums="1"
--8<-- "./examples/python_research_transcript_analysis_stream.py"
```

</details>

- Same pattern can be adapted for:
  - summarising interview excerpts
  - suggesting candidate themes
  - extracting claims or concerns from field notes
  - rewriting technical text for a broader audience
  - drafting structured metadata from free text

- **streaming** is meaningful for UX applications, and is otherwise a nice demo of capabilities. Your workflow/application may not need it!

## Ex 2. Codebook-assisted analysis

- A researcher has a small codebook, protocol, or trusted reference text.
- The workflow provides that reference as framing context.
- TULIP then analyses a transcript excerpt against the provided categories.
- The output remains a draft for researcher validation.
Demo script:

```bash
pixi run python examples/python_research_codebook_workflow.py
```

<details>
<summary>Show python_research_codebook_workflow.py</summary>

```python title="python_research_codebook_workflow.py" linenums="1"
--8<-- "./examples/python_research_codebook_workflow.py"
```

</details>

Example scenario:

- The codebook defines categories such as:
  - trust
  - usability
  - privacy concern
  - social influence
- The transcript excerpt is analysed against these candidate categories.
- The output includes:
  - suggested label
  - supporting quote
  - confidence/uncertainty
  - reason for researcher review

What it shows:

- TULIP can support structured research workflows.
- The method, coding framework, and validation remain researcher-controlled.
- The model should not silently invent categories or conclusions.

## Ex 3. Embeddings as the next step

- Imagine a researcher asks: "Where do participants mention uncertainty about using AI with sensitive data?"
- The system searches across interview excerpts, field notes, or research documents using semantic similarity, not exact keywords.
- It returns the most relevant text chunks, which can then be cited, reviewed, or summarised.

Demo script:

```bash
pixi run python examples/python_research_embedding_search.py
```

<details>
<summary>Show python_research_embedding_search.py</summary>

```python title="python_research_embedding_search.py" linenums="1"
--8<-- "./examples/python_research_embedding_search.py"
```

</details>

What it shows:

- one research question
- a small set of transcript-like text chunks
- embedding-based ranking of the most relevant passages
- retrieval as a building block for RAG/search, not a complete analysis platform

<!-- markdownlint-enable MD033 -->
