import 'package:flutter/material.dart';

class TvView extends StatelessWidget {
  const TvView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tv, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text('TV Page', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
