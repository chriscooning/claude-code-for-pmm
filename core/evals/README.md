# Session Evals

Capture and review Claude Code sessions to improve AI-assisted workflows.

## Quick Start

```bash
cd core/scripts

# Generate eval for most recent session
python trace_to_eval.py session recent

# Generate evals for last 5 sessions
python trace_to_eval.py recent -n 5

# List pending evals
python trace_to_eval.py list --pending
```

## Workflow

1. **Capture**: Claude Code auto-saves sessions to `~/.claude/projects/`
2. **Generate**: Run `python trace_to_eval.py session recent`
3. **Review**: Open eval in Obsidian, check AI analysis
4. **Annotate**: Update judgement and add notes
5. **Improve**: Apply suggestions to AGENTS.md

## Eval Structure

Each eval includes:

- **User Intent**: Initial request
- **Conversation Flow**: Collapsed message turns
- **Tool Summary**: What tools were used
- **AI Analysis**: Suggested judgement, patterns, improvements
- **Manual Review**: Space for your notes

## Judgement Values

- `success`: Task completed correctly
- `partial`: Mostly done, minor issues
- `failure`: Task failed or wrong result
- `pending`: Not yet reviewed

## Axial Codes

Tag patterns for analysis:

| Code | Meaning |
|------|---------|
| `good-context-gathering` | Read/explored before acting |
| `efficient-tool-use` | Minimal tool calls |
| `iterative-refinement` | Improved based on feedback |
| `task-tracking` | Used TodoWrite |
| `incomplete` | Stopped before done |

## CLI Reference

```bash
# List projects
python trace_parser.py projects

# List sessions
python trace_parser.py sessions -n 10

# Parse specific session
python trace_parser.py parse abc123

# Generate eval
python trace_to_eval.py session abc123
```
