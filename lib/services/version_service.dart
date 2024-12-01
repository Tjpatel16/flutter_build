import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show HttpException;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/version_info.dart';

class VersionService {
  static const String _githubApiUrl =
      'https://api.github.com/repos/Tjpatel16/flutter_build/releases/latest';
  static const Duration _cacheTimeout = Duration(hours: 1);

  static PackageInfo? _packageInfo;
  static String? _latestVersion;
  static bool _hasUpdate = false;
  static DateTime? _lastCheck;
  static VersionInfo? _versionInfo;

  /// Initialize package info and return VersionInfo
  static Future<VersionInfo> _getVersionInfo() async {
    try {
      if (_versionInfo != null) return _versionInfo!;

      _packageInfo ??= await PackageInfo.fromPlatform();
      _versionInfo = VersionInfo(
        version: _packageInfo!.version,
        buildNumber: _packageInfo!.buildNumber,
      );
      return _versionInfo!;
    } catch (e) {
      debugPrint('Error getting package info: $e');
      return VersionInfo.defaultInfo();
    }
  }

  static Future<void> checkForUpdates() async {
    try {
      final versionInfo = await _getVersionInfo();
      final latestVersion = await _getLatestVersion();

      // Always compare versions regardless of cache
      _hasUpdate = _compareVersions(versionInfo.version, latestVersion);
      _lastCheck = DateTime.now();

      if (_hasUpdate) {
        debugPrint(
            'Update available: Current version: ${versionInfo.version}, Latest version: $latestVersion');
      } else {
        debugPrint(
            'No update available. Current: ${versionInfo.version}, Latest: $latestVersion');
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      // Reset state on error
      _hasUpdate = false;
      _latestVersion = null;
    }
  }

  /// Gets the current version number
  static Future<VersionInfo> getCurrentVersion() async {
    final versionInfo = await _getVersionInfo();
    return versionInfo;
  }

  static Future<String> _getLatestVersion() async {
    try {
      final response = await http.get(Uri.parse(_githubApiUrl));
      if (response.statusCode != 200) {
        throw HttpException(
            'Failed to fetch latest version: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      final tagName = data['tag_name'].toString();
      // Remove 'v' prefix if present and store clean version
      _latestVersion = tagName.startsWith('v') ? tagName.substring(1) : tagName;
      debugPrint('Latest version from GitHub: $_latestVersion');
      return _latestVersion!;
    } catch (e) {
      debugPrint('Error fetching latest version: $e');
      rethrow;
    }
  }

  static bool _compareVersions(String current, String latest) {
    try {
      // Clean up version strings - remove 'v' prefix and split into parts
      current = current.replaceAll(RegExp(r'[^0-9.]'), '').trim();
      latest = latest.replaceAll(RegExp(r'[^0-9.]'), '').trim();

      debugPrint('Comparing versions - Current: $current, Latest: $latest');

      // Split versions into parts and convert to integers
      List<int> currentParts = current
          .split('.')
          .map((part) => int.tryParse(part.trim()) ?? 0)
          .toList();
      List<int> latestParts = latest
          .split('.')
          .map((part) => int.tryParse(part.trim()) ?? 0)
          .toList();

      // Ensure both lists have exactly 3 elements (major.minor.patch)
      while (currentParts.length < 3) currentParts.add(0);
      while (latestParts.length < 3) latestParts.add(0);

      // Trim to first 3 elements if more exist
      currentParts = currentParts.take(3).toList();
      latestParts = latestParts.take(3).toList();

      debugPrint(
          'Version parts - Current: $currentParts, Latest: $latestParts');

      // Compare each part in order (major, minor, patch)
      for (var i = 0; i < 3; i++) {
        if (latestParts[i] > currentParts[i]) {
          debugPrint(
              'Update available: Latest version part ${latestParts[i]} > Current version part ${currentParts[i]} at position $i');
          return true;
        }
        if (latestParts[i] < currentParts[i]) {
          debugPrint(
              'No update: Latest version part ${latestParts[i]} < Current version part ${currentParts[i]} at position $i');
          return false;
        }
      }

      debugPrint('Versions are equal');
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
      final url = Uri.parse(
          'https://github.com/Tjpatel16/flutter_build/releases/latest');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error opening release page: $e');
      rethrow;
    }
  }
}
