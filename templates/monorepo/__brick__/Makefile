# Makefile

FLUTTER_VERSION := 3.44.2

.PHONY: bootstrap

bootstrap:
	@echo "⬇️ Installing Flutter version $(FLUTTER_VERSION) with FVM..."
	@fvm install $(FLUTTER_VERSION)
	@fvm global $(FLUTTER_VERSION)

	@echo "⬇️ Installing Melos..."
	@dart pub global activate melos