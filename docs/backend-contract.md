# Backend Contract (Reference Mock API)

This boilerplate targets the **mock-api-nextjs** backend as its reference contract.

- Source: https://github.com/inisialkey/mock-api-nextjs
- Full design: that repo's `docs/api/00-overview.md` + `docs/api/flutter-integration-guide.md`

> Routes are served under `/api` (the actual Next.js routes are **not** `/v1`-prefixed despite the design doc). Use `…/api` as the Dio `baseUrl` and the paths below.

## Base URL (per platform, dev)
| Target | baseUrl |
|---|---|
| Android emulator | `http://10.0.2.2:3000/api` |
| iOS simulator | `http://localhost:3000/api` |
| Physical device | `http://<LAN-IP>:3000/api` |

WebSocket base: `ws://<host>:3000`.

## Response envelope

**Success** (2xx):
```jsonc
{ "success": true, "message": "…", "data": <T | T[] | null>, "meta": { /* pagination, list only */ } }
```

**Error** (4xx/5xx):
```jsonc
{ "success": false, "message": "…", "errors": { "field": ["msg"] } | null,
  "error_code": "VALIDATION_ERROR", "request_id": "req_…" }
```
- `message` is snackbar-safe.
- `errors` = field map only for `422 VALIDATION_ERROR`, else `null`.
- HTTP status = category; `error_code` = specific cause (interceptor dispatch key).

## error_code enum
`BAD_REQUEST`, `AUTH_INVALID_CREDENTIALS`, `AUTH_TOKEN_EXPIRED`, `AUTH_TOKEN_INVALID`,
`AUTH_REFRESH_TOKEN_INVALID`, `AUTH_ACCOUNT_DISABLED`, `AUTHORIZATION_FORBIDDEN`,
`RESOURCE_NOT_FOUND`, `RESOURCE_ALREADY_EXISTS`, `FILE_TOO_LARGE`, `UNSUPPORTED_MEDIA_TYPE`,
`VALIDATION_ERROR`, `FORCE_UPDATE_REQUIRED`, `RATE_LIMIT_EXCEEDED`, `MAINTENANCE_MODE`,
`INTERNAL_SERVER_ERROR`.

Interceptor rules:
- `401 AUTH_TOKEN_EXPIRED` → refresh access token, retry once.
- `401 AUTH_REFRESH_TOKEN_INVALID` (or refresh fails) → clear session, force login.
- other `401 AUTH_TOKEN_INVALID` → force login.

## Pagination
Request: `?page=1&limit=20&search=&sort=created_at&order=desc` (limit clamped 1..100).
```jsonc
"meta": { "page": 1, "limit": 20, "total": 153, "total_pages": 8, "has_next": true, "has_prev": false }
```

## Auth (`/auth/*`)
| Method | Path | Body | Data |
|---|---|---|---|
| POST | `/auth/login` | `{email, password}` | `{user, access_token, refresh_token, token_type:"Bearer", expires_in}` |
| POST | `/auth/register` | `{name, email, password, phone?}` | same as login |
| POST | `/auth/refresh` | `{refresh_token}` | new `{access_token, refresh_token, token_type, expires_in}` |
| POST | `/auth/logout` | — (Bearer) | `null` |
| GET | `/auth/me` | — (Bearer) | `user` |

Tokens: store `access_token` + `refresh_token` in secure storage. Send `Authorization: Bearer <access_token>`.

## User object
```jsonc
{ "id": "…", "name": "…", "email": "…", "phone": "…|null", "avatar_url": "…|null",
  "role": "user|admin", "is_active": true, "created_at": "ISO", "updated_at": "ISO" }
```

## Users CRUD (`/users`, Bearer required)
| Method | Path | Notes | Data |
|---|---|---|---|
| GET | `/users?page&limit&search&role&sort&order` | list | `User[]` + `meta` |
| GET | `/users/{id}` | detail | `User` |
| PUT | `/users/{id}` | update `{name?, phone?, avatar_url?}` (self or admin) | updated `User` |
| DELETE | `/users/{id}` | soft delete (admin) | `null` |

> "Create user" = `POST /auth/register` (no `POST /users`).

## Edge-case simulator
Append `?scenario=<name>` (e.g. slow network, timeout, 4xx/5xx, `empty`) to any endpoint to exercise error/empty paths — useful for widget/integration tests.
