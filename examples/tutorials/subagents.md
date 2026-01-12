# Subagents: Specialized AI Assistants for Your Projects

## What Are Subagents?

Subagents are specialized AI assistants you configure for specific tasks or projects. Instead of giving the same context every time you start a new chat, you define it once and the agent always knows what to do.

Think of it like this: your main AI assistant is a generalist. Subagents are specialists—a writing editor who knows your voice, a code reviewer who knows your standards, or a research assistant who knows your domain.

## Why Use Them?

**1. No more repeating yourself**
Instead of pasting "here's my writing style, here's my book structure, here are the editing rules..." every session, the subagent already knows.

**2. Consistent outputs**
The agent follows the same rules every time. Your book chapters will have consistent voice. Your code reviews will check the same things.

**3. Faster context loading**
The subagent reads only what it needs. A writing agent doesn't need your codebase context.

**4. Shareable with your team**
Commit subagents to your repo. Now everyone on the team has the same specialized assistants.

## How to Set Them Up

### Claude Code

Create a markdown file in `.claude/agents/`:

```
your-repo/
└── .claude/
    └── agents/
        └── my-agent.md
```

**Format:**
```markdown
---
name: my-agent
description: When to use this agent (shown in agent picker)
tools: Read, Edit, Write, Grep, Glob
model: sonnet
---

# System Prompt

Your instructions here. Tell the agent:
- What it does
- What files to reference
- Rules to follow
- Output format expected
```

**Use it:** Run `/agents` in Claude Code to see and select your agents.

### Factory

Create a markdown file in `.factory/droids/`:

```
your-repo/
└── .factory/
    └── droids/
        └── my-droid.md
```

**Format:**
```markdown
---
name: my-droid
description: When to use this droid
model: inherit
tools: ["Read", "Edit", "Grep", "Glob", "LS"]
---

# System Prompt

Your instructions here.
```

**Key differences from Claude Code:**
- `tools` is an array with quotes: `["Read", "Edit"]`
- Tool names differ slightly: `LS` instead of `Bash(ls)`, `FetchUrl` instead of `WebFetch`
- Use `model: inherit` to match the parent session

## Real Example: Blog Writing Agent

I created a subagent for writing a blog post. Here's what it includes:

```markdown
---
name: blog-agent
description: Agent for writing and editing ai product playbook along with aman
tools: Read, Glob, Grep, Edit, Write, WebSearch, WebFetch
model: sonnet
---

# Blog post agent

You are a specialized writing agent for my blog.

## Key Reference Files
Before writing, ALWAYS read:
- `Table of contents.md` - structure
- `aman_voice_analysis.md` - My writing voice
- `learnings.md` - Lessons from editing previous posts

## Writing Rules
- Target 2,500-3,000 words per post
- Start with a hook (quote or question)
- Use numbered steps for tutorials
- Cut 30-40% ruthlessly - if it doesn't teach, remove it
...
```

Now when I say "help me write this post", the agent already knows my voice, the book structure, and the editing rules I learned from the previous post.

## Tips

**Start simple.** Your first subagent can be 10 lines. Add detail as you learn what's missing.

**Reference files, don't duplicate.** Point to existing docs rather than copying content into the agent definition. Keeps things maintainable.

**Restrict tools.** A writing agent doesn't need `Execute`. Fewer tools = more focused behavior.

**Use description well.** This is how the AI decides when to suggest this agent. Make it clear: "Use for writing posts" not "post stuff".

## Quick Start

1. Create the directory: `mkdir -p .claude/agents` (or `.factory/droids`)
2. Create `my-agent.md` with the format above
3. Add your instructions
4. Test it out

That's it. You now have a specialist on your team.

## How I Created My Subagent Without Writing a Single Line

Here's the actual workflow I used to create a PRD writing subagent. I didn't write the agent definition myself—I had Claude Code do it by pointing it to my existing context files.

### The Prompt

I started with:
> "I want a subagent to help me write PRDs. How do I set that up in Claude Code?"

Claude Code looked up its own documentation on subagents and explained the format.

Then I said:
> "Yes let's create it. Some more context:"

And pointed to three files:
- `prd_template.md` - Our team's standard PRD structure
- `writing_guidelines.md` - How we write at the company (tone, length, formatting)
- `good_prd_examples/` - A folder with 3 PRDs that got good feedback

### What Happened

Claude Code:
1. Read all the files to understand the context
2. Extracted the template structure into required sections
3. Turned the writing guidelines into DO/DON'T rules
4. Analyzed the good examples to identify patterns
5. Created the `.claude/agents/prd-writer.md` file with everything structured properly

I then asked it to do the same for Factory droids. It fetched the Factory docs, learned the format differences, and created `.factory/droids/prd-writer.md` with the correct syntax.

### Why This Works

The key insight: **you probably already have the context documented somewhere**. Voice guides, style docs, lessons learned, project briefs—these exist in your repo or notes. Instead of manually translating them into a subagent definition, point the AI at them and let it do the synthesis.

### The Pattern

```
1. "I want a subagent for [project/task]"
2. "Here are the context files: [list paths]"
3. Let the AI read them and create the agent
4. Review and tweak as needed
```

This took me about 2 minutes. Writing the agent definition manually would have taken 20+, and I probably would have forgotten half the rules from my learnings doc.
