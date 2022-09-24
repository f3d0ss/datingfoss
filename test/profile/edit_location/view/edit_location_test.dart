import 'package:datingfoss/profile/edit_location/view/edit_location.dart';
import 'package:datingfoss/widgets/select_location_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';

void main() {
  group('EditLocation', () {
    late PrivateData<LatLng> location;
    setUp(() {
      location = PrivateData<LatLng>(LatLng(1, 1));
    });
    testWidgets('render SelectLocationMap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditLocation(location: location),
        ),
      );
      await tester.pump();
      expect(find.byType(SelectLocationMap), findsOneWidget);
    });

    testWidgets('tapp on save button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditLocation(location: location),
        ),
      );
      final findIconButton = find.byType(IconButton);
      await tester.tap(findIconButton.last);
      await tester.pumpAndSettle();
    });
  });
}
