import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/models/theme_base.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/utils/color_extension.dart';
import 'package:glider/widgets/common/provider_switch_list_tile.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';
import 'package:glider/widgets/common/smooth_animated_cross_fade.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppearanceBottomSheet extends HookConsumerWidget {
  const AppearanceBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return ScrollableBottomSheet(
      children: <Widget>[
        ProviderSwitchListTile(
          title: appLocalizations.showUrl,
          provider: showUrlProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setShowUrl(value: value),
        ),
        ProviderSwitchListTile(
          title: appLocalizations.showThumbnail,
          provider: showThumbnailProvider,
          onSave: (bool value) => ref
              .read(storageRepositoryProvider)
              .setShowThumbnail(value: value),
        ),
        ProviderSwitchListTile(
          title: appLocalizations.showMetadata,
          provider: showMetadataProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setShowMetadata(value: value),
        ),
        const SizedBox(height: 4),
        _buildHorizontalScrollable(
          children: <Widget>[
            for (ThemeBase themeBase in ThemeBase.values)
              _ThemeBaseButton(themeBase),
          ],
        ),
        const SizedBox(height: 8),
        _buildHorizontalScrollable(
          children: <Widget>[
            for (Color color in AppTheme.themeColors) _ThemeColorButton(color),
          ],
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildHorizontalScrollable({required List<Widget> children}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: children),
      ),
    );
  }
}

class _ThemeBaseButton extends HookConsumerWidget {
  const _ThemeBaseButton(this.base, {Key? key}) : super(key: key);

  final ThemeBase base;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeBase themeBase =
        ref.watch(themeBaseProvider).data?.value ?? ThemeBase.system;

    useMemoized(
      () => Future<void>.microtask(() {
        if (base == themeBase) {
          Scrollable.ensureVisible(
            context,
            duration: AnimationUtil.defaultDuration,
            curve: Curves.easeInOut,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        }
      }),
    );

    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: base.color(context),
            onPrimary: base.color(context).isDark ? Colors.white : Colors.black,
            shape: const StadiumBorder(),
            minimumSize: const Size(40, 40),
          ),
        ),
        child: ElevatedButton.icon(
          onPressed: () async {
            await ref.read(storageRepositoryProvider).setThemeBase(base);
            ref.refresh(themeBaseProvider);
          },
          label: Row(
            children: <Widget>[
              Text(base.title(context)),
              const SizedBox(width: 4),
            ],
          ),
          icon: SmoothAnimatedCrossFade(
            duration: kThemeChangeDuration,
            condition: base == themeBase,
            trueChild: const Icon(FluentIcons.checkmark_24_regular),
          ),
        ),
      ),
    );
  }
}

class _ThemeColorButton extends HookConsumerWidget {
  const _ThemeColorButton(this.color, {Key? key}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color themeColor =
        ref.watch(themeColorProvider).data?.value ?? AppTheme.defaultColor;

    useMemoized(
      () => Future<void>.microtask(() {
        if (color == themeColor) {
          Scrollable.ensureVisible(
            context,
            duration: AnimationUtil.defaultDuration,
            curve: Curves.easeInOut,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        }
      }),
    );

    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: const CircleBorder(),
          minimumSize: const Size(40, 40),
          padding: EdgeInsets.zero,
        ),
      ),
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(storageRepositoryProvider).setThemeColor(color);
          ref.refresh(themeColorProvider);
        },
        child: SmoothAnimatedSwitcher(
          duration: kThemeChangeDuration,
          condition: color == themeColor,
          child: const Icon(FluentIcons.checkmark_24_regular),
        ),
      ),
    );
  }
}