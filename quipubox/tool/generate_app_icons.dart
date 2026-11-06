import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart' as img;

/// Ejecutar desde quipubox/: dart run tool/generate_app_icons.dart
void main() {
  final source = img.decodePng(File('assets/logo.png').readAsBytesSync())!;
  final icon = img.Image(width: 1024, height: 1024, numChannels: 3);
  img.fill(icon, color: img.ColorRgb8(11, 35, 64));
  final logo = img.copyResize(source, width: 720);
  img.compositeImage(
    icon,
    logo,
    dstX: (icon.width - logo.width) ~/ 2,
    dstY: (icon.height - logo.height) ~/ 2,
  );

  void save(String path, int size) {
    final image = img.copyResize(icon, width: size, height: size);
    File(path).writeAsBytesSync(img.encodePng(image));
  }

  const androidSizes = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192,
  };
  for (final entry in androidSizes.entries) {
    save(
      'android/app/src/main/res/mipmap-${entry.key}/ic_launcher.png',
      entry.value,
    );
  }

  const iosDirectory = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
  final contents =
      jsonDecode(File('$iosDirectory/Contents.json').readAsStringSync())
          as Map<String, dynamic>;
  for (final item in contents['images'] as List<dynamic>) {
    final image = item as Map<String, dynamic>;
    final filename = image['filename'] as String?;
    if (filename == null) continue;
    final size = double.parse((image['size'] as String).split('x').first);
    final scale = double.parse((image['scale'] as String).replaceAll('x', ''));
    save('$iosDirectory/$filename', (size * scale).round());
  }
}
