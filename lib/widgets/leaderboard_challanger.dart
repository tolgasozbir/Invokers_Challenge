import '../extensions/context_extension.dart';
import '../extensions/widget_extension.dart';
import '../constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_strings.dart';
import '../models/challenger_result.dart';
import '../providers/game_provider.dart';

class LeaderboardChallanger extends StatefulWidget {
  const LeaderboardChallanger({super.key,});

  @override
  State<LeaderboardChallanger> createState() => _LeaderboardChallangerState();
}

class _LeaderboardChallangerState extends State<LeaderboardChallanger> {

  List<ChallengerResult> results = [];
  bool isLoading = false;

  @override
  void initState() {
    Future.microtask(() async {
      changeLoading();
      results = await context.read<GameProvider>().databaseService.getChallangerScores();
      changeLoading();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.read<GameProvider>().databaseService.dispose();
    super.didChangeDependencies();
  }

  void changeLoading() {
    if (!mounted) return;
    setState(() { 
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        results.isEmpty ? const CircularProgressIndicator.adaptive().wrapCenter() : resultListView(results),
        if (results.isNotEmpty)
          showMoreBtn().wrapPadding(const EdgeInsets.all(8))
      ],
    );
  }

  SizedBox showMoreBtn() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : () async {
          changeLoading();
          await Future.delayed(const Duration(seconds: 1));
          results.addAll(await context.read<GameProvider>().databaseService.getChallangerScores());
          changeLoading();
        },
        child: Text(AppStrings.showMore, style: TextStyle(fontSize: context.sp(12)),),
      ),
    );
  }

  ListView resultListView(List<ChallengerResult> results) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount:results.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        final data = results[index];
        return Card(
          color: AppColors.dialogBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  '  ${index+1}.  ${data.name}',
                  style: TextStyle(color: Color(0xFFEEEEEE), fontSize: context.sp(13)),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ),
              Expanded(
                flex: 2, 
                child: Center(
                  child: Text(
                    data.time.toString(),
                    style: TextStyle(color: Color(0xFFFFCC00), fontSize: context.sp(13)),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              Expanded(
                flex: 2, 
                child: Center(
                  child: Text(
                    '${data.score}    ',
                    style: TextStyle(color: Color(0xFF00FF00), fontSize: context.sp(13)),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
