# OpenCode Agents Setup Guide

This guide covers the installation and usage of seven complementary agents for full-stack software development.

## 📦 Available Agents

### 1. **senior_backend_borg** (Primary Agent)

Expert backend architect for distributed systems, APIs, and enterprise-grade backend engineering.

**Use for:**

- Building microservices and distributed systems
- Designing and implementing REST/GraphQL/gRPC APIs
- Database design, optimization, and migrations
- Kubernetes deployments and container orchestration
- Implementing SAGA patterns, CQRS, Event Sourcing
- Security (JWT, OAuth 2.0, OWASP compliance)
- Performance optimization and scalability

### 2. **senior_frontend_borg** (Primary Agent)

Expert implementation agent for building production-quality frontend applications.

**Use for:**

- Building Angular, Next.js, or Vue.js applications
- Implementing UI components (PrimeNG, Material, daisyUI)
- TypeScript, CSS, SCSS, Tailwind development
- Frontend testing and debugging
- Responsive design and accessibility
- State management and API integration

### 3. **prof_borg** (Subagent)

Expert educator for understanding concepts, patterns, and architectural decisions.

**Use for:**

- Learning concepts (CAP theorem, consistent hashing, etc.)
- Understanding design patterns (SAGA, Circuit Breaker, CQRS)
- Explaining trade-offs and architectural decisions
- Theory behind implementation decisions
- Quick technical explanations and clarifications

### 4. **code-reviewer-borg** (Subagent)

Expert code review agent for finding correctness, safety, and maintainability issues with grounded, high-signal feedback.

**Use for:**

- Reviewing diffs before commit or PR
- Finding correctness and regression risks
- Catching type safety, validation, and error handling issues
- Checking whether a bug fix includes a reproducing regression test
- Identifying the smallest necessary follow-up changes

### 5. **mother** (Subagent)

Principal engineering advisor and mother to the borgs for deeper analysis before acting.

**Use for:**

- Architecture decisions with real trade-offs
- Complex debugging, race conditions, and distributed failure analysis
- Planning refactors into minimal, low-risk increments
- Pre-implementation strategy on risky or expensive changes
- Getting one grounded recommendation before the builder agents proceed

### 6. **scv** (Subagent)

Bounded implementation worker for tightly scoped coding tasks. SCV stands for Space Construction Vehicle.

**Use for:**

- Parallel work slices with explicit file boundaries
- Focused bug fixes with reproducing tests
- Small constrained refactors inside a narrow module
- Executing a parent agent's task packet with clear verification
- Returning concise implementation handoff notes

### 7. **scv_mcp** (Subagent)

Bounded MCP implementation worker for tightly scoped Model Context Protocol tasks.

**Use for:**

- Adding or refining a single MCP tool, resource, or prompt
- Focused MCP server, app, extension, or packaging slices
- MCP-specific bug fixes with protocol-aware verification
- Narrow MCP config, transport, or integration fixes
- Returning concise MCP implementation handoff notes
- Preparing MCP packaging and registry metadata, but not publishing or releasing

---

## 🚀 Installation

### Option 1: Project-Specific (Recommended for Teams)

```bash
# Create the directory
mkdir -p .opencode/agent

# Copy all agents
cp senior_backend_borg.md .opencode/agent/
cp senior_frontend_borg.md .opencode/agent/
cp prof_borg.md .opencode/agent/
cp code-reviewer-borg.md .opencode/agent/
cp mother.md .opencode/agent/
cp scv.md .opencode/agent/
cp scv_mcp.md .opencode/agent/

# Commit to version control so team members get them
git add .opencode/
git commit -m "Add OpenCode agents for backend, frontend, education, review, strategy, and execution workers"
```

**Benefit**: Entire team uses consistent agents and workflows.

### Option 2: Global (Personal Use)

```bash
# Create the directory
mkdir -p ~/.config/opencode/agent

# Copy all agents
cp senior_backend_borg.md ~/.config/opencode/agent/
cp senior_frontend_borg.md ~/.config/opencode/agent/
cp prof_borg.md ~/.config/opencode/agent/
cp code-reviewer-borg.md ~/.config/opencode/agent/
cp mother.md ~/.config/opencode/agent/
cp scv.md ~/.config/opencode/agent/
cp scv_mcp.md ~/.config/opencode/agent/
```

**Benefit**: Available across all your projects.

### Option 3: Selective Installation

You can mix and match - install some globally and some per-project:

```bash
# Backend & frontend globally (use across all projects)
cp senior_backend_borg.md ~/.config/opencode/agent/
cp senior_frontend_borg.md ~/.config/opencode/agent/

# Education, review, strategy, and execution subagents per-project (team-specific context)
mkdir -p .opencode/agent
cp prof_borg.md .opencode/agent/
cp code-reviewer-borg.md .opencode/agent/
cp mother.md .opencode/agent/
cp scv.md .opencode/agent/
cp scv_mcp.md .opencode/agent/
```

---

## 💡 Usage

### Primary Agents (Backend & Frontend)

**Switch between them:**

```bash
# Press Tab key to cycle through primary agents
# Or use your configured switch_agent keybind
```

**Direct invocation:**

```text
@senior_backend_borg design a distributed order processing system with SAGA pattern
@senior_frontend_borg create a login form with validation and accessibility
```

**What they do:**

1. Analyze requirements (functional + non-functional)
2. Break down into manageable tasks
3. Ask for confirmation
4. Implement step-by-step with testing
5. Verify against requirements before completion

### Prof Borg (Subagent)

**Invoke with @ mention:**

```text
@prof_borg explain the CAP theorem in the context of my microservices
@prof_borg what's the difference between orchestration and choreography SAGA?
@prof_borg why use consistent hashing in distributed caching?
@prof_borg explain JWT vs session authentication trade-offs
```

**What it does:**

- Provides concise, practical explanations
- Focuses on the 20% that gives 80% value
- Uses examples and analogies
- Explains trade-offs, not just definitions
- No code implementation (read-only)

### Code Reviewer Borg (Subagent)

**Invoke with @ mention:**

```text
@code-reviewer-borg review this diff for correctness and regression risk
@code-reviewer-borg review this bug fix and check whether the tests prove it
@code-reviewer-borg find the highest-signal issues in these changes
```

**What it does:**

- Reviews code changes for correctness, safety, maintainability, and repo fit
- Prioritizes grounded, actionable findings over generic nits
- Calls out missing regression tests for bug fixes
- Stays read-only and does not modify files

### Mother (Subagent)

**Invoke with @ mention:**

```text
@mother weigh the trade-offs between these two caching designs and recommend one
@mother analyze this race condition and propose the smallest safe fix
@mother review this refactor plan and suggest a lower-risk sequence
```

**What it does:**

- Provides deeper technical analysis before implementation starts
- Recommends one primary path with explicit trade-offs and effort signals
- Favors minimal, maintainable, low-risk changes
- Stays read-only and does not modify files

### SCV (Subagent)

**Invoke with @ mention:**

```text
@scv implement this bounded task packet with the given allowed files and verification
@scv add the reproducing test and smallest safe fix inside these two files
@scv execute this narrow refactor and return a concise handoff report
```

**What it does:**

- Executes tightly scoped implementation packets
- Is instructed to stay inside explicit file boundaries from the task packet
- Starts bug fixes with a reproducing test
- Returns a concise implementation handoff with verification

**Important:** SCV boundaries are prompt-enforced, not runtime-sandboxed. Keep `allowed_files` tight, keep `verification_required` explicit, and expect SCV to return a blocker if the packet is underspecified or the verification command is not permitted.

**Canonical packet shape:**

```text
SCV task packet

skills_to_apply:
- Type-safe TypeScript only
- Bug fixes start with a reproducing test
- Reuse existing error-handling patterns

task_context:
- Goal: prevent duplicate retry scheduling
- Current behavior: retry jobs can be enqueued twice on timeout + reconnect
- Desired behavior: at most one retry job per message id
- Relevant files: src/queue/retry.ts, src/queue/retry.test.ts
- Important local context: keep current logging shape

required_output:
- add a reproducing regression test
- implement the smallest safe fix
- keep public API unchanged

allowed_files:
- src/queue/retry.ts
- src/queue/retry.test.ts

verification_required:
- run the targeted retry test

constraints:
- no new dependencies

non_goals:
- do not refactor queue architecture
```

### SCV MCP (Subagent)

**Invoke with @ mention:**

```text
@scv_mcp implement this bounded MCP task packet
@scv_mcp add the MCP tool and protocol-aware verification inside these files
@scv_mcp execute this narrow MCP App wiring change and return a concise handoff report
```

**What it does:**

- Executes tightly scoped MCP implementation packets
- Requires host, transport, and MCP surface context when runtime MCP behavior changes
- Starts MCP bug fixes with a reproducing test or protocol check
- Returns a concise handoff with protocol-aware verification

**Important:** SCV MCP boundaries are prompt-enforced, not runtime-sandboxed. Keep `allowed_files` tight, specify host and transport explicitly when runtime MCP behavior changes, and expect SCV MCP to return a blocker if MCP protocol context, verified docs, or the required verification command is missing. SCV MCP prepares code and metadata only; it does not publish, deploy, or release.

**Canonical packet shape:**

```text
SCV MCP task packet

skills_to_apply:
- Use current official MCP docs and official SDK behavior
- Model exposed behavior explicitly as tools/resources/prompts
- Never log to stdout for stdio servers

task_context:
- Goal: add an order lookup tool
- Current behavior: server exposes no order lookup capability
- Desired behavior: host can fetch order details by id
- Relevant files: src/server.ts, src/tools/orders.ts, tests/orders-tool.test.ts
- Target host(s): Claude Desktop
- Transport expectation: stdio
- Intended MCP surface: tools
- Important local context: keep the existing SDK wiring pattern

required_output:
- implement the tool
- add a targeted regression or protocol test
- keep transport and auth unchanged

allowed_files:
- src/server.ts
- src/tools/orders.ts
- tests/orders-tool.test.ts

verification_required:
- run the targeted tool test

docs_verified:
- MCP docs: tools concept and stdio guidance verified

constraints:
- no new dependencies

non_goals:
- do not add resources or prompts
- do not redesign server architecture
```

---

## 🎯 Workflow Examples

### Example 1: Full-Stack Feature Development

```bash
# Backend: Design the API
You: "@senior_backend_borg design a user authentication API with JWT"
Backend: [Analyzes, designs schema, creates OpenAPI spec, implements with tests]

# Frontend: Build the UI
You: "@senior_frontend_borg create login component that uses this API"
Frontend: [Analyzes, creates component with validation and error handling]

# Learn about the pattern
You: "@prof_borg explain why JWT is stateless and its security implications"
Prof: [Explains concept, trade-offs, and best practices]
```

### Example 2: Microservices Architecture

```bash
# Learn the pattern first
You: "@prof_borg explain SAGA pattern for distributed transactions"
Prof: [Explains orchestration vs choreography, trade-offs]

# Design the system
You: "@senior_backend_borg implement order SAGA with choreography using Kafka"
Backend: [Designs event flow, implements services, adds compensation logic]

# Clarify during implementation
You: "@prof_borg what's idempotency and why does it matter here?"
Prof: [Explains with practical examples]
```

### Example 3: Performance Optimization

```bash
# Backend investigation
You: "@senior_backend_borg optimize this slow database query"
Backend: [Analyzes query, adds indexes, rewrites with EXPLAIN analysis]

# Learn the theory
You: "@prof_borg explain database indexing strategies and B-tree vs hash indexes"
Prof: [Explains concepts and when to use each]

# Frontend optimization
You: "@senior_frontend_borg optimize component rendering performance"
Frontend: [Implements memoization, lazy loading, code splitting]
```

### Example 4: Distributed Systems Development

```bash
# Architecture design
You: "@senior_backend_borg design a distributed caching layer for our API"
Backend: [Designs with consistent hashing, Redis cluster, cache invalidation]

# Learn the concepts
You: "@prof_borg why use consistent hashing over simple modulo?"
Prof: [Explains minimal key remapping during scaling]

# Implementation continues
You: "Proceed with the implementation"
Backend: [Implements with proper TTLs, cache warming, monitoring]
```

### Example 5: Cross-Stack Development

```bash
# Backend API
You: "@senior_backend_borg create REST API for product catalog with pagination"
Backend: [Implements with Spring Boot, OpenAPI spec, database optimization]

# Frontend integration
You: "@senior_frontend_borg create product listing component using this API"
Frontend: [Builds with infinite scroll, loading states, error handling]

# Understanding integration
You: "@prof_borg explain REST pagination strategies and trade-offs"
Prof: [Explains offset vs cursor pagination, performance implications]
```

### Example 6: Review Before Merge

```bash
# Implement the change
You: "@senior_frontend_borg fix the checkout total rounding bug"
Frontend: [Adds a reproducing test, fixes the bug, and gets the test passing]

# Review the diff before merge
You: "@code-reviewer-borg review this bug fix for correctness, regression risk, and whether the tests prove it"
Reviewer: [Flags any high-signal issues and checks that the regression test really covers the bug]

# Clarify trade-offs if needed
You: "@prof_borg explain the trade-offs between rounding per line item vs only at the final total"
Prof: [Explains correctness, accounting, and UX implications]
```

### Example 7: Backend Review Flow

```bash
# Implement the bug fix
You: "@senior_backend_borg fix the duplicate order creation bug in our payment retry flow"
Backend: [Adds a reproducing test, fixes the idempotency bug, and gets the test passing]

# Review before merge
You: "@code-reviewer-borg review this backend fix for correctness, concurrency risk, and whether the regression test is strong enough"
Reviewer: [Checks for missing edge cases, race conditions, and weak test coverage]

# Clarify the underlying pattern
You: "@prof_borg explain idempotency keys and why they matter in retry-heavy distributed systems"
Prof: [Explains how they prevent duplicate side effects and where they can still fail]
```

### Example 8: Parallel SCV Work Slice

```bash
# Plan the safest decomposition first
You: "@mother split this feature into the smallest safe implementation slices"
Mother: [Recommends two disjoint file-bounded work packets]

# Execute one slice with SCV
You: "@scv SCV task packet\n\nskills_to_apply:\n- Type-safe TS only\n- Reuse existing parser patterns\n\ntask_context:\n- Goal: add parser validation\n- Current behavior: malformed input reaches downstream logic\n- Desired behavior: parser rejects malformed input early\n- Relevant files: src/parser.ts, tests/parser.test.ts\n- Important local context: preserve current public API\n\nrequired_output:\n- implement parser validation\n- add or update tests\n\nallowed_files:\n- src/parser.ts\n- tests/parser.test.ts\n\nverification_required:\n- run the parser test\n\nconstraints:\n- no new dependencies\n\nnon_goals:\n- do not refactor parser architecture"
SCV: [Implements only the bounded slice and returns files changed plus verification]

# Review the merged result
You: "@code-reviewer-borg review the combined change for correctness and regression risk"
Reviewer: [Checks the final integrated diff]
```

### Example 9: MCP SCV Slice

```bash
# Plan the MCP slice first
You: "@mother identify the smallest safe MCP implementation slice for adding a read-only order lookup capability"
Mother: [Recommends a bounded tool-only change with explicit verification]

# Execute the MCP slice
You: "@scv_mcp SCV MCP task packet\n\nskills_to_apply:\n- Use current official MCP docs and official SDK behavior\n- Model exposed behavior explicitly as tools/resources/prompts\n- Never log to stdout for stdio servers\n\ntask_context:\n- Goal: add an order lookup tool\n- Current behavior: server exposes no order lookup capability\n- Desired behavior: host can fetch order details by id\n- Relevant files: src/server.ts, src/tools/orders.ts, tests/orders-tool.test.ts\n- Target host(s): Claude Desktop\n- Transport expectation: stdio\n- Intended MCP surface: tools\n- Important local context: keep the existing SDK wiring pattern\n\nrequired_output:\n- implement the tool\n- add a targeted test\n- keep transport and auth unchanged\n\nallowed_files:\n- src/server.ts\n- src/tools/orders.ts\n- tests/orders-tool.test.ts\n\nverification_required:\n- run the targeted tool test\n\ndocs_verified:\n- MCP docs: tools concept and stdio guidance verified\n\nconstraints:\n- no new dependencies\n\nnon_goals:\n- do not add resources or prompts\n- do not redesign server architecture"
SCV MCP: [Implements the bounded MCP slice and returns files changed plus protocol-aware verification]

# Review the integrated result
You: "@code-reviewer-borg review this MCP change for correctness and regression risk"
Reviewer: [Checks the final diff and test coverage]
```

---

## ⚙️ Agent Configuration Details

### senior_backend_borg

```yaml
mode: primary
model: openai/gpt-5.3-codex
temperature: 0.2
tools:
  write: true
  edit: true
  bash: true
permission:
  edit: ask
  bash:
    "mvn *": ask
    "gradle *": ask
    "dotnet *": ask
    "npm *": ask
    "docker *": ask
    "kubectl get*": ask
    "kubectl describe*": ask
    "psql *": ask
    "mysql *": ask
    "redis-cli *": ask
    "git status": ask
    "git diff": ask
    "git log*": ask
    "*": ask
```

**Specializes in:**

- .NET Core, Spring Boot, distributed systems
- MySQL, PostgreSQL, Redis, MongoDB
- Docker, Kubernetes, service mesh
- SAGA, CQRS, Event Sourcing patterns
- JWT, OAuth 2.0, OWASP security
- Performance optimization, scalability

### senior_frontend_borg

```yaml
mode: primary
model: openai/gpt-5.3-codex
temperature: 0.2
tools:
  write: true
  edit: true
  bash: true
permission:
  edit: ask
  bash:
    "npm *": ask
    "yarn *": ask
    "pnpm *": ask
    "bun *": ask
    "git status": allow
    "git diff": allow
    "git log*": allow
    "*": ask
```

**Specializes in:**

- Angular, Next.js, Vue.js frameworks
- PrimeNG, Material, HeroUI, daisyUI components
- TypeScript, CSS, SCSS, Tailwind
- Responsive design, accessibility
- Testing with Vitest, Jest, Wallaby

### prof_borg

```yaml
mode: subagent
model: openai/gpt-5.3-codex
temperature: 0.3
tools:
  write: false
  edit: false
  bash: false
```

**Specializes in:**

- Teaching distributed systems concepts
- Explaining architectural patterns
- Clarifying trade-offs and best practices
- Algorithm and data structure explanations
- 80/20 principle: essential knowledge for maximum value

### code-reviewer-borg

```yaml
mode: subagent
model: openai/gpt-5.3-codex
temperature: 0.2
tools:
  write: false
  edit: false
  bash: false
```

**Specializes in:**

- Correctness and regression review
- Safety, validation, and error handling issues
- Type safety and maintainability concerns
- Test adequacy, especially for bug fixes
- Minimal, actionable review feedback

### mother

```yaml
mode: subagent
model: openai/gpt-5.4
temperature: 0.2
tools:
  write: false
  edit: false
  bash: false
```

**Specializes in:**

- Architecture trade-offs and strategic recommendations
- Complex debugging and failure analysis
- Refactor planning in minimal increments
- Pre-implementation risk analysis
- One high-confidence recommendation with guardrails

### scv

```yaml
mode: subagent
model: openai/gpt-5.3-codex
temperature: 0.1
tools:
  write: true
  edit: true
  bash: true
permission:
  edit: allow
  bash:
    "git reset --hard*": deny
    "git checkout --*": deny
    "git clean*": deny
    "rm -rf*": deny
    "git push*": deny
    "npm publish*": deny
    "pnpm publish*": deny
    "yarn npm publish*": deny
    "bun publish*": deny
    "gh release*": deny
    "git status": allow
    "git diff": allow
    "git log*": allow
    "npm *": ask
    "pnpm *": ask
    "yarn *": ask
    "bun *": ask
    "cargo *": ask
    "python *": ask
    "uv *": ask
    "pytest *": ask
    "*": ask
```

**Specializes in:**

- Bounded implementation packets
- Parallelizable file-scoped work
- Regression-test-first bug fixes
- Minimal changes with explicit verification
- Concise handoff output for parent agents

### scv_mcp

```yaml
mode: subagent
model: openai/gpt-5.3-codex
temperature: 0.1
tools:
  write: true
  edit: true
  bash: true
permission:
  edit: allow
  bash:
    "git reset --hard*": deny
    "git checkout --*": deny
    "git clean*": deny
    "rm -rf*": deny
    "git push*": deny
    "npm publish*": deny
    "pnpm publish*": deny
    "yarn npm publish*": deny
    "bun publish*": deny
    "gh release*": deny
    "git status": allow
    "git diff": allow
    "git log*": allow
    "npx @modelcontextprotocol/inspector *": allow
    "npm *": ask
    "pnpm *": ask
    "yarn *": ask
    "bun *": ask
    "node *": ask
    "uv *": ask
    "python *": ask
    "pip *": ask
    "cargo *": ask
    "dotnet *": ask
    "*": ask
```

**Specializes in:**

- Bounded MCP implementation packets
- Focused MCP server, app, extension, and packaging slices
- Protocol-aware verification with MCP-specific guardrails
- Minimal surface changes with explicit host and transport context
- Concise handoff output for parent agents
- No publish/deploy/release actions

---

## 🔧 Customization

### Adjust Temperature

Edit any agent file's frontmatter:

```yaml
# For more creative/varied responses
temperature: 0.5

# For very focused/deterministic responses
temperature: 0.1
```

### Change Models

```yaml
# Faster, cheaper (for simple tasks)
model: anthropic/claude-haiku-4-20250514

# Most capable (for complex tasks)
model: anthropic/claude-opus-4-20250514
```

### Modify Permissions

In `senior_backend_borg.md`:

```yaml
permission:
  edit: allow              # No confirmation needed
  bash:
    "kubectl apply*": ask  # Always ask before applying K8s changes
    "rm -rf*": deny       # Block dangerous commands
    "docker run*": allow  # Auto-approve Docker runs
```

In `senior_frontend_borg.md`:

```yaml
permission:
  bash:
    "npm run dev": allow   # Auto-approve dev server
    "npm run build": ask   # Ask before building
```

---

## 📝 Adding Project Context

Create an `AGENTS.md` file in your project root to provide context to all agents:

```markdown
# Project Context

## Architecture Overview
This is a microservices-based e-commerce platform with event-driven architecture.

### Backend Services (Spring Boot + .NET Core)
- **Order Service**: .NET Core, PostgreSQL, handles order processing
- **Payment Service**: Spring Boot, MySQL, integrates with Stripe
- **Inventory Service**: Spring Boot, MongoDB, manages stock levels
- **Notification Service**: .NET Core, RabbitMQ consumer, sends emails/SMS

### Frontend Applications
- **Customer Portal**: Next.js 14 with App Router, Tailwind + shadcn/ui
- **Admin Dashboard**: Angular 17, PrimeNG, reactive forms
- **Mobile App**: React Native (separate repo)

### Infrastructure
- **Container Orchestration**: Kubernetes (GKE)
- **Message Broker**: RabbitMQ for events, Kafka for analytics
- **Caching**: Redis cluster (3 nodes)
- **API Gateway**: Kong with rate limiting
- **Observability**: Prometheus + Grafana + Jaeger

## Architectural Patterns

### Backend Patterns
- **SAGA Pattern**: Choreography-based with RabbitMQ
- **CQRS**: Commands and queries separated in Order Service
- **Circuit Breaker**: Resilience4j for all external calls
- **Idempotency**: All POST/PUT/DELETE use idempotency keys
- **Event Sourcing**: Order events stored in event store

### Frontend Patterns
- **State Management**: Zustand for Customer Portal, NgRx for Admin
- **API Layer**: React Query for Customer Portal, Angular HttpClient with interceptors
- **Component Library**: Shared components in `@company/ui-components`
- **Routing**: File-based routing (Next.js), lazy-loaded modules (Angular)

## Code Standards

### Backend (.NET Core / Spring Boot)
- **Architecture**: Clean Architecture with domain-driven design
- **Testing**: Minimum 80% coverage, use TestContainers for integration tests
- **API Design**: OpenAPI 3.0 spec required before implementation
- **Security**: JWT with refresh tokens, RBAC, OWASP Top 10 compliance
- **Logging**: Structured logging with Serilog (.NET) / Logback (Java)
- **Naming**: 
  - Controllers: `[Entity]Controller` (e.g., `OrderController`)
  - Services: `[Entity]Service` interface + `[Entity]ServiceImpl`
  - Repositories: `[Entity]Repository`

### Frontend (Next.js / Angular)
- **TypeScript**: Strict mode enabled, no `any` types
- **Components**: Functional components with hooks (React), standalone components (Angular)
- **Styling**: Tailwind utility classes, no custom CSS unless necessary
- **Testing**: Vitest for Next.js, Jasmine/Karma for Angular
- **Accessibility**: WCAG 2.1 AA compliance mandatory
- **File Naming**:
  - Components: PascalCase (Button.tsx, UserProfile.component.ts)
  - Utilities: camelCase (formatDate.ts, apiClient.ts)
  - Types: PascalCase with .types.ts suffix (User.types.ts)

## Critical Rules

### Security
- **Never commit secrets** - use environment variables
- **Validate all inputs** - backend AND frontend
- **Parameterized queries only** - prevent SQL injection
- **Rate limiting** - implement on API gateway + service level
- **CORS** - whitelist only known origins

### Database
- **Migrations**: Always create migration scripts, never manual changes
- **Indexes**: Add indexes for all foreign keys and frequent WHERE clauses
- **Transactions**: Use transactions for multi-step operations
- **Connection Pooling**: Configure properly (HikariCP for Java, Npgsql for .NET)

### Distributed Systems
- **Idempotency**: All state-changing operations must be idempotent
- **Timeouts**: Set explicit timeouts for all external calls (default: 5s)
- **Retries**: Exponential backoff with jitter, max 3 retries
- **Circuit Breakers**: Resilience4j with 50% error threshold
- **Health Checks**: Implement /health and /ready endpoints

### Git Workflow
- **Branching**: Feature branches from `develop`, PR to `develop`
- **Commits**: Conventional Commits format (feat/fix/docs/refactor)
- **PR Requirements**: Tests pass, code review approved, no merge conflicts

## Environment Variables

### Backend Services
```

DATABASE_URL=postgresql://...
REDIS_URL=redis://...
RABBITMQ_URL=amqp://...
JWT_SECRET=...
STRIPE_API_KEY=...

```text

### Frontend Applications
```

NEXT_PUBLIC_API_URL=<https://api.example.com>
NEXT_PUBLIC_STRIPE_KEY=pk_...

```text

## Testing Strategy

### Backend
- **Unit Tests**: Business logic in service layer (80%+ coverage)
- **Integration Tests**: API endpoints with TestContainers
- **Contract Tests**: Pact for service-to-service contracts
- **Load Tests**: k6 scripts for critical endpoints

### Frontend
- **Unit Tests**: Pure functions and business logic
- **Component Tests**: Vitest + Testing Library
- **E2E Tests**: Playwright for critical user flows
- **Visual Regression**: Percy for UI consistency

## Deployment

### CI/CD Pipeline (GitHub Actions)
1. Lint and format check
2. Run unit tests
3. Run integration tests
4. Build Docker image
5. Push to container registry
6. Deploy to staging (auto)
7. Run E2E tests on staging
8. Deploy to production (manual approval)

### Kubernetes Deployment
- **Namespace**: `production`, `staging`, `development`
- **Resources**: Requests and limits defined for all pods
- **Replicas**: Min 2 for HA, HPA configured
- **Health Checks**: Liveness and readiness probes mandatory
```

All seven agents will automatically read and follow these project-specific rules.

---

## 🐛 Troubleshooting

### Agents Not Showing Up

**Check file locations:**

```bash
# Project-specific
ls .opencode/agent/

# Global
ls ~/.config/opencode/agent/

# Should see all seven agents
# senior_backend_borg.md
# senior_frontend_borg.md
# prof_borg.md
# code-reviewer-borg.md
# mother.md
# scv.md
# scv_mcp.md
```

**Verify YAML frontmatter:**

- Must have `---` delimiters at start and end
- Valid YAML syntax (no tabs, proper indentation)
- Required fields: `description`, `mode`

**Restart OpenCode:**

```bash
# Exit current session and restart
# Agents are loaded at startup
```

### Tab Key Not Switching Between Agents

- Only works for `mode: primary` agents (backend & frontend)
- `mode: subagent` agents like `prof_borg`, `code-reviewer-borg`, `mother`, `scv`, and `scv_mcp` must use `@mention`
- Check your keybind configuration
- Make sure both primary agents are installed

### Permission Prompts Too Frequent

**For backend agent**, add more auto-approved commands:

```yaml
permission:
  bash:
    "mvn clean install": allow
    "gradle build": allow
    "kubectl apply*": allow
    "docker-compose up*": allow
```

**For frontend agent**, add development commands:

```yaml
permission:
  bash:
    "npm run *": allow
    "yarn *": allow
    "pnpm *": allow
```

### Agent Using Wrong Technology

The agents will follow your project's `AGENTS.md` context file. Make sure it specifies:

- Which framework to use (Spring Boot vs .NET Core)
- Which frontend framework (Angular vs Next.js vs Vue.js)
- Architectural patterns to follow

### Want Different Behavior Per Project

**Override global agents with project-specific versions:**

1. Copy the global agent to your project:

```bash
cp ~/.config/opencode/agent/senior_backend_borg.md .opencode/agent/
# Example for the reviewer subagent:
# cp ~/.config/opencode/agent/code-reviewer-borg.md .opencode/agent/
# Example for the strategy subagent:
# cp ~/.config/opencode/agent/mother.md .opencode/agent/
# Example for the execution subagent:
# cp ~/.config/opencode/agent/scv.md .opencode/agent/
# Example for the MCP execution subagent:
# cp ~/.config/opencode/agent/scv_mcp.md .opencode/agent/
```

2. Edit the project version with project-specific instructions

3. OpenCode prioritizes project-specific agents over global ones

---

## 📚 Additional Resources

- [OpenCode Agents Documentation](https://opencode.ai/docs/agents/)
- [OpenCode Rules Documentation](https://opencode.ai/docs/rules/)
- [OpenCode Configuration](https://opencode.ai/docs/config/)
- [Anthropic Claude Documentation](https://docs.anthropic.com/)

---

## 🎓 Pro Tips

### 1. Use Agents in Combination

```bash
# Learn → Decide → Implement workflow
@prof_borg explain CQRS pattern
@mother compare CQRS vs a simpler CRUD service for our order domain
@senior_backend_borg design CQRS for order service
@senior_frontend_borg create command and query components
```

### 2. Create Project Rules

Add `AGENTS.md` to your project root with:

- Tech stack and architecture overview
- Coding standards and conventions
- Security requirements
- Testing strategies
- Deployment procedures

### 3. Customize Per Project

Override global agents with project-specific versions:

- Global: General full-stack capabilities
- Project: Specific to your stack and patterns

### 4. Use Descriptive @ Mentions

```bash
# Vague
@prof_borg explain SAGA

# Better - provides context
@prof_borg explain SAGA pattern in context of order processing with payment failure handling
```

### 5. Leverage Both Primary Agents

```bash
# Backend first
@senior_backend_borg create user API

# Then frontend
@senior_frontend_borg create user management UI using the API from backend agent
```

### 6. Iterate on Agent Instructions

These agents are living documents:

- Add technologies as you adopt them
- Refine instructions based on what works
- Share improvements with your team
- Version control in `.opencode/agent/`

### 7. Use Subagent for Quick Learning

Don't switch away from your primary agent:

```bash
# While working with backend agent
You: "Implementing distributed cache..."
You: "@prof_borg quick: consistent hashing vs simple hash"
Prof: [Brief explanation]
You: "Thanks! Using consistent hashing then..."
```

---

## 📊 Quick Reference Card

```text
┌────────────────────────────────────────────────────────────────┐
│  OPENCODE AGENTS QUICK REFERENCE                               │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  senior_backend_borg (Primary)                               │
│  • Tab to switch or @mention                                   │
│  • Distributed systems, microservices, APIs                    │
│  • .NET Core, Spring Boot, Kubernetes                          │
│  • Database optimization, SAGA, CQRS                           │
│  • Security: JWT, OAuth 2.0, OWASP                            │
│  • Default perms: asks before running most commands           │
│                                                                │
│  senior_frontend_borg (Primary)                               │
│  • Tab to switch or @mention                                   │
│  • Angular, Next.js, Vue.js                                    │
│  • TypeScript, Tailwind, component libraries                   │
│  • Responsive design, accessibility                            │
│  • Allows safe git; asks for package commands                 │
│                                                                │
│  prof_borg (Subagent)                                          │
│  • @prof_borg [question]                                       │
│  • Explains concepts and patterns                             │
│  • No code changes (read-only)                                │
│  • 80/20 teaching: essential knowledge, maximum value         │
│                                                                │
│  code-reviewer-borg (Subagent)                               │
│  • @code-reviewer-borg [review request]                      │
│  • Reviews diffs for correctness and risk                    │
│  • Calls out missing regression tests                        │
│  • No code changes (read-only)                               │
│                                                                │
│  mother (Subagent)                                           │
│  • @mother [advisory request]                                │
│  • Recommends one path for risky problems                    │
│  • Great for architecture and hard debugging                 │
│  • No code changes (read-only)                               │
│                                                                │
│  scv (Subagent)                                              │
│  • @scv [bounded task packet]                                │
│  • Executes tightly scoped implementation work               │
│  • Follows allowed file boundaries from the task packet      │
│  • Returns concise handoff plus verification                 │
│                                                                │
│  scv_mcp (Subagent)                                          │
│  • @scv_mcp [bounded MCP packet]                             │
│  • Executes focused MCP implementation work                  │
│  • Requires MCP runtime context when behavior changes        │
│  • Returns protocol-aware handoff plus verification          │
│                                                                │
│  WORKFLOW TIPS:                                               │
│  1. Learn with prof_borg                                      │
│  2. Decide with mother                                        │
│  3. Design with senior_backend_borg                           │
│  4. Execute bounded slices with scv                           │
│  5. Use scv_mcp for narrow MCP implementation slices          │
│  6. Build UI with senior_frontend_borg                        │
│  7. Review with code-reviewer-borg                            │
│  8. Iterate and refine                                        │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Common Use Cases

### Microservices Development

- **Backend**: Design services, implement APIs, add Kubernetes manifests
- **Prof**: Explain service mesh, SAGA patterns, circuit breakers
- **Frontend**: Build admin UI to manage services

### API-First Development

- **Backend**: Create OpenAPI spec, implement endpoints with tests
- **Prof**: Explain REST vs GraphQL vs gRPC trade-offs
- **Frontend**: Generate API client, build UI consuming APIs

### Database Optimization

- **Backend**: Add indexes, optimize queries, implement caching
- **Prof**: Explain indexing strategies, query optimization, CAP theorem
- **Frontend**: Implement infinite scroll, optimize data fetching

### Security Implementation

- **Backend**: Implement JWT auth, RBAC, rate limiting, OWASP compliance
- **Prof**: Explain OAuth 2.0 flows, zero-trust architecture
- **Frontend**: Implement auth UI, secure token storage, CSRF protection

### Performance Tuning

- **Backend**: Add caching, optimize database, implement async processing
- **Prof**: Explain distributed caching, eventual consistency
- **Frontend**: Code splitting, lazy loading, memoization

### CI/CD Pipeline Setup

- **Backend**: Create Dockerfiles, K8s manifests, migration scripts
- **Prof**: Explain blue-green deployments, canary releases
- **Frontend**: Build optimization, asset compression, CDN integration

### Code Review Before Merge

- **Reviewer**: Review diffs for correctness, regression risk, and maintainability
- **Backend/Frontend**: Apply only the smallest necessary fixes
- **Prof**: Explain any architectural trade-offs the review surfaces

### Architecture Decision Support

- **Mother**: Compare options and recommend the simplest viable path
- **Backend/Frontend**: Implement the chosen path incrementally
- **Reviewer**: Sanity-check the final diff before merge

### Complex Debugging

- **Mother**: Analyze the failure mode and recommend the smallest safe path forward
- **Backend/Frontend**: Implement the fix with a reproducing test first
- **Reviewer**: Check regression risk and test strength before merge

### Parallel Implementation Slices

- **Mother**: Define the smallest safe decomposition
- **SCV**: Execute disjoint task packets with explicit allowed files
- **Reviewer**: Review the integrated result after merge

### MCP Implementation Slices

- **Mother**: Define the smallest safe MCP slice with explicit host and transport assumptions
- **SCV MCP**: Execute bounded MCP task packets with protocol-aware verification
- **Reviewer**: Review the integrated MCP diff for correctness and regression risk

---

## 🚀 Getting Started Checklist

- [ ] Install agents (project-specific OR global)
- [ ] Create `AGENTS.md` in project root with context
- [ ] Test switching between primary agents with Tab
- [ ] Test invoking subagent with `@prof_borg`
- [ ] Test invoking subagent with `@code-reviewer-borg`
- [ ] Test invoking subagent with `@mother`
- [ ] Test invoking subagent with `@scv`
- [ ] Test invoking subagent with `@scv_mcp`
- [ ] Customize permissions based on your workflow
- [ ] Add project-specific rules and conventions
- [ ] Share with team (commit `.opencode/` to version control)
- [ ] Iterate and refine agent instructions over time

---

**You now have a complete AI-powered development environment!** 🎉

Use `senior_backend_borg` for services and APIs, `senior_frontend_borg` for UI, `prof_borg` to learn concepts, `mother` for deeper technical judgment, `scv` for bounded execution work, `scv_mcp` for narrow MCP implementation slices, and `code-reviewer-borg` to sharpen changes before merge. Happy coding!
