import 'dart:io';

import 'package:image/image.dart' as img;

/// Ejecutar desde quipubox/: dart run tool/generate_splash_assets.dart
/// Luego: dart run flutter_native_splash:create
void main() {
  final source = img.decodePng(File('assets/logo.png').readAsBytesSync())!;
  // Android 12 usa una máscara circular. Mantener todo el logo dentro
  // del círculo seguro de 768 px en un lienzo transparente de 1152 px.
  final logo = img.copyResize(source, width: 560);
  final canvas = img.Image(width: 1152, height: 1152, numChannels: 4);
  img.compositeImage(
    canvas,
    logo,
    dstX: (canvas.width - logo.width) ~/ 2,
    dstY: (canvas.height - logo.height) ~/ 2,
  );
  File('assets/splash_android12.png').writeAsBytesSync(img.encodePng(canvas));
}
