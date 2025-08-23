import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bourboneur/Core/Apis/Auth.dart';
import 'package:bourboneur/Core/Apis/Package.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/Package.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/custom_button.dart';
import 'package:bourboneur/pages/capture_payment_details.dart';
import 'package:bourboneur/pages/page_helpers/open_dashboard.dart';
import 'package:bourboneur/pages/sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Core/Apis/User.dart';

class SelectPackagePage extends StatefulWidget {
  const SelectPackagePage({super.key});

  @override
  State<SelectPackagePage> createState() => _SelectPackagePageState();
}

class _SelectPackagePageState extends State<SelectPackagePage> {
  Controller controller = Get.find<Controller>();

  bool isLoading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    await PackageApi.all();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return !isLoading
        ? Container(
          color:  Theme.of(context).colorScheme.background,
          child: SafeArea(
              child: Scaffold(
                 backgroundColor: Theme.of(context).colorScheme.background,
                  body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("get whiskey wise,",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Arial')),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          controller.user.value.packageId == null
                              ? "Start your 7-day free trial.  Cancel anytime."
                              : "Start your subscription now. Cancel anytime.",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 16, color: const Color(0xffbfbfbf))),
                      const SizedBox(
                        height: 10,
                      ),
                      const PackageForm()
                      // if ( controller.user.value.packageId == null )
                      // Text(
                      //     "You will not be charged, until trial is over. After that your normal package price is active",
                      //     textAlign: TextAlign.left,
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .bodySmall
                      //         ?.copyWith(color: const Color(0xffe07e2f))),
                      // const SizedBox(
                      //   height: 50,
                      // ),
                    ],
                  ),
                ),
              )),
            ),
        )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFff8202),
              ),
            ),
          );
  }
}

class PackageForm extends StatefulWidget {
  const PackageForm({super.key});

  @override
  State<PackageForm> createState() => _PackageFormState();
}

class _PackageFormState extends State<PackageForm> {
  Controller controller = Get.find<Controller>();
  Utils utils = Utils();
  bool isAvailable = false;
  String? selectedPackageId;
  String? selectedAppStorePackageId;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final List<PurchaseDetails> _purchases = [];

  List<ProductDetails> _products = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<void> _handleSubmit() async {
    if (selectedPackageId == null) {
      utils.showToast("Error", "Select a package first.");
      return;
    }
    if (Platform.isIOS) {
      if (!isAvailable) {
        utils.showToast(
            "Error", "In-App Purchases are not available on this device.");
        return;
      }

      if (_products.isEmpty) {
        utils.showToast("Error", "No products available for purchase.");
        return;
      }

      try {
        final product = _products.firstWhere(
          (p) => p.id == selectedAppStorePackageId,
          orElse: () => throw Exception("Selected product not found."),
        );
        await _subscribe(product: product);
      } catch (e) {
        utils.hideLoadingDialog();
        utils.showToast(
            "Error", "Failed to initiate purchase: ${e.toString()}");
      }
    }
    // if (Platform.isIOS) {
    //   if (isAvailable) {
    //     _subscribe(
    //         product: _products.firstWhere(
    //         (product) => product.id == selectedAppStorePackageId,
    //       ));
    //   } else {
    //     utils.showToast("Sorry", "This product is currently unavailable");
    //   }
    // }
     else {
      Get.off(() => CapturePaymentDetails(
            packageId: selectedPackageId!,
            trialAvailable: controller.user.value.packageId == null,
          ));
    }
  }
Future<void> _handleRestore() async {
    try {
      utils.showLoadingDialog();
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      utils.hideLoadingDialog();
      utils.showToast("Error", "Failed to restore purchases: ${e.toString()}");
    }
  }
  @override
  void initState() {
    Platform.isIOS ? initializeIosPayment() : null;
    super.initState();
  }
@override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  Future<List<ProductDetails>> _getProducts(
      {required Set<String> productIds}) async {
    try {
      ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(productIds);
      return response.productDetails;
    } catch (e) {
      utils.showToast("Error", "Failed to fetch products: ${e.toString()}");
      return [];
    }
  }
  // Future<List<ProductDetails>> _getProducts(
  //     {required Set<String> productIds}) async {
  //   ProductDetailsResponse response =
  //       await _inAppPurchase.queryProductDetails(productIds);
  //   return response.productDetails;
  // }
  Future<void> initializeIosPayment() async {
    try {
      isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        utils.showToast(
            "Error", "In-App Purchases are not available on this device.");
        return;
      }

      Set<String> appleStoreIds = controller.packages
          .where((package) => package.appleStoreId != null)
          .map((package) => package.appleStoreId!)
          .toSet();

      if (appleStoreIds.isEmpty) {
        utils.showToast("Error", "No valid products found for purchase.");
        return;
      }

      List<ProductDetails> products =
          await _getProducts(productIds: appleStoreIds);
      if (products.isEmpty) {
        utils.showToast(
            "Error", "Some products are unavailable. Please try again later.");
        return;
      }

      setState(() {
        _products = products;
      });

      final Stream<List<PurchaseDetails>> purchaseUpdated =
          _inAppPurchase.purchaseStream;
      _subscription = purchaseUpdated.listen(
        _listenToPurchaseUpdated,
        onDone: () {
          _subscription?.cancel();
        },
        onError: (error) {
          utils.hideLoadingDialog();
          utils.showToast(
              "Error", "Purchase stream error: ${error.toString()}");
          _subscription?.cancel();
        },
      );
    } catch (e) {
      utils.showToast("Error", "Failed to initialize payment: ${e.toString()}");
    }
  }
  /*intilizeIosPayment() async {
    isAvailable = await _inAppPurchase.isAvailable();
    Set<String> appleStoreIds = {};
    for (var package in controller.packages) {
      if (package.appleStoreId != null) {
        appleStoreIds.add(package.appleStoreId!);
      }
    }
    List<ProductDetails> products =
        await _getProducts(productIds: appleStoreIds);

    _products = products;

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      print(error.toString());
      _subscription!.cancel();
    });
  }
  */
// 21/7/25
 /* void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    try {
      purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        switch (purchaseDetails.status) {

          case PurchaseStatus.pending:
             utils.hideLoadingDialog();
            break;

          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:

            await PackageApi.subscribe(controller.user.value.id!,selectedPackageId!, purchaseDetails.purchaseID.toString());
            await UserApi.getById(controller.user.value.id!);
            
            utils.hideLoadingDialog();
            Get.offAll(() => openDashboard(controller.user.value));
            utils.showToast("Success", "Your package has been activated, enjoy!");

            break;

          case PurchaseStatus.error:

            utils.hideLoadingDialog();
            break;

          default:

            utils.hideLoadingDialog();
            break;
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
          // setState(() {});
        }
      });
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }
  */
  //END 21/7/25
  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    try {
      for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
        switch (purchaseDetails.status) {
          case PurchaseStatus.pending:
          utils.hideLoadingDialog();
            // Already showing loading dialog
            break;

          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            try {
              await PackageApi.subscribe(
                controller.user.value.id!,
                selectedPackageId!,
                purchaseDetails.purchaseID.toString(),
              );
              await UserApi.getById(controller.user.value.id!);
              utils.hideLoadingDialog();
              Get.offAll(() => openDashboard(controller.user.value));
              utils.showToast(
                  "Success", "Your package has been activated, enjoy!");
            } catch (e) {
              utils.hideLoadingDialog();
              utils.showToast(
                  "Error", "Failed to activate subscription: ${e.toString()}");
            }
            break;

          case PurchaseStatus.error:
            utils.hideLoadingDialog();
            utils.showToast("Error",
                "Purchase failed: ${purchaseDetails.error?.message ?? 'Unknown error'}");
            break;

          case PurchaseStatus.canceled:
            utils.hideLoadingDialog();
            utils.showToast("Info", "Purchase was canceled by the user.");
            break;

          default:
            utils.hideLoadingDialog();
            utils.showToast("Error", "Unknown purchase status.");
            break;
        }

        if (purchaseDetails.pendingCompletePurchase) {
          try {
            await _inAppPurchase.completePurchase(purchaseDetails);
          } catch (e) {
            utils.showToast(
                "Error", "Failed to complete purchase: ${e.toString()}");
          }
        }
      }
    } catch (e) {
      utils.hideLoadingDialog();
      utils.showToast("Error", "Purchase processing error: ${e.toString()}");
    }
  }
Future<void> _subscribe({required ProductDetails product}) async {
    try {
      utils.showLoadingDialog();
      final purchaseParam = PurchaseParam(productDetails: product);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      utils.hideLoadingDialog();
      utils.showToast("Error", "Purchase failed: ${e.toString()}");
    }
  }
  // Future<void> _subscribe({required ProductDetails product}) async {
  //   late PurchaseParam purchaseParam;
  //   try {
  //     utils.showLoadingDialog();
  //     purchaseParam = PurchaseParam(productDetails: product);
  //     // _inAppPurchase
  //     _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  //   } catch (e) {
  //      utils.hideLoadingDialog();
  //       utils.showToast("Sorry", e.toString());
  //     //  utils.showToast("Sorry", "Looks like we were not able to open in app purchase");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "Save 30%",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Arial',
                      // fontWeight: FontWeight.normal
                    ),
              )),
              const Expanded(child: SizedBox()
                  // Spacer()
                  )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: const BoxDecoration(
              color: Color(0xff716d6c),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [..._preparePackages(controller.packages)],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          text: controller.user.value.packageId == null
              ? "Start free 1 week trial"
              : "Renew subscription",
          onTap: _handleSubmit,
        ),
        if(Platform.isIOS)
         const SizedBox(
            height: 15,
          ),
            if (Platform.isIOS)
        CustomButton(
          text: "Restore subscription",
          onTap: _handleRestore,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          controller.user.value.packageId == null
              ? "After the trial period you’ll be charged based upon your preferences selected above."
              : "After subscription complete you’ll will now be charged based upon your preferences selected above.",
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: const Color(0xffbfbfbf)),
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () async {
                await launchUrl(Uri.parse(controller.config.value.termsUrl!));
              },
              child: Text(
                "Terms of Use",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color(0xffbfbfbf)),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await launchUrl(Uri.parse(controller.config.value.privacyUrl!));
              },
              child: Text(
                "Privacy Policy",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color(0xffbfbfbf)),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 70,
        ),
        Container(
          alignment: Alignment.center,
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: "Want to change account? ",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: const Color(0xffbfbfbf)),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Auth.logout();
                  Get.offAll(() => const SignInPage());
                },
              text: "Logout",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: const Color(0xFFff8202), fontSize: 12),
            ),
          ])),
        )
      ],
    );
  }

  List<Widget> _preparePackages(RxList<Package> result) {
    List<Widget> list = [];
    bool trialAvailable = controller.user.value.packageId == null;
    for (Package package in result.value) {
      list.add(PackageItem(
        package: package,
        trialAvailable: trialAvailable,
        isSelected: package.id == selectedPackageId,
        onTap: (Package package) {
          setState(() {
            selectedPackageId = package.id;
            selectedAppStorePackageId = package.appleStoreId;
          });
          //  Get.off(() => CapturePaymentDetails(
          //     packageId: package.id!,
          //     trialAvailable: trialAvailable,
          //   ));
        },
      ));
    }

    return list;
  }
}

class PackageItem extends StatelessWidget {
  PackageItem({
    super.key,
    required this.package,
    required this.trialAvailable,
    this.isSelected,
    this.onTap,
  });

  Package package;
  bool trialAvailable;
  bool? isSelected;
  void Function(Package)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!(package);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: const Color(0xFFff8202)
                    .withOpacity(isSelected == true ? 1 : 0),
                width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 10),
        child: Column(
          children: [
            Text((package.packageType == "yearly" ? "yearly" : "monthly"),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.normal)),
            const SizedBox(
              height: 5,
            ),
            Text("\$${package.price}",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 26,
                      fontFamily: 'Arial',
                      // fontWeight: FontWeight.normal
                    )),
            if (trialAvailable)
              const SizedBox(
                height: 5,
              ),
            Text("7 day free trial",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.normal))
          ],
        ),
      ),
    );
  }
}
