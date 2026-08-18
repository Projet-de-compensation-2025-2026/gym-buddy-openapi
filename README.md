# gym-buddy-openapi

Versioned OpenAPI 3.1 contract for Gym Buddies. This repository is the source of truth — not a live `/v3/api-docs` endpoint.

Product decisions: [`gym-buddy-documentation`](https://github.com/Projet-de-compensation-2025-2026/gym-buddy-documentation). Technical rules: [08-OpenAPI-contract.md](https://github.com/Projet-de-compensation-2025-2026/gym-buddy-documentation/blob/develop/40-Technical-specifications/08-OpenAPI-contract.md).

`package.json` version and `info.version` stay **`0.1.0`** until Release cuts a later `0.1.x` tag. Do not invent `1.0.0`.

## Depend on a version (tag)

Pin a **git tag**, not a raw `develop` SHA GET.

```bash
pnpm add github:Projet-de-compensation-2025-2026/gym-buddy-openapi#v0.1.0
```

npm / yarn use the same GitHub URL (`github:Projet-de-compensation-2025-2026/gym-buddy-openapi#v0.1.0`). The package contents are the `$ref` tree under `openapi/`.

There is **no** tag yet. After this lands on `develop`, Sentinel / Release must run **Actions → Release** (or `gh workflow run Release -f version=0.1.0`) so the first annotated tag is **`v0.1.0`** on `main`. Feature branches do not push tags.

A Maven / OpenAPI Generator consumer checks out that same tag (or depends on the git package) and points `inputSpec` at `openapi/openapi.yaml`. Switching `gym-buddy-service` and `gym-buddy-ui` is sibling work, not this repo.

## Generate from the `$ref` tree

Point generators at the tree root:

```text
node_modules/gym-buddy-openapi/openapi/openapi.yaml
```

or, from a checkout of tag `v0.1.0`:

```text
openapi/openapi.yaml
```

Do **not** generate from `bundled.yaml`. That file is not the consumer source of truth and is not checked in. Do **not** vendor YAML into `gym-buddy-ui`. Do **not** treat Spring `springdoc` `/v3/api-docs` as the published contract.

## Layout

| Path | Role |
| --- | --- |
| `package.json` | Versioned package (`0.1.0`). Consumers pin `…#v0.1.0`. |
| `openapi/openapi.yaml` | Thin root. **Edit source and generator entry.** |
| `openapi/paths/` | Path items (`health`, `auth`) |
| `openapi/components/schemas/entities/` | Shared entities (`HealthStatus`, `RegisteredUser`, `ErrorResponse`, …) |
| `openapi/components/schemas/requests/` | Request bodies (`RegisterRequest`, `LoginRequest`) |
| `openapi/components/schemas/responses/` | Response bodies (`AccessTokenResponse`) |
| `openapi/components/securitySchemes.yaml` | `bearerAuth`, `refreshCookie` |
| `openapi/components/headers.yaml` | Refresh `Set-Cookie` / clear-cookie headers |

The tree is the edit format. The package / tagged checkout is how consumers see it. A local `bash .github/scripts/ci/bundle.sh` dump is a CI resolve check only — do not check it in and do not point codegen at it.

## Current contract (`0.1.0`)

Server prefix `/api/v1`:

- `GET /healthz`, `GET /readyz`
- `POST /auth/register`, `/auth/login`, `/auth/refresh`, `/auth/logout`

## Pipeline

| Workflow | Trigger | Promise |
| --- | --- | --- |
| CI | PR / push on `develop` | format, lint the `$ref` tree, package/`info.version` match, tree resolves, YAML served over HTTP |
| Release | `workflow_dispatch` | squash `develop` → `main`, tag `vX.Y.Z` (first tag is `v0.1.0`) |
| Deploy | that tag | GitHub Pages serves the `$ref` tree |
