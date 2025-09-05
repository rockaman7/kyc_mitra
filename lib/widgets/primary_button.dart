import 'package:flutter/material.dart';

// class PrimaryButton extends StatelessWidget {
//   final String label;
//   final VoidCallback? onPressed;

//   const PrimaryButton({super.key, required this.label, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       onPressed: onPressed,
//       child: Text(label, style: const TextStyle(fontSize: 18)),
//     );
//   }
// }
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed; // nullable

  const PrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

