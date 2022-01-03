import 'dart:io';
import 'dart:ui';
// ignore: import_of_legacy_library_into_null_safe
import 'package:date_format/date_format.dart';
import 'package:date_util/date_util.dart';
import 'package:fraction/fraction.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart';
import 'package:kominfo/src/Controller/absen_controller.dart';
import 'package:kominfo/src/DAO/dao.dart';
import 'package:kominfo/src/Model/absen_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:kominfo/src/View/mobile.dart';
import 'package:intl/intl.dart';

class Pdf{
  Future<File> createImagePDF(List<File> files) async {
    PdfDocument document = PdfDocument();

    for(File f in files){
      PdfPage? page = document.pages.add();

      var image = PdfBitmap(f.readAsBytesSync());
      double imageWidth = image.width.toDouble(),
          imageHeight = image.height.toDouble(),
          pageWidth = page.getClientSize().width,
          pageHeight = page.getClientSize().height,
          width = imageWidth - pageWidth,
          height = imageHeight - pageHeight,
          temp = 0.0;

      var frac = Fraction.fromDouble((imageWidth/imageHeight));

      if(imageWidth > pageWidth && imageHeight > pageHeight){
        if(height > width){
          height = imageHeight - height;
          width = (frac.numerator/frac.denominator) * height;
        }
        else{
          width = imageWidth - width;
          height = width/(frac.numerator/frac.denominator);
        }
      }
      else if(imageWidth > pageWidth && imageHeight < pageHeight){
        width = imageWidth - width;
        height = width/(frac.numerator/frac.denominator);
      }
      else if(imageWidth < pageWidth && imageHeight > pageHeight){
        height = imageHeight - height;
        width = (frac.numerator/frac.denominator) * height;
      }
      else{
        height = imageHeight;
        width = imageWidth;
      }

      page.graphics.drawImage(
        image,
        Rect.fromLTWH(
            0, 0, width, height
        ),
      );
    }

    List<int> bytes = document.save();
    document.dispose();

    return await getPdf(bytes, 'file.pdf');
  }


  Future<void> createAbsenPDF(dt) async {
    var dateUtility = DateUtil();
    int days = dateUtility.daysInMonth(dt.month, dt.year);

    PdfDocument document = PdfDocument();
    document.pageSettings.size = PdfPageSize.legal;
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    final page = document.pages.add();

    PdfStringFormat format = PdfStringFormat(
        alignment: PdfTextAlignment.center
    );

    page.graphics.drawString(
        "PEMERINTAHAN KABUPATEN MIMIKA\n"
            "DINAS KOMUNIKASI DAN INFORMATIKA KABUPATEN MIMIKA\n"
            "DAFTAR HADIR PEGAWAI\n"
            "BULAN : ${getMonth(dt.month)} ${dt.year}",
        PdfStandardFont(PdfFontFamily.timesRoman, 10, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height
        ),
        format: format
    );

    PdfGrid grid = await MakeTable(dt, days, format);

    grid.draw(
      page: page,
      bounds: const Rect.fromLTWH(0, 100, 0, 0),
    )!;

    List<int> bytes = document.save();
    document.dispose();

    pdfSave(bytes, 'test.pdf');
  }

  // ignore: non_constant_identifier_names
  Future<PdfGrid> MakeTable(dt, days, format) async{
    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.timesRoman, 8, style: PdfFontStyle.bold),
    );

    grid.columns.add(count: days+3);
    grid.headers.add(2);
    grid.columns[0].width = 15;
    grid.columns[1].width = 150;
    grid.columns[2].width = 120;

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = "NO";
    header.cells[1].value = "NAMA";
    header.cells[2].value = "JABATAN";
    header.cells[3].value = "TANGGAL";

    header.cells[0].stringFormat = format;
    header.cells[1].stringFormat = format;
    header.cells[2].stringFormat = format;
    header.cells[3].stringFormat = format;

    header.cells[0].rowSpan = 2;
    header.cells[1].rowSpan = 2;
    header.cells[2].rowSpan = 2;
    header.cells[3].columnSpan = (days);

    header = grid.headers[1];
    for(int i=0; i<days; i++){
      header.cells[i+3].value = (i+1).toString();
      grid.columns[i+3].width = 20;
      header.cells[i+3].stringFormat = format;

      if(isWeekend(i,dt)){
        header.cells[i+3].style.textBrush = PdfSolidBrush(PdfColor(204, 0, 61));
      }
    }

    await setTableValues(grid, header, days, format, dt);

    return grid;
  }

  // ignore: non_constant_identifier_names
  Future<void> setTableValues(grid, header, days, format, dt) async {
    List<AbsenModel> absents = await AbsenController().fetchAllAbsen();

    for(int i=0; i<absents.length; i++){
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = (i+1).toString();
      row.cells[1].value = '${absents.elementAt(i).nama}\n${absents.elementAt(i).tugas}\n${absents.elementAt(i).nip}';
      row.cells[2].value = absents.elementAt(i).jabatan;

      row.cells[0].stringFormat = format;
      row.cells[2].stringFormat = format;

      for(int j=0; j<days; j++){
        if(isWeekend(j,dt)){
          row.cells[j+3].style.backgroundBrush = PdfSolidBrush(PdfColor(204, 0, 61));
        }
        else{
          dt = DateTime(dt.year,dt.month,(j+1));
          if(absents.elementAt(i).tgl_presensi == dt.toString().substring(0,10)){
            var url = '${DAO().base_url}${absents.elementAt(i).tandatangan}';
            var response = await get(Uri.parse(url));
            row.cells[j+3].imagePosition = PdfGridImagePosition.fit;
            row.cells[j+3].style.backgroundImage = PdfBitmap(response.bodyBytes.toList());
          }
        }
      }
    }
  }

  bool isWeekend(i,DateTime dt){
    String s = DateFormat().add_EEEE().format(DateTime(dt.year,dt.month,(i+1))).toLowerCase().trim();
    if(s == "sunday" || s == "saturday"){
      return true;
    }
    return false;
  }

  String getMonth(int month){
    if(month == 1){
      return "JANUARI";
    }
    else if(month == 2){
      return "FEBRUARI";
    }
    else if(month == 3){
      return "MARET";
    }
    else if(month == 4){
      return "APRIL";
    }
    else if(month == 5){
      return "MEI";
    }
    else if(month == 6){
      return "JUNI";
    }
    else if(month == 7){
      return "JULI";
    }
    else if(month == 8){
      return "AGUSTUS";
    }
    else if(month == 9){
      return "SEPTEMBER";
    }
    else if(month == 10){
      return "OKTOBER";
    }
    else if(month == 11){
      return "NOVEMBER";
    }
    else{
      return "DESEMBER";
    }
  }
}