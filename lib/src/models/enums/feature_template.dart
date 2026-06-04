enum FeatureTemplate { monorepo, basic }

extension FeatureTemplateX on FeatureTemplate {
  String get label => switch (this) {
    FeatureTemplate.monorepo => 'Monorepo',
    FeatureTemplate.basic => 'Basic',
  };

  String get description => switch (this) {
    FeatureTemplate.monorepo => '',
    FeatureTemplate.basic => '',
  };
}
