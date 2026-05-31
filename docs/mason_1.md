# 🎯 Activate from https://pub.dev
dart pub global activate mason_cli

# 🚀 Initialize mason
mason init

# 📦 Install your first brick
mason add hello

# 📦 Create your first brick
mason new <brick> --output-dir=templates

# 🧱 Use your first brick
mason make hello


```shell
mason make app_package --output-dir=monorepo_demo/apps --app_name=social_app --org=team.workspace --platforms=android,ios,web
mason make feature_package --output-dir=monorepo_demo/packages/features --feature_name=core_ui
```