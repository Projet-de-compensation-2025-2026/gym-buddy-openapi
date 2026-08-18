# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- GitHub Actions CI on `develop`, Release squash+tag onto `main`, Deploy to GitHub Pages
- Stub OpenAPI document at `openapi/openapi.yaml`
- Auth contract: `POST /auth/register`, `/auth/login`, `/auth/refresh`, `/auth/logout` (access JWT in JSON, HttpOnly refresh cookie)

### Changed

- Health contract: `GET /health` replaced by unauthenticated `GET /healthz` (liveness) and `GET /readyz` (PostgreSQL + object storage)

[Unreleased]: https://github.com/Projet-de-compensation-2025-2026/gym-buddy-openapi
