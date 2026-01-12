#Requires -Version 5.1

# Claude Code for PMM Setup Script
# Creates directories, copies templates, and guides you through goals creation

$ErrorActionPreference = "Stop"

# Set console encoding to UTF-8 for proper character display
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Helper function to write UTF-8 files without BOM (PowerShell 5.1 compatible)
function Write-UTF8FileNoBOM {
    param(
        [string]$Path,
        [string]$Content
    )
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBomEncoding)
}

# Functions
function Print-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "============================================================"
    Write-Host "  $Text"
    Write-Host "============================================================"
    Write-Host ""
}

function Print-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Print-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Print-Warning {
    param([string]$Message)
    Write-Host "! $Message" -ForegroundColor Yellow
}

function Ask-Question {
    param(
        [string]$Prompt,
        [string]$Example = ""
    )
    
    Write-Host ""
    Write-Host $Prompt
    if ($Example) {
        Write-Host $Example -ForegroundColor Blue
    }
    $response = Read-Host
    return $response
}

function Ask-Multiline {
    param([string]$Prompt)
    
    Write-Host ""
    Write-Host $Prompt
    Write-Host "(Type your answer, then press Ctrl+Z and Enter when done)"
    Write-Host ""
    
    $lines = @()
    while ($true) {
        $line = Read-Host
        if ($line -eq $null) { break }
        $lines += $line
    }
    return ($lines -join "`n")
}

# Create workspace structure first (works in both interactive and non-interactive modes)
Print-Header "Creating Workspace"

$dirs = @("Tasks", "Knowledge")
foreach ($dir in $dirs) {
    if (Test-Path $dir) {
        Print-Info "Directory exists: $dir/"
    } else {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Print-Success "Created: $dir/"
    }
}

# Create TPMM-specific knowledge folders
Print-Info "Creating knowledge base structure..."
$knowledgeDirs = @(
    "Knowledge/competitive-intel",
    "Knowledge/customer-stories",
    "Knowledge/sales-collateral",
    "Knowledge/product-positioning",
    "Knowledge/launch-plans",
    "Knowledge/technical-content"
)

foreach ($dir in $knowledgeDirs) {
    if (Test-Path $dir) {
        Print-Info "Directory exists: $dir/"
    } else {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Print-Success "Created: $dir/"
    }
}

# Copy template files
Print-Header "Setting Up Templates"

if (-not (Test-Path "AGENTS.md") -and (Test-Path "core/templates/AGENTS.md")) {
    Copy-Item "core/templates/AGENTS.md" "AGENTS.md"
    Print-Success "Copied: AGENTS.md"
} else {
    Print-Info "File exists: AGENTS.md (preserving your version)"
}

if (-not (Test-Path ".gitignore") -and (Test-Path "core/templates/gitignore")) {
    Copy-Item "core/templates/gitignore" ".gitignore"
    Print-Success "Copied: .gitignore"
} else {
    Print-Info "File exists: .gitignore (preserving your version)"
}

# Create BACKLOG.md
if (-not (Test-Path "BACKLOG.md")) {
    $backlogContent = @"
# Backlog

Drop raw notes or todos here. Say `process my backlog` when you're ready for triage.
"@
    Write-UTF8FileNoBOM -Path "BACKLOG.md" -Content $backlogContent
    Print-Success "Created: BACKLOG.md"
} else {
    Print-Info "File exists: BACKLOG.md"
}

# Check if running interactively
try {
    $null = $Host.UI.RawUI
    $isInteractive = $true
} catch {
    $isInteractive = $false
}

if (-not $isInteractive -or [Console]::IsInputRedirected) {
    # Running non-interactively (e.g., by Claude)
    Write-Host ""
    Write-Host "=== Setup Script Detected Non-Interactive Execution ==="
    Write-Host ""
    Write-Host "I see the setup script was run, but it requires interactive input."
    Write-Host "Let me help you set up your goals through conversation instead!"
    Write-Host ""
    Write-Host "I'll ask you a few questions about your goals and priorities, then"
    Write-Host "create your GOALS.md file. Ready to begin?"
    Write-Host ""
    Write-Host "Here are the questions I'll ask:"
    Write-Host ""
    Write-Host "1. What's your current role?"
    Write-Host "2. What company do you work for?"
    Write-Host "3. What product(s) or service(s) do you work on?"
    Write-Host "4. Who is your primary target audience/customer?"
    Write-Host "5. What industry or domain?"
    Write-Host "6. What are your typical work hours?"
    Write-Host "7. What's your primary professional vision?"
    Write-Host "8. What would make this a successful year?"
    Write-Host "9. What are your objectives for this quarter?"
    Write-Host "10. What are your top 3 priorities right now?"
    Write-Host ""
    Write-Host "Let's start! What's your current role?"
    exit 0
}

# Start setup
Clear-Host
Print-Header "Welcome to Claude Code for PMM Setup"

Write-Host "This setup will help you:"
Write-Host "  1. Create your workspace structure"
Write-Host "  2. Define your goals and priorities"
Write-Host "  3. Configure your AI assistant"
Write-Host ""
Write-Host "Takes about 2 minutes. Be honest and specific."
Write-Host ""
Write-Host "Note: You can update your goals anytime in the future by:"
Write-Host "      - Asking Claude: 'can we update my goals?'"
Write-Host "      - Editing GOALS.md directly in your IDE (like Cursor)"
Write-Host ""
Read-Host "Press Enter to begin..."


# Check if project is already set up
$isSetup = $false
if (Test-Path "GOALS.md") {
    $goalsContent = Get-Content "GOALS.md" -Raw
    if ($goalsContent -notmatch "This file will be generated during setup") {
        $isSetup = $true
    }
}

if ($isSetup) {
    # Project is already set up - offer update mode
    Print-Header "Project Already Set Up"
    Write-Host "I see you already have GOALS.md configured."
    Write-Host ""
    Write-Host "What would you like to update?"
    Write-Host ""
    Write-Host "  1. Full setup (recreate everything)"
    Write-Host "  2. Update goals and priorities only"
    Write-Host "  3. Update work schedule preferences only"
    Write-Host "  4. Update product/company context only"
    Write-Host "  5. Cancel (exit setup)"
    Write-Host ""
    $updateChoice = Read-Host "Enter your choice (1-5)"
    
    switch ($updateChoice) {
        "1" {
            Write-Host ""
            Write-Host "Running full setup..."
            Write-Host ""
            # Continue with full setup below
        }
        "2" {
            Write-Host ""
            Write-Host "We'll update your goals and priorities."
            Write-Host ""
            Write-Host "You can update GOALS.md by:"
            Write-Host "  - Asking Claude: 'can we update my goals?'"
            Write-Host "  - Editing GOALS.md directly in your IDE (like Cursor)"
            Write-Host ""
            exit 0
        }
        "3" {
            Write-Host ""
            Write-Host "We'll update your work schedule preferences."
            Write-Host ""
            Write-Host "You can update GOALS.md by:"
            Write-Host "  - Asking Claude: 'can we update my goals?'"
            Write-Host "  - Editing GOALS.md directly in your IDE (like Cursor)"
            Write-Host ""
            exit 0
        }
        "4" {
            Write-Host ""
            Write-Host "We'll update your product/company context."
            Write-Host ""
            Write-Host "You can update GOALS.md by:"
            Write-Host "  - Asking Claude: 'can we update my goals?'"
            Write-Host "  - Editing GOALS.md directly in your IDE (like Cursor)"
            Write-Host ""
            exit 0
        }
        "5" {
            Write-Host ""
            Write-Host "Setup cancelled."
            exit 0
        }
        default {
            Write-Host ""
            Write-Host "Invalid choice. Running full setup..."
            Write-Host ""
        }
    }
}

# Create placeholder GOALS.md (will be replaced during setup)
if (-not (Test-Path "GOALS.md")) {
    $goalsPlaceholder = @"
# Goals & Strategic Direction

*This file will be generated during setup. Run the setup script to create your personalized goals.*

## Quick Setup

Run `./setup` (Mac/Linux) or `setup.bat` (Windows) to configure your goals and priorities.
"@
    Write-UTF8FileNoBOM -Path "GOALS.md" -Content $goalsPlaceholder
    Print-Success "Created: GOALS.md (placeholder)"
} elseif (-not $isSetup) {
    Print-Info "File exists: GOALS.md (will be updated during setup)"
}

# Goals creation
Print-Header "Building Your Personal Goals"

Write-Host "Now let's create your GOALS.md - the heart of your Claude Code for PMM."
Write-Host ""
Write-Host "I'll ask you about your goals and priorities."
Write-Host "This helps your AI agent make smarter decisions about task priorities."
Write-Host ""
Write-Host "Be honest and specific - this is for you, not anyone else."
Write-Host "You can always edit GOALS.md later to refine your thinking."
Write-Host ""
Read-Host "Ready to dive in? Press Enter to start..."

# Collect answers

# Section 1: Current Situation
Print-Header "1. Current Situation"

$ans_role = Ask-Question `
    "What's your current role?" `
    "Product Manager, Senior Engineer, Founder, VP Product, Technical Product Marketing Manager"

# Section 1.5: Product & Company Context
Print-Header "1.5. Product & Company Context"

$ans_company = Ask-Question `
    "What company do you work for?" `
    ""

$ans_product = Ask-Question `
    "What product(s) or service(s) do you work on?" `
    "SaaS platform for developers, Mobile app for consumers, Enterprise security tool"

$ans_target_audience = Ask-Question `
    "Who is your primary target audience/customer?" `
    "Enterprise developers, SMB owners, Product managers, Security teams"

$ans_industry = Ask-Question `
    "What industry or domain?" `
    "Developer tools, Healthcare, Fintech, E-commerce"

$ans_competitors = Ask-Question `
    "Who are your main competitors? (optional, press Enter to skip)" `
    "Competitor A, Competitor B, or press Enter to skip"

# Section 1.6: Work Schedule Preferences
Print-Header "1.6. Work Schedule Preferences"

Write-Host "When do you do your best work? This helps prioritize tasks by time of day."
Write-Host ""

$ans_work_hours = Ask-Question `
    "What are your typical work hours? (e.g., 9am-5pm, 10am-6pm)" `
    "9am-5pm"

$ans_morning_work = Ask-Question `
    "What type of work do you prefer in the morning? (e.g., meetings, sales calls, quick tasks)" `
    "Sales enablement, stakeholder communication, competitive briefings, or press Enter for default"

$ans_afternoon_work = Ask-Question `
    "What type of work do you prefer in the afternoon? (e.g., deep work, writing, analysis)" `
    "Deep content work, launch planning, competitive analysis, or press Enter for default"

$ans_evening_work = Ask-Question `
    "What type of work do you prefer at end of day? (e.g., planning, admin, monitoring)" `
    "Competitive monitoring, community engagement, planning, or press Enter for default"

# Section 2: Vision
Print-Header "2. Your Vision"

$ans_vision = Ask-Question `
    "What's your primary professional vision? What are you building toward?" `
    "Become VP Product, Launch a successful product, Build a thriving consultancy"

# Section 3: Success This Year
Print-Header "3. Success This Year"

$ans_success_12mo = Ask-Question `
    "In 12 months, what would make you think 'this was a successful year'?" `
    "Shipped 3 major features, Built a team of 10, Became recognized expert in my field"

# Section 4: This Quarter
Print-Header "4. This Quarter"

$ans_q1_goals = Ask-Question `
    "What are your objectives for THIS QUARTER (next 90 days)?" `
    "Launch new feature, Improve activation by 20%, Build PM practice"

# Section 5: Top Priorities
Print-Header "5. Top Priorities"

$ans_top3 = Ask-Question `
    "What are your top 3 priorities right now? (Be brutally honest)" `
    "1. Ship Q1 roadmap, 2. Build thought leadership, 3. Develop AI product skills"

# Section 6: Skills & Relationships
Print-Header "6. Skills & Relationships"

$ans_skills = Ask-Question `
    "What skills do you need to develop to achieve your vision?" `
    ""

$ans_relationships = Ask-Question `
    "What key relationships or network do you need to build?" `
    ""

# Section 7: Challenges & Opportunities
Print-Header "7. Challenges & Opportunities"

$ans_challenges = Ask-Question `
    "What's currently blocking you or slowing you down?" `
    ""

$ans_opportunities = Ask-Question `
    "What opportunities are you exploring or considering?" `
    ""

# Set empty placeholders for sections user can fill in later
$ans_vision_why = ""
$ans_success_5yr = ""
$ans_current_focus = ""
$ans_q1_metrics = ""

# Generate GOALS.md
Print-Header "Generating Your GOALS.md"

$currentDate = Get-Date -Format "MMMM dd, yyyy"

# Build conditional sections
$productSection = if ($ans_product) { "### What product(s) do you work on?`n$ans_product`n" } else { "" }
$audienceSection = if ($ans_target_audience) { "### Who is your primary target audience?`n$ans_target_audience`n" } else { "" }
$industrySection = if ($ans_industry) { "### What industry or domain?`n$ans_industry`n" } else { "" }
$competitorsSection = if ($ans_competitors) { "### Main competitors`n$ans_competitors`n" } else { "" }
$morningWorkSection = if ($ans_morning_work) { "**Morning work preferences:** $ans_morning_work`n" } else { "" }
$afternoonWorkSection = if ($ans_afternoon_work) { "**Afternoon work preferences:** $ans_afternoon_work`n" } else { "" }
$eveningWorkSection = if ($ans_evening_work) { "**Evening work preferences:** $ans_evening_work`n" } else { "" }
$visionWhySection = if ($ans_vision_why) { "**Why this matters:**`n$ans_vision_why`n" } else { "" }
$q1MetricsSection = if ($ans_q1_metrics) { "**How will you measure success on those quarterly objectives?**`n$ans_q1_metrics`n" } else { "" }

$roleLine = $ans_role
if ($ans_company) {
    $roleLine += " at $ans_company"
}

$goalsContent = @"
# Goals & Strategic Direction

*Last updated: $currentDate*

## Current Context

### What's your current role?
$roleLine

$productSection$audienceSection$industrySection$competitorsSection### Work Schedule Preferences

**Typical work hours:** $ans_work_hours

$morningWorkSection$afternoonWorkSection$eveningWorkSection### What's your primary professional vision? What are you building toward?
$ans_vision

$visionWhySection## Success Criteria

### In 12 months, what would make you think 'this was a successful year'?
$ans_success_12mo

### What's your 5-year north star? Where do you want to be?
$ans_success_5yr

## Current Focus Areas

### What are you actively working on right now?
$ans_current_focus

### What are your objectives for THIS QUARTER (next 90 days)?
$ans_q1_goals

$q1MetricsSection### What skills do you need to develop to achieve your vision?
$ans_skills

### What key relationships or network do you need to build?
$ans_relationships

## Strategic Context

### What's currently blocking you or slowing you down?
$ans_challenges

### What opportunities are you exploring or considering?
$ans_opportunities

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

$ans_top3

---

**Your AI assistant uses this document to prioritize tasks and suggest what to work on each day.**

*Review and update this weekly as your priorities shift.*
"@

Write-UTF8FileNoBOM -Path "GOALS.md" -Content $goalsContent
Print-Success "Created: GOALS.md"

# Create product context file
Print-Header "Creating Product Context File"

$competitorsSectionContext = if ($ans_competitors) { "## Competitors`n$ans_competitors`n" } else { "" }
$morningDefault = if ($ans_morning_work) { $ans_morning_work } else { "Default: Sales enablement, stakeholder communication" }
$afternoonDefault = if ($ans_afternoon_work) { $ans_afternoon_work } else { "Default: Deep content work, launch planning" }
$eveningDefault = if ($ans_evening_work) { $ans_evening_work } else { "Default: Competitive monitoring, planning" }

$productContextContent = @"
# Product Context

*Auto-generated during setup - update as needed*

## Company
$ans_company

## Product/Service
$ans_product

## Target Audience
$ans_target_audience

## Industry
$ans_industry

$competitorsSectionContext## Key Messaging Points
[Add your key value propositions, positioning statements, etc.]

## Product Links
- Website: [Add URL]
- Documentation: [Add URL]
- Demo: [Add URL]

## Work Schedule
- Typical hours: $ans_work_hours
- Morning preferences: $morningDefault
- Afternoon preferences: $afternoonDefault
- Evening preferences: $eveningDefault
"@

Write-UTF8FileNoBOM -Path "Knowledge/product-context.md" -Content $productContextContent
Print-Success "Created: Knowledge/product-context.md"

# Final summary
Print-Header "Setup Complete!"

Write-Host "Your Claude Code for PMM is ready to use."
Write-Host ""
Write-Host "Next Steps:"
Write-Host ""
Write-Host "1. Review GOALS.md and refine as needed"
Write-Host "2. Read AGENTS.md to understand how your AI agent works"
Write-Host "3. Start adding tasks or notes to BACKLOG.md"
Write-Host "4. Tell your AI: 'Read AGENTS.md and help me process my backlog'"
Write-Host ""
Print-Success "Happy organizing!"
Write-Host ""
