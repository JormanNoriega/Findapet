import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatelessWidget {
  final String data; // Los datos que irán en el QR (puede ser una URL)

  QRCodePage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Código QR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Genera el código QR
            QrImageView(
              data: data, // Datos a codificar (puede ser una URL)
              version: QrVersions.auto,
              size: 200.0, // Tamaño del QR
              backgroundColor: Colors.white, // Fondo blanco
            ),
            SizedBox(height: 20),
            Text(
              'Escanea este código QR para ver más detalles',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
