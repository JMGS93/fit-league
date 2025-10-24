import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nuevo_proyecto/main.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});
  
  @override
  BannerAdWidgetState createState() => BannerAdWidgetState();
}

class BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-5888493538069890/2199108725",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Error al cargar el banner: \$error');
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final isSub = MyApp.of(context)?.isSubscribed ?? false;
    if (isSub) {
      return const SizedBox.shrink();
    }
    return _bannerAd != null
      ? Container(
          alignment: Alignment.center,
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        )
      : const SizedBox.shrink();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}