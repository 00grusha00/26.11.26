import 'dart:convert';
import 'dart:io';
import '../models/trip_model.dart';

class DesktopStorage {
  static const String _fileName = 'fleet_log_data.json';

  static Future<File> _getDesktopFile() async {
    String desktopPath;

    if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile == null || userProfile.isEmpty) {
        throw Exception('Не удалось определить USERPROFILE');
      }
      desktopPath = '$userProfile\\Desktop';
    } else {
      final home = Platform.environment['HOME'];
      if (home == null || home.isEmpty) {
        throw Exception('Не удалось определить HOME');
      }
      desktopPath = '$home/Desktop';
    }

    final desktopDir = Directory(desktopPath);
    if (!await desktopDir.exists()) {
      await desktopDir.create(recursive: true);
    }

    return File('$desktopPath${Platform.pathSeparator}$_fileName');
  }

  static Future<String> getFilePath() async {
    final file = await _getDesktopFile();
    return file.path;
  }

  static Future<List<Trip>?> loadTrips() async {
    try {
      final file = await _getDesktopFile();
      if (!await file.exists()) {
        return null;
      }
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        return null;
      }
      final List<dynamic> decoded = jsonDecode(content) as List<dynamic>;
      return decoded
          .map((item) => Trip.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveTrips(List<Trip> trips) async {
    final file = await _getDesktopFile();
    final jsonString = const JsonEncoder.withIndent('  ').convert(
      trips.map((t) => t.toJson()).toList(),
    );
    await file.writeAsString(jsonString, flush: true);
  }
}
