import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav_beladiya/ui/screens/post_list/post_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Posts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const PostListScreen(),
    );
  }
}

// Removed template counter screen; app starts at PostListScreen
