// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_single_cascade_in_expression_statements, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tictac_app/home_screen.dart';

class GameScreen extends StatefulWidget {
  String player1;
  String player2;
  GameScreen({super.key, required this.player1, required this.player2});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> _board;
  late String _currplayer;
  late String _winner;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.generate(3, (_) => ""));
    _currplayer = "X";
    _winner = "";
    _gameOver = false;
  }

  //Reset Game
  void resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ""));
      _currplayer = "X";
      _winner = "";
      _gameOver = false;
    });
  }

  void makeMove(int row, int col) {
    if (_board[row][col] != "" || _gameOver) {
      return;
    }
    setState(() {
      _board[row][col] = _currplayer;
    });
    //row check
    if (_board[row][0] == _currplayer &&
        _board[row][1] == _currplayer &&
        _board[row][2] == _currplayer) {
      _winner = _currplayer;
      _gameOver = true;
    } 
    //col check
    else if (_board[0][col] == _currplayer &&
        _board[1][col] == _currplayer &&
        _board[2][col] == _currplayer) {
      _winner = _currplayer;
      _gameOver = true;
    } 
    //diagnol check
    else if (_board[0][0] == _currplayer &&
        _board[1][1] == _currplayer &&
        _board[2][2] == _currplayer) {
      _winner = _currplayer;
      _gameOver = true;
    } else if (_board[0][2] == _currplayer &&
        _board[1][1] == _currplayer &&
        _board[2][0] == _currplayer) {
      _winner = _currplayer;
      _gameOver = true;
    }

    //switch players
    _currplayer = _currplayer == "X" ? "O" : "X";

    //check for a tie
    if (!_board.any((row) => row.any((cell) => cell == ""))) {
      _gameOver = true;
      _winner = "It's a tie";
    }

    if (_winner != "") {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          btnOkText: "Play Again",
          title: _winner == "X"
              ? widget.player1 + " " + "Won!"
              : _winner == "O"
                  ? widget.player2 + " " + "Won!"
                  : "It's a tie",
          btnOkOnPress: () {
            resetGame();
          })
        ..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 47, 114),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          SizedBox(
            height: 120,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Turn: ",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  Text(
                      _currplayer == "X"
                          ? widget.player1 + " ($_currplayer)"
                          : widget.player2 + " ($_currplayer)",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: _currplayer == "X"
                            ? Color.fromARGB(255, 202, 248, 50)
                            : Colors.lightBlueAccent,
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(5),
            child: GridView.builder(
                itemCount: 9,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => makeMove(row, col),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 3, 47, 114),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          _board[row][col],
                          style: TextStyle(
                            letterSpacing: 5,
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: _currplayer == "X"
                                ? Color.fromARGB(255, 202, 248, 50)
                                : Colors.lightBlueAccent,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: resetGame,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Reset Game",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                  widget.player1 = "";
                  widget.player2 = "";
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Restart Game",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
