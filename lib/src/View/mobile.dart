import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<File> getPdf(List<int> bytes, String fileName) async {
  final path = (await getApplicationDocumentsDirectory()).path;
  File file = await writeFile('$path/$fileName', bytes);
  return file;
}

Future<void> pdfSave(List<int> bytes, String fileName) async {
  final path = (await getApplicationDocumentsDirectory()).path;
  await writeFile('$path/$fileName', bytes);
  OpenFile.open('$path/$fileName');
}

Future<File> imageSave(ByteData data, String fileName) async {
  final path = (await getApplicationDocumentsDirectory()).path;
  final buffer = data.buffer;

  return await writeFile(
    '$path/$fileName',
    buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes
    ),
  );
}

Future<File> writeFile(String path, byte) async {
  return await File(path).
  writeAsBytes(
      byte,
      flush: true
  );
}