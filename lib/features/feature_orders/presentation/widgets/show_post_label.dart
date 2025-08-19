import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shapyar_bloc/core/colors/app-colors.dart';

import '../../../../core/config/app-colors.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../data/models/store_info.dart';

class PdfViewerScreen extends StatefulWidget {
  static String routeName = 'PdfViewerScreen';

  const PdfViewerScreen({super.key});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? pdfPath;
  //var args = StoreInfo(storeName: '', storeAddress: '', phoneNumber: '', instagram: '', postalCode: '', website: '', storeIcon: '');

  StoreInfo storeInfo =  StoreInfo(storeName: 'بلبل', storeAddress: 'بلبل', phoneNumber: 'بلبل', instagram: 'بلبل', postalCode: 'بلبل', website: 'بلبل', storeIcon: 'بلبل');

  @override
  void initState() {
    super.initState();
    _generatePdf(); // تولید PDF در لحظه ورود
  }

/*  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as StoreInfo;
  }*/

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    // خواندن تصویر از assets
    final ByteData imageData =
    await rootBundle.load('assets/images/post_label.jpg');
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    final image = pw.MemoryImage(imageBytes);

    final ByteData instaIcon = await rootBundle.load('assets/images/insta.png');
    final Uint8List instaIconImageBytes = instaIcon.buffer.asUint8List();
    final instaImage = pw.MemoryImage(instaIconImageBytes);

    final ttfData = await rootBundle.load("assets/fonts/Yekan.ttf");
    final ttf = pw.Font.ttf(ttfData.buffer.asByteData());

   // await Hive.openBox<StoreInfo>('storeBox');
   // var storeBox = Hive.box<StoreInfo>('storeBox');
   // var store = storeBox.get('storeInfo') ?? StoreInfo(instagram: '',phoneNumber: '',postalCode: '',storeAddress: '',storeIcon: '',storeName: '',website: '');


    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final width = PdfPageFormat.a4.width;
          final height = PdfPageFormat.a4.height;
          return pw.Stack(
            children: [
              pw.Image(image, fit: pw.BoxFit.fitWidth),
              pw.Positioned(
                  left: width * 0.47,
                  top: height * 0.3,child: pw.Container(
                width: width * 0.27,
                height: height * 0.02,
                // color: PdfColors.red,
                alignment: pw.Alignment.center,
                child:  pw.Image(instaImage,
                    width: width * 0.09, height: width * 0.09),)
              ),
              pw.Positioned(
                  left: width * 0.47,
                  top: height * 0.39,
                  child: pw.Container(
                      width: width * 0.27,
                      height: height * 0.02,
                      //    color: PdfColors.red,
                      alignment: pw.Alignment.center,
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Image(instaImage,
                                width: width * 0.03, height: width * 0.03),
                            pw.SizedBox(width: width * 0.01),
                            pw.Text('instagram')
                          ]))),
              positionedTextWidget(
                  text: storeInfo.storeName,//نام گیرنده
                  heightContainer: height * 0.02,
                  widthContainer: width * 0.28,
                  leftPositioned: width * 0.445,
                  topPositioned: height * 0.449,
                  font: ttf,
                  fontSize: width * 0.02,
                  alignment: pw.Alignment.centerRight,
                  fontWeight: pw.FontWeight.normal,
                  maxLine: 1),
              positionedTextWidget(
                  text: storeInfo.storeName,
                  heightContainer: height * 0.027,
                  widthContainer: width * 0.3,
                  leftPositioned: width * 0.45,
                  topPositioned: height * 0.34,
                  font: ttf,
                  fontSize: width * 0.03,
                  alignment: pw.Alignment.center,
                  fontWeight: pw.FontWeight.bold,
                  maxLine: 1),
              positionedTextWidget(
                  text: storeInfo.storeAddress,
                  heightContainer: height * 0.059,
                  widthContainer: width * 0.33,
                  leftPositioned: width * 0.445,
                  topPositioned: height * 0.495,
                  font: ttf,
                  fontSize: width * 0.018,
                  alignment: pw.Alignment.topRight,
                  fontWeight: pw.FontWeight.normal,
                  maxLine: 4),
              positionedTextWidget(
                  text: storeInfo.storeName,//یادداشت
                  heightContainer: height * 0.023,
                  widthContainer: width * 0.33,
                  leftPositioned: width * 0.445,
                  topPositioned: height * 0.57,
                  font: ttf,
                  fontSize: width * 0.018,
                  alignment: pw.Alignment.topRight,
                  fontWeight: pw.FontWeight.normal,
                  maxLine: 2),
              positionedTextWidget(
                  text: '0123456789 ',//کد پستی گیرنده
                  heightContainer: height * 0.017,
                  widthContainer: width * 0.115,
                  leftPositioned: width * 0.604,
                  topPositioned: height * 0.595,
                  font: ttf,
                  fontSize: width * 0.018,
                  alignment: pw.Alignment.center,
                  fontWeight: pw.FontWeight.normal,
                  maxLine: 1),
              positionedTextWidget(
                  text: '09122356987 ',
                  heightContainer: height * 0.017,
                  widthContainer: width * 0.13,
                  leftPositioned: width * 0.42,
                  topPositioned: height * 0.595,
                  font: ttf,
                  fontSize: width * 0.018,
                  alignment: pw.Alignment.center,
                  fontWeight: pw.FontWeight.normal,
                  maxLine: 1),
              positionedTextWidget(
                  text: 'این نام فروشگاه است!',
                  heightContainer: height * 0.027,
                  widthContainer: width * 0.3,
                  leftPositioned: width * 0.1,
                  topPositioned: height * 0.28,
                  font: ttf,
                  fontSize: width * 0.03,
                  alignment: pw.Alignment.centerRight,
                  fontWeight: pw.FontWeight.bold,
                  maxLine: 1),
              positionedTextWidget(
                  text: 'آدرس',
                  heightContainer: height * 0.077,
                  widthContainer: width * 0.33,
                  leftPositioned: width * 0.066,
                  topPositioned: height * 0.34,
                  font: ttf,
                  fontSize: width * 0.018,
                  alignment: pw.Alignment.topRight,
                  fontWeight: pw.FontWeight.normal,
                  maxLine: 6),
              positionedTextWidget(
                  text: '0123456789 ',
                  heightContainer: height * 0.017,
                  widthContainer: width * 0.115,
                  leftPositioned: width * 0.225,
                  topPositioned: height * 0.418,
                  font: ttf,
                  fontSize: width * 0.018,
                  alignment: pw.Alignment.center,
                  fontWeight: pw.FontWeight.normal,
                  maxLine: 1),
              positionedTextWidget(
                  text: '09128888888 ',
                  heightContainer: height * 0.017,
                  widthContainer: width * 0.13,
                  leftPositioned: width * 0.06,
                  topPositioned: height * 0.418,
                  font: ttf,
                  fontSize: width * 0.018,
                  alignment: pw.Alignment.center,
                  fontWeight: pw.FontWeight.normal,
                  maxLine: 1),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/post_label.pdf');
    await file.writeAsBytes(await pdf.save());

    setState(() {
      pdfPath = file.path; // مسیر PDF در متغیر ذخیره می‌شود
    });
  }

  Future<void> _savePdf() async {
    if (pdfPath == null) return;
    final output = await getExternalStorageDirectory();
    final savedFile = File('${output!.path}/final_output.pdf');
    await File(pdfPath!).copy(savedFile.path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF ذخیره شد! ✅ در: ${savedFile.path}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  AppConfig.background,
      appBar: AppBar(
        backgroundColor:  AppConfig.background,
        title: Text("برچسب چستی",style: TextStyle( color: AppConfig.white,fontSize: AppConfig.calFontSize(context, 3.8)),),leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppConfig.white,),
          onPressed: () {

          Navigator.pop(context);
        },
      ),),
      body: pdfPath == null
          ? Center(child: ProgressBar())
          : PDFView(
        filePath: pdfPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageSnap: true,
        fitPolicy: FitPolicy.BOTH,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConfig.background,
        onPressed: _savePdf,
        tooltip: "ذخیره PDF",
        child: Icon(Icons.save,color: AppConfig.white,),
      ),
    );
  }
}

pw.Widget positionedTextWidget({
  required String text,
  required double leftPositioned,
  required double topPositioned,
  required double widthContainer,
  required double heightContainer,
  required pw.Font font,
  required double fontSize,
  required pw.Alignment alignment,
  required pw.FontWeight fontWeight,
  required int maxLine,
}) {
  return pw.Positioned(
      left: leftPositioned,
      top: topPositioned,
      child: pw.Container(
          alignment: alignment,
          color: PdfColors.green,
          width: widthContainer,
          height: heightContainer,
          child: pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(
              text,
              style: pw.TextStyle(
                fontSize: fontSize,
                font: font,
                color: PdfColors.black,
                fontWeight: fontWeight,
              ),
              maxLines: maxLine,
              overflow: pw.TextOverflow.clip,
            ),

          )));
}
