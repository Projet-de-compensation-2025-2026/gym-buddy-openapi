# Gym Buddies API contract

Versioned OpenAPI 3.1 definitions used to generate the Java service interfaces and Angular client. Edit the `$ref` tree at [openapi/openapi.yaml](openapi/openapi.yaml); consumers pin a published tag or an explicitly reviewed commit.

## Validate

```sh
bash .github/scripts/ci/test.sh
bash .github/scripts/ci/smoke.sh
```

[CI](.github/workflows/ci.yml) defines the required tools and formatting checks. [Release](.github/workflows/release.yml) synchronizes package/spec versions and creates SemVer tags.

Product requirements, architecture and engineering conventions: [project documentation](https://github.com/Projet-de-compensation-2025-2026/gym-buddy-documentation). Changes are recorded in [CHANGELOG.md](CHANGELOG.md).
