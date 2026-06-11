## Stack
TypeScript (80%), JavaScript (2%), Node.js runtime, Docker for containerisation. Check `package.json` for exact framework and library versions before making changes.

## Constraints
Never modify:
- `package-lock.json`, `yarn.lock`, or any lock files
- Any generated code (files with headers indicating auto-generation)
- Credential files, `.env`, `.env.*`, secrets configs
- `Dockerfile` and `docker-compose*.yml` unless the task explicitly requires it
- Migration files (`**/migrations/**`)
- `tsconfig.json` base compiler options unless performing `ts_strict_migration` work

## Conventions
- Source lives at the repo root (`components/`, `pages/`, `gateways/`, `providers/`, `services/`, `styles/`, `types/`, `utils/`) — there is no `src/` subdirectory
- E2E tests live under `cypress/e2e/` and follow `*.cy.ts` naming; there are no unit test files (`*.test.ts` / `*.spec.ts`) in this repo
- Exports should be explicit; avoid barrel re-exports unless the pattern already exists in the file being modified
- Dead code removal: only delete exports confirmed unreferenced across the entire repo, not just the current file
- TypeScript strict flags are being incrementally enabled — do not loosen existing strict settings

## Dependency manifests
- `package.json` — all npm dependency declarations
- `package-lock.json` — exact resolved versions (read-only; regenerate with `npm install` after edits to `package.json`)

## Notes for specific skills
- `cve_scan`: version `d6cc81e5` has consistently produced 0 changes — verify scanner config before assuming no CVEs exist
- `dependency_updates`: run `npm outdated` to identify candidates; update one dependency group at a time; verify build passes
- `ts_strict_migration`: enable flags one at a time in `tsconfig.json`; fix all resulting errors before committing
