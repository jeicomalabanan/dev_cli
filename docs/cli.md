# Proper shell alias

## For zsh:
```makefile
dev_cli:
	@echo 'alias dev="dart run tools/dev_cli/bin/dev.dart"' >> ~/.zshrc
	@echo "✅ Added dev alias to ~/.zshrc"
	@echo "👉 Run: source ~/.zshrc"
```

## For bash:
```makefile
dev_cli:
	@echo 'alias dev="dart run tools/dev_cli/bin/dev.dart"' >> ~/.bashrc
	@echo "✅ Added dev alias to ~/.bashrc"
	@echo "👉 Run: source ~/.bashrc"
```

# Activate globally (local dev version)

From inside `dev_cli` folder:
```shell
dart pub global activate --source path toolchain/dev_cli/bin/
```
✔ installs from local folder
✔ perfect for monorepo development


# Activate from Git (recommended for real usage)

If your CLI is in a repo:
```shell
dart pub global activate --source git https://github.com/your-org/dev_cli.git
```

You can also pin a branch/tag:
```shell
dart pub global activate --source git https://github.com/your-org/dev_cli.git --git-ref main
```

## Make sure global bin is in PATH
Add this to your shell (`zshrc` / `bashrc`):

```shell
export PATH="$PATH:$HOME/.pub-cache/bin"
```