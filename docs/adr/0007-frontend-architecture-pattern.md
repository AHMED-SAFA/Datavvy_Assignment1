# ADR-0007: Frontend Architecture Pattern — Clean Architecture with Feature-Based Organization

## Status
**Accepted** — 2026-11-07

## Context
The Flutter Web frontend needs a scalable, maintainable architecture that separates concerns and aligns with SOLID principles. The app has two main features: authentication and vehicle management.

## Decision
We adopt **Clean Architecture** organized by technical layer with clear dependency rules:

```
┌─────────────────────────────────────────────┐
│              Presentation Layer             │
│  Pages, Widgets, BLoCs                      │
│  Depends on: Domain                         │
├─────────────────────────────────────────────┤
│                Domain Layer                 │
│  Entities, Repository Interfaces            │
│  Depends on: Nothing (innermost layer)      │
├─────────────────────────────────────────────┤
│                 Data Layer                  │
│  Models, DataSources, Repository Impls      │
│  Depends on: Domain (implements interfaces) │
└─────────────────────────────────────────────┘
```

### Dependency Rule
Dependencies point **inward** only:
- `presentation/` → `domain/` ✅
- `data/` → `domain/` ✅
- `domain/` → `data/` ❌ (never)
- `presentation/` → `data/` ❌ (never, except in DI setup)

### Package Structure
```
lib/
├── core/          # Cross-cutting concerns (theme, network, constants)
├── data/          # External world (API calls, JSON parsing, repo impls)
├── domain/        # Business rules (entities, repository interfaces)
├── presentation/  # UI (pages, widgets, BLoCs)
└── injection_container.dart  # Dependency injection wiring
```

### Dependency Injection
We use a simple **service locator** pattern via a manual `InjectionContainer` class rather than a full DI framework:

```dart
class InjectionContainer {
  static final AuthRepository authRepository = AuthRepositoryImpl(...);
  static final VehicleRepository vehicleRepository = VehicleRepositoryImpl(...);
}
```

## Rationale
- Clean Architecture ensures business logic is independent of frameworks, UI, and external services
- Layer separation makes each layer independently testable
- Repository pattern allows swapping real API calls for mock data during testing
- Manual DI is sufficient for this project size — `get_it` or `injectable` would add complexity without proportional benefit
- The `core/` package avoids duplication of shared utilities across features

## Consequences
- **Positive**: Clear boundaries. Easy to test. New features follow the same pattern. Domain entities are pure Dart — no framework dependencies.
- **Negative**: More directories and files than a flat structure. Some indirection (model → entity mapping).
- **Trade-off accepted**: The structural overhead is minimal and pays dividends in maintainability and testability.

## SOLID Alignment

| Principle | Implementation |
|-----------|---------------|
| **SRP** | Each file has one class with one responsibility. Pages render UI, BLoCs manage state, Repositories abstract data access. |
| **OCP** | New vehicle fields can be added to models/entities without changing the BLoC or page structure. |
| **LSP** | `AuthRepositoryImpl` and `VehicleRepositoryImpl` are drop-in replacements for their interfaces. |
| **ISP** | `AuthRepository` and `VehicleRepository` are separate interfaces. No client depends on methods it doesn't use. |
| **DIP** | BLoCs receive repository interfaces via constructor injection. They never instantiate repositories directly. |
