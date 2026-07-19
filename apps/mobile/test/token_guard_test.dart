import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Dynamic-theming guard (Phase 2.1c): raw hex colors and raw font families
/// are only allowed in the generated token bindings. Everything else must go
/// through DsColors/DsTypography so a token change propagates everywhere.
const allowed = <String>{
  'lib/design_system/tokens_generated.dart',
};

void main() {
  test('no raw hex colors or font families outside the token layer', () {
    final violations = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    final rawColor = RegExp(r'Color\(0x|Color\.fromARGB|Color\.fromRGBO');
    final rawFont = RegExp(r"fontFamily:\s*'");
    for (final file in files) {
      final normalized = file.path.replaceAll(r'\', '/');
      if (allowed.contains(normalized)) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (rawColor.hasMatch(line) || rawFont.hasMatch(line)) {
          violations.add('$normalized:${i + 1}: ${line.trim()}');
        }
      }
    }
    expect(
      violations,
      isEmpty,
      reason: 'Use DsColors/DsTypography tokens instead:\n${violations.join('\n')}',
    );
  });
}
