import 'dart:io';

import 'package:snake/show_menu.dart';
import 'package:snake/snake_game.dart';

void main() {
  while (true) {
    try {
      showMenu();
      String? m = stdin.readLineSync();
      String mLower = m!.toLowerCase();
      if (mLower == 'f') {
        final game = SnakeGame(50, 20);
        game.start();
      } else if (mLower == 'm') {
        final game = SnakeGame(30, 15);
        game.start();
      } else if (mLower == 'd') {
        final game = SnakeGame(20, 10);
        game.start();
      } else {
        break;
      }
    } catch (e) {
      print('Erro: $e');
    }
  }
}
