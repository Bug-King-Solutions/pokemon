# App Update API Setup Guide

## Overview
This app includes an in-app update system that checks for new versions from a remote server. Users can update the app without going through the Play Store or App Store.

## API Endpoint Requirements

You need to set up an API endpoint that returns update information. Update the `_updateCheckUrl` in `lib/data/services/update_service.dart`.

### Required API Response Format

Your API endpoint should return JSON in this format:

```json
{
  "version": "1.0.1",
  "version_code": 2,
  "download_url": "https://your-domain.com/downloads/app-release.apk",
  "release_notes": "Bug fixes and performance improvements\n\n- Fixed notification scheduling\n- Improved animation smoothness\n- Added new Flower-Mon types",
  "force_update": false
}
```

### Field Descriptions

- **version**: String - Version number (e.g., "1.0.1")
- **version_code**: Integer - Build number (must be higher than current version)
- **download_url**: String - Direct download link to APK/IPA file
- **release_notes**: String - Release notes to show to users (supports newlines)
- **force_update**: Boolean - If true, users must update (can't dismiss dialog)

### Example API Implementation (Node.js/Express)

```javascript
app.get('/api/check-update', (req, res) => {
  const currentVersion = req.query.version || '1.0.0';
  const currentVersionCode = parseInt(req.query.version_code || '1');
  
  // Latest version info
  const latestVersion = {
    version: '1.0.1',
    version_code: 2,
    download_url: 'https://your-domain.com/downloads/app-release.apk',
    release_notes: 'Bug fixes and performance improvements',
    force_update: false
  };
  
  // Compare versions
  if (latestVersion.version_code > currentVersionCode) {
    res.json(latestVersion);
  } else {
    res.status(204).send(); // No update available
  }
});
```

### Example API Implementation (PHP)

```php
<?php
header('Content-Type: application/json');

$currentVersion = $_GET['version'] ?? '1.0.0';
$currentVersionCode = intval($_GET['version_code'] ?? 1);

$latestVersion = [
    'version' => '1.0.1',
    'version_code' => 2,
    'download_url' => 'https://your-domain.com/downloads/app-release.apk',
    'release_notes' => 'Bug fixes and performance improvements',
    'force_update' => false
];

if ($latestVersion['version_code'] > $currentVersionCode) {
    echo json_encode($latestVersion);
} else {
    http_response_code(204); // No update available
}
?>
```

## Configuration Steps

1. **Set Your API Endpoint**
   - Open `lib/data/services/update_service.dart`
   - Update `_updateCheckUrl` with your API endpoint URL
   - Example: `static const String _updateCheckUrl = 'https://your-domain.com/api/check-update';`

2. **Host Your APK/IPA Files**
   - Upload your release APK/IPA files to a publicly accessible URL
   - Use HTTPS for security
   - Update the `download_url` in your API response

3. **Version Management**
   - Update `version` in `pubspec.yaml` when releasing
   - Format: `version: 1.0.1+2` (version name + build number)
   - Build number should increment with each release

## Testing

1. **Test Update Check**
   - Build a release APK with version 1.0.0+1
   - Set your API to return version 1.0.1+2
   - Install and run the app
   - The update dialog should appear

2. **Test Force Update**
   - Set `force_update: true` in your API response
   - User should not be able to dismiss the dialog

3. **Test Dismissal**
   - Set `force_update: false`
   - User can tap "Later" to dismiss
   - Dialog won't show again for the same version

## Security Considerations

1. **HTTPS Only**: Always use HTTPS for API endpoints and download URLs
2. **File Verification**: Consider adding APK signature verification
3. **Rate Limiting**: Implement rate limiting on your API endpoint
4. **Authentication**: Optionally add API key authentication

## Alternative: GitHub Releases

You can use GitHub Releases as your update server:

1. Create a repository
2. Upload APK files as release assets
3. Use GitHub API: `https://api.github.com/repos/yourusername/pokemon/releases/latest`
4. Parse the response to extract download URL

## Notes

- Update checks happen automatically on app start (once per day)
- Users can manually check for updates from Settings > About
- For iOS, direct APK installation is not possible - use TestFlight or App Store
- Android requires "Install from Unknown Sources" permission for direct APK installation
