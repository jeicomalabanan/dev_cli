# Makefile

.PHONY: bootstrap

bootstrap:
	@echo "🚀 Bootstrapping project..."
	flutter pub get
	dart pub global activate mason_cli
	@echo "✅ Bootstrap complete"

bundle:
	mason bundle templates/app -t dart -o lib/bundles
	mason bundle templates/feature -t dart -o lib/bundles
	mason bundle templates/monorepo -t dart -o lib/bundles
	mason bundle templates/dart_package -t dart -o lib/bundles
	mason bundle templates/flutter_package -t dart -o lib/bundles