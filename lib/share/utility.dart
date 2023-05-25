import 'dart:io';
import 'dart:math';


mixin Utility {
  static Future<File> moveFile(File originalFile, String targetPath) async {
    try {
      // This will try first to just rename the file if they are on the same directory,
      return await originalFile.rename(targetPath);
    } on FileSystemException catch (e) {
      // if the rename method fails, it will copy the original file to the new directory and then delete the original file
      final newFileInTargetPath = await originalFile.copy(targetPath);
      await originalFile.delete();
      return newFileInTargetPath;
    }
  }
  static String getFileSizeString({required int bytes, int decimals = 0}) {
    try {
      const suffixes = ["B", "Kb", "Mb", "Gb", "Tb"];
      var i = (log(bytes) / log(1024)).floor();
      return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
    } catch (e) {
      return '';
    }
  }
}
