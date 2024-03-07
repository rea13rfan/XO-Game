import 'package:flutter/material.dart';

void main() {
  runApp(XOGame());
}

class XOGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XO Game',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: Center(child: Text('XO Game')),
        ),
        body: Center(
          child: XOBoard(),
        ),
      ),
    );
  }
}

class XOBoard extends StatefulWidget {
  @override
  XOBoardState createState() => XOBoardState();
}

class XOBoardState extends State<XOBoard> {
  late List<List<String>> boardState;
  late bool isPlayerX;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

  void initializeBoard() {
    boardState = List.generate(3, (_) => List.filled(3, ''));
    isPlayerX = true;
    gameOver = false;
  }

  void placeMark(int row, int col) {
    if (!gameOver && boardState[row][col].isEmpty) {
      setState(() {
        boardState[row][col] = isPlayerX ? 'X' : 'O';
        checkWinner(row, col);
        checkDraw();
        isPlayerX = !isPlayerX;
      });
    }
  }

  void checkWinner(int row, int col) {
    String currentMark = boardState[row][col];
    bool rowWin = true, colWin = true, mainDiagWin = true, antiDiagWin = true;

    for (int i = 0; i < 3; i++) {
      if (boardState[row][i] != currentMark) rowWin = false;
      if (boardState[i][col] != currentMark) colWin = false;
      if (boardState[i][i] != currentMark) mainDiagWin = false;
      if (boardState[i][2 - i] != currentMark) antiDiagWin = false;
    }

    if (rowWin || colWin || mainDiagWin || antiDiagWin) {
      showWinnerDialog(currentMark);
      setState(() {
        gameOver = true;
      });
    }
  }

  void checkDraw() {
    bool isBoardFull = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (boardState[i][j].isEmpty) {
          isBoardFull = false;
          break;
        }
      }
    }

    if (isBoardFull && !gameOver) {
      showDrawDialog();
      setState(() {
        gameOver = true;
      });
    }
  }

  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Player $winner wins!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetBoard();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void showDrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('It\'s a draw! Try to play again'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetBoard();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void resetBoard() {
    setState(() {
      initializeBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          gameOver
              ? ''
              : isPlayerX
              ? "Player X's turn"
              : "Player O's turn",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20.0),
        Column(
          children: List.generate(3, (row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (col) {
                return GestureDetector(
                  onTap: () => placeMark(row, col),
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Center(
                      child: Text(
                        boardState[row][col],
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
        SizedBox(height: 30.0),
        ElevatedButton(
          onPressed: resetBoard,
          child: Text('Reset Board'),
        ),
      ],
    );
  }
}




