class Config {
  String? stripePk;
  String? saveCardUrl;
  String? subscribeNowUrl;
  String? portalUrl;
  String? termsUrl;
  String? privacyUrl;
  Map? currentVersion;

  Config({
    this.stripePk,
    this.saveCardUrl,
    this.subscribeNowUrl,
    this.portalUrl,
    this.termsUrl,
    this.privacyUrl
  });

  Config.fromJson(json) {
    stripePk = json['stripe_pk'];
    saveCardUrl = json['save_card_url'];
    subscribeNowUrl = json['subscribe_now_url'];
    portalUrl = json['portal_url'];
    termsUrl = json['terms_url'];
    privacyUrl = json['privacy_url'];
    currentVersion = json['current_version'];
  }

  Map<String, dynamic> toJson() {
    return {
      "stripe_pk": stripePk,
      'save_card_url': saveCardUrl,
      "subscribe_now_url": subscribeNowUrl,
      'portal_url': portalUrl,
      'terms_url': termsUrl,
      'privacy_url': privacyUrl,
      'current_version': currentVersion
    };
  }
}
