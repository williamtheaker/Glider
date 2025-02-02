import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/models/user.dart';
import 'package:glider/providers/user_provider.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/widgets/common/options_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserOptionsCommand with CommandMixin {
  UserOptionsCommand.copy(this.context, this.ref, {required this.id})
      : optionsDialogBuilder = ((Iterable<OptionsDialogOption> options) =>
            OptionsDialog.copy(context, options: options));

  UserOptionsCommand.share(this.context, this.ref, {required this.id})
      : optionsDialogBuilder = ((Iterable<OptionsDialogOption> options) =>
            OptionsDialog.share(context, options: options));

  final BuildContext context;
  final WidgetRef ref;
  final String id;
  final Widget Function(Iterable<OptionsDialogOption>) optionsDialogBuilder;

  @override
  Future<void> execute() async {
    final User user = await ref.read(userNotifierProvider(id).notifier).load();

    final List<OptionsDialogOption> optionsDialogOptions =
        <OptionsDialogOption>[
      if (user.about != null)
        OptionsDialogOption(
          title: AppLocalizations.of(context).text,
          text: FormattingUtil.convertHtmlToHackerNews(user.about!),
        ),
      OptionsDialogOption(
        title: AppLocalizations.of(context).userLink,
        text: Uri.https(
          WebsiteRepository.authority,
          'user',
          <String, String>{'id': user.id},
        ).toString(),
      ),
    ];

    await showDialog<void>(
      context: context,
      builder: (_) => optionsDialogBuilder(optionsDialogOptions),
    );
  }
}
