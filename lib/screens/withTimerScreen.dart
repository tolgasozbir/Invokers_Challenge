import 'dart:async';
import 'package:dota2_invoker/components/dbResultWidget.dart';
import 'package:dota2_invoker/widgets/big_spell_picture.dart';
import 'package:dota2_invoker/components/trueFalseWidget.dart';
import 'package:dota2_invoker/entities/DbAccesLayer.dart';
import 'package:dota2_invoker/providers/timer_provider.dart';
import 'package:dota2_invoker/entities/sounds.dart';
import 'package:dota2_invoker/models/spell.dart';
import 'package:dota2_invoker/entities/spells.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class WithTimerScreen extends StatefulWidget {
  const WithTimerScreen({ Key? key }) : super(key: key);

  @override
  _WithTimerScreenState createState() => _WithTimerScreenState();
}

class _WithTimerScreenState extends State<WithTimerScreen> with TickerProviderStateMixin {

  
  DbAccesLayer dbAccesLayer = DbAccesLayer();

  String textfieldValue="Unnamed";
  Timer? timer;
  Sounds _sounds =Sounds();
  double startButtonOpacity=1.0;
  List<String> spellList=[];
  Spells spells=Spells();
  bool isStart=false;
  int trueCounterValue=0;
  late int result;
  String randomSpellImg="images/quas-wex-exort.jpg";
  List<String> currentCombination=["q","w","e"];
  List<String> trueCombination=[];

  void switchElements(String image,String key) {
    selectedElement.removeAt(0);
    currentCombination.removeAt(0);
    currentCombination.add(key);
    selectedElement.add(invokerSelectedElements(image));
    setState(() {});
  }

  late List<dynamic> selectedElement=[
    invokerSelectedElements("images/invoker_quas.png"),
    invokerSelectedElements("images/invoker_wex.png"),
    invokerSelectedElements("images/invoker_exort.png"),
  ];

  late AnimationController animControlTrue;
  late Animation<double> animTranslateTrue;
  late Animation<double> animAlphaTrue;

  late AnimationController animControlFalse;
  late Animation<double> animTranslateFalse;
  late Animation<double> animAlphaFalse;

  @override
  void dispose() {
    if (timer!=null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animControlTrue=AnimationController(vsync: this,duration: Duration(milliseconds: 600));
    animTranslateTrue=Tween(begin: 8.0.h,end: -12.0.h).animate(animControlTrue)..addListener(() {setState(() { });});
    animAlphaTrue=Tween(begin: 1.0,end: 0.0).animate(animControlTrue)..addListener(() {setState(() { });});
    animControlFalse=AnimationController(vsync: this,duration: Duration(milliseconds: 600));
    animTranslateFalse=Tween(begin: 8.0.h,end: -12.0.h).animate(animControlFalse)..addListener(() {setState(() { });});
    animAlphaFalse=Tween(begin: 1.0,end: 0.0).animate(animControlFalse)..addListener(() {setState(() { });});

    spellList=spells.getSpellImagePaths;

    dbAccesLayer.getAllResultOnce();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TimerProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: buildBody(),
          ),
        ),
      );
    });
  }

  Widget buildBody() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          trueCounter(),
          timerCounter(),
          trueFalseIcons(),
          invokerCombinedSkillWidget(),
          selectedElements(),
          invokerMainElements(),
          startButton(),
          showLeaderBoardButton(),
          //dbResults(),
        ],
      ),
    );
  }

  Widget trueCounter(){
    return Container(
      width: double.infinity,
      height: 12.h,
      child: Stack(
        children: [
          Center(child: Text(trueCounterValue.toString(),style: TextStyle(fontSize: 12.w,color: Colors.green,),)),
        ],
      ),
    );
  }

  Widget timerCounter() {
    return Card(
      color: Color(0xFF303030),
      child: Consumer<TimerProvider>(builder: (context, timerModel, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
          SizedBox(width: 14.w, height: 14.w, child: CircularProgressIndicator(
            color: Colors.amber,
            backgroundColor: Colors.blue,
            valueColor: timerModel.getCountdownValue.toDouble()<=10 ? AlwaysStoppedAnimation<Color>(Colors.red) : AlwaysStoppedAnimation<Color>(Colors.amber),
            value: timerModel.getCountdownValue.toDouble()/60,
            strokeWidth: 4,
          ),),
          Text( " ${timerModel.getCountdownValue} ",style: TextStyle(fontSize: 8.w,),)
          ],
        );
      }),
    );
  }

  Widget trueFalseIcons() {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: TrueFalseWidget(
        // animTranslateTrue: animTranslateTrue, 
        // animAlphaTrue: animAlphaTrue, 
        // animTranslateFalse: animTranslateFalse, 
        // animAlphaFalse: animAlphaFalse
      ),
    );
  }

  BigSpellPicture invokerCombinedSkillWidget() {
    return BigSpellPicture(image: randomSpellImg,size: 28.w,);
  }

  Widget invokerSelectedElements(String image) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [ BoxShadow(color: Colors.black54, blurRadius: 12, spreadRadius: 4), ],
      ),
      child: Image.asset(image,width: 7.w,)
    );
  }

  Padding selectedElements() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: 25.w,
        height: 10.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selectedElement[0],
            selectedElement[1],
            selectedElement[2],
          ],
        ),
      ),
    );
  }

  Row invokerMainElements() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        invokerElement("images/invoker_quas.png"),
        invokerElement("images/invoker_wex.png"),
        invokerElement("images/invoker_exort.png"),
        invokerElement("images/invoker_invoke.png"),
      ],
    );
  }

  GestureDetector invokerElement(String image) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [ BoxShadow(color: Colors.black54, blurRadius: 12, spreadRadius: 4), ],
        ),
        child: Image.asset(image,width: 20.w,)
      ),
      onTap: () {
        if(image=="images/invoker_quas.png"){
          switchElements("images/invoker_quas.png","q");
        }
        else if(image=="images/invoker_wex.png"){
          switchElements("images/invoker_wex.png","w");
        }
        else if(image=="images/invoker_exort.png"){
          switchElements("images/invoker_exort.png","e");
        }
        else{
          if(isStart){          
            if (currentCombination.toString()==trueCombination.toString()) {
              print("true");
              Spell nextSpell=spells.getRandomSpell;
              _sounds.trueCombinationSound(trueCombination);
              setState(() { });
              trueCounterValue++;
              randomSpellImg=nextSpell.image;
              trueCombination=nextSpell.combine;
              animControlTrue.forward();
              Timer(Duration(milliseconds: 600), (){animControlTrue.reset();});
            }else{
              print("false");
              _sounds.failCombinationSound();
              animControlFalse.forward();
              Timer(Duration(milliseconds: 600), (){animControlFalse.reset();});
            }
            print(trueCombination);
          }
        }
      },
    );
  }


  Widget startButton() {
    return Transform.translate(offset: Offset(0.0,48.0),
      child: Opacity(
        opacity: startButtonOpacity,
        child: SizedBox(
          width: 36.w,
          height: 6.h,
          child: Consumer<TimerProvider>(
            builder: (context,timerModel,child){
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF545454),
                ),
                child: Text("Start",style: TextStyle(fontSize: 12.sp),),
                onPressed: isStart != true ? () {
                  isStart=true;
                  timer=Timer.periodic(Duration(seconds: 1), (timer) { 
                      timerModel.decreaseCountdownValue();
                      if (timerModel.getCountdownValue==0) {
                        result=trueCounterValue;
                        timer.cancel();
                        isStart=false;
                        startButtonOpacity=1.0;
                        timerModel.resetCountdownValue();
                        resultDiaglog();
                        setState(() { });
                      }
                  });
                  Spell nextSpell = spells.getRandomSpell;
                  randomSpellImg = nextSpell.image;
                  trueCombination = nextSpell.combine;
                  startButtonOpacity=0.0;
                  trueCounterValue=0;
                  //timerModel.time60=60;
                  setState(() {});
                } : null,
              );
            },
          )
        ),
      ),
    );
  }

  Widget showLeaderBoardButton() {
    return Transform.translate(offset: Offset(0.0,64.0),
      child: Opacity(
        opacity: startButtonOpacity,
        child: SizedBox(
          width: 36.w,
          height: 6.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF545454),
            ),
            child: Text("Leaderboard",style: TextStyle(fontSize: 12.sp),),
            onPressed: () {
              dbResultDiaglog();
            },
          ),
        ),
      ),
    );
  }


  void dbResultDiaglog() {
    showDialog(
      context: context,
      builder: (_) => myLeaderboardAlertDialog(),
      barrierDismissible: false,
    );
  }

  Widget myLeaderboardAlertDialog(){
   return AlertDialog(
      title: Text("Results",style: TextStyle(color: Color(0xFFEEEEEE),)),
      content: SizedBox(width: 65.w,height: 35.h, child: Card(color:Color(0xFF666666) , child: DbResultWidget())),
      backgroundColor: Color(0xFF444444),
      actions: [
        TextButton(
          child: Text("Back"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],
    );
 }

  void resultDiaglog(){
    showDialog(
      context: context,
      builder: (_) => myAlertDialog(),
      barrierDismissible: false,
    );
  }

 Widget myAlertDialog(){
   return AlertDialog(
      title: Text("Results",style: TextStyle(color: Color(0xFFEEEEEE),)),
      content: Container(
        width: double.infinity,
        height: 27.5.h,
        child: Column(
          children: [
            Text("True Combinations\n\n$result",style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFFEEEEEE), fontSize: 18),textAlign: TextAlign.center,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLength: 14,
                decoration: InputDecoration(
                  fillColor: Colors.white24,
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "Name",
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.amber, fontSize: 18,fontWeight: FontWeight.w600)
                ),
                onChanged: (value){
                  if (value.length<=0) {
                    textfieldValue="Unnamed";
                  }
                  else{
                    textfieldValue=value;
                  }
                },
              ),
            )
          ],
        )
      ),
      backgroundColor: Color(0xFF444444),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              child: Text("Back"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Send"),
              onPressed: (){
                if (textfieldValue.length<=0) {
                    textfieldValue="Unnamed";
                }
                dbAccesLayer.addDbValue(textfieldValue,result);
                textfieldValue="";
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
 }

}
