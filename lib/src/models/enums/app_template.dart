enum AppTemplate { monorepo, basic }

extension AppTemplateX on AppTemplate {
  String get label => switch (this) {
    AppTemplate.monorepo => 'Monorepo',
    AppTemplate.basic => 'Basic',
  };

  String get description => switch (this) {
    AppTemplate.monorepo => '',
    AppTemplate.basic => '',
  };
}
