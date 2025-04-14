class Config {
  String? stripePk;
  String? saveCardUrl;
  String? subscribeNowUrl;
  String? portalUrl;
  String? termsUrl;
  String? privacyUrl;
  Map? currentVersion;
  String? uploadUrl;
  String? pourImagePlaceHolder;
  String? ratingExportUrl;

  Config({
    this.stripePk,
    this.saveCardUrl,
    this.subscribeNowUrl,
    this.portalUrl,
    this.termsUrl,
    this.privacyUrl,
    this.uploadUrl,
    this.pourImagePlaceHolder,
    this.ratingExportUrl
  });

  Config.fromJson(json) {
    stripePk = json['stripe_pk'];
    saveCardUrl = json['save_card_url'];
    subscribeNowUrl = json['subscribe_now_url'];
    portalUrl = json['portal_url'];
    termsUrl = json['terms_url'];
    privacyUrl = json['privacy_url'];
    currentVersion = json['current_version'];
    pourImagePlaceHolder = json['pour_image_placeholder'];
    uploadUrl = json['upload_url'];
    ratingExportUrl = json['rating_export_url'];
  }

  Map<String, dynamic> toJson() {
    return {
      "stripe_pk": stripePk,
      'save_card_url': saveCardUrl,
      "subscribe_now_url": subscribeNowUrl,
      'portal_url': portalUrl,
      'terms_url': termsUrl,
      'privacy_url': privacyUrl,
      'current_version': currentVersion,
      'upload_url': uploadUrl,
      'pur_image_placeholder': pourImagePlaceHolder,
      'rating_export_url': ratingExportUrl
    };
  }
}
