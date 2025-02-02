import 'package:flutter/material.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/loading.dart';
import 'package:glider/widgets/users/user_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountLoggedIn extends HookConsumerWidget {
  const AccountLoggedIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(usernameProvider).when(
          data: _userDataBuilder,
          loading: () => const Loading(),
          error: (_, __) => const Error(),
        );
  }

  Widget _userDataBuilder(String? username) =>
      username != null ? UserBody(id: username) : const Error();
}
