# gym-buddy-openapi

Versioned OpenAPI 3 contract for Gym Buddies. This repository is the source of truth — not a live `/v3/api-docs` endpoint.

Product decisions: [`gym-buddy-documentation`](https://github.com/Projet-de-compensation-2025-2026/gym-buddy-documentation). Technical rules: [08-OpenAPI-contract.md](https://github.com/Projet-de-compensation-2025-2026/gym-buddy-documentation/blob/develop/40-Technical-specifications/08-OpenAPI-contract.md).

Pipeline-first: `openapi/openapi.yaml` starts as a `/health` stub so CI can lint and smoke a running file server.

| Workflow | Trigger | Promise |
| --- | --- | --- |
| CI | PR / push on `develop` | format, spec lint, YAML served over HTTP |
| Release | `workflow_dispatch` | squash `develop` → `main`, tag `vX.Y.Z` |
| Deploy | that tag | GitHub Pages (spec + later Swagger UI) |
