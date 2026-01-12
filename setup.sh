#!/usr/bin/env bash

# Claude Code for PMM Setup Script
# Creates directories, copies templates, and guides you through goals creation

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo "============================================================"
    echo "  $1"
    echo "============================================================"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

ask_question() {
    local prompt="$1"
    local example="$2"
    local response=""

    # Print prompt to terminal (stderr so it's not captured)
    echo "" >&2
    echo "$prompt" >&2
    if [ -n "$example" ]; then
        echo -e "${BLUE}$example${NC}" >&2
    fi
    read -r response
    # Return answer to stdout (gets captured)
    echo "$response"
}

ask_multiline() {
    local prompt="$1"
    local response=""

    echo ""
    echo "$prompt"
    echo "(Type your answer, then press Ctrl+D when done)"
    echo ""
    response=$(cat)
    echo "$response"
}

# Create workspace structure first (works in both interactive and non-interactive modes)
print_header "Creating Workspace"

for dir in "Tasks" "Knowledge"; do
    if [ -d "$dir" ]; then
        print_info "Directory exists: $dir/"
    else
        mkdir -p "$dir"
        print_success "Created: $dir/"
    fi
done

# Create TPMM-specific knowledge folders
print_info "Creating knowledge base structure..."
for dir in "Knowledge/competitive-intel" "Knowledge/customer-stories" "Knowledge/sales-collateral" "Knowledge/product-positioning" "Knowledge/launch-plans" "Knowledge/technical-content"; do
    if [ -d "$dir" ]; then
        print_info "Directory exists: $dir/"
    else
        mkdir -p "$dir"
        print_success "Created: $dir/"
    fi
done

# Copy template files
print_header "Setting Up Templates"

if [ ! -f "AGENTS.md" ] && [ -f "core/templates/AGENTS.md" ]; then
    cp "core/templates/AGENTS.md" "AGENTS.md"
    print_success "Copied: AGENTS.md"
else
    print_info "File exists: AGENTS.md (preserving your version)"
fi

if [ ! -f ".gitignore" ] && [ -f "core/templates/gitignore" ]; then
    cp "core/templates/gitignore" ".gitignore"
    print_success "Copied: .gitignore"
else
    print_info "File exists: .gitignore (preserving your version)"
fi

# Create BACKLOG.md
if [ ! -f "BACKLOG.md" ]; then
    cat > "BACKLOG.md" << 'EOF'
# Backlog

Drop raw notes or todos here. Say `process my backlog` when you're ready for triage.
EOF
    print_success "Created: BACKLOG.md"
else
    print_info "File exists: BACKLOG.md"
fi

# Check if running interactively
if [ ! -t 0 ]; then
    # Running non-interactively (e.g., by Claude)
    echo ""
    echo "=== Setup Script Detected Non-Interactive Execution ==="
    echo ""
    echo "I see the setup script was run, but it requires interactive input."
    echo "Let me help you set up your goals through conversation instead!"
    echo ""
    echo "I'll ask you a few questions about your goals and priorities, then"
    echo "create your GOALS.md file. Ready to begin?"
    echo ""
    echo "Here are the questions I'll ask:"
    echo ""
    echo "1. What's your current role?"
    echo "2. What company do you work for?"
    echo "3. What product(s) or service(s) do you work on?"
    echo "4. Who is your primary target audience/customer?"
    echo "5. What industry or domain?"
    echo "6. What are your typical work hours?"
    echo "7. What's your primary professional vision?"
    echo "8. What would make this a successful year?"
    echo "9. What are your objectives for this quarter?"
    echo "10. What are your top 3 priorities right now?"
    echo ""
    echo "Let's start! What's your current role?"
    exit 0
fi

# Start setup
clear
print_header "Welcome to Claude Code for PMM Setup"

echo "This setup will help you:"
echo "  1. Create your workspace structure"
echo "  2. Define your goals and priorities"
echo "  3. Configure your AI assistant"
echo ""
echo "Takes about 2 minutes. Be honest and specific."
echo ""
echo "Note: You can update your goals anytime in the future by:"
echo "      - Asking Claude: 'can we update my goals?'"
echo "      - Editing GOALS.md directly in your IDE (like Cursor)"
echo ""
read -p "Press Enter to begin..."


# Check if project is already set up
IS_SETUP=false
if [ -f "GOALS.md" ]; then
    # Check if GOALS.md is not just a placeholder
    if ! grep -q "This file will be generated during setup" "GOALS.md"; then
        IS_SETUP=true
    fi
fi

if [ "$IS_SETUP" = true ]; then
    # Project is already set up - offer update mode
    print_header "Project Already Set Up"
    echo "I see you already have GOALS.md configured."
    echo ""
    echo "What would you like to update?"
    echo ""
    echo "  1. Full setup (recreate everything)"
    echo "  2. Update goals and priorities only"
    echo "  3. Update work schedule preferences only"
    echo "  4. Update product/company context only"
    echo "  5. Cancel (exit setup)"
    echo ""
    read -p "Enter your choice (1-5): " update_choice
    
    case "$update_choice" in
        1)
            echo ""
            echo "Running full setup..."
            echo ""
            # Continue with full setup below
            ;;
        2)
            echo ""
            echo "We'll update your goals and priorities."
            echo ""
            echo "You can update GOALS.md by:"
            echo "  - Asking Claude: 'can we update my goals?'"
            echo "  - Editing GOALS.md directly in your IDE (like Cursor)"
            echo ""
            exit 0
            ;;
        3)
            echo ""
            echo "We'll update your work schedule preferences."
            echo ""
            echo "You can update GOALS.md by:"
            echo "  - Asking Claude: 'can we update my goals?'"
            echo "  - Editing GOALS.md directly in your IDE (like Cursor)"
            echo ""
            exit 0
            ;;
        4)
            echo ""
            echo "We'll update your product/company context."
            echo ""
            echo "You can update GOALS.md by:"
            echo "  - Asking Claude: 'can we update my goals?'"
            echo "  - Editing GOALS.md directly in your IDE (like Cursor)"
            echo ""
            exit 0
            ;;
        5)
            echo ""
            echo "Setup cancelled."
            exit 0
            ;;
        *)
            echo ""
            echo "Invalid choice. Running full setup..."
            echo ""
            ;;
    esac
fi

# Create placeholder GOALS.md (will be replaced during setup)
if [ ! -f "GOALS.md" ]; then
    cat > "GOALS.md" << 'EOF'
# Goals & Strategic Direction

*This file will be generated during setup. Run the setup script to create your personalized goals.*

## Quick Setup

Run `./setup` (Mac/Linux) or `setup.bat` (Windows) to configure your goals and priorities.
EOF
    print_success "Created: GOALS.md (placeholder)"
elif [ "$IS_SETUP" = false ]; then
    print_info "File exists: GOALS.md (will be updated during setup)"
fi

# Goals creation
print_header "Building Your Personal Goals"

echo "Now let's create your GOALS.md - the heart of your Claude Code for PMM."
echo ""
echo "I'll ask you about your goals and priorities."
echo "This helps your AI agent make smarter decisions about task priorities."
echo ""
echo "Be honest and specific - this is for you, not anyone else."
echo "You can always edit GOALS.md later to refine your thinking."
echo ""
read -p "Ready to dive in? Press Enter to start..."

# Collect answers (keeping it short - 5 essential questions)

# Section 1: Current Situation
print_header "1. Current Situation"

ans_role=$(ask_question \
    "What's your current role?" \
    "Product Manager, Senior Engineer, Founder, VP Product, Technical Product Marketing Manager")

# Section 1.5: Product & Company Context
print_header "1.5. Product & Company Context"

ans_company=$(ask_question \
    "What company do you work for?" \
    "")

ans_product=$(ask_question \
    "What product(s) or service(s) do you work on?" \
    "SaaS platform for developers, Mobile app for consumers, Enterprise security tool")

ans_target_audience=$(ask_question \
    "Who is your primary target audience/customer?" \
    "Enterprise developers, SMB owners, Product managers, Security teams")

ans_industry=$(ask_question \
    "What industry or domain?" \
    "Developer tools, Healthcare, Fintech, E-commerce")

ans_competitors=$(ask_question \
    "Who are your main competitors? (optional, press Enter to skip)" \
    "Competitor A, Competitor B, or press Enter to skip")

# Section 1.6: Work Schedule Preferences
print_header "1.6. Work Schedule Preferences"

echo "When do you do your best work? This helps prioritize tasks by time of day."
echo ""

ans_work_hours=$(ask_question \
    "What are your typical work hours? (e.g., 9am-5pm, 10am-6pm)" \
    "9am-5pm")

ans_morning_work=$(ask_question \
    "What type of work do you prefer in the morning? (e.g., meetings, sales calls, quick tasks)" \
    "Sales enablement, stakeholder communication, competitive briefings, or press Enter for default")

ans_afternoon_work=$(ask_question \
    "What type of work do you prefer in the afternoon? (e.g., deep work, writing, analysis)" \
    "Deep content work, launch planning, competitive analysis, or press Enter for default")

ans_evening_work=$(ask_question \
    "What type of work do you prefer at end of day? (e.g., planning, admin, monitoring)" \
    "Competitive monitoring, community engagement, planning, or press Enter for default")

# Section 2: Vision
print_header "2. Your Vision"

ans_vision=$(ask_question \
    "What's your primary professional vision? What are you building toward?" \
    "Become VP Product, Launch a successful product, Build a thriving consultancy")

# Section 3: Success This Year
print_header "3. Success This Year"

ans_success_12mo=$(ask_question \
    "In 12 months, what would make you think 'this was a successful year'?" \
    "Shipped 3 major features, Built a team of 10, Became recognized expert in my field")

# Section 4: This Quarter
print_header "4. This Quarter"

ans_q1_goals=$(ask_question \
    "What are your objectives for THIS QUARTER (next 90 days)?" \
    "Launch new feature, Improve activation by 20%, Build PM practice")

# Section 5: Top Priorities
print_header "5. Top Priorities"

ans_top3=$(ask_question \
    "What are your top 3 priorities right now? (Be brutally honest)" \
    "1. Ship Q1 roadmap, 2. Build thought leadership, 3. Develop AI product skills")

# Section 6: Skills & Relationships
print_header "6. Skills & Relationships"

ans_skills=$(ask_question \
    "What skills do you need to develop to achieve your vision?" \
    "")

ans_relationships=$(ask_question \
    "What key relationships or network do you need to build?" \
    "")

# Section 7: Challenges & Opportunities
print_header "7. Challenges & Opportunities"

ans_challenges=$(ask_question \
    "What's currently blocking you or slowing you down?" \
    "")

ans_opportunities=$(ask_question \
    "What opportunities are you exploring or considering?" \
    "")

# Set empty placeholders for sections user can fill in later
ans_vision_why=""
ans_success_5yr=""
ans_current_focus=""
ans_q1_metrics=""

# Generate GOALS.md
print_header "Generating Your GOALS.md"

CURRENT_DATE=$(date +"%B %d, %Y")

cat > "GOALS.md" << EOF
# Goals & Strategic Direction

*Last updated: ${CURRENT_DATE}*

## Current Context

### What's your current role?
${ans_role}${ans_company:+ at }${ans_company}

${ans_product:+### What product(s) do you work on?
${ans_product}}

${ans_target_audience:+### Who is your primary target audience?
${ans_target_audience}}

${ans_industry:+### What industry or domain?
${ans_industry}}

${ans_competitors:+### Main competitors
${ans_competitors}}

### Work Schedule Preferences

**Typical work hours:** ${ans_work_hours}

${ans_morning_work:+**Morning work preferences:** ${ans_morning_work}}

${ans_afternoon_work:+**Afternoon work preferences:** ${ans_afternoon_work}}

${ans_evening_work:+**Evening work preferences:** ${ans_evening_work}}

### What's your primary professional vision? What are you building toward?
${ans_vision}

${ans_vision_why:+**Why this matters:**
${ans_vision_why}}

## Success Criteria

### In 12 months, what would make you think 'this was a successful year'?
${ans_success_12mo}

### What's your 5-year north star? Where do you want to be?
${ans_success_5yr}

## Current Focus Areas

### What are you actively working on right now?
${ans_current_focus}

### What are your objectives for THIS QUARTER (next 90 days)?
${ans_q1_goals}

${ans_q1_metrics:+**How will you measure success on those quarterly objectives?**
${ans_q1_metrics}}

### What skills do you need to develop to achieve your vision?
${ans_skills}

### What key relationships or network do you need to build?
${ans_relationships}

## Strategic Context

### What's currently blocking you or slowing you down?
${ans_challenges}

### What opportunities are you exploring or considering?
${ans_opportunities}

## Priority Framework

When evaluating new tasks and commitments:

**P0 (Critical/Urgent)** - Must do THIS WEEK:
- Directly advances quarterly objectives
- Time-sensitive opportunities
- Critical stakeholder communication
- Immediate blockers to remove

**P1 (Important)** - This month:
- Builds key skills or expertise
- Advances product strategy
- Significant career development
- High-value learning opportunities

**P2 (Normal)** - Scheduled work:
- Supports broader objectives
- Maintains stakeholder relationships
- Operational efficiency
- General learning and exploration

**P3 (Low)** - Nice to have:
- Administrative tasks
- Speculative projects
- Activities without clear advancement value

## What are your top 3 priorities right now?

${ans_top3}

---

**Your AI assistant uses this document to prioritize tasks and suggest what to work on each day.**

*Review and update this weekly as your priorities shift.*

EOF

print_success "Created: GOALS.md"

# Create product context file
print_header "Creating Product Context File"

cat > "Knowledge/product-context.md" << EOF
# Product Context

*Auto-generated during setup - update as needed*

## Company
${ans_company}

## Product/Service
${ans_product}

## Target Audience
${ans_target_audience}

## Industry
${ans_industry}

${ans_competitors:+## Competitors
${ans_competitors}}

## Key Messaging Points
[Add your key value propositions, positioning statements, etc.]

## Product Links
- Website: [Add URL]
- Documentation: [Add URL]
- Demo: [Add URL]

## Work Schedule
- Typical hours: ${ans_work_hours}
- Morning preferences: ${ans_morning_work:-Default: Sales enablement, stakeholder communication}
- Afternoon preferences: ${ans_afternoon_work:-Default: Deep content work, launch planning}
- Evening preferences: ${ans_evening_work:-Default: Competitive monitoring, planning}
EOF

print_success "Created: Knowledge/product-context.md"

# Final summary
print_header "Setup Complete!"

echo "Your Claude Code for PMM is ready to use."
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Review GOALS.md and refine as needed"
echo "2. Read AGENTS.md to understand how your AI agent works"
echo "3. Start adding tasks or notes to BACKLOG.md"
echo "4. Tell your AI: 'Read AGENTS.md and help me process my backlog'"
echo ""
print_success "Happy organizing!"
echo ""
