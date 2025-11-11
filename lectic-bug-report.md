# Bug: Multi-Party Conversations Don't Switch Agents

## Version
Lectic v0.0.0-beta6 (September 19, 2025)

## Issue
When using multi-party frontmatter with `interlocutors:` (plural), the `:ask[Name]` directive does not properly switch between agents. Either the agent names switch but the prompts/behavior don't, or the agents don't load at all.

## Reproduction
```yaml
---
interlocutors:
  - name: Boggle
    provider: anthropic
    prompt: You are an expert on personal finance.
  - name: Oggle
    provider: anthropic
    prompt: You are very skeptical of conventional financial advice.
---

:ask[Boggle] What is the best way to save for retirement?
```

Run `:Lectic`, then add:

```
:ask[Oggle] What do you think about that advice?
```

Run `:Lectic` again.

## Expected
- Boggle responds with financial expertise
- Oggle responds with skepticism about conventional advice
- Each agent uses their distinct prompt

## Actual
- Error appears in output: `<error>Something went wrong when executing a command:<stdout from="Boggle">undefined</stdout><stderr from="Boggle">undefined</stderr></error>`
- Agents don't switch properly - either only names change but behavior stays the same, or agents don't load their prompts at all
- The LLM sees the error message and responds to it

## Note
Single-party conversations using `interlocutor:` (singular) work correctly.
