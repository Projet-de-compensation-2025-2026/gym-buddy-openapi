# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- Messaging: `GET`/`POST /conversations`, `GET`/`POST /conversations/{id}/messages`, `DELETE /messages/{id}`, `GET /ws` (FS-MSG-01..10). Ticket #67. Friends-only direct pair, text 1–4000, one image or one audio via existing `/media` (`kind=message`). Sender tombstone within 10 minutes. Inbox unread counts. Persistence first; WebSocket fan-out of `message.created`, `message.deleted`, `conversation.updated`. Non-friends `FORBIDDEN`; stranger conversation `NOT_FOUND`.
- Parameterized search: `GET /search/people` and `GET /search/events` (FS-SRCH-01..08). Ticket #65. Query params `q`, `sports` (repeat, any-of), `experience`, `city`, `radiusKm` (1–50), `friendState`, `activity`, `from`/`to`, `remaining`, `organizerIsFriend`, `sort=relevance|distance|starts_at`, cursor `before`, `size`, `debug`. Unauthenticated is `401`. Private strangers, blocked users, and (when `remaining=true`) full events never appear.
- Admin and moderation: `GET /admin/users`, lock/unlock, `PATCH /admin/users/{id}/role`, hide/unhide content, `GET /admin/reports`, `POST /admin/reports/{id}/resolve`, member `POST /reports`, `GET /admin/media`, `POST /admin/fixtures` and `/reset`, `GET /admin/audit` (FS-ADM-01..09, FS-ACCT-08/09). Ticket #69. Members hitting `/admin/*` get `NOT_FOUND`. Role PATCH is admin-only (`FORBIDDEN` for moderators). Last admin demote/lock is `CONFLICT`. Hide requires a reason (`VALIDATION`). Fixture trigger is documented; generating thousands of rows is ticket #70.
- Friend suggestions and weekly matching: `GET /suggestions`, `POST /suggestions/{userId}/dismiss`, `POST`/`DELETE /matching/opt-in`, `GET /matching/me` (FS-SUGG-01..07, FS-MATCH-01..03). Ticket #66. Default size 20, max 50. Each suggestion has a plain-language `reason`. Dismiss is 30 days. Matching opt-in is per ISO week; `GET /matching/me` returns the proposed pair and draft instant event (capacity 1, visibility friends) when assigned.
- Events: `GET`/`POST /events`, `GET`/`PATCH /events/{id}`, `POST /events/{id}/cancel`, `POST /events/{id}/applications`, `DELETE /applications/{id}`, `POST /applications/{id}/accept`, `POST /applications/{id}/decline` (FS-EVT-01..13). Ticket #64. Instant or `FREQ=WEEKLY;BYDAY` (+ optional `UNTIL`). Visibility public / friends / private. Capacity 1–100 excluding organizer. 90-day materialised occurrences. Transactional last-seat accept is `CONFLICT`. Organizer pending applicants include matching score (FS-EVT-13).
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
