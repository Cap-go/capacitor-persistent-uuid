# AGENTS.md

Guidance for agents and contributors working on @capgo/capacitor-persistent-uuid.

## Commands

- Use Bun for development commands: bun install, bun run build, bun run verify, bunx cap sync.
- Public docs and marketing copy should show standard npm/npx install commands.
- Run bun run verify before submitting plugin changes.

## Project

- src/definitions.ts is the source for public API docs. Run bun run docgen after API changes.
- Android implementation lives under android/src/main/java/app/capgo/persistent_uuid and uses AccountManager.
- iOS implementation lives under ios/Sources/PersistentUuidPlugin and uses Keychain.
- Keep CocoaPods (*.podspec) and SwiftPM (Package.swift) names in sync.
- dist/ is generated and should not be edited manually.

## Release

- GitHub repo: Cap-go/capacitor-persistent-uuid.
- Docs URL: https://capgo.app/docs/plugins/persistent-uuid/.
- Repository description must start with: Capacitor plugin for ...
- Keep assets/github-social-template.svg specific to this plugin and export assets/github-social-preview.png for GitHub social preview before launch.
