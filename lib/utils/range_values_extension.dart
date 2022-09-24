import 'package:flutter/material.dart' as material;
import 'package:models/models.dart';

extension RangeValuesExtension on RangeValues {
  material.RangeValues get materialRangeValues =>
      material.RangeValues(start, end);
}
