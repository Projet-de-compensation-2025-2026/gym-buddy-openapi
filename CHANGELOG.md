# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [Semantic Versioning](https://semver.org/).

## [Unreleased]

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
