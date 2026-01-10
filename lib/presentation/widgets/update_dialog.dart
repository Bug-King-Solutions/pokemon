import 'package:flutter/material.dart';
import '../../data/models/app_update_info.dart';
import '../../data/services/update_service.dart';
import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'soft_button.dart';

class UpdateDialog extends StatefulWidget {
  final AppUpdateInfo updateInfo;
  final UpdateService updateService;

  const UpdateDialog({
    super.key,
    required this.updateInfo,
    required this.updateService,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _isDownloading = false;

  Future<void> _handleUpdate() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      await widget.updateService.downloadAndInstall(widget.updateInfo.downloadUrl);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Update failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  Future<void> _handleDismiss() async {
    if (!widget.updateInfo.forceUpdate) {
      await widget.updateService.dismissVersion(widget.updateInfo.version);
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.updateInfo.forceUpdate,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.system_update,
              color: AppTheme.primaryRed,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Update Available',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.deepBurgundy,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Version ${widget.updateInfo.version} is now available!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              if (widget.updateInfo.releaseNotes.isNotEmpty) ...[
                Text(
                  'What\'s New:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.updateInfo.releaseNotes,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (widget.updateInfo.forceUpdate)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This update is required to continue using the app.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.orange.shade700,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        actions: [
          if (!widget.updateInfo.forceUpdate)
            TextButton(
              onPressed: _handleDismiss,
              child: Text(
                'Later',
                style: TextStyle(color: AppTheme.deepBurgundy.withOpacity(0.6)),
              ),
            ),
          SoftButton(
            text: _isDownloading ? 'Downloading...' : 'Update Now',
            icon: _isDownloading ? null : Icons.download,
            onPressed: _isDownloading ? null : _handleUpdate,
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}
