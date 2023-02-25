import 'dart:math';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Corner {left, middle, right}

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _duration = Duration(milliseconds: 800);

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: _duration, reverseDuration: _duration);
    _animation = Tween<double>(begin: 4, end: 8).animate(_animationController);
    _animationController.repeat(reverse: true);
    _animationController.addListener(() {
      setState(() { });
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  BorderRadius getCornerRadius(Corner corner) {
    switch (corner) {
      case Corner.left:
        return const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(2),
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(4),
        );
      case Corner.middle:
        return const BorderRadius.all(Radius.circular(2));
      case Corner.right:
        return const BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(2),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: CustomPaint(
            painter: AboutMePainter(),
            child: Column(
              children: [
                avatar(context),
                EmptyBox.h24(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialIcon(FontAwesomeIcons.google, corner: Corner.left),
                    socialIcon(FontAwesomeIcons.linkedin),
                    socialIcon(FontAwesomeIcons.github),
                    socialIcon(FontAwesomeIcons.instagram, corner: Corner.right),
                  ],
                ),
                Divider(
                  color: Colors.white, 
                  thickness: 1,
                  indent: context.dynamicWidth(0.24),
                  endIndent: context.dynamicWidth(0.24),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget avatar(BuildContext context) {
    return Container(
      color: Colors.green.withOpacity(0.1),
      height: context.height/3,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: BackButton(),
          ),
          Positioned(
            top: context.dynamicHeight(0.08),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: context.dynamicHeight(0.086),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/other/profile.jpeg"),
                radius: context.dynamicHeight(0.08),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: 0,
                      right: -context.dynamicHeight(0.004),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: context.dynamicHeight(0.024),
                        child: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          radius: context.dynamicHeight(0.020),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: ArcText(
              radius: context.height/3,
              text: "Tolga Sözbir",
              textStyle: TextStyle(
                fontSize: context.sp(20),
                fontWeight: FontWeight.w500, 
                shadows: [Shadow(blurRadius: 8,),],
              ),
              direction: Direction.counterClockwise,
              startAngleAlignment: StartAngleAlignment.center,
              startAngle: pi,
              placement: Placement.inside,
            ),
          )
        ],
      ),
    );
  }

  Widget socialIcon(IconData icon, {Corner corner = Corner.middle}) {
    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: getCornerRadius(corner),
        border: Border.all(color: Colors.white),
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.deepPurpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: _animation.value,
            color: Colors.white
          )
        ]
      ),
      child: Icon(icon),
    );
  }  
}


class AboutMePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final gradient = LinearGradient(
      colors: [Colors.purple, Colors.deepPurpleAccent],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(
        Rect.fromCenter(
          center: Offset(width/2, height/2), 
          width: width, 
          height: height
        ),
      );

    Paint paint = Paint();
    paint.shader = gradient;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(width, height/4);
    path.quadraticBezierTo(width/2, height/2.2, 0, height/4);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(AboutMePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(AboutMePainter oldDelegate) => false;
}
