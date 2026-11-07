# Stark Group Vehicle Management System

Assignment 1 for the Datavvy Academy course **Build a Full-Stack Web App with Flutter & Spring Boot**.

The VMS is a full-stack fleet administration application with JWT login, vehicle CRUD, duplicate vehicle-number validation, search, responsive Flutter Web screens, and PostgreSQL persistence.

## Features

- Public landing page and login
- JWT authentication
- Vehicle list with desktop table and mobile cards
- Register, edit, and delete vehicles
- Duplicate vehicle-number validation
- Search by number, brand, model, owner, or color
- Client-side vehicle pagination with 10 rows per page by default and selectable page sizes
- Manufacturing year calendar picker
- Registration date picker
- Active/inactive status
- Dark/light theme
- Responsive sidebar navigation
- PostgreSQL persistence
- Backend unit/integration tests
- Flutter analyzer and widget tests

## Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter Web / Dart |
| State | `flutter_bloc` / Cubit |
| HTTP | Dio |
| Frontend architecture | Clean Architecture |
| Backend | Java 21 / Spring Boot 3.2.5 |
| API | REST / JSON |
| Database | PostgreSQL |
| ORM | Spring Data JPA / Hibernate |
| Authentication | Spring Security / JWT |
| Build | Maven 3.9.x |

## Requirements

- Java 21
- Maven 3.9.x
- Flutter SDK
- Chrome
- PostgreSQL
- pgAdmin 4 (recommended)

Expected local tool paths:

```text
F:\jdk-21.0.6
F:\apache-maven
```

## Project Structure

```text
assignment1/
├── .gitignore
├── README.md
├── docs/adr/                 # Architecture Decision Records
├── vms-backend/
│   ├── pom.xml
│   └── src/
│       ├── main/java/com/starkgroup/vms/
│       │   ├── config/
│       │   ├── controller/
│       │   ├── dto/
│       │   ├── entity/
│       │   ├── enums/
│       │   ├── exception/
│       │   ├── mapper/
│       │   ├── repository/
│       │   ├── security/
│       │   └── service/
│       ├── main/resources/
│       │   ├── application.properties
│       │   └── data.sql
│       └── test/java/
└── vms-frontend/
    ├── pubspec.yaml
    ├── lib/
    │   ├── core/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       ├── app/
    │       ├── auth/
    │       ├── blocs/
    │       ├── landing/
    │       └── vehicles/
    └── test/
```

## PostgreSQL Setup

### Create the database in pgAdmin

1. Open pgAdmin 4.
2. Connect to the local PostgreSQL server.
3. Right-click **Databases**.
4. Choose **Create → Database**.
5. Set the name to `vmsdb`.
6. Set owner to `postgres`.

Default connection:

```text
Host: localhost
Port: 5432
Database: vmsdb
Username: postgres
```

The active backend configuration is in `vms-backend/src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/vmsdb
spring.datasource.username=postgres
spring.datasource.password=${DB_PASSWORD:postgres}
```

Use your real PostgreSQL password through an environment variable.

Git Bash:

```bash
export DB_PASSWORD="your-postgres-password"
```

PowerShell:

```powershell
$env:DB_PASSWORD = "your-postgres-password"
```

On startup, Hibernate creates or updates the `vehicles` table and `data.sql` inserts 30 sample vehicles. The seed script uses PostgreSQL-compatible `ON CONFLICT DO NOTHING`, so it is safe to run repeatedly.

View data in pgAdmin Query Tool:

```sql
SELECT *
FROM public.vehicles
ORDER BY id DESC;
```

## Run the Backend

Git Bash:

```bash
cd /e/datavvy/assignment1/vms-backend

export JAVA_HOME="F:/jdk-21.0.6"
export PATH="$JAVA_HOME/bin:$PATH"

"F:/apache-maven/bin/mvn.cmd" spring-boot:run
```

PowerShell:

```powershell
Set-Location E:\datavvy\assignment1\vms-backend
$env:JAVA_HOME = "F:\jdk-21.0.6"
& "F:\apache-maven\bin\mvn.cmd" spring-boot:run
```

Backend URL:

```text
http://localhost:8081
```

Successful PostgreSQL logs contain:

```text
HikariPool-1 - Added connection org.postgresql.jdbc.PgConnection
HikariPool-1 - Start completed
```

## Run the Frontend

Open a second terminal:

```bash
cd /e/datavvy/assignment1/vms-frontend
flutter pub get
flutter run -d chrome --web-port 8080
```

Open:

```text
http://localhost:8080
```

The frontend calls `http://localhost:8081/api`.

## Login

Development credentials:

```text
Username: admin
Password: admin123
```

The application intentionally does not prefill these values.

## API Reference

All vehicle endpoints require:

```http
Authorization: Bearer <jwt-token>
```

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/api/auth/login` | Authenticate |
| GET | `/api/vehicles` | List vehicles |
| GET | `/api/vehicles/{id}` | Get one vehicle |
| POST | `/api/vehicles` | Create vehicle |
| PUT | `/api/vehicles/{id}` | Update vehicle |
| DELETE | `/api/vehicles/{id}` | Delete vehicle |
| GET | `/api/vehicles/search?query=Audi` | Search vehicles |

Login request:

```json
{
  "username": "admin",
  "password": "admin123"
}
```

Vehicle request:

```json
{
  "vehicleNumber": "SG-CAR-007",
  "brand": "Tesla",
  "model": "Model 3",
  "type": "CAR",
  "color": "White",
  "year": 2024,
  "ownerName": "Tony Stark",
  "status": "ACTIVE",
  "registrationDate": "2024-06-01"
}
```

Valid types:

```text
CAR, TRUCK, BIKE, SUV, VAN
```

Valid statuses:

```text
ACTIVE, INACTIVE
```

## Business Rules

- Vehicle number is required and must be 2–50 characters.
- Vehicle numbers are normalized to uppercase.
- Vehicle numbers must be unique.
- Brand, model, color, and owner are required.
- Manufacturing year must be between 1886 and 2100.
- Type, status, and registration date are required.
- Protected endpoints require a valid JWT.
- Duplicate numbers return HTTP `409 Conflict`.

## Architecture

### Backend

```text
Controller → Service Interface → Repository → PostgreSQL
     ↕             ↕
    DTOs        Entities / Mapper
```

Controllers handle HTTP, services contain business rules, repositories handle persistence, DTOs define API contracts, and security filters validate JWTs.

### Frontend

```text
Presentation → Cubit → Domain Repository
                          ↓
                  Data Repository
                          ↓
                    Remote DataSource
                          ↓
                           API
```

Presentation features are separated into `landing`, `auth`, and `vehicles`. Cubits receive repository abstractions through constructor injection.

## SOLID Principles

- **Single Responsibility:** Each controller, service, repository, Cubit, and page has one primary responsibility.
- **Open/Closed:** New data-source implementations can be added behind repository interfaces.
- **Liskov Substitution:** Repository implementations can be replaced by test doubles.
- **Interface Segregation:** Authentication and vehicle contracts are separate.
- **Dependency Inversion:** Presentation logic depends on domain interfaces, not HTTP clients.

## Testing

Backend:

```bash
cd /e/datavvy/assignment1/vms-backend
export JAVA_HOME="F:/jdk-21.0.6"
"F:/apache-maven/bin/mvn.cmd" clean test
```

Frontend:

```bash
cd /e/datavvy/assignment1/vms-frontend
flutter analyze
flutter test
flutter build web
```

Covered backend behavior includes login, authorization, CRUD, search, duplicate validation, and service rules.

## Hot Reload

With Flutter running:

```text
r  Hot reload
R  Hot restart
q  Stop
```

## Troubleshooting

### PostgreSQL connection refused

```powershell
Get-Service *postgres*
Test-NetConnection localhost -Port 5432
```

### Password authentication failed

```powershell
$env:DB_PASSWORD = "your-postgres-password"
```

Restart Spring Boot afterward.

### No vehicles found

Check backend logs for `PgConnection`, then run:

```sql
SELECT COUNT(*) FROM public.vehicles;
```

If the count is zero, restart Spring Boot and inspect the `data.sql` initialization error.

### Frontend cannot connect

Confirm Spring Boot is running on port `8081`, Flutter is running on port `8080`, and the frontend API base URL is `http://localhost:8081/api`.

## Architecture Decision Records

- [ADR-0001: Technology Stack](docs/adr/0001-technology-stack-selection.md)
- [ADR-0002: Backend Architecture](docs/adr/0002-backend-architecture-pattern.md)
- [ADR-0003: BLoC State Management](docs/adr/0003-frontend-state-management.md)
- [ADR-0004: JWT Authentication](docs/adr/0004-authentication-strategy.md)
- [ADR-0005: REST API Conventions](docs/adr/0005-api-design-conventions.md)
- [ADR-0006: Database Design](docs/adr/0006-database-design.md)
- [ADR-0007: Frontend Architecture](docs/adr/0007-frontend-architecture-pattern.md)

## Production Notes

- Store the JWT secret in environment configuration.
- Do not commit database passwords or production secrets.
- Replace the development in-memory user with persistent user management.
- Restrict CORS to the deployed frontend origin.
- Use database migrations and set `ddl-auto=validate` in production.
