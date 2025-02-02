import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/utils/pagination_mixin.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/common/scroll_to_top_scaffold.dart';
import 'package:glider/widgets/inbox/inbox_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeStateProvider<int> inboxPaginationStateProvider =
    StateProvider.autoDispose<int>(
  (AutoDisposeStateProviderRef<int> ref) => PaginationMixin.initialPage,
);

class InboxPage extends HookConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollToTopScaffold(
      body: FloatingAppBarScrollView(
        title: Text(AppLocalizations.of(context).inbox),
        body: const InboxBody(),
      ),
    );
  }
}
