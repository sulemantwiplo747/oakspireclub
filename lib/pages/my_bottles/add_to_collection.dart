import 'dart:io';

import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/custom_button.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/bottles_list/search_input.dart';
import 'package:bourboneur/pages/bottles_search.dart';
import 'package:bourboneur/pages/my_bottles/bottle_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddToCollection extends StatefulWidget {
  AddToCollection({super.key, this.blueBook});

  BlueBook? blueBook;

  @override
  State<AddToCollection> createState() => _AddToCollectionState();
}

class _AddToCollectionState extends State<AddToCollection> {
  Controller controller = Get.find<Controller>();

  bool isBusy = false;
  bool isSubmitting = false;

  double _filledPercentage = 100.0;
  int _animationIndex = 0;
  File? _selectedBottleImage;
  String? _collectionImage;

  BlueBook? blueBook;
  TextEditingController? paidPrice;
  TextEditingController? quantity;

  @override
  void initState() {
    paidPrice = TextEditingController();
    quantity = TextEditingController();

    if ( widget.blueBook != null )
    {
      _getData(widget.blueBook!);
    }

    super.initState();
  }

  void _onSelect(BlueBook b) {

    Navigator.pop(context);
    _getData(b);

  }

  void _getData(BlueBook b) async {
      blueBook = b;
    paidPrice?.value = TextEditingValue(text: blueBook!.average!);
    quantity?.value = TextEditingValue(text: "1");
    _selectedBottleImage = null;
    _collectionImage = null;

    

    isBusy = true;
    setState(() {});
    var data = await CollectionApi.isInGroupCollection(
      controller.user.value.id!,
      blueBook!.id!,
      CollectionType.normal,
    );

    if (data != false) {
      int q = data.length;
      double totalFill = 0;
      double totalPrice = 0;

      data.forEach((Collection item) {
        totalPrice += double.parse(item.pricePaid!);
        totalFill += int.parse(item.fill!);
        _collectionImage = item.image;
      });

      totalPrice = q > 0 ? totalPrice / q : 0;
      totalFill = q > 0 ? totalFill / q : 0;

      paidPrice?.value = TextEditingValue(text: totalPrice <= 0 ? "" : totalPrice.toString());
      quantity?.value = TextEditingValue(text: q <= 0 ? "" : q.toString());

      _filledPercentage = totalFill;
    }

    isBusy = false;
    setState(() {});
  }

  void _onFillChange(v) {
    _filledPercentage = v;
    setState(() {});
  }

  void _onSubmit() async {
    isSubmitting = true;
    setState(() {});

    int filled = _filledPercentage.toInt();
    final text = paidPrice?.text ?? '';
    double price = double.tryParse(text) ?? 0.0;
    final q = quantity?.text ?? '';
    int count = int.tryParse(q) ?? 0;

    await CollectionApi.add(
      blueBook!.id!,
      controller.user.value.id!,
      CollectionType.normal,
      quantity: count,
      fill: filled,
      paidPrice: price,
      image: _selectedBottleImage ?? _collectionImage,
    );

    isSubmitting = false;
    setState(() {});
    final noti =  widget.blueBook == null ? "New collection added." : "Collection updated successfully";
    Utils().showToast("Success", noti);
    Navigator.pop(context);    
  }

  _getInitialImage() {
    if (_selectedBottleImage != null) {
      return Image.file(
        _selectedBottleImage!,
        height: 240,
        fit: BoxFit.contain,
      );
    }

    // check if the collection has an image
    if (_collectionImage != null) {
      return Image.network(
        height: 240,
        fit: BoxFit.contain,
        controller.config.value.uploadUrl! + '/' + _collectionImage!,
      );
    }

    // if no image found use bluebook image
    if (blueBook != null &&  blueBook!.image != null) {
      return Image.network(
        height: 240,
        fit: BoxFit.contain,
        blueBook!.image == null
            ? controller.config.value.pourImagePlaceHolder!
            : controller.config.value.uploadUrl! + '/' + blueBook!.image!,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      showBottomNavigator: false,
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StaggeredItemAnimation(
                      index: ++_animationIndex,
                      child: const Text(
                        "Add to Collection",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xfffe8003),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Search field
                    StaggeredItemAnimation(
                      index: ++_animationIndex,
                      child: BottlesSearchInput(
                        hintText: "Search bottles or add your own​",
                        readOnly: true,
                        onTap: () {
                          Get.to(
                            () => BottlesSearchPage(
                              pageType: SearchPageType.normal,
                              onSelect: _onSelect,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form fields container
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          StaggeredItemAnimation(
                            index: ++_animationIndex,
                            child: BottleImagePicker(
                              onImagePicked: (file) {
                                setState(() {
                                  _selectedBottleImage = file;
                                });
                              },
                              initialImage: _getInitialImage(),
                            ),
                          ),
                          const SizedBox(height: 24),

                          StaggeredItemAnimation(
                            index: ++_animationIndex,
                            child: PurchasePriceField(controller: paidPrice),
                          ),
                          const SizedBox(height: 24),

                          StaggeredItemAnimation(
                            index: ++_animationIndex,
                            child: QuantityField(controller: quantity),
                          ),
                          const SizedBox(height: 32),

                          StaggeredItemAnimation(
                            index: ++_animationIndex,
                            child: FillLevelSlider(
                              value: _filledPercentage,
                              min: 12,
                              max: 100,
                              onChanged: _onFillChange,
                            ),
                          ),
                          const SizedBox(height: 24),
                          StaggeredItemAnimation(
                            index: ++_animationIndex,
                            child: CustomButton(
                              isLoading: isSubmitting,
                              text: "Submit",
                              onTap: _onSubmit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (blueBook == null)
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => BottlesSearchPage(
                      pageType: SearchPageType.normal,
                      onSelect: _onSelect,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color.fromARGB(0, 244, 67, 54),
                ),
              ),
            if (isBusy)
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black.withOpacity(0.45),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xfffe8003),
                    ),
                    strokeWidth: 4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PurchasePriceField extends StatelessWidget {
  PurchasePriceField({super.key, this.controller});

  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel("Purchase Price"),
        const SizedBox(height: 10),
        _StyledTextField(
          controller: controller,
          hintText: "0.00",
          prefixText: "\$",
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            FilteringTextInputFormatter.deny(RegExp(r'^0')),
          ],
        ),
      ],
    );
  }
}

class QuantityField extends StatelessWidget {
  QuantityField({super.key, this.controller});

  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel("Quantity"),
        const SizedBox(height: 10),
        _StyledTextField(
          controller: controller,
          hintText: "0",
          prefixIcon: Icons.bookmark_add_rounded,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'\d+'))],
        ),
      ],
    );
  }
}

class FillLevelSlider extends StatelessWidget {
  final double value; // current value controlled by parent
  final ValueChanged<double>? onChanged; // callback to parent
  final double min;
  final double max;

  const FillLevelSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel("Fill Level"),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbColor: const Color(0xfffe8003),
            activeTrackColor: const Color(0xfffe8003),
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            overlayColor: const Color(0xfffe8003).withOpacity(0.3),
            valueIndicatorColor: const Color(0xfffe8003),
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Slider(
            value: value.clamp(
              min,
              max,
            ), // safety in case parent sends invalid value
            min: min,
            max: max,
            divisions: 100,
            label: "${value.toStringAsFixed(0)}%",
            onChanged: onChanged, // ← directly pass to parent
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Reusable Components
// ──────────────────────────────────────────────────────────────────────────────

class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final String hintText;
  final String? prefixText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  const _StyledTextField({
    required this.hintText,
    this.prefixText,
    this.prefixIcon,
    this.keyboardType,
    this.controller,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: inputFormatters,
      controller: controller,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        height: 2.5,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: 36,
          right: 12,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 180, 180, 180),
          fontSize: 18,
          height: 2.5,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: prefixText != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  prefixText!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              )
            : prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(prefixIcon, color: Colors.white, size: 22),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
        enabledBorder: _border,
        focusedBorder: _border,
        border: _border,
        isDense: true,
        filled: false,
      ),
    );
  }

  static const _border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2),
    borderRadius: BorderRadius.all(Radius.circular(15)),
  );
}
