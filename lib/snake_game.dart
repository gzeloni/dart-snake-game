import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:snake/direction.dart';
import 'package:snake/position.dart';

class SnakeGame {
  final int width;
  final int height;
  final List<Position> snake = [];
  Position? fruit;
  Direction direction = Direction.right;
  bool gameOver = false;
  Timer? timer;

  SnakeGame(this.width, this.height) {
    snake.add(Position(width ~/ 2, height ~/ 2));
    spawnFruit();
  }

  void start() {
    setupInput();

    timer = Timer.periodic(Duration(milliseconds: 200), (Timer t) {
      update();
      if (gameOver) {
        t.cancel();
        print("Fim de Jogo!");
        exit(0);
      }
      render();
    });
  }

  void setupInput() {
    stdin.lineMode = false;
    stdin.echoMode = false;

    stdin.listen((List<int> codes) {
      try {
        final first = codes.first;
        final len = codes.length;

        if (len == 1 && ((first > 0x01 && first < 0x20) || first == 0x7f)) {
          handleControlCode(first);
        } else if (len > 1 && first == 0x1b && codes[1] == 0x5b) {
          handleEscapeSequence(codes[2]);
        } else {
          throw Exception('Tecla digitada não reconhecida');
        }
      } catch (e) {
        print('Erro: $e');
      }
    });
  }

  void handleControlCode(int code) {
    if (code == 0x09) {
      // Tab key pressed
      // Implement your logic here
    }
    // Handle other control codes if needed
  }

  void handleEscapeSequence(int code) {
    try {
      switch (code) {
        case 0x41:
          // Up Arrow
          if (direction != Direction.down) {
            direction = Direction.up;
          }
          break;
        case 0x42:
          // Down Arrow
          if (direction != Direction.up) {
            direction = Direction.down;
          }
          break;
        case 0x43:
          // Right Arrow
          if (direction != Direction.left) {
            direction = Direction.right;
          }
          break;
        case 0x44:
          // Left Arrow
          if (direction != Direction.right) {
            direction = Direction.left;
          }
          break;
        default:
          throw Exception('Tecla de seta inválida');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  void update() {
    final nextPos = Position(snake.first.x, snake.first.y);
    switch (direction) {
      case Direction.up:
        nextPos.y -= 1;
        break;
      case Direction.down:
        nextPos.y += 1;
        break;
      case Direction.left:
        nextPos.x -= 1;
        break;
      case Direction.right:
        nextPos.x += 1;
        break;
    }

    if (isOutOfBounds(nextPos) || isSnakeCollision(nextPos)) {
      gameOver = true;
      return;
    }

    snake.insert(0, nextPos);

    if (nextPos.x == fruit!.x && nextPos.y == fruit!.y) {
      spawnFruit();
    } else {
      snake.removeLast();
    }
  }

  bool isOutOfBounds(Position pos) {
    return pos.x < 0 || pos.x >= width || pos.y < 0 || pos.y >= height;
  }

  bool isSnakeCollision(Position pos) {
    return snake.any((p) => p.x == pos.x && p.y == pos.y);
  }

  void spawnFruit() {
    final random = Random();
    int x = random.nextInt(width);
    int y = random.nextInt(height);
    while (isSnakeCollision(Position(x, y))) {
      x = random.nextInt(width);
      y = random.nextInt(height);
    }
    fruit = Position(x, y);
  }

  void render() {
    stdout.write('\x1b[2J');
    stdout.write('\n');
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        if (i == fruit!.y && j == fruit!.x) {
          stdout.write('* ');
        } else if (snake.any((p) => p.x == j && p.y == i)) {
          stdout.write('# ');
        } else {
          stdout.write('. ');
        }
      }
      stdout.write('\n');
    }
  }
}
