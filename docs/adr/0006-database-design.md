# ADR-0006: Database Design — H2 for Development with PostgreSQL Migration Path

## Status
**Accepted** — 2026-11-07

## Context
The VMS needs persistent storage for vehicle data. PostgreSQL 18.6 is available on the system (F:\postgres) but requires password configuration. The development workflow should be frictionless.

## Decision
We use **H2 file-based database** for development with a clear migration path to PostgreSQL for production.

### Database Schema

```sql
CREATE TABLE vehicles (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    vehicle_number  VARCHAR(50)  NOT NULL UNIQUE,
    brand           VARCHAR(100) NOT NULL,
    model           VARCHAR(100) NOT NULL,
    type            VARCHAR(20)  NOT NULL,  -- CAR, TRUCK, BIKE, SUV, VAN
    color           VARCHAR(50),
    year            INT          NOT NULL,
    owner_name      VARCHAR(200) NOT NULL,
    status          VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE', -- ACTIVE, INACTIVE
    registration_date DATE,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### H2 Configuration
```yaml
spring:
  datasource:
    url: jdbc:h2:file:./data/vmsdb
    driver-class-name: org.h2.Driver
  h2:
    console:
      enabled: true
      path: /h2-console
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
```

### PostgreSQL Migration (when needed)
```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/vmsdb
    driver-class-name: org.postgresql.Driver
    username: postgres
    password: ${DB_PASSWORD}
  jpa:
    hibernate:
      ddl-auto: update
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
```

## Rationale
- H2 file-based mode persists data across restarts (unlike in-memory mode)
- Zero configuration — no database server management during development
- JPA/Hibernate abstracts SQL dialect differences, so switching to PostgreSQL requires only a config change
- H2 Console provides a built-in web UI for debugging data at `/h2-console`
- The `UNIQUE` constraint on `vehicle_number` enforces the business rule at the database level (defense in depth alongside service-layer validation)

## Consequences
- **Positive**: Instant setup. No external dependencies for development. Data persists in `./data/vmsdb.mv.db` file.
- **Negative**: H2 has different SQL dialect quirks. Some PostgreSQL-specific features (e.g., `JSONB`, full-text search) are unavailable.
- **Mitigation**: Use only standard SQL. Service-layer validation handles business rules. Integration tests against PostgreSQL before production deployment.
