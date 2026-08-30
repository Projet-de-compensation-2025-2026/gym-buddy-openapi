# gym-buddy-openapi

Versioned OpenAPI 3.1 contract for Gym Buddies. This repository is the source of truth — not a live `/v3/api-docs` endpoint.

Product decisions: [`gym-buddy-documentation`](https://github.com/Projet-de-compensation-2025-2026/gym-buddy-documentation). Technical rules: [08-OpenAPI-contract.md](https://github.com/Projet-de-compensation-2025-2026/gym-buddy-documentation/blob/develop/40-Technical-specifications/08-OpenAPI-contract.md).

`package.json` version and `info.version` stay **`0.1.0`** until Release cuts a later `0.1.x` tag. Do not invent `1.0.0`.

## Depend on a version (tag)

Pin a **git tag**, not a raw `develop` SHA.

```bash
pnpm add github:Projet-de-compensation-2025-2026/gym-buddy-openapi#v0.1.0
```

npm / yarn use the same GitHub URL (`github:Projet-de-compensation-2025-2026/gym-buddy-openapi#v0.1.0`). The package contents are the `$ref` tree under `openapi/`.

Git tag **v0.1.0** exists (`info.version` `0.1.0`; ticket **#46** Done). Feature branches do not push tags. Later `0.1.x` tags are cut with **Actions → Release**.

A Maven / OpenAPI Generator consumer checks out that same tag (or depends on the git package) and points `inputSpec` at `openapi/openapi.yaml`. **Today** `gym-buddy-service` `develop` **`3ffdef8`** (ticket **#47** Done) and `gym-buddy-ui` `develop` **`47eac9c`** (ticket **#48** Done) already generate from that tree. They do **not** read `bundled.yaml`. Ticket **#40** / **#46** / **#47** / **#48** stay **Done** as history.

## Generate from the `$ref` tree

Point generators at the tree root:

```text
node_modules/gym-buddy-openapi/openapi/openapi.yaml
```

or, from a checkout of tag `v0.1.0`:

```text
openapi/openapi.yaml
```

Ticket **#54** deletes the former checked-in `openapi/bundled.yaml`. It is **not** a consumer input. Dual maintenance of a second consumer document is no longer required. CI may flatten a **temp** bundle as a lint check (`bash .github/scripts/ci/bundle.sh /tmp/bundled.yaml`); do **not** check that file in. Do **not** vendor YAML into `gym-buddy-ui`. Do **not** treat Spring `springdoc` `/v3/api-docs` as the published contract.

## Layout

| Path | Role |
| --- | --- |
| `package.json` | Versioned package (`0.1.0`). Consumers pin `…#v0.1.0`. |
| `openapi/openapi.yaml` | Thin root. **Edit source and generator entry.** |
| `openapi/paths/` | Path items (`health`, `auth`, `me`, `profiles`, `friendships`, `blocks`, `media`, `posts`, `comments`, `feed`, `events`, `applications`) |
| `openapi/components/schemas/entities/` | Shared entities (`HealthStatus`, `RegisteredUser`, `Profile`, `ErrorResponse`, …) |
| `openapi/components/schemas/requests/` | Request bodies (`RegisterRequest`, `LoginRequest`, `CreatePostRequest`, `PatchPostRequest`, …) |
| `openapi/components/schemas/responses/` | Response bodies (`AccessTokenResponse`, `CreateMediaResponse`, `MediaUrlResponse`) |
| `openapi/components/securitySchemes.yaml` | `bearerAuth`, `refreshCookie` |
| `openapi/components/headers.yaml` | Refresh `Set-Cookie` / clear-cookie headers |

The tree is the edit format and the consumer input. The package / tagged checkout is how consumers see it.

## Current contract (`0.1.0`)

Server prefix `/api/v1`:

- `GET /healthz`, `GET /readyz`
- `POST /auth/register`, `/auth/login`, `/auth/refresh`, `/auth/logout`, `/auth/password`
- `POST /me/close`
- `GET`/`PATCH /profiles/me`, `GET /profiles/{handle}`
- `GET`/`POST /friendships`, `POST /friendships/{id}/accept`, `/decline`, `DELETE /friendships/{id}`
- `POST /blocks`, `DELETE /blocks/{userId}`
- `POST /media`, `GET /media/{id}/url`, `DELETE /media/{id}`
- `POST /posts`, `GET`/`PATCH`/`DELETE /posts/{id}`, `POST`/`DELETE /posts/{id}/reposts`, `PUT`/`DELETE /posts/{id}/like`, `GET /posts/{id}/likes`
- `GET`/`POST /posts/{id}/comments`, `GET /comments/{id}/replies`, `DELETE /comments/{id}`, `PUT`/`DELETE /comments/{id}/like`
- `GET /feed`
- `GET`/`POST /events`, `GET`/`PATCH /events/{id}`, `POST /events/{id}/cancel`, `POST /events/{id}/applications`
- `DELETE /applications/{id}`, `POST /applications/{id}/accept`, `POST /applications/{id}/decline`

## Pipeline

| Workflow | Trigger | Promise |
| --- | --- | --- |
| CI | PR / push on `develop` | format, lint the `$ref` tree (optional temp flatten for lint only), package/`info.version` match, YAML served over HTTP |
| Release | `workflow_dispatch` | squash `develop` → `main`, tag `vX.Y.Z` (current tag is `v0.1.0`) |
| Deploy | that tag | GitHub Pages workflow exists; the site is **not** live (HTTP 404). Do **not** enable gym-buddy-openapi Pages in this ticket. The package/tag is not broken. |
