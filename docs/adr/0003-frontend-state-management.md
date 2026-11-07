# ADR-0003: Frontend State Management — BLoC Pattern

## Status
**Accepted** — 2026-11-07

## Context
The Flutter Web frontend needs state management for authentication state, vehicle list state, form state, and API loading/error states. Flutter offers multiple state management options: setState, Provider, Riverpod, BLoC, GetX, MobX, and Redux.

## Decision
We adopt the **BLoC (Business Logic Component)** pattern using the `flutter_bloc` package as the primary state management solution.

### State Management Architecture
```
UI (Pages/Widgets)
    │
    ├── dispatches Events ──→ BLoC
    │                          │
    │                          ├── calls Repository (interface)
    │                          │        │
    │                          │        └── calls DataSource (API)
    │                          │
    │◄── emits States ────────┘
    │
    └── rebuilds via BlocBuilder / BlocListener / BlocConsumer
```

### BLoCs in the System
| BLoC | Events | States |
|------|--------|--------|
| **AuthBloc** | LoginRequested, LogoutRequested, CheckAuthStatus | AuthInitial, AuthLoading, AuthAuthenticated, AuthUnauthenticated, AuthError |
| **VehicleBloc** | LoadVehicles, AddVehicle, UpdateVehicle, DeleteVehicle, SearchVehicles | VehicleInitial, VehicleLoading, VehicleLoaded, VehicleOperationSuccess, VehicleError |

## Rationale

### Why BLoC over alternatives?

| Option | Verdict | Reason |
|--------|---------|--------|
| **setState** | ❌ Rejected | Not scalable. Mixes UI and business logic. No testability. |
| **Provider** | ❌ Rejected | Good for DI but limited for complex async flows. No built-in event/state pattern. |
| **Riverpod** | ⚠️ Considered | Excellent but less commonly taught in Spring Boot + Flutter courses. More complex mental model. |
| **BLoC** | ✅ Accepted | Enforces unidirectional data flow. Separates business logic from UI. Excellent testability. Strong community and documentation. Industry-standard for enterprise Flutter. |
| **GetX** | ❌ Rejected | Too opinionated. Encourages tight coupling. Poor testability. |
| **Redux** | ❌ Rejected | Too much boilerplate for this scope. Better suited for very large applications. |

### BLoC + SOLID alignment
- **SRP**: Each BLoC handles one domain concern (auth or vehicles)
- **OCP**: New events/states can be added without modifying existing handlers
- **DIP**: BLoCs depend on abstract repository interfaces, not concrete implementations
- **ISP**: Events and states are small, focused sealed classes

## Consequences
- **Positive**: Predictable state flow. Easy to debug (every state change is traceable). Excellent test coverage possible. Consistent pattern across the app.
- **Negative**: More files per feature (event, state, bloc). Learning curve for developers new to BLoC.
- **Mitigation**: Using `equatable` package to simplify state comparison. Using `BlocConsumer` where both listening and building are needed.
