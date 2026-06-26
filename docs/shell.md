# Show Only the Current Folder in the macOS Terminal Prompt (zsh)

This guide customizes your macOS terminal prompt to display only the current folder instead of the default:

```text
fst.user@FSTAdmins-MacBook-Pro ~ %
```

After following these steps, your prompt will look like:

```text
~ %
```

or, when inside a project:

```text
repo-jeicomalabanan %
```

## Step 1: Open your zsh configuration

Run:

```bash
nano ~/.zshrc
```

## Step 2: Set the prompt

Add the following line to the end of the file (or replace any existing `PROMPT=` line):

```zsh
PROMPT='%1~ %# '
```

### What it means

* `%1~` – Displays only the current folder name.
* `%#` – Displays `%` for a normal user and `#` for the root user.

Examples:

```text
~ %
Documents %
Downloads %
repo-jeicomalabanan %
packages %
```

## Step 3: Save the file

In Nano:

1. Press **Ctrl + O** to save.
2. Press **Enter** to confirm.
3. Press **Ctrl + X** to exit.

## Step 4: Reload the configuration

Run:

```bash
source ~/.zshrc
```

Your terminal prompt should immediately update.

## Troubleshooting

If the prompt does not change:

1. Check your shell:

```bash
echo $SHELL
```

Expected output:

```text
/bin/zsh
```

2. If you're using **Oh My Zsh**, your theme may override the prompt. Add the following line **after** the `source $ZSH/oh-my-zsh.sh` line in `~/.zshrc`:

```zsh
PROMPT='%1~ %# '
```

This ensures your custom prompt overrides the theme's default prompt.
