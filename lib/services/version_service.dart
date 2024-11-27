import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show HttpException;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionService {
  static const String _githubApiUrl =
      'https://api.github.com/repos/Tjpatel16/flutter_build/releases/latest';
  static const Duration _cacheTimeout = Duration(hours: 1);

  static String? _currentVersion;
  static String? _latestVersion;
  static bool _hasUpdate = false;
  static DateTime? _lastCheck;

  static Future<void> checkForUpdates() async {
    // Skip check if last check was within cache timeout
    if (_lastCheck != null &&
        DateTime.now().difference(_lastCheck!) < _cacheTimeout) {
      return;
    }

    try {
      final currentVersion = await getCurrentVersion();
      final latestVersion = await _getLatestVersion();

      _hasUpdate = _compareVersions(currentVersion, latestVersion);
      _lastCheck = DateTime.now();

      if (_hasUpdate) {
        debugPrint(
            'Update available: Current version: $currentVersion, Latest version: $latestVersion');
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      // Reset state on error
      _hasUpdate = false;
      _latestVersion = null;
    }
  }

  static Future<String> getCurrentVersion() async {
    try {
      _currentVersion ??=
          await PackageInfo.fromPlatform().then((info) => info.version);
      return _currentVersion!;
    } catch (e) {
      debugPrint('Error getting current version: $e');
      return '0.0.0';
    }
  }

  static Future<String> _getLatestVersion() async {
    try {
      final response = await http.get(Uri.parse(_githubApiUrl));
      if (response.statusCode != 200) {
        throw HttpException(
            'Failed to fetch latest version: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      _latestVersion = data['tag_name'].toString().replaceAll('v', '');
      return _latestVersion!;
    } catch (e) {
      debugPrint('Error fetching latest version: $e');
      rethrow;
    }
  }

  static bool _compareVersions(String current, String latest) {
    try {
      // Clean up version strings - remove 'v' prefix and any other non-numeric characters except dots
      current = current.replaceAll(RegExp(r'[^0-9.]'), '');
      latest = latest.replaceAll(RegExp(r'[^0-9.]'), '');

      if (current == latest) return false;

      final currentParts =
          current.split('.').map((part) => int.tryParse(part) ?? 0).toList();
      final latestParts =
          latest.split('.').map((part) => int.tryParse(part) ?? 0).toList();

      // Ensure both lists have 3 elements
      while (currentParts.length < 3) currentParts.add(0);
      while (latestParts.length < 3) latestParts.add(0);

      for (var i = 0; i < 3; i++) {
        if (latestParts[i] > currentParts[i]) return true;
        if (latestParts[i] < currentParts[i]) return false;
      }

      return false;
    } catch (e) {
      debugPrint('Error comparing versions: $e');
      return false;
    }
  }

  static bool hasUpdate() => _hasUpdate;

  static String? getLatestVersion() => _latestVersion;

  static Future<void> openReleasePage() async {
    try {
      // Use the releases page URL instead of API URL for opening in browser
      final uri = Uri.parse(
          'https://github.com/Tjpatel16/flutter_build/releases/latest');
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch release page');
      }
    } catch (e) {
      debugPrint('Error opening release page: $e');
    }
  }
}
