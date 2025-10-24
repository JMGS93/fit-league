import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nuevo_proyecto/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/banner_ad_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  SubscriptionScreenState createState() => SubscriptionScreenState();
}

class SubscriptionScreenState extends State<SubscriptionScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _sub;
  List<ProductDetails> _products = [];
  bool _loading = true;

  static const _kIds = <String>{
    'remove_ads_monthly',
    'remove_ads_yearly',
  };

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final response = await _iap.queryProductDetails(_kIds);
    setState(() {
      _products = response.productDetails;
      _loading = false;
    });
    _sub = _iap.purchaseStream.listen(_onPurchaseUpdated, onDone: () => _sub.cancel());
    await _iap.restorePurchases();
  }

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;
    final prefs = await SharedPreferences.getInstance();
    for (final p in purchases) {
      if ((p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored)
          && _kIds.contains(p.productID)) {
        MyApp.of(context)?.unlockAdsOff();
        final price = _products.firstWhere((x) => x.id == p.productID).price;
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .set({
              'suscribed': true,
              'subscriptionProductPrice': price,
              'subscriptionDate': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
        await prefs.setBool('is_subscribed', true);
      }
      if (p.pendingCompletePurchase) {
        await _iap.completePurchase(p);
      }
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _buy(ProductDetails prod) {
    final param = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: param);
  }

  void _restore() => _iap.restorePurchases();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bool realSub = MyApp.of(context)?.isSubscribed ?? false;
    final bool isSub = realSub;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.amber),
        centerTitle: true,
        title: Text(loc.removeAdsTitle, style: const TextStyle(color: Colors.amber)),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(height: 49, child: BannerAdWidget()),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (isSub)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events, size: 64, color: Colors.amber),
                  const SizedBox(height: 12),
                  Text(
                    loc.alreadySubscribedMessage,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _restore,
                    child: Text(
                      loc.restorePurchasesButton,
                      style: const TextStyle(color: Colors.amber),
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (var prod in _products) ...[
                    Card(
                      color: Colors.blue,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.amber),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prod.id == 'remove_ads_monthly'
                                  ? loc.monthlyPlanName
                                  : loc.annualPlanName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              prod.id == 'remove_ads_monthly'
                                  ? loc.monthlyPlanDesc
                                  : loc.annualPlanDesc,
                              style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              prod.id == 'remove_ads_monthly'
                                  ? loc.monthlyBenefit1
                                  : loc.annualBenefit1,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              prod.id == 'remove_ads_monthly'
                                  ? loc.monthlyBenefit2
                                  : loc.annualBenefit2,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              prod.id == 'remove_ads_monthly'
                                  ? loc.monthlyBenefit3
                                  : loc.annualBenefit3,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              prod.id == 'remove_ads_monthly'
                                  ? loc.monthlyBenefit4
                                  : loc.annualBenefit4,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => _buy(prod),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    prod.price,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  Transform.translate(
                    offset: const Offset(0, -5),
                    child: Center(
                      child: TextButton(
                        onPressed: _restore,
                        child: Text(
                          loc.restorePurchasesButton,
                          style: const TextStyle(color: Colors.amber),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(height: 49, child: BannerAdWidget()),
          ),
        ],
      ),
    );
  }
}