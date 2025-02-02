import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Experimental extends HookConsumerWidget {
  const Experimental({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Block(
      child: Row(
        children: <Widget>[
          Icon(
            FluentIcons.warning_24_regular,
            size:
                Theme.of(context).textTheme.bodyMedium?.scaledFontSize(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(AppLocalizations.of(context).experimentalDescription),
          ),
        ],
      ),
    );
  }
}
