import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glider/models/user_menu_action.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserBottomSheet extends HookConsumerWidget {
  const UserBottomSheet({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollableBottomSheet(
      children: <Widget>[
        for (UserMenuAction menuAction in UserMenuAction.values)
          ListTile(
            leading: Icon(menuAction.icon(context)),
            title: Text(menuAction.title(context)),
            onTap: () async {
              Navigator.of(context).pop();
              unawaited(menuAction.command(context, ref, id: id).execute());
            },
          ),
      ],
    );
  }
}
