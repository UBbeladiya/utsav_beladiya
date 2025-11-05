import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryController extends GetxController {
  // Position of the emoji (default: center of screen)
  final Rx<Offset?> emojiPosition = Rx<Offset?>(null);
  
  // Initialize emoji position to center
  void initializePosition(Size screenSize) {
    if (emojiPosition.value == null) {
      emojiPosition.value = Offset(
        screenSize.width / 2,
        screenSize.height / 2,
      );
    }
  }
  
  // Update emoji position when dragged
  void updatePosition(Offset newPosition) {
    emojiPosition.value = newPosition;
  }
}

