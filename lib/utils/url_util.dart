import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_launcher/native_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlUtil {
  UrlUtil._();

  static Future<bool> tryLaunch(
      BuildContext context, WidgetRef ref, String urlString) async {
    final bool success = await _tryLaunchNonBrowser(urlString) ||
        await ref.read(useCustomTabsProvider.future) &&
            await _tryLaunchCustomTab(context, urlString) ||
        await _tryLaunchPlatform(urlString);

    if (!success) {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).openLinkError)),
      );
    }

    return success;
  }

  static Future<bool> _tryLaunchNonBrowser(String urlString) async {
    try {
      return await NativeLauncher.launchNonBrowser(urlString) ?? false;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<bool> _tryLaunchCustomTab(
      BuildContext context, String urlString) async {
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;

    try {
      await FlutterWebBrowser.openWebPage(
        url: urlString,
        customTabsOptions: CustomTabsOptions(
          defaultColorSchemeParams: CustomTabsColorSchemeParams(
            toolbarColor: appBarTheme.backgroundColor,
          ),
          shareState: CustomTabsShareState.on,
          showTitle: true,
        ),
        safariVCOptions: SafariViewControllerOptions(
          barCollapsingEnabled: true,
          preferredBarTintColor: appBarTheme.backgroundColor,
          preferredControlTintColor: appBarTheme.iconTheme?.color,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
      return true;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> _tryLaunchPlatform(String urlString) async {
    if (await canLaunchUrlString(urlString)) {
      return launchUrlString(
        urlString,
        mode: LaunchMode.externalApplication,
      );
    }

    return false;
  }
}
