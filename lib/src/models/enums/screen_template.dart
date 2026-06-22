enum ScreenTemplate { scaffold, basic }

extension ScreenTemplateX on ScreenTemplate {
  String get label => switch (this) {
        ScreenTemplate.scaffold => 'Scaffold',
        ScreenTemplate.basic => 'Basic',
      };

  String get description => switch (this) {
        ScreenTemplate.scaffold => '',
        ScreenTemplate.basic => '',
      };
}
