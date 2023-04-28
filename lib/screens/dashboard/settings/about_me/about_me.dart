import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../extensions/widget_extension.dart';
import '../../../../widgets/app_scaffold.dart';
import '../../../../widgets/app_snackbar.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/social_icon.dart';

class AboutMeView extends StatelessWidget {
  const AboutMeView({super.key});

  String get gMail => 'tolgasoz1@gmail.com';
  String get urlLinkedIn => 'https://www.linkedin.com/in/tolga-sözbir/';
  String get urlGit => 'https://github.com/tolgasozbir';
  String get urlInstagram => 'https://www.instagram.com/tolga_sozbir/';
  List<Map<String, dynamic>> get technologyList => const [
    {
      'tool' : 'Flutter',
      'icon' : ImagePaths.icFlutter,
      'color' : Colors.blue,
    },
    {
      'tool' : 'C#',
      'icon' : ImagePaths.icCsharp,
      'color' : Colors.purpleAccent,
    },
    {
      'tool' : 'Firebase',
      'icon' : ImagePaths.icFirebase,
      'color' : Colors.amber,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppScaffold(
        body: SizedBox.expand(
          child: CustomPaint(
            painter: AboutMePainter(),
            child: _bodyView(context),
          ),
        ),
      ),
    );
  }

  Column _bodyView(BuildContext context) {
    return Column(
      children: [
        const ProfileAvatar(),
        const EmptyBox.h32(),
        socialIcons(),
        whiteDivider(context),
        const EmptyBox.h32(),
        technologies(),
        const EmptyBox.h32(),
        aboutMeBio(context)
      ],
    );
  }

  Row socialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialIcon(
          icon: FontAwesomeIcons.google, 
          corner: Corner.left,
          onTap: () => socialBtnFn(gMail, sendMail: true),
        ),
        SocialIcon(
          icon: FontAwesomeIcons.linkedin,
          onTap: () => socialBtnFn(urlLinkedIn),
        ),
        SocialIcon(
          icon: FontAwesomeIcons.github,
          onTap: () => socialBtnFn(urlGit),
        ),
        SocialIcon(
          icon: FontAwesomeIcons.instagram, 
          corner: Corner.right,
          onTap: () => socialBtnFn(urlInstagram),
        ),
      ],
    );
  }

  Future<void> socialBtnFn(String path, {bool sendMail = false}) async {
    try{
      Uri? url;
      if (!sendMail) url = Uri.parse(path);
      else {
        url = Uri(
          scheme: 'mailto',
          path: path,
        );
      }
      await launchUrl(url);
    }
    catch(e) {
      AppSnackBar.showSnackBarMessage(text: AppStrings.errorMessage, snackBartype: SnackBarType.error);
    }
  }

  Divider whiteDivider(BuildContext context) {
    return Divider(
      color: AppColors.white, 
      thickness: 1,
      indent: context.dynamicWidth(0.24),
      endIndent: context.dynamicWidth(0.24),
    );
  }

  Column technologies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(AppStrings.langsAndTools, style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          children: List.generate(technologyList.length, (index) {
            final item = technologyList[index];
            return Chip(
              side: BorderSide(
                strokeAlign: BorderSide.strokeAlignOutside,
                color: item['color'] as Color,
              ),
              label: Text(item['tool'] as String), 
              avatar: Image.asset(item['icon'] as String ),
              labelPadding: const EdgeInsets.only(left: 2, right: 4),
            ).wrapPadding(const EdgeInsets.symmetric(horizontal: 3));
          }),
        ),
      ],
    );
  }

  Container aboutMeBio(BuildContext context) {
    final boxDecoration = BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(4),
        bottomLeft: Radius.circular(4),
        bottomRight: Radius.circular(8),
      ),
      border: Border.all(color: AppColors.white30),
    );

    return Container(
      padding: const EdgeInsets.all(8),
      width: context.dynamicWidth(0.72),
      decoration: boxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.aboutMe, 
            style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.bold),
          ),
          const EmptyBox.h4(),
          Text(
            AppStrings.bio,
            style: TextStyle(fontSize: context.sp(12)),
          ),
        ],
      ),
    );
  }

}

class AboutMePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final gradient = const LinearGradient(
      colors: AppColors.aboutMeGradient,
    ).createShader(
        Rect.fromCenter(
          center: Offset(width/2, height/2), 
          width: width, 
          height: height,
        ),
      );

    final paint = Paint();
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
