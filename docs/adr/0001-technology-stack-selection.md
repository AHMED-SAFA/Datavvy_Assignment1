# ADR-0001: Technology Stack Selection

## Status
**Accepted** — 2026-11-07

## Context
Stark Group requires a Vehicle Management System (VMS) as a full-stack web application. The system needs a responsive web frontend, a RESTful backend API, and persistent data storage. The course mandate specifies Flutter Web + Spring Boot + SQL.

## Decision
We will use the following technology stack:

| Layer | Technology | Version |
|-------|-----------|---------|
| Frontend | Flutter Web | 3.47.x (Dart 3.13.x) |
| Backend | Java Spring Boot | 3.2.x (Java 21) |
| Database | H2 (dev) / PostgreSQL (prod) | H2 2.x / PG 18.x |
| Build Tool | Maven | 3.9.9 |
| API Protocol | REST over HTTP/JSON | — |

## Rationale
- **Flutter Web**: Single codebase for web (and potentially mobile in future). Dart's strong typing reduces runtime errors. Widget-based composition aligns with component-driven design.
- **Spring Boot**: Mature, production-proven Java framework with excellent ecosystem (Spring Security, Spring Data JPA, Bean Validation). Convention-over-configuration reduces boilerplate.
- **H2 for development**: Zero-configuration embedded database. Allows rapid development without managing external DB services. JPA abstraction means switching to PostgreSQL requires only a config change.
- **Java 21 LTS**: Long-term support release with modern features (records, pattern matching, virtual threads).
- **Maven**: Standard build tool with broad IDE and CI/CD support.

## Consequences
- **Positive**: Type safety across the full stack. Rich ecosystem for both Flutter and Spring. Clean separation between frontend and backend via REST API.
- **Negative**: Flutter Web bundle size is larger than traditional HTML/JS. Two different languages (Dart + Java) increase cognitive load. H2 does not support all PostgreSQL features — integration tests should validate against PostgreSQL before production.
- **Risks**: Flutter Web SEO is limited (acceptable for an internal management tool). H2-to-PostgreSQL migration may surface SQL dialect differences.
