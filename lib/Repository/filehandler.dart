import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';

import 'dart:async';

import 'package:path_provider/path_provider.dart';

import '../global_handlers.dart';

Future<String> loadAssetString(String path) async {
  return await rootBundle.loadString(path);
}

Future<void> zipDirectory(String source, String dest) async {
  final dataDir = Directory(source);
  try {
    final zipFile = File(dest);
    ZipFile.createFromDirectory(
        sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
  } catch (e) {
    logger("ZipError:$e");
  }
}

Future<void> zipFiles() async {
  final sourceDir = Directory("source_dir");
  final files = [
    File("${sourceDir.path}file1"),
    File("${sourceDir.path}file2")
  ];
  final zipFile = File("zip_file_path");
  try {
    ZipFile.createFromFiles(
        sourceDir: sourceDir, files: files, zipFile: zipFile);
  } catch (e) {
    logger("ZipError:$e");
  }
}

Future<void> extractZip(String src, String dir) async {
  final zipFile = File(src);
  final destinationDir = Directory(dir);
  try {
    ZipFile.extractToDirectory(
        zipFile: zipFile, destinationDir: destinationDir);
  } catch (e) {
    logger("ZipError:$e");
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  logger("File Path: $path");
  return File('$path/counter.txt');
}

Future<String> fileDir() {
  return _localPath;
}

Future<File> locateFile(String filename) async {
  final path = await _localPath;
  return File('$path/$filename');
}

Future<String> getfilePath(String fileName) async {
  final path = await _localPath;
  logger("File Path: $path");
  return '$path/$fileName';
  // return File('$path/$fileName');
}

Future<File> getFile(String fileName) async {
  final path = await _localPath;
  File fll = File('$path/$fileName');
  return fll;
}

Future<List> listofFiles(final directory) async {
  List file = Directory(directory.path)
      .listSync(); //use your folder name insted of resume.
  return file;
}

Future<bool> dirExists(String path) async {
  final myDir = Directory(path);
  var isThere = await myDir.exists();
  return (isThere) ? true : false;
}

Future<bool> fileExists(String path) async {
  final dir = await _localPath;
  final myFile = File("$dir/$path");
  var isThere = await myFile.exists();
  return (isThere) ? true : false;
}

Future<bool> createDir(String path) async {
  var directory = await Directory(path).create(recursive: true);
  if (await dirExists(path)) {
    logger("The Path: ${directory.absolute}");
    return true;
  } else {
    return false;
  }
}

Future<Directory> getDir(String dir) async {
  var dir_ = await getApplicationDocumentsDirectory();
  var directory = Directory("${dir_.path}/$dir");
  return directory;
}

Future<String> getFileSize(String filepath, int decimals) async {
  var file = File(filepath);
  int bytes = await file.length();
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0
    return 0;
  }
}

Future<String> readFile(String fileName) async {
  try {
    final file = await getFile(fileName);

    // Read the file
    final contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0
    return "";
  }
}

Future<File> writeToFile(String content, String fileName) async {
  final file = await locateFile(fileName);
  return await file.writeAsString(content);
}

Future<void> zipProgress() async {
  final zipFile = File("zip_file_path");
  final destinationDir = Directory("destination_dir_path");
  try {
    await ZipFile.extractToDirectory(
        zipFile: zipFile,
        destinationDir: destinationDir,
        onExtracting: (zipEntry, progress) {
          logger('progress: ${progress.toStringAsFixed(1)}%');
          logger('name: ${zipEntry.name}');
          logger('isDirectory: ${zipEntry.isDirectory}');
          logger(
              'modificationDate: ${zipEntry.modificationDate!.toLocal().toIso8601String()}');
          logger('uncompressedSize: ${zipEntry.uncompressedSize}');
          logger('compressedSize: ${zipEntry.compressedSize}');
          logger('compressionMethod: ${zipEntry.compressionMethod}');
          logger('crc: ${zipEntry.crc}');
          return ZipFileOperation.includeItem;
        });
  } catch (e) {
    logger("ZipError:$e");
  }
}

String getStringFromBytes(ByteData data) {
  final buffer = data.buffer;
  var list = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  return utf8.decode(list);
}
