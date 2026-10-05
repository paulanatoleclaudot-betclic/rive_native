import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rive_native/rive_native.dart' as rive;

import 'src/utils.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test(
    'Factory.flutter.decodeImage resolves to null when decoding fails',
    () async {
      final image = await rive.Factory.flutter
          .decodeImage(Uint8List.fromList([0, 1, 2, 3]))
          .timeout(const Duration(seconds: 5));

      expect(image, isNull);
    },
  );

  test('a failed decodeImage does not block the next file decode', () async {
    await rive.Factory.flutter
        .decodeImage(Uint8List.fromList([0, 1, 2, 3]))
        .timeout(const Duration(seconds: 5));

    final file = await rive.File.decode(
      loadFile('assets/local_bounds.riv'),
      riveFactory: rive.Factory.flutter,
    ).timeout(const Duration(seconds: 5));

    expect(file, isNotNull);
  });
}
