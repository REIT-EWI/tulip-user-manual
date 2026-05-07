# TLS meeting (2026-04-30)

Use curl as the default live-demo path for these teaching examples: it keeps setup light and makes the request payload visible on screen. Keep one Python script for the streaming moment.

Before running the demos, set the `.env` file to the right capability/model pair:

- for chat and workflow demos: `TUDELFT_TULIP_CAPABILITY=chat` and `TUDELFT_TULIP_MODEL_ALIAS=chat`
- for the embedding demo: `TUDELFT_TULIP_CAPABILITY=embed` and `TUDELFT_TULIP_MODEL_ALIAS=embed`

For an education audience, one strong concrete example is better than several near-identical prompt variations.

## Demo Chat

- input: document snippet → output: summary / rewritten text
- show:
  - streaming (important for UX)
  - latency expectations
- endpoint: `/chat/v1`
- default script: `examples/curl-teaching-content-rewrite.sh`
- streaming variant: `examples/python_teaching_rewrite_stream.py`

### Ex 1: Teaching content rewrite

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

And streaming:

```bash
python examples/python_teaching_rewrite_stream.py
```

Same pattern, different teaching tasks, for example:

- drafting rubric language
- summarizing student feedback
- rewriting course FAQ or policy text

That makes the point without pretending each prompt variant is a separate demo.

### Ex 2. Tool use or workflow automation

- A course coordinator asks a question about appeals or assessment rules.
- The assistant first checks a trusted policy source.
- It then drafts a plain-language answer for the course page or staff mailbox.

Demo script:

```bash
python examples/python_teaching_policy_workflow.py
```

### Ex 3. Embeddings as the next step

Make it concrete with a search scenario:

- Imagine a lecturer asks: "Where does it say whether group work is allowed in assessment?"
- The system searches across course guides, policy pages, and FAQ content using semantic similarity, not exact keywords.
- It returns the most relevant text chunks, which can then be cited or summarized.

Demo script:

```bash
python examples/python_teaching_embedding_search.py
```

What it shows:

- one user question
- a small set of policy-like text chunks
- embedding-based ranking of the most relevant passages

Useful phrasing in the meeting:

- "This is not just chat. It is a better way to search across teaching documents."
- "The value is finding the right paragraph quickly, even when the wording in the question does not match the wording in the source text."

No deep demo unless they explicitly need it.

If needed, point to `examples/curl-embedding.sh` as proof that embedding support exists, but keep the discussion at the use-case level.
