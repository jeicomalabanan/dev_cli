enum AppTemplate { basic, monorepo }

extension AppTemplateX on AppTemplate {
  String get label => switch (this) {
    AppTemplate.basic => 'Basic',
    AppTemplate.monorepo => 'Monorepo',
  };

  String get description => switch (this) {
    AppTemplate.basic => 'Clean flutter application.',
    AppTemplate.monorepo => 'Reusable flutter application for monorepo.',
  };
}
