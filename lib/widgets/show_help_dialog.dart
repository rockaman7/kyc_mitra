import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Help"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}
