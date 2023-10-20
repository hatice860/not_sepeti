import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends StatelessWidget {
  final File file;
  final String text;

  const PDFScreen({Key? key, required this.file, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Görüntüleyici'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PDFView(
              filePath: file.path,
              onPageChanged: (int? page, int? total) {
                // PDF sayfa değiştiğinde gerçekleştirilecek işlemler burada yapılabilir.
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _openPDF(context, file, text);
            },
            child: Text("PDF'i Aç"),
          ),
        ],
      ),
    );
  }

  void _openPDF(BuildContext context, File file, String text) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('PDF Görüntüleyici'),
          ),
          body: Column(
            children: [
              Expanded(
                child: PDFView(
                  filePath: file.path,
                  onPageChanged: (int? page, int? total) {
                    // PDF sayfa değiştiğinde gerçekleştirilecek işlemler burada yapılabilir.
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Text(text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
