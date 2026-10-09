// lib/app/app.dart

import 'package:flutter/material.dart';

import 'router.dart';

class WishQueueApp extends StatelessWidget {
  const WishQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WishQueue',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
