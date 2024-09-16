import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class QrImageWidget extends StatelessWidget {
  final String base64String;

  QrImageWidget({required this.base64String});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _decodeImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Container(
            width: 200,
            height: 200,
            child: Image.memory(snapshot.data!),
          );
        } else {
          return Text('Unknown Error');
        }
      },
    );
  }

  Future<Uint8List> _decodeImage() async {
    Uint8List bytes = base64Decode(base64String);
    ui.Codec codec = await ui.instantiateImageCodec(bytes);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ByteData? byteData = await frameInfo.image.toByteData();
    return byteData!.buffer.asUint8List();
  }
}
