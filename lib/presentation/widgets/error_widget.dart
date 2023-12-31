import 'package:flutter/material.dart';

import '/domain/exceptions/app_exception.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget(
      {super.key, required this.exceptionCaught, this.onPressed});
  final AppException? exceptionCaught;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final exception = exceptionCaught ?? AppException();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            exception.title ?? "",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            exception.message ?? "",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onPressed != null) ...[
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  backgroundColor: Theme.of(context).colorScheme.surface),
              onPressed: onPressed,
              child: const Text("Retry"),
            ),
          ]
        ],
      ),
    );
  }
}
