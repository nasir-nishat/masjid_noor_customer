import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatelessWidget {
  final VoidCallback? onClose;
  final String? message;
  const LoadingWidget({super.key, this.onClose, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null)
            Text(message!,
                style:
                    context.textTheme.bodyLarge!.copyWith(color: Colors.white)),
          const SizedBox(height: 16),
          if (onClose != null)
            ElevatedButton(
                onPressed: () {
                  onClose!();
                },
                child: const Text("Cancel"))
        ],
      ),
    );
  }
}
