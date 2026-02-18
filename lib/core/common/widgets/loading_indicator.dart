import 'package:flutter/cupertino.dart';

void iOSLoadingDialog(
    BuildContext context, {
      String message = 'Please wait...',
    }) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (_) => PopScope(
      canPop: false,
      child: CupertinoAlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CupertinoActivityIndicator(radius: 14),
            const SizedBox(height: 12),
            Text(message),
          ],
        ),
      ),
    ),
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}