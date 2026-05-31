# Global Installation

You can install the Dev CLI globally using Dart's pub global activation.

## List Installed Global Packages

Displays all globally activated Dart packages:

```shell
dart pub global list
```

Example output:

```text
Activated packages:
- dev_cli 1.0.0
- melos 7.0.0
- mason_cli 0.1.0
```

---

## Install Dev CLI

Activate the latest version directly from GitHub:

```shell
dart pub global activate --source git https://github.com/jeicomalabanan/dev_cli
```

Activate the latest version directly from local:

```shell
dart pub global activate --source path bin
```

Verify the installation:

```shell
dart pub global list
```

You should see:

```text
dev_cli <version>
```

You can now run:

```shell
dev --help
```

---

## Update Dev CLI

Running the activation command again will pull the latest version from the repository:

```shell
dart pub global activate --source git https://github.com/jeicomalabanan/dev_cli
```

---

## Uninstall Dev CLI

Remove the globally installed package:

```shell
dart pub global deactivate dev_cli
```

Verify removal:

```shell
dart pub global list
```

The `dev_cli` package should no longer appear in the list.

---

## Troubleshooting

### `dev: command not found`

Ensure Dart's global executable directory is included in your `PATH`.

Common location:

```shell
~/.pub-cache/bin
```

Add it to your shell profile:

```shell
export PATH="$PATH:$HOME/.pub-cache/bin"
```

Reload your shell:

```shell
source ~/.zshrc
```

or

```shell
source ~/.bashrc
```

Verify:

```shell
which dev
```

Expected output:

```text
~/.pub-cache/bin/dev
```

You should now be able to execute:

```shell
dev --help
```
