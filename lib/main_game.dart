import 'dart:math';

import 'package:flutter/material.dart';

class MainGame extends StatefulWidget {
  const MainGame({Key? key}) : super(key: key);

  @override
  State<MainGame> createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  static const String Player_X = "X";
  static const String Player_Y = "o";

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = Player_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _heaederText(),
          _gameContainer(),
          _resetButton(),
        ],
      )),
    );
  }

  _resetButton(){
    return ElevatedButton(onPressed: () {
      setState(() {
        initializeGame();
      });
    }, child: Text("Restart Game"));
  }

  Widget _heaederText() {
    return Column(
      children: [
        const Text(
          "Tic Tae Toe",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ],
    );
  }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 9,
        itemBuilder: (context, index) {
          return _box(index);
        },
      ),
    );
  }

  Widget _box(int index) {
    return InkWell(
      onTap: () {
        if (gameEnd || occupied[index].isNotEmpty) {
          return;
        }
        setState(() {
          occupied[index] = currentPlayer;
          // if (currentPlayer == Player_X) {
            currentPlayer = Player_Y;
          // } else {
          //   currentPlayer = Player_X;
          // }
          checkForWinner();
          checkForDraw();
          autoFill();
        });

        // setState(() {});
      },
      child: Container(
        color: occupied[index].isEmpty
            ? Colors.black26
            : occupied[index] == Player_X
                ? Colors.blue
                : Colors.black,
        margin: EdgeInsets.all(8),
        child: Center(
            child: Text(
          occupied[index],
          style: TextStyle(fontSize: 50,color: Colors.white),
        )),
      ),
    );
  }

  autoFill(){
    // bestMove(occupied);
    // currentPlayer = Player_X;

    var rng = Random();
    // var i = minmax(occupied,3,true);
    // print(i);
    while(!gameEnd) {
      checkForWinner();
      checkForDraw();
      int i = rng.nextInt(8);
      if (occupied[i].isEmpty) {
        occupied[i] = currentPlayer;
        currentPlayer = Player_X;
        break;
      }
    }
  }

  void bestMove(List<String> board){
    bool flag = true;
    for(var i in board){
      if(i != ""){
        flag = false;
        break;
      }
    }
    if(flag){
      return;
    }
    var bestScore = -1000000000000000000;
    var bestI;
    for(int i = 0;i<board.length;i++){
      if(board[i] == ""){
        board[i] = currentPlayer;
        var score = minimax(board,0,false);
        board[i] = "";
        if(score>=bestScore){
          bestScore = score;
          bestI = i;
        }
      }
    }
    // print(bestI);
    occupied[bestI] = currentPlayer;
    currentPlayer = Player_X;
  }

  int minimax(List<String> board,int depth,bool isMaximizing){
    // int result = checkForWinner();
    // if(result != 0){
    //   return result;
    // }
    if(isMaximizing){
      var bestScore = -1000000000000000000;
      for(int i = 0;i<board.length;i++){
        if(board[i] == ""){
          board[i] = Player_Y;
          var score = minimax(board, depth+1, false);
          board[i] = "";
          bestScore = max(score, bestScore);
          // print(score);
        }
      }
      // print(bestScore);
      return bestScore;
    }
    else{
      var bestScore = 1000000000000000000;
      for(int i = 0; i<board.length;i++){
        if(board[i] == ""){
          board[i] = Player_X;
          var score = minimax(board, depth+1, true);
          board[i] = "";
          bestScore = min(bestScore, score);
        }
      }
      gameEnd = false;
      return bestScore;
    }
  }
  //
  //
  // int minimax(board, depth, isMaximizing) {
  //   var result = checkWin(board);
  //   if (result != '') {
  //     return scores[result]!;
  //   }
  //   if (isMaximizing) {
  //     var bestScore = -1000000000000000000;
  //     for (var i = 0; i < 3; i++) {
  //       for (var j = 0; j < 3; j++) {
  //         // Is the spot available?
  //         if (board[i][j] == '') {
  //           board[i][j] = players[0];
  //           var score = minimax(board, depth + 1, false);
  //           board[i][j] = '';
  //
  //           bestScore = max(score, bestScore);
  //         }
  //       }
  //     }
  //     return bestScore;
  //   } else {
  //     var bestScore = 1000000000000000000;
  //     for (var i = 0; i < 3; i++) {
  //       for (var j = 0; j < 3; j++) {
  //         // Is the spot available?
  //         if (board[i][j] == '') {
  //           board[i][j] = players[1];
  //           var score = minimax(board, depth + 1, true);
  //           board[i][j] = '';
  //           bestScore = min(score, bestScore);
  //         }
  //       }
  //     }
  //     isWin = false;
  //     return bestScore;
  //   }
  // }


 int checkForWinner() {
    List<List<int>> winnersList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var winner in winnersList) {
      String PlayerPosition0 = occupied[winner[0]];
      String PlayerPosition1 = occupied[winner[1]];
      String PlayerPosition2 = occupied[winner[2]];

      if (PlayerPosition0.isNotEmpty) {
        if (PlayerPosition0 == PlayerPosition1 &&
            PlayerPosition0 == PlayerPosition2) {
          showGameOverMessage("Player $PlayerPosition0 wins");
          gameEnd = true;
          if(PlayerPosition0 == "X"){
            return -1;
          }
          else if(PlayerPosition0 == "o"){
            return 1;
          }
        }
      }
    }
    return 0;
  }

  showGameOverMessage(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Game Over \n $s",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
          ),
        )));
  }

  checkForDraw(){
    if(gameEnd){
      return;
    }
    bool draw = true;
    for(var occupiedPlayer in occupied){
      if(occupiedPlayer.isEmpty){
        draw = false;
      }
    }
    if(draw){
      showGameOverMessage("Draw");
      gameEnd = true;
    }
  }
}

// void bestMove(board) {
  //   // AI to make its turn
  //
  //   bool flag = true;
  //   for (int i = 0; i < 3; i++) {
  //     for (int j = 0; j < 3; j++) {
  //       if (board[i][j] == "") {
  //         flag = false;
  //         break;
  //       }
  //     }
  //   }
  //   if (flag) {
  //     return;
  //   }
  //   var bestScore = -1000000000000000000;
  //   var move = {};
  //   for (var i = 0; i < 3; i++) {
  //     for (var j = 0; j < 3; j++) {
  //       // Is the spot available?
  //       if (board[i][j] == '') {
  //         board[i][j] = players[0];
  //         var score = minimax(board, 0, false);
  //         board[i][j] = '';
  //         if (score >= bestScore) {
  //           bestScore = score;
  //           move['i'] = i;
  //           move['j'] = j;
  //         }
  //       }
  //     }
  //   }
  //   board[move['i']][move['j']] = players[0];
  //   turn = 1;
  // }