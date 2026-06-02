# Makefile

.PHONY: bootstrap

bootstrap:
	@echo "🚀 Bootstrapping project..."
	flutter pub get
	dart pub global activate mason_cli
	@echo "✅ Bootstrap complete"

bundle:
	mason bundle bricks/app -t dart -o lib/bundles
	mason bundle bricks/monorepo -t dart -o lib/bundles