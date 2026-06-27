# Makefile

.PHONY: bootstrap

bootstrap:
	@echo "🚀 Bootstrapping project..."
	flutter pub get
	dart pub global activate mason_cli
	@echo "✅ Bootstrap complete"

bundle:
	mason bundle templates/default_app -t dart -o lib/bundles
	mason bundle templates/default_feature -t dart -o lib/bundles
	mason bundle templates/default_package -t dart -o lib/bundles
	mason bundle templates/monorepo -t dart -o lib/bundles
	mason bundle templates/monorepo_app -t dart -o lib/bundles
	mason bundle templates/monorepo_feature -t dart -o lib/bundles
	mason bundle templates/monorepo_package -t dart -o lib/bundles
	mason bundle templates/screen -t dart -o lib/bundles