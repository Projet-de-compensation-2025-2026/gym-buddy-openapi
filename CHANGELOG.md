# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- Friends news feed: `GET /feed` (FS-FEED-01..06). Ticket #63. Cursor `before`, default size 20, max 50. Items are posts and reposts by the viewer and accepted friends; public posts from non-friends stay off this feed. Hidden/deleted omitted.
- Profiles: `GET`/`PATCH /profiles/me`, `GET /profiles/{handle}` (full vs private stub, FS-PROF-01..06). Ticket #59.
- Password change: `POST /auth/password` (FS-ACCT-05). Ticket #59.
- Close account: `POST /me/close` (FS-ACCT-07). Ticket #59.
- Friendships and blocks: `GET`/`POST /friendships`, accept/decline/delete, `POST /blocks`, `DELETE /blocks/{userId}` (FS-FRND-01..08). Ticket #60.
- Media: `POST /media`, `GET /media/{id}/url`, `DELETE /media/{id}` (FS-MED-01..09). Ticket #68. Error codes `PAYLOAD_TOO_LARGE` and `QUOTA_EXCEEDED`.
- Nested comments: `GET`/`POST /posts/{id}/comments`, `GET /comments/{id}/replies`, `DELETE /comments/{id}`, `PUT`/`DELETE /comments/{id}/like` (FS-CMT-01..07). Ticket #62. Max depth 4 (root = 0). Author delete tombstones the body; children remain. Page roots (20) + expand replies. No media in comments. Idempotent like.
- Posts, likes, and reposts: `POST /posts`, `GET`/`PATCH`/`DELETE /posts/{id}`, `POST`/`DELETE /posts/{id}/reposts`, `PUT`/`DELETE /posts/{id}/like`, `GET /posts/{id}/likes` (FS-POST-01..08). Ticket #61. Visibility `friends` (default) or `public`. Edit window 15 minutes. Soft-delete. Idempotent like. Unique repost. Max 4 image `mediaIds`.
- `ErrorResponse` code `NOT_FOUND` for unknown or closed handles.

### Changed

- Delete checked-in `openapi/bundled.yaml`. Consumers already generate from the `$ref` tree (`openapi/openapi.yaml` on tag **v0.1.0**). CI may flatten a temp bundle as a lint check; that file is not checked in. Ticket #54.

## [0.1.0] — 2026-08-18

### Added

- GitHub Actions CI on `develop`, Release squash+tag onto `main`, Deploy to GitHub Pages
- Stub OpenAPI document at `openapi/openapi.yaml`
- Auth contract: `POST /auth/register`, `/auth/login`, `/auth/refresh`, `/auth/logout` (access JWT in JSON, HttpOnly refresh cookie)
- Versioned npm/pnpm package (`package.json` `0.1.0`) so consumers pin `github:Projet-de-compensation-2025-2026/gym-buddy-openapi#v0.1.0` and generate from the `$ref` tree

### Changed

- Health contract: `GET /health` replaced by unauthenticated `GET /healthz` (liveness) and `GET /readyz` (PostgreSQL + object storage)
- Split `openapi/openapi.yaml` into a `$ref` tree (paths, entities, requests, responses). Ticket #40 history: consumers generated from the checked-in bundle `openapi/bundled.yaml` (`info.version` remains `0.1.0`).
- Package consumers pin a git tag and generate from `openapi/openapi.yaml` (the `$ref` tree). That is the target SoT. `openapi/bundled.yaml` stays checked in as today’s `gym-buddy-service` fetch file until ticket #47. Pin a tag, not a raw `develop` SHA.

[Unreleased]: https://github.com/Projet-de-compensation-2025-2026/gym-buddy-openapi
[0.1.0]: https://github.com/Projet-de-compensation-2025-2026/gym-buddy-openapi/releases/tag/v0.1.0
