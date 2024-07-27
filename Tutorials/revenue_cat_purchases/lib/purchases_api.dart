import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesApi {

  static const googleApiKey = "";
  static const iosApiKey = "";

  static Future init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(googleApiKey);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(iosApiKey);
    }
    if (configuration != null) {
      await Purchases.configure(configuration);
    }
  }

  static Future<List<Offering>> fetchOffers() async {
    final offerings = await Purchases.getOfferings();
    final current = offerings.current;

    return current == null ? [] : [current];
  }
}
