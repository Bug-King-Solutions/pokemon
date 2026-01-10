import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon/presentation/providers/update_provider.dart';
import 'update_dialog.dart';
import '../../core/di/setup_locator.dart';
import '../../data/services/update_service.dart';

/// Widget that checks for updates and shows update dialog
class UpdateChecker extends ConsumerStatefulWidget {
  final Widget child;
  final bool checkOnStart;

  const UpdateChecker({
    super.key,
    required this.child,
    this.checkOnStart = true,
  });

  @override
  ConsumerState<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends ConsumerState<UpdateChecker> {
  @override
  void initState() {
    super.initState();
    if (widget.checkOnStart) {
      // Check for updates after a short delay to let the app initialize
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkForUpdates(forceCheck: false);
      });
    }
  }

  Future<void> _checkForUpdates({bool forceCheck = false}) async {
    final updateService = getIt<UpdateService>();
    final updateInfo = await updateService.checkForUpdate(forceCheck: forceCheck);

    if (updateInfo != null && mounted) {
      // Invalidate the provider to refresh
      ref.invalidate(updateCheckProvider);

      // Show update dialog
      showDialog(
        context: context,
        barrierDismissible: !updateInfo.forceUpdate,
        builder: (context) => UpdateDialog(
          updateInfo: updateInfo,
          updateService: updateService,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to update check provider
    ref.listen<AsyncValue<dynamic>>(
      updateCheckProvider,
      (previous, next) {
        next.whenData((updateInfo) {
          if (updateInfo != null && mounted) {
            final updateService = getIt<UpdateService>();
            showDialog(
              context: context,
              barrierDismissible: !updateInfo.forceUpdate,
              builder: (context) => UpdateDialog(
                updateInfo: updateInfo,
                updateService: updateService,
              ),
            );
          }
        });
      },
    );

    return widget.child;
  }

  // Public method to manually check for updates
  void checkForUpdates({bool forceCheck = true}) {
    _checkForUpdates(forceCheck: forceCheck);
  }
}
