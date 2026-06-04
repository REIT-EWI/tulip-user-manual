#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

: "${TUDELFT_TULIP_API_KEY:?Set TUDELFT_TULIP_API_KEY in .env or environment}"

BASE_URL="${TUDELFT_TULIP_BASE_URL:-https://api.tulip.tudelft.nl}"
CAPABILITY="chat"
MODEL_ALIAS="chat"
API_ROOT="${BASE_URL%/}/${CAPABILITY}/v1"


SYSTEM_PROMPT="You are a careful research assistant and clear communicator. Help analyse transcript excerpts in a cautious, structured way. Distinguish evidence from interpretation, avoid overclaiming, and flag uncertainty."

USER_PROMPT='Analyse the following interview-style transcript excerpt.

Return:
1. A short neutral summary.
2. Candidate themes or labels.
3. Evidence snippets from the text.
4. Uncertainties or follow-up questions.
5. Anything that should not be inferred from this excerpt alone.

Do not invent information. Keep interpretation cautious.

Transcript:
Interviewer: What made you decide to use the tool?
Participant: At first I used it because others in the group were trying it. It helped me summarise notes quickly, but I was unsure whether I could paste sensitive material into it. I also found that the output sounded confident even when it missed important context.'

curl -sS --fail "${API_ROOT}/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d "$(jq -n \
    --arg model "${MODEL_ALIAS}" \
    --arg system_prompt "${SYSTEM_PROMPT}" \
    --arg user_prompt "${USER_PROMPT}" \
    '{
      model: $model,
      temperature: 0.2,
      messages: [
        {role: "system", content: $system_prompt},
        {role: "user", content: $user_prompt}
      ]
    }')" | jq -r '.choices[0].message.content'
