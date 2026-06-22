import 'package:flutter/material.dart';

import 'dimen_res.dart';

final class WidgetRes {
  WidgetRes._();

  static const fillSpace = Spacer();
  static const rowPadding = SizedBox(width: DimenRes.padding);
  static const columnPadding = SizedBox(height: DimenRes.padding);
  static const rowMargin = SizedBox(width: DimenRes.margin);
  static const columnMargin = SizedBox(height: DimenRes.margin);
}
