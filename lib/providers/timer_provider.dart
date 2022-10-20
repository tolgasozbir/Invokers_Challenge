import 'dart:async';
import '../constants/app_strings.dart';
import '../services/database_service.dart';
import '../widgets/custom_animated_dialog.dart';
import '../widgets/result_dialog.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class TimerProvider extends ChangeNotifier {

  Timer? _timer;
  TextEditingController _textEditingController = TextEditingController();

  bool _isStart = false;
  int _timerValue = 0;
  int _countdownValue = 60;
  int _totalTabs = 0;
  int _totalCast = 0;
  int _correctCombinationCount = 0;

  bool get isStart => _isStart;
  int get getTimeValue => _timerValue;
  int get getCountdownValue => _countdownValue;
  int get getTotalTabs => _totalTabs;
  int get getTotalCast => _totalCast;
  int get getCorrectCombinationCount => _correctCombinationCount;

  double get calculateCps => _totalTabs/_timerValue;
  double get calculateScps => _totalCast/_timerValue;

  void changeIsStartStatus(){
    _isStart = !_isStart;
    notifyListeners();
  }

  void increaseTotalTabs(){
    _totalTabs++;
    notifyListeners();
  }  

  void increaseTotalCast(){
    _totalCast++;
    notifyListeners();
  }

  void increaseCorrectCounter(){
    _correctCombinationCount++;
    notifyListeners();
  }  
  
  void _increaseTimer(){
    _timerValue++;
    notifyListeners();
  }

  void _decreaseCountdownValue(){
    _countdownValue--;  
    notifyListeners();
  }

  void startTimer(){
    changeIsStartStatus();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { 
      _increaseTimer();
    });
  }

  void startCoundown(){
    changeIsStartStatus();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { 
      _decreaseCountdownValue();
      if (_countdownValue <= 0) {
        disposeTimer();
        changeIsStartStatus();
        CustomAnimatedDialog.showCustomDialog(
          title: AppStrings.result, 
          content: ResultDialog(
            correctCount: _correctCombinationCount,
            textEditingController: _textEditingController
          ),
          action: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: Text(AppStrings.send),
                onPressed: () async {
                  String name = _textEditingController.text.trim();
                  if (name.length == 0) {
                    name=AppStrings.unNamed;
                  }
                  await DatabaseService.instance.addScore(
                    table: DatabaseTable.withTimer, 
                    name: name, 
                    score: _correctCombinationCount
                  );
                  Navigator.pop(navigatorKey.currentContext!);
                },
              ),
              TextButton(
                child: Text(AppStrings.back),
                onPressed: () => Navigator.pop(navigatorKey.currentContext!),
              ),
            ],
          ),
        );
      }
    });
  }

  void resetTimer(){
    _isStart = false;
    _timerValue = 0;
    _countdownValue = 60;
    _totalTabs = 0;
    _totalCast = 0;
    _correctCombinationCount = 0;
    disposeTimer();
    notifyListeners();
  }

  void disposeTimer(){
    if (_timer!=null) {
      _timer!.cancel();
    }
  }

}