# What is Mason?

[Mason](https://docs.brickhub.dev) is a code generation tool for Dart/Flutter that helps you create reusable templates called **bricks**.

Instead of manually creating folders/files every time, Mason can generate them automatically.

Example use cases in your Flutter monorepo:

* Create a new feature package
* Create a new app
* Generate screens/widgets/blocs
* Generate repository/usecase/data layers
* Generate boilerplate architecture
* Standardize folder structures

---

# 1. Install Mason

## Activate Mason CLI

```bash
dart pub global activate mason_cli
```

Verify:

```bash
mason --version
```

---

# 2. Initialize Mason in Your Repo

Inside your Flutter monorepo root:

```bash
mason init
```

This creates:

```txt
mason.yaml
```

Example:

```yaml
bricks:
  feature:
    path: bricks/feature
```

---

# 3. Create Your First Brick

Create a brick:

```bash
mason new feature
```

This creates:

```txt
bricks/
  feature/
    brick.yaml
    __brick__/
```

---

# 4. Brick Structure

Example:

```txt
bricks/
  feature/
    brick.yaml
    hooks/
    __brick__/
      lib/
        {{feature_name.snakeCase()}}/
          presentation/
          domain/
          data/
```

`{{ }}` are Mason variables.

---

# 5. Configure Variables

Example `brick.yaml`:

```yaml
name: feature
description: Generate a feature package

vars:
  feature_name:
    type: string
    description: Feature name
```

---

# 6. Generate Files

Run:

```bash
mason make feature
```

Mason asks:

```txt
? Feature name: auth
```

Result:

```txt
lib/
  auth/
    presentation/
    domain/
    data/
```

---

# 7. Flutter Monorepo Example

Based on your architecture:

```txt
apps/
packages/
features/
core/
shared/
bricks/
```

You can create bricks for:

| Brick      | Purpose                 |
| ---------- | ----------------------- |
| app        | Create new Flutter app  |
| feature    | Create feature package  |
| screen     | Create screen           |
| bloc       | Create bloc/cubit       |
| repository | Create repository layer |
| usecase    | Create usecase          |
| shared_ui  | Create reusable widgets |
| api        | Create API clients      |

---

# 8. Example Feature Brick

## Template File

`__brick__/lib/{{feature_name.snakeCase()}}_screen.dart`

```dart
class {{feature_name.pascalCase()}}Screen {
  const {{feature_name.pascalCase()}}Screen();
}
```

Generate:

```bash
mason make feature --feature_name auth
```

Result:

```dart
class AuthScreen {
  const AuthScreen();
}
```

---

# 9. Hooks (Very Important)

Hooks let you run Dart scripts before/after generation.

Example:

```txt
hooks/
  pre_gen.dart
  post_gen.dart
```

Use cases:

* Run `flutter create`
* Delete generated files
* Modify pubspec
* Run melos bootstrap
* Prevent duplicate packages
* Interactive prompts

Example:

```dart
void run(HookContext context) async {
  context.logger.info('Generating feature...');
}
```

---

# 10. Add Bricks to mason.yaml

Example:

```yaml
bricks:
  app:
    path: bricks/app

  feature:
    path: bricks/feature

  package:
    path: bricks/package
```

Get bricks:

```bash
mason get
```

---

# 11. Common Commands

| Command                 | Description         |
| ----------------------- | ------------------- |
| `mason init`            | Initialize Mason    |
| `mason new brick_name`  | Create brick        |
| `mason make brick_name` | Generate from brick |
| `mason get`             | Fetch bricks        |
| `mason add`             | Add remote brick    |
| `mason publish`         | Publish brick       |

---

# 12. Example: Create App Brick

Your hook can run:

```bash
flutter create apps/my_app --org=com.workspace
```

Then Mason overwrites:

* `pubspec.yaml`
* `main.dart`
* architecture folders
* melos config
* flavors
* routing

This is the professional setup for scalable Flutter monorepos.

---

# 13. Recommended Setup for Your Monorepo

```txt
root/
├── apps/
├── packages/
├── features/
├── core/
├── shared/
├── bricks/
│   ├── app/
│   ├── feature/
│   ├── package/
│   ├── screen/
│   └── bloc/
├── mason.yaml
├── melos.yaml
```

---

# 14. Very Useful Mason Features

## Case conversions

```txt
{{name.camelCase()}}
{{name.snakeCase()}}
{{name.pascalCase()}}
```

---

## Conditionals

```txt
{{#use_bloc}}
Bloc code
{{/use_bloc}}
```

---

## Loops

```txt
{{#fields}}
final {{name}} {{type}};
{{/fields}}
```

---

# 15. Learning Resources

* [Mason Documentation](https://docs.brickhub.dev)
* [BrickHub](https://brickhub.dev)
* [Very Good Ventures Mason Examples](https://github.com/VeryGoodOpenSource/mason)

---

# Recommended Next Step

For your current monorepo setup, the best first bricks are:

1. `app`
2. `feature`
3. `screen`
4. `bloc`
5. `repository`

Those five bricks already automate most Flutter boilerplate work.
