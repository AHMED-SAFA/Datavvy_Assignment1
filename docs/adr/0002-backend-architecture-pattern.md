# ADR-0002: Backend Architecture Pattern — Layered Architecture with SOLID Principles

## Status
**Accepted** — 2026-11-07

## Context
The Spring Boot backend must handle authentication, vehicle CRUD operations, business rule validation (duplicate vehicle numbers), and expose REST APIs. The architecture must be maintainable, testable, and follow industry-standard design patterns.

## Decision
We adopt a **Layered Architecture** (Controller → Service → Repository) with strict adherence to SOLID principles:

```
┌─────────────────────────────────────────┐
│            Controller Layer             │  ← HTTP concerns only
│  (AuthController, VehicleController)    │
├─────────────────────────────────────────┤
│              DTO Layer                  │  ← Request/Response objects
│  (VehicleRequest, VehicleResponse,      │
│   LoginRequest, LoginResponse,          │
│   ApiResponse wrapper)                  │
├─────────────────────────────────────────┤
│        Mapper Layer                     │  ← Entity ↔ DTO conversion
│  (VehicleMapper)                        │
├─────────────────────────────────────────┤
│            Service Layer                │  ← Business logic
│  (VehicleService interface →            │
│   VehicleServiceImpl)                   │
├─────────────────────────────────────────┤
│          Repository Layer               │  ← Data access
│  (VehicleRepository extends JpaRepo)    │
├─────────────────────────────────────────┤
│           Entity Layer                  │  ← JPA entities
│  (Vehicle)                              │
└─────────────────────────────────────────┘
```

### SOLID Mapping

| Principle | Application |
|-----------|------------|
| **Single Responsibility** | Controllers handle HTTP, Services handle business logic, Repositories handle data access, Mappers handle conversion |
| **Open/Closed** | Service interfaces allow new implementations without modifying consumers. Global exception handler extends error handling without changing controllers |
| **Liskov Substitution** | Any `VehicleService` implementation is interchangeable. Custom exceptions extend `RuntimeException` hierarchy correctly |
| **Interface Segregation** | DTOs expose only necessary fields. Request and Response are separate interfaces. Clients never depend on unused data |
| **Dependency Inversion** | Controllers depend on `VehicleService` (interface), not `VehicleServiceImpl`. Spring IoC manages the binding |

## Rationale
- Layered architecture is the most widely understood pattern for Spring Boot applications. It provides clear separation of concerns without the complexity of hexagonal/onion architecture that would be over-engineering for this scope.
- Interface-based service layer (VehicleService → VehicleServiceImpl) allows mocking in tests and future implementation swaps.
- DTO pattern prevents JPA entity leakage to API consumers, enabling independent API and data model evolution.
- Global exception handler centralizes error formatting and prevents exception details from leaking to clients.

## Consequences
- **Positive**: Easy to test each layer independently. New team members can understand the codebase quickly. Business rules live in one place (service layer).
- **Negative**: Some boilerplate for simple CRUD (mapper, DTO, interface). For a small application, the ceremony may feel heavy.
- **Trade-off accepted**: The boilerplate cost is justified by testability, maintainability, and alignment with industry standards.
