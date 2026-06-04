enum PackageTemplate { monorepo, basic }

extension PackageTemplateX on PackageTemplate {
  String get label => switch (this) {
    PackageTemplate.monorepo => 'Monorepo',
    PackageTemplate.basic => 'Basic',
  };

  String get description => switch (this) {
    PackageTemplate.monorepo => '',
    PackageTemplate.basic => '',
  };
}
