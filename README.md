# 🚗 Stark Group — Vehicle Management System (VMS)

> **Assignment 1** — Datavvy Academy: Build a Full-Stack Web App with Flutter & Spring Boot

## Overview

A full-stack Vehicle Management System for **Stark Group** that enables fleet administrators to manage their vehicle inventory with complete CRUD operations, authentication, and business rule validation.

## Tech Stack

| Component | Technology |
|-----------|-----------|
| 🎨 Frontend | Flutter Web 3.47.x (Dart 3.13.x) |
| ⚙️ Backend | Java 21 + Spring Boot 3.2.x |
| 🗄️ Database | H2 (dev) / PostgreSQL 18.x (prod) |
| 🔐 Auth | JWT (JSON Web Tokens) |
| 📦 Build | Maven 3.9.x |
| 🏗️ State Mgmt | BLoC Pattern (flutter_bloc) |

## Features

- ✅ **Login / Authentication** — JWT-based secure login
- ✅ **Vehicle List** — View all vehicles in a responsive data table
- ✅ **Add Vehicle** — Register new vehicles with form validation
- ✅ **Edit Vehicle** — Update existing vehicle details
- ✅ **Delete Vehicle** — Remove vehicles with confirmation dialog
- ✅ **Duplicate Vehicle Number Validation** — Business rule preventing duplicate registrations
- ✅ **Real Database-Backed Data** — H2 persistent storage (no mock data)
- ✅ **Search** — Search vehicles by number and other fields

## Project Structure

```
assignment1/
├── vms-backend/          # Spring Boot REST API
│   ├── src/main/java/    # Java source code
│   ├── src/main/resources/  # Configuration
│   └── pom.xml           # Maven dependencies
├── vms-frontend/         # Flutter Web application
│   ├── lib/              # Dart source code
│   ├── web/              # Web assets
│   └── pubspec.yaml      # Flutter dependencies
└── docs/
    └── adr/              # Architecture Decision Records
```

## Architecture

### Backend (Layered Architecture + SOLID)
```
Controller → Service (Interface) → Repository → Database
     ↕            ↕                     ↕
    DTOs       Entities              JPA/H2
```

### Frontend (Clean Architecture + BLoC)
```
Pages/Widgets → BLoC → Repository (Interface) → DataSource → REST API
```

## Getting Started

### Prerequisites
- Java 21 (JDK) — `F:\jdk-21.0.6`
- Maven 3.9.x — `F:\apache-maven`
- Flutter 3.47.x — already installed
- (Optional) PostgreSQL 18.x — `F:\postgres`

### Run the Backend
```bash
cd assignment1/vms-backend

# Set JAVA_HOME
set JAVA_HOME=F:\jdk-21.0.6

# Build and run
F:\apache-maven\bin\mvn clean spring-boot:run
```
The backend starts on **http://localhost:8081**. H2 Console available at http://localhost:8081/h2-console.

### Run the Frontend
```bash
cd assignment1/vms-frontend
flutter pub get
flutter run -d chrome
```
The frontend starts on **http://localhost:8080** (or a similar port).

### Default Login
| Field | Value |
|-------|-------|
| Username | `admin` |
| Password | `admin123` |

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` | Authenticate user |
| GET | `/api/vehicles` | List all vehicles |
| GET | `/api/vehicles/{id}` | Get vehicle by ID |
| POST | `/api/vehicles` | Create new vehicle |
| PUT | `/api/vehicles/{id}` | Update vehicle |
| DELETE | `/api/vehicles/{id}` | Delete vehicle |
| GET | `/api/vehicles/search?query=x` | Search vehicles |

## Architecture Decision Records

See [docs/adr/](docs/adr/README.md) for detailed architectural decisions:
- ADR-0001: Technology Stack Selection
- ADR-0002: Backend Architecture Pattern
- ADR-0003: Frontend State Management (BLoC)
- ADR-0004: Authentication Strategy (JWT)
- ADR-0005: API Design Conventions
- ADR-0006: Database Design
- ADR-0007: Frontend Architecture Pattern

## Design Principles

This project strictly follows **SOLID** principles:
- **S**ingle Responsibility — Each class/widget has one job
- **O**pen/Closed — Extensible via interfaces, not modification
- **L**iskov Substitution — Implementations are interchangeable
- **I**nterface Segregation — Focused, minimal interfaces
- **D**ependency Inversion — Depend on abstractions, not concretions

---

*Built as part of the Datavvy Academy course: "Build a Full-Stack Web App with Flutter & Spring Boot"*
