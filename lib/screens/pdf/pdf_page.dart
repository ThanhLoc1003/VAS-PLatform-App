import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../service/path_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PDFScreen extends StatelessWidget {
  PDFScreen({super.key, required this.pdfViewerKey});
  final GlobalKey<SfPdfViewerState> pdfViewerKey;

  final getPathFile = DirectoryPath();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[50],
        title: const Text("PDF Viewer"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await launchUrl(Uri.https('drive.google.com', '/open', {
                  // 'export': 'download',
                  'id': '1-3naJv7sR3HWR1W466YSw6VSl7myJWua'
                }));
                // _openUrl(
                //     'https://drive.google.com/uc?export=view&id=16IKc6FesISwLPeKLFL_HtqTcz5sSAtYN');
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body:
          //  SfPdfViewer.asset(key: pdfViewerKey, 'assets/2019_DD_DTH.pdf'),
          SfPdfViewer.network(
        'https://drive.google.com/uc?export=view&id=1-3naJv7sR3HWR1W466YSw6VSl7myJWua',
        key: pdfViewerKey,
      ),
    ));
  }
}
