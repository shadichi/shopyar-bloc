import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<void> generateAndSavePDF(String userData) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text(userData, style: pw.TextStyle(fontSize: 20)),
        );
      },
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/user_info.pdf');

  await file.writeAsBytes(await pdf.save());

  print('PDF ذخیره شد در: ${file.path}');
}
