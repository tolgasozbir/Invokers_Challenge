import 'package:dota2_invoker_game/constants/app_strings.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../providers/boss_battle_provider.dart';
import '../../../../utils/game_save_handler.dart';
import '../../../../widgets/app_snackbar.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BossBattleProvider>(
      builder: (context, provider, child) {
        return Visibility(
          visible: provider.isSavingEnabled,
          child: RawChip(
            side: BorderSide(color: AppColors.white.withOpacity(0.2)),
            onPressed: () => saveGameFn(context),
            avatar: const Icon(Icons.save),
            label: const Text(AppStrings.save),
            padding: const EdgeInsets.fromLTRB(12, 2, 6, 2),
            backgroundColor: context.theme.scaffoldBackgroundColor,
          ),
        );
      },
    );
  }

  void saveGameFn(BuildContext context) async {
    final provider = context.read<BossBattleProvider>();
    await GameSaveHandler.instance.saveGame(
      SaveProps(
        provider.roundProgress,
        //kullanıcının var olan altınını ve item networth değerini topluyoruz (neden item değerlerini topluyoruz? çünkü load ederken itemler geri alındığında eksik gold olmaması için)
        provider.userGold + provider.inventory.fold(0, (previousValue, element) => previousValue+element.item.cost), 
        provider.inventory.map((e) => e.item.name).toList(),
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    AppSnackBar.showSnackBarMessage(
      text: AppStrings.sbGameSaved, 
      snackBartype: SnackBarType.success, 
      duration: const Duration(seconds: 1),
    );
  }
}
