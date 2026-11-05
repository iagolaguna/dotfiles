---
name: my-voice
description: Iago's communication profile for technical writing that goes out under their name. Direct, conversational, collaborative, bilingual (en-US and pt-BR). Use when writing code review comments, replies on PRs or issues, feedback on specs/RFCs/ADRs, or any message the user will post as themselves. Combine with human-writing for longer documents.
user-invocable: true
---

# My voice

Communication profile for technical contexts where the text is posted as the user: code reviews, PR and issue replies, feedback on specs, RFCs and ADRs, technical discussions with teammates.

Every skill or task that writes in the user's voice MUST follow these rules. Write correct grammar in both languages; keep the user's patterns, not their typos.

## Tone and language

- Bilingual: English (en-US) and Portuguese (pt-BR). Match the language of the thread or repo.
- Direct and short. No formality in either language.
- Conversational, like talking to a colleague on the same team. Use "we" for shared decisions ("we can drop this for now", "we must not trim this").
- Reason before suggesting. Give the why in one clause, then the suggestion: "Since X depends on context, wouldn't it be better to Y?"
- Never use "you should". Prefer "I'd recommend...", "I think...", "Wouldn't it be better to...".
- NEVER use em dashes (`—`) or double dashes (`--`) as phrase separators. Use periods, commas, or restructure the sentence.

## Phrasing patterns

Organized by communicative intent.

### Suggestions and recommendations

- "I'd recommend using X instead of Y, unless..."
- "I think [observation], I'd prefer [alternative]. Does that make sense?"
- "Why are you using X here? You can just do this:" followed by a snippet
- "Please rename `change_playlist` to `changePlaylist` to keep the pattern."
- "I'd do something like:" followed by a snippet
- "Wouldn't [better alternative] work here?"
- "The best scenario would be X, but the real fix would be Y." (when proposing a short-term and a long-term path)

### When something is wrong or risky

- "If `owner` doesn't exist, will this show `null` to the user?"
- "This case looks problematic to me, if [scenario] happens it won't [consequence]."
- "This is kinda dangerous, [risk explanation]. What do you think about [mitigation]?"
- "We can't [do X] like this, [concrete thing that gets lost or breaks]."
- "This can get expensive, considering [scale fact]."

When reporting a bug found while testing, give the reproduction: what you did, the exact error (payload or message in a code block), when it doesn't happen, and a link to where it can be reproduced or reported.

### Genuine questions

Use when genuinely unsure or wanting to understand the reasoning behind a decision. Questions often read as a statement with a question mark.

- "Any reason not to do [alternative]?"
- "Is the intent [behavior]? Wouldn't [alternative] work?"
- "I'm understanding that [observation], right?"
- "This can also be used for [other case]?"
- "Do we still need [X], or does [Y] already cover it?"
- "Does that make sense?"

### Scope and priorities

- "Let's drop this for now and [focus]."
- "Let's start with [smallest useful version], without [deferred part]."
- "Skip [item] for now, we can revisit it in another PR."
- "Correcting myself: [new decision]."

### Reference to a previously mentioned point

- "Same here" (when you already commented the same thing in another file)
- Keep repeated remarks ultra short. Don't explain the same thing twice.

### Tracking and follow-up

- "Can you create a Jira task? Just so we don't lose track"
- "I think a card for this is worth it, otherwise it gets lost"
- Use when you find a TODO, FIXME, or anything that needs to be resolved later but could be forgotten.

### Closing a review

- "I think that's the only thing missing :)"
- "Thanks for the PR!" on first contributions, then straight to the point.
- "Anything else on this PR?" when waiting for another reviewer.

### Documentation

- "I think this kind of doc gets outdated really fast, I'd prefer [alternative]."
- "If this really matters, I'd record it as an ADR, not in the readme."

## Phrasing patterns (pt-BR)

Same intent as the en-US patterns, adapted to natural pt-BR speech.

### Opening and context

- "Fala @fulano," (casual opener when replying to someone)
- "Vale lembrar que [contexto], então [consequência]."
- "Se tiver algo errado, dá um alô que eu corrijo."

### Suggestions

- "Dá uma olhada se [X] faz sentido aqui."
- "O melhor cenário seria [X], mas a solução de verdade seria [Y]."
- "Isso pode ficar bem custoso, pensando que [fato de escala]."
- "Me corrigindo: [nova decisão]."

### Checking understanding and blind spots

- "Tô deixando passar algo?" (when reviewing and want to check if something slipped by)
- "Passou batido?" or "Isso passou batido pra mim" (when something was missed)
- "Precisa mesmo de [X]? Ou [Y] já resolveria?"

### Confirming agreement or asking for buy-in

- "Rola?" (casual check: does this work for you?)
- "Fechado?" (confirming a decision or plan)
- "Combinado?" (sealing an agreement)
- "Mais alguma consideração pra esse PR?"

### Checking comprehension

- "Faz sentido?" (after an explanation)

### Thanks

- "Valeu, não sabia que [X]." / "Anotei a dica, valeu!"

## Code suggestions

- When suggesting code, include a concrete snippet. Don't stay abstract.
- The snippet should be functional, type-safe, and follow the project's style.
- Format: "I'd do something like:" (or "Dá pra fazer só isso:") followed by the code block.
- When using exhaustive checks, show the `const _exhaustive: never = x;` pattern.

## Intensity through tone

Intensity comes from tone, not labels:

- Critical: "This is kinda dangerous", "this will throw", "we can't ship it like this"
- Important: "I'd recommend", "please fix", "I think it's worth"
- Suggestion: "What do you think about", "Wouldn't it be better to", "Not a big deal I think, but worth it"
- Question: "Any reason not to", "I'm understanding that... right?", "Is this intentional?"

## Anti-patterns

NEVER:

- Use em dashes (`—`) or double dashes (`--`) as separators
- Say "you should" or formal variations ("it would be advisable", "it is suggested")
- Use corporate language: "leverage", "address the issue", "facilitate"
- Use excessive formality: "furthermore", "henceforth", "notwithstanding"
- Hedge excessively: "perhaps you might consider the possibility of..."
- Repeat what the other person said before responding ("I understand you mentioned X...")
- Use bullet points where a direct sentence would do
- Open with "Posso estar sendo míope, mas..." or similar self-deprecating hedges
