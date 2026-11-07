# ADR-0005: API Design Conventions — RESTful API Standards

## Status
**Accepted** — 2026-11-07

## Context
The Flutter frontend communicates with the Spring Boot backend via HTTP. We need consistent API conventions for endpoints, request/response formats, error handling, and HTTP status codes.

## Decision

### URL Convention
- Base URL: `http://localhost:8081/api`
- Resource-based URLs: `/api/vehicles`, `/api/vehicles/{id}`
- Auth endpoints: `/api/auth/login`

### HTTP Methods & Status Codes

| Operation | Method | URL | Success Code | Error Codes |
|-----------|--------|-----|-------------|-------------|
| Login | POST | /api/auth/login | 200 OK | 401 Unauthorized |
| List vehicles | GET | /api/vehicles | 200 OK | 401 Unauthorized |
| Get vehicle | GET | /api/vehicles/{id} | 200 OK | 404 Not Found |
| Create vehicle | POST | /api/vehicles | 201 Created | 400 Bad Request, 409 Conflict |
| Update vehicle | PUT | /api/vehicles/{id} | 200 OK | 400, 404, 409 |
| Delete vehicle | DELETE | /api/vehicles/{id} | 204 No Content | 404 Not Found |
| Search vehicles | GET | /api/vehicles/search?query=x | 200 OK | 401 Unauthorized |

### Response Envelope
All responses (except 204) use a standard wrapper:
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... },
  "timestamp": "2026-11-07T20:00:00Z"
}
```

Error responses:
```json
{
  "success": false,
  "message": "Vehicle number already exists",
  "data": null,
  "timestamp": "2026-11-07T20:00:00Z"
}
```

### Validation Error Response
```json
{
  "success": false,
  "message": "Validation failed",
  "data": {
    "vehicleNumber": "Vehicle number is required",
    "year": "Year must be between 1900 and 2030"
  },
  "timestamp": "2026-11-07T20:00:00Z"
}
```

## Rationale
- Consistent envelope simplifies frontend error handling (always check `success` field)
- Standard HTTP status codes enable proper Dio interceptor handling on the Flutter side
- 409 Conflict for duplicate vehicle number is semantically correct
- 204 No Content for DELETE is REST convention (no body needed)

## Consequences
- **Positive**: Predictable API behavior. Frontend can have a single response parser. Clear error messages for user display.
- **Negative**: Envelope adds slight payload overhead. Non-standard (some teams prefer bare responses + HTTP codes only).
