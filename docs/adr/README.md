# Architecture Decision Records (ADR)

This directory contains the Architecture Decision Records for the **Stark Group Vehicle Management System (VMS)** — Assignment 1.

## What are ADRs?
Architecture Decision Records capture important architectural decisions along with their context and consequences. They serve as a decision log for the team and future maintainers.

## ADR Index

| ADR | Title | Status |
|-----|-------|--------|
| [ADR-0001](0001-technology-stack-selection.md) | Technology Stack Selection | ✅ Accepted |
| [ADR-0002](0002-backend-architecture-pattern.md) | Backend Architecture — Layered + SOLID | ✅ Accepted |
| [ADR-0003](0003-frontend-state-management.md) | Frontend State Management — BLoC Pattern | ✅ Accepted |
| [ADR-0004](0004-authentication-strategy.md) | Authentication — JWT Stateless Auth | ✅ Accepted |
| [ADR-0005](0005-api-design-conventions.md) | API Design Conventions — REST Standards | ✅ Accepted |
| [ADR-0006](0006-database-design.md) | Database — H2 Dev / PostgreSQL Prod | ✅ Accepted |
| [ADR-0007](0007-frontend-architecture-pattern.md) | Frontend Architecture — Clean Architecture | ✅ Accepted |

## Template
New ADRs should follow this structure:
```markdown
# ADR-NNNN: Title

## Status
Accepted / Deprecated / Superseded by ADR-XXXX

## Context
What is the issue that we're seeing that motivates this decision?

## Decision
What is the change that we're proposing and/or doing?

## Rationale
Why did we choose this over the alternatives?

## Consequences
What becomes easier or more difficult to do because of this change?
```

## Project Overview
- **Frontend**: Flutter Web 3.47.x with BLoC state management
- **Backend**: Spring Boot 3.2.x with Java 21
- **Database**: H2 (development) / PostgreSQL (production)
- **Auth**: JWT-based stateless authentication
- **API**: RESTful with standard envelope responses
