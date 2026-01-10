class AppUpdateInfo {
  final String version;
  final String downloadUrl;
  final String releaseNotes;
  final bool forceUpdate;
  final int versionCode;

  AppUpdateInfo({
    required this.version,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.forceUpdate,
    required this.versionCode,
  });

  factory AppUpdateInfo.fromJson(Map<String, dynamic> json) {
    return AppUpdateInfo(
      version: json['version'] as String,
      downloadUrl: json['download_url'] as String,
      releaseNotes: json['release_notes'] as String? ?? 'New update available!',
      forceUpdate: json['force_update'] as bool? ?? false,
      versionCode: json['version_code'] as int? ?? 0,
    );
  }
}
