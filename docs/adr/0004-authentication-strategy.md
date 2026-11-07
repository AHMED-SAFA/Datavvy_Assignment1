# ADR-0004: Authentication Strategy — JWT-Based Stateless Authentication

## Status
**Accepted** — 2026-11-07

## Context
The VMS requires login functionality. The backend is a REST API (stateless by design), and the frontend is a Flutter Web SPA. We need an authentication mechanism that works well with this architecture.

## Decision
We implement **JWT (JSON Web Token) based stateless authentication** with the following design:

### Authentication Flow
```
┌──────────┐         ┌──────────────┐         ┌────────────┐
│  Flutter  │──POST──→│  /api/auth/  │──verify──→│  Hardcoded │
│  Login    │  login  │  login       │  creds   │  User DB   │
│  Page     │◄──JWT───│  Controller  │◄─────────│            │
└──────────┘  token   └──────────────┘          └────────────┘
      │
      │ stores JWT in SharedPreferences
      │
      ▼
┌──────────┐         ┌──────────────┐         ┌────────────┐
│  Flutter  │──GET───→│  /api/       │──filter──→│  JWT Auth   │
│  Vehicle  │ +Bearer │  vehicles    │  chain   │  Filter    │
│  Pages    │◄─data──│  Controller  │◄─valid───│            │
└──────────┘         └──────────────┘          └────────────┘
```

### Key Decisions
1. **Hardcoded admin user** (username: `admin`, password: `admin123`) — Assignment scope does not require user registration
2. **JWT stored in SharedPreferences** on the client — acceptable for a learning project; production would use HttpOnly cookies
3. **Token expiration**: 24 hours — long enough for development sessions
4. **Spring Security filter chain** validates JWT on every protected request
5. **Public endpoints**: `/api/auth/**`, `/h2-console/**` — no JWT required
6. **Protected endpoints**: `/api/vehicles/**` — JWT required

## Rationale
- REST APIs should be stateless; JWT eliminates server-side session storage
- JWT is the industry standard for SPA + API authentication
- Spring Security's filter chain integrates naturally with JWT validation
- SharedPreferences is sufficient for this scope (internal management tool, not a banking app)

## Consequences
- **Positive**: Stateless backend (horizontally scalable). No session management complexity. Standard Authorization header pattern.
- **Negative**: JWT cannot be easily revoked (mitigated by short expiry in production). Token stored in browser storage is vulnerable to XSS (acceptable for course assignment scope).
- **Future improvement**: Add refresh tokens, move to HttpOnly cookies, implement user registration with BCrypt password hashing against a database table.
