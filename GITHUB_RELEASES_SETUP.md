# GitHub Releases Setup Guide

## Overview
This guide will help you set up GitHub Releases as your free hosting platform for app updates. No server needed!

## Step 1: Create a GitHub Repository

1. Go to [GitHub](https://github.com) and sign in (or create an account - it's free!)
2. Click the "+" icon in the top right, then "New repository"
3. Name it something like `pokemon-releases` or `flower-mon-releases`
4. Make it **Public** (so the API can access it)
5. Click "Create repository"

## Step 2: Configure the App

1. Open `lib/data/services/update_service.dart`
2. Find these lines (around line 14-15):
   ```dart
   static const String _githubUsername = 'YOUR_GITHUB_USERNAME';
   static const String _githubRepo = 'YOUR_REPO_NAME';
   ```
3. Replace them with your GitHub username and repository name:
   ```dart
   static const String _githubUsername = 'yourusername';
   static const String _githubRepo = 'pokemon-releases';
   ```

## Step 3: Build Your Release APK

1. Open terminal/command prompt in your project directory
2. Build a release APK:
   ```bash
   flutter build apk --release
   ```
3. Your APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

## Step 4: Create a GitHub Release

1. Go to your GitHub repository
2. Click "Releases" (on the right side of the page)
3. Click "Create a new release"
4. **Tag version**: Enter your version tag (e.g., `v1.0.1`)
   - Important: Must start with `v` and follow format `v1.0.1`
5. **Release title**: Same as tag (e.g., `v1.0.1`)
6. **Description**: Write release notes (this will show to users):
   ```
   Bug fixes and improvements
   
   - Fixed notification scheduling
   - Improved animation smoothness
   - Added new Flower-Mon types
   ```
7. **Attach APK**: 
   - Click "Attach binaries"
   - Select your `app-release.apk` file
   - Wait for upload to complete
8. Click "Publish release"

## Step 5: Update Version in Your Code

Before creating a new release:

1. Open `pubspec.yaml`
2. Update the version:
   ```yaml
   version: 1.0.1+2  # Version name + build number
   ```
3. Rebuild the app and create a new release on GitHub

## Version Numbering

- **Version format**: `v1.0.1` (must start with `v`)
- **Build number**: Should increment with each release
- Example progression:
  - v1.0.0+1 (first release)
  - v1.0.1+2 (minor update)
  - v1.1.0+3 (major update)

## How It Works

1. App checks: `https://api.github.com/repos/YOUR_USERNAME/YOUR_REPO/releases/latest`
2. GitHub API returns the latest release info
3. App finds the `.apk` file in the release assets
4. Shows update dialog if version is newer
5. User downloads APK directly from GitHub

## Testing

1. Build and install version 1.0.0:
   ```bash
   flutter build apk --release
   # Install on device
   ```

2. Create a GitHub release with version v1.0.1

3. Open the app - it should check for updates and show the dialog

4. Or manually check: Settings > About > Check for Updates

## Benefits of GitHub Releases

✅ **Completely free** - No hosting costs  
✅ **No server needed** - GitHub handles everything  
✅ **Easy to manage** - Just upload APK files  
✅ **Automatic CDN** - Fast downloads worldwide  
✅ **Version history** - All releases are saved  
✅ **Release notes** - Built-in changelog support  

## Notes

- Make sure your repository is **Public** (or use a GitHub Personal Access Token for private repos)
- APK files should be uploaded as release assets (not in the repo)
- Version tags must match the format: `v1.0.1` (with the `v` prefix)
- Users need to allow "Install from Unknown Sources" on Android to install APKs

## Alternative: Private Repository

If you want a private repository:

1. Create a GitHub Personal Access Token:
   - Settings > Developer settings > Personal access tokens > Generate new token
   - Select scope: `public_repo` or `repo` (for private repos)

2. Update `update_service.dart` to include the token in headers:
   ```dart
   final response = await http.get(
     Uri.parse(_updateCheckUrl),
     headers: {
       'Accept': 'application/json',
       'Authorization': 'token YOUR_TOKEN_HERE', // Add this
     },
   );
   ```

However, for most use cases, a public repository is fine since APK files are meant to be distributed anyway!

## Troubleshooting

**Update not showing?**
- Check that the version tag is newer (e.g., v1.0.1 > v1.0.0)
- Verify the APK file is attached to the release
- Check that repository name and username are correct in code

**Download not working?**
- Ensure APK file is attached as a release asset (not in repository)
- Check that the file has `.apk` extension
- Verify GitHub repository is public (or token is set correctly)

**Can't install APK?**
- User needs to enable "Install from Unknown Sources" in Android settings
- Go to Settings > Security > Unknown Sources (or Install Unknown Apps)
