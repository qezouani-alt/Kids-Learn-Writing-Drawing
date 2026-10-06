import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_config.dart';

/// A single startup opportunity. Late ads never interrupt a drawing session.
class StartupAd {
  AppOpenAd? _ad;
  bool _closed = false;

  Future<void> prepare() async {
    if (kIsWeb ||
        defaultTargetPlatform != TargetPlatform.iOS ||
        AdMobConfig.iosAppOpenAdUnitId.trim().isEmpty) {
      return;
    }
    try {
      await _load().timeout(const Duration(seconds: 3));
    } catch (error) {
      debugPrint('Startup ad skipped: $error');
      dispose();
    }
  }

  Future<void> _load() async {
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        ageRestrictedTreatment: AgeRestrictedTreatment.child,
        maxAdContentRating: MaxAdContentRating.g,
      ),
    );
    final consent = Completer<bool>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(tagForUnderAgeOfConsent: true),
      () => consent.complete(true),
      (_) => consent.complete(false),
    );
    if (!await consent.future || _closed) return;
    if (!await ConsentInformation.instance.canRequestAds() || _closed) return;
    await MobileAds.instance.initialize();
    if (_closed) return;
    final loaded = Completer<void>();
    await AppOpenAd.load(
      adUnitId: AdMobConfig.iosAppOpenAdUnitId.trim(),
      request: const AdRequest(nonPersonalizedAds: true),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          if (_closed) {
            ad.dispose();
          } else {
            _ad = ad;
          }
          loaded.complete();
        },
        onAdFailedToLoad: (_) => loaded.complete(),
      ),
    );
    await loaded.future;
  }

  Future<void> showIfReady() async {
    final ad = _ad;
    if (ad == null ||
        _closed ||
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }
    _ad = null;
    final finished = Completer<void>();
    void finish() {
      ad.dispose();
      if (!finished.isCompleted) finished.complete();
    }

    ad.fullScreenContentCallback = FullScreenContentCallback<AppOpenAd>(
      onAdDismissedFullScreenContent: (_) => finish(),
      onAdFailedToShowFullScreenContent: (_, _) => finish(),
    );
    try {
      await ad.show();
      await finished.future;
    } catch (_) {
      finish();
    }
  }

  void dispose() {
    _closed = true;
    _ad?.dispose();
    _ad = null;
  }
}
