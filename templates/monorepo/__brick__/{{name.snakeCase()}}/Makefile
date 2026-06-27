# Default Flutter version for the project
FLUTTER_VERSION := 3.44.4

# Keep print statements clean by silencing command echoing globally
.SILENT:

.PHONY: bootstrap

bootstrap:
	@echo "⬇️ Installing Flutter version $(FLUTTER_VERSION) with FVM..."
	@fvm install $(FLUTTER_VERSION)
	@fvm global $(FLUTTER_VERSION)

	@echo "⬇️ Installing Melos..."
	@dart pub global activate melos