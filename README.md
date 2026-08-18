# gym-buddy-openapi

Versioned OpenAPI 3.1 contract for Gym Buddies. This repository is the source of truth — not a live `/v3/api-docs` endpoint.

Product decisions: [`gym-buddy-documentation`](https://github.com/Projet-de-compensation-2025-2026/gym-buddy-documentation). Technical rules: [08-OpenAPI-contract.md](https://github.com/Projet-de-compensation-2025-2026/gym-buddy-documentation/blob/develop/40-Technical-specifications/08-OpenAPI-contract.md).

## Layout

| Path | Role |
| --- | --- |
| `openapi/openapi.yaml` | Thin root. Edit here and the `$ref` tree. Redocly lints this file. |
| `openapi/paths/` | Path items (`health`, `auth`) |
| `openapi/components/schemas/entities/` | Shared entities (`HealthStatus`, `RegisteredUser`, `ErrorResponse`, …) |
| `openapi/components/schemas/requests/` | Request bodies (`RegisterRequest`, `LoginRequest`) |
| `openapi/components/schemas/responses/` | Response bodies (`AccessTokenResponse`) |
| `openapi/components/securitySchemes.yaml` | `bearerAuth`, `refreshCookie` |
| `openapi/components/headers.yaml` | Refresh `Set-Cookie` / clear-cookie headers |
| `openapi/bundled.yaml` | **Consumer document.** One OpenAPI 3.1 file (`info.version` `0.1.x`). |

Do not copy this YAML into `gym-buddy-ui`. Service and UI generate from the bundle (codegen is sibling tickets, not this repo).

## Consumer bundle

`gym-buddy-service` and `gym-buddy-ui` generate from **`openapi/bundled.yaml`**.

That file is checked in and kept current by CI (`bash .github/scripts/ci/bundle.sh` uses `@redocly/cli@1 bundle`, then Prettier). After you edit the `$ref` tree, regenerate:

```bash
bash .github/scripts/ci/bundle.sh
```

A tag of this repository (or the raw `openapi/bundled.yaml` on that tag) is the artifact to point codegen at. GitHub Pages also serves `bundled.yaml` next to the split source.

## Current contract (`0.1.0`)

Server prefix `/api/v1`:

- `GET /healthz`, `GET /readyz`
- `POST /auth/register`, `/auth/login`, `/auth/refresh`, `/auth/logout`

## Pipeline

| Workflow | Trigger | Promise |
| --- | --- | --- |
| CI | PR / push on `develop` | format, lint the root **and** the bundle, bundle freshness, YAML served over HTTP |
| Release | `workflow_dispatch` | squash `develop` → `main`, tag `vX.Y.Z` |
| Deploy | that tag | GitHub Pages (split spec + bundled document) |
