import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:nuevo_proyecto/main.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;

  void loadAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-5888493538069890/4170665940',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          debugPrint('Interstitial cargado correctamente.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Error al cargar intersticial: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  void showAd(BuildContext context) {
    final isSub = MyApp.of(context)?.isSubscribed ?? false;
    if (isSub) return;
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          loadAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          loadAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      debugPrint('Interstitial no está disponible');
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}