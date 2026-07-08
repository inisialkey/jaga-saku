# Backend Alignment Plan

Align the boilerplate's network + auth + users onto the reference contract in
[backend-contract.md](./backend-contract.md). The response envelope is shared
(DioClient + interceptor), so this is a re-platform across 3 sequential PRs, not
a users-only change. Each phase must end green (`analyze` clean + tests pass).

Conventions kept: Cubit state mgmt, `feature/{data,domain,pages}` layout,
`Either<Failure,T>`, per-feature barrels, get_it DI, go_router.

## Phase A — Core / Network  (foundation)
- `core/network/api_response.dart`: `ApiResponse<T>` parsing `{success,message,data,meta?}`; typed `data` via a `fromJsonT` converter.
- `core/models/pagination.dart` (or `page.dart`): `PaginationMeta {page,limit,total,totalPages,hasNext,hasPrev}` + `Page<T> {items, meta}`.
- `core/error/error_codes.dart`: Dart enum mirroring server `error_code`.
- `core/error/failure.dart`: add failures for the new codes (Unauthorized/Forbidden/NotFound/Validation(fieldErrors)/RateLimit/Maintenance/ForceUpdate) while keeping existing ones; map in DioClient via `error_code`.
- `core/api/dio_client.dart`: parse the envelope (unwrap `data`, surface `message`/`error_code`); base options + headers (`X-Request-Id`, `X-App-Version`, `X-App-Platform`); keep single-instance + timeouts.
- `core/api/dio_interceptor.dart`: 401 dispatch on `error_code` — `AUTH_TOKEN_EXPIRED`→refresh+retry; `AUTH_REFRESH_TOKEN_INVALID`/refresh-fail→ClearSession+login; other 401→login. Drop the legacy `'jwt error'` message check.
- `core/api/list_api.dart`: `/auth/login|register|refresh|logout|me`, `/users`, `/users/{id}`.
- `.env.*.json`: `BASE_URL=http://10.0.2.2:3000/api` (dev placeholder), `API_KEY` optional.
- Tests: ApiResponse parse, pagination parse, error_code→Failure mapping, interceptor refresh/logout dispatch.
**Acceptance:** envelope + interceptor work against the contract shape; analyze clean; tests green.

## Phase B — Auth
- Models (snake_case via json_serializable): `UserModel`, `TokenPairModel`/`AuthResponseModel`, `LoginRequest`, `RegisterRequest`.
- Entities: `User`, `TokenPair`.
- Repository + impl on the new envelope; usecases: `Login`, `Register`, `RefreshToken`, `Logout`, `GetCurrentUser`.
- AuthCubit/login+register pages aligned; secure-storage token save/clear.
- Update auth tests to new shapes.
**Acceptance:** login/register/refresh/logout/me round-trip against contract; tests green.

## Phase C — Users CRUD (reference feature)
- Entity + `UserModel` (shared with auth where sensible).
- Datasource: `getUsers(page,limit,search)`, `getUser(id)`, `updateUser(id, body)`, `deleteUser(id)`.
- Repository + usecases: `GetUsers` (paginated), `GetUser`, `UpdateUser`, `DeleteUser`. (Create = register, in auth.)
- Cubits: list (pagination + search + refresh), detail, edit.
- Pages: users list (infinite scroll/pull-refresh), detail, edit form.
- Tests ~100% (datasource/repo/usecase/cubit), using the `?scenario=` simulator patterns for error/empty.
**Acceptance:** full CRUD reference feature; ~100% coverage on it; the canonical pattern to copy for new features.

## After
White-label → FCM + cert-pin → GitHub Actions CI + coverage gate (see project roadmap).
