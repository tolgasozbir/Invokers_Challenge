import 'dart:async';
import 'package:dota2_invoker/constants/app_colors.dart';
import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/trueFalseWidget.dart';
import '../../../providers/timer_provider.dart';
import 'training_view.dart';

abstract class TrainingViewModel extends State<TrainingView> with TickerProviderStateMixin {

  final globalAnimKey = GlobalKey<TrueFalseWidgetState>();

  bool isStart = false;
  bool showAllSpells = false;

  List<String> currentCombination=["q","w","e"];

  BoxDecoration skillBlackShadowDec = BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.blackShadow, 
        blurRadius: 12, 
        spreadRadius: 4
      ),
    ],
  );

  @override
  void initState() {
    init();
    super.initState();
  }
  
  void init() async {
    Future.microtask(() => context.read<TimerProvider>().resetTimer());
  }
  

  late List<Widget> selectedOrbs = [
    orb(ImagePaths.quasOrb),
    orb(ImagePaths.wexOrb),
    orb(ImagePaths.exortOrb),
  ];

  Widget orb(String image) {
    return Container(
      decoration: skillBlackShadowDec,
      child: Image.asset(image,width: context.dynamicWidth(0.07))
    );
  }

  void switchOrb(String image,String key) {
    context.read<TimerProvider>().increaseTotalTabs();
    selectedOrbs.removeAt(0);
    currentCombination.removeAt(0);
    currentCombination.add(key);
    selectedOrbs.add(orb(image));
    setState(() {});
  }

}