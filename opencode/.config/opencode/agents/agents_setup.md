# OpenCode Agents Setup Guide

This guide covers the installation and usage of three complementary agents for full-stack software development.

## 📦 Available Agents

### 1. **backend-systems-architect** (Primary Agent)
Expert backend architect for distributed systems, APIs, and enterprise-grade backend engineering.

**Use for:**
- Building microservices and distributed systems
- Designing and implementing REST/GraphQL/gRPC APIs
- Database design, optimization, and migrations
- Kubernetes deployments and container orchestration
- Implementing SAGA patterns, CQRS, Event Sourcing
- Security (JWT, OAuth 2.0, OWASP compliance)
- Performance optimization and scalability

### 2. **senior-frontend-dev** (Primary Agent)
Expert implementation agent for building production-quality frontend applications.

**Use for:**
- Building Angular, Next.js, or Vue.js applications
- Implementing UI components (PrimeNG, Material, daisyUI)
- TypeScript, CSS, SCSS, Tailwind development
- Frontend testing and debugging
- Responsive design and accessibility
- State management and API integration

### 3. **prof-educate-me** (Subagent)
Expert educator for understanding concepts, patterns, and architectural decisions.

**Use for:**
- Learning concepts (CAP theorem, consistent hashing, etc.)
- Understanding design patterns (SAGA, Circuit Breaker, CQRS)
- Explaining trade-offs and architectural decisions
- Theory behind implementation decisions
- Quick technical explanations and clarifications

---

## 🚀 Installation

### Option 1: Project-Specific (Recommended for Teams)

```bash
# Create the directory
mkdir -p .opencode/agent

# Copy all agents
cp backend-systems-architect.md .opencode/agent/
cp senior-frontend-dev.md .opencode/agent/
cp prof-educate-me.md .opencode/agent/

# Commit to version control so team members get them
git add .opencode/
git commit -m "Add OpenCode agents for backend, frontend, and education"
```

**Benefit**: Entire team uses consistent agents and workflows.

### Option 2: Global (Personal Use)

```bash
# Create the directory
mkdir -p ~/.config/opencode/agent

# Copy all agents
cp backend-systems-architect.md ~/.config/opencode/agent/
cp senior-frontend-dev.md ~/.config/opencode/agent/
cp prof-educate-me.md ~/.config/opencode/agent/
```

**Benefit**: Available across all your projects.

### Option 3: Selective Installation

You can mix and match - install some globally and some per-project:

```bash
# Backend & frontend globally (use across all projects)
cp backend-systems-architect.md ~/.config/opencode/agent/
cp senior-frontend-dev.md ~/.config/opencode/agent/

# Education subagent per-project (team-specific context)
mkdir -p .opencode/agent
cp prof-educate-me.md .opencode/agent/
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
```
@backend-systems-architect design a distributed order processing system with SAGA pattern
@senior-frontend-dev create a login form with validation and accessibility
```

**What they do:**
1. Analyze requirements (functional + non-functional)
2. Break down into manageable tasks
3. Ask for confirmation
4. Implement step-by-step with testing
5. Verify against requirements before completion

### Prof Educate Me (Subagent)

**Invoke with @ mention:**
```
@prof-educate-me explain the CAP theorem in the context of my microservices
@prof-educate-me what's the difference between orchestration and choreography SAGA?
@prof-educate-me why use consistent hashing in distributed caching?
@prof-educate-me explain JWT vs session authentication trade-offs
```

**What it does:**
- Provides concise, practical explanations
- Focuses on the 20% that gives 80% value
- Uses examples and analogies
- Explains trade-offs, not just definitions
- No code implementation (read-only)

---

## 🎯 Workflow Examples

### Example 1: Full-Stack Feature Development

```bash
# Backend: Design the API
You: "@backend-systems-architect design a user authentication API with JWT"
Backend: [Analyzes, designs schema, creates OpenAPI spec, implements with tests]

# Frontend: Build the UI
You: "@senior-frontend-dev create login component that uses this API"
Frontend: [Analyzes, creates component with validation and error handling]

# Learn about the pattern
You: "@prof-educate-me explain why JWT is stateless and its security implications"
Prof: [Explains concept, trade-offs, and best practices]
```

### Example 2: Microservices Architecture

```bash
# Learn the pattern first
You: "@prof-educate-me explain SAGA pattern for distributed transactions"
Prof: [Explains orchestration vs choreography, trade-offs]

# Design the system
You: "@backend-systems-architect implement order SAGA with choreography using Kafka"
Backend: [Designs event flow, implements services, adds compensation logic]

# Clarify during implementation
You: "@prof-educate-me what's idempotency and why does it matter here?"
Prof: [Explains with practical examples]
```

### Example 3: Performance Optimization

```bash
# Backend investigation
You: "@backend-systems-architect optimize this slow database query"
Backend: [Analyzes query, adds indexes, rewrites with EXPLAIN analysis]

# Learn the theory
You: "@prof-educate-me explain database indexing strategies and B-tree vs hash indexes"
Prof: [Explains concepts and when to use each]

# Frontend optimization
You: "@senior-frontend-dev optimize component rendering performance"
Frontend: [Implements memoization, lazy loading, code splitting]
```

### Example 4: Distributed Systems Development

```bash
# Architecture design
You: "@backend-systems-architect design a distributed caching layer for our API"
Backend: [Designs with consistent hashing, Redis cluster, cache invalidation]

# Learn the concepts
You: "@prof-educate-me why use consistent hashing over simple modulo?"
Prof: [Explains minimal key remapping during scaling]

# Implementation continues
You: "Proceed with the implementation"
Backend: [Implements with proper TTLs, cache warming, monitoring]
```

### Example 5: Cross-Stack Development

```bash
# Backend API
You: "@backend-systems-architect create REST API for product catalog with pagination"
Backend: [Implements with Spring Boot, OpenAPI spec, database optimization]

# Frontend integration
You: "@senior-frontend-dev create product listing component using this API"
Frontend: [Builds with infinite scroll, loading states, error handling]

# Understanding integration
You: "@prof-educate-me explain REST pagination strategies and trade-offs"
Prof: [Explains offset vs cursor pagination, performance implications]
```

---

## ⚙️ Agent Configuration Details

### backend-systems-architect

```yaml
mode: primary                   # Main backend development agent
model: claude-sonnet-4          # Balanced speed and capability
temperature: 0.2                # Low for precise, deterministic code
tools:
  write: true                   # Can create files
  edit: true                    # Can modify files
  bash: true                    # Can run commands
permissions:
  edit: ask                     # Asks before modifying files
  bash:
    "mvn|gradle|dotnet *": allow     # Auto-approve build tools
    "docker *": allow                # Auto-approve Docker
    "kubectl get|describe*": allow   # Auto-approve K8s read ops
    "psql|mysql|redis-cli *": allow  # Auto-approve DB CLIs
    "git status|diff|log*": allow    # Auto-approve safe git
    "*": ask                         # Ask for everything else
```

**Specializes in:**
- .NET Core, Spring Boot, distributed systems
- MySQL, PostgreSQL, Redis, MongoDB
- Docker, Kubernetes, service mesh
- SAGA, CQRS, Event Sourcing patterns
- JWT, OAuth 2.0, OWASP security
- Performance optimization, scalability

### senior-frontend-dev

```yaml
mode: primary                   # Main frontend development agent
model: claude-sonnet-4          # Balanced speed and capability
temperature: 0.2                # Low for precise, deterministic code
tools:
  write: true                   # Can create files
  edit: true                    # Can modify files
  bash: true                    # Can run commands
permissions:
  edit: ask                     # Asks before modifying files
  bash:
    "npm|yarn|pnpm|bun *": allow     # Auto-approve package managers
    "git status|diff|log*": allow    # Auto-approve safe git
    "*": ask                         # Ask for everything else
```

**Specializes in:**
- Angular, Next.js, Vue.js frameworks
- PrimeNG, Material, HeroUI, daisyUI components
- TypeScript, CSS, SCSS, Tailwind
- Responsive design, accessibility
- Testing with Vitest, Jest, Wallaby

### prof-educate-me

```yaml
mode: subagent                  # Invoked for specific tasks
model: claude-sonnet-4          # Same model for consistency
temperature: 0.3                # Slightly higher for clear explanations
tools:
  write: false                  # Read-only, no file creation
  edit: false                   # No modifications
  bash: false                   # No command execution
```

**Specializes in:**
- Teaching distributed systems concepts
- Explaining architectural patterns
- Clarifying trade-offs and best practices
- Algorithm and data structure explanations
- 80/20 principle: essential knowledge for maximum value

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

In `backend-systems-architect.md`:

```yaml
permission:
  edit: allow              # No confirmation needed
  bash:
    "kubectl apply*": ask  # Always ask before applying K8s changes
    "rm -rf*": deny       # Block dangerous commands
    "docker run*": allow  # Auto-approve Docker runs
```

In `senior-frontend-dev.md`:

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
```

### Frontend Applications
```
NEXT_PUBLIC_API_URL=https://api.example.com
NEXT_PUBLIC_STRIPE_KEY=pk_...
```

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

All three agents will automatically read and follow these project-specific rules.

---

## 🐛 Troubleshooting

### Agents Not Showing Up

**Check file locations:**
```bash
# Project-specific
ls .opencode/agent/

# Global
ls ~/.config/opencode/agent/

# Should see all three agents
# backend-systems-architect.md
# senior-frontend-dev.md
# prof-educate-me.md
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
- `mode: subagent` (prof-educate-me) must use `@mention`
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
cp ~/.config/opencode/agent/backend-systems-architect.md .opencode/agent/
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
# Learn → Design → Implement workflow
@prof-educate-me explain CQRS pattern
@backend-systems-architect design CQRS for order service
@senior-frontend-dev create command and query components
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
@prof-educate-me explain SAGA

# Better - provides context
@prof-educate-me explain SAGA pattern in context of order processing with payment failure handling
```

### 5. Leverage Both Primary Agents
```bash
# Backend first
@backend-systems-architect create user API

# Then frontend
@senior-frontend-dev create user management UI using the API from backend agent
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
You: "@prof-educate-me quick: consistent hashing vs simple hash"
Prof: [Brief explanation]
You: "Thanks! Using consistent hashing then..."
```

---

## 📊 Quick Reference Card

```
┌────────────────────────────────────────────────────────────────┐
│  OPENCODE AGENTS QUICK REFERENCE                               │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  backend-systems-architect (Primary)                          │
│  • Tab to switch or @mention                                   │
│  • Distributed systems, microservices, APIs                    │
│  • .NET Core, Spring Boot, Kubernetes                          │
│  • Database optimization, SAGA, CQRS                           │
│  • Security: JWT, OAuth 2.0, OWASP                            │
│  • Auto-approves: mvn, gradle, dotnet, docker, kubectl read   │
│                                                                │
│  senior-frontend-dev (Primary)                                │
│  • Tab to switch or @mention                                   │
│  • Angular, Next.js, Vue.js                                    │
│  • TypeScript, Tailwind, component libraries                   │
│  • Responsive design, accessibility                            │
│  • Auto-approves: npm, yarn, pnpm, bun                        │
│                                                                │
│  prof-educate-me (Subagent)                                   │
│  • @prof-educate-me [question]                                │
│  • Explains concepts and patterns                             │
│  • No code changes (read-only)                                │
│  • 80/20 teaching: essential knowledge, maximum value         │
│                                                                │
│  WORKFLOW TIPS:                                               │
│  1. Learn with prof-educate-me                                │
│  2. Design with backend-systems-architect                     │
│  3. Build UI with senior-frontend-dev                         │
│  4. Iterate and refine                                        │
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

---

## 🚀 Getting Started Checklist

- [ ] Install agents (project-specific OR global)
- [ ] Create `AGENTS.md` in project root with context
- [ ] Test switching between primary agents with Tab
- [ ] Test invoking subagent with `@prof-educate-me`
- [ ] Customize permissions based on your workflow
- [ ] Add project-specific rules and conventions
- [ ] Share with team (commit `.opencode/` to version control)
- [ ] Iterate and refine agent instructions over time

---

**You now have a complete AI-powered development environment!** 🎉

Use the backend agent for services and APIs, the frontend agent for UI, and the prof agent to learn concepts along the way. Happy coding!
