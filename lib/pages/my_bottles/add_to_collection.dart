import 'package:bourboneur/common/custom_button.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:flutter/material.dart';

class AddToCollection extends StatefulWidget {
  const AddToCollection({super.key});

  @override
  State<AddToCollection> createState() => _AddToCollectionState();
}

class _AddToCollectionState extends State<AddToCollection> {
  double _filledPercentage = 100.0;
  int _animationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      showBottomNavigator: false,
      child: SafeArea(
        child: SingleChildScrollView(
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
                  child: BottleSearchField(),
                ),
                const SizedBox(height: 32),

                // Form fields container
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StaggeredItemAnimation(
                        index: ++_animationIndex,
                        child: BottleImagePicker()
                      ),
                      // const BottleImagePicker(),
                      const SizedBox(height: 24),

                      StaggeredItemAnimation(
                        index: ++_animationIndex,
                        child: PurchasePriceField(),
                      ),
                      const SizedBox(height: 24),

                      StaggeredItemAnimation(
                        index: ++_animationIndex,
                        child: QuantityField(),
                      ),
                      const SizedBox(height: 32),

                      StaggeredItemAnimation(
                        index: ++_animationIndex,
                        child: FillLevelSlider(),
                      ),
                      const SizedBox(height: 24),
                      StaggeredItemAnimation(
                        index: ++_animationIndex,
                        child: CustomButton(text: "Submit"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Separate Widgets
// ──────────────────────────────────────────────────────────────────────────────

class BottleSearchField extends StatelessWidget {
  const BottleSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            height: 2.5,
            color: Colors.white,
          ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: 36,
          right: 12,
        ),
        hintText: "Search thousands of bottles",
        hintStyle: TextStyle(
          color: Color.fromARGB(255, 180, 180, 180),
          fontSize: 18,
          height: 2.5,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(
            Icons.search_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 24, minHeight: 24),
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

class BottleImagePicker extends StatelessWidget {
  const BottleImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FieldLabel("Bottle Image"),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            // TODO: Implement image picker
          },
          child: Container(
            height: 250,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/camera.png", height: 120),
                const SizedBox(height: 10),
                const Text(
                  "click to add",
                  style: TextStyle(
                    color: Color(0xffff6f59),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PurchasePriceField extends StatelessWidget {
  const PurchasePriceField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel("Purchase Price"),
        const SizedBox(height: 10),
        _StyledTextField(
          hintText: "0.00",
          prefixText: "\$",
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

class QuantityField extends StatelessWidget {
  const QuantityField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel("Quantity"),
        const SizedBox(height: 10),
        _StyledTextField(
          hintText: "0",
          prefixIcon: Icons.bookmark_add_rounded,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

class FillLevelSlider extends StatefulWidget {
  const FillLevelSlider({super.key});

  @override
  State<FillLevelSlider> createState() => _FillLevelSliderState();
}

class _FillLevelSliderState extends State<FillLevelSlider> {
  double _value = 100.0;

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
            value: _value,
            min: 0,
            max: 100,
            divisions: 100,
            label: "${_value.toStringAsFixed(0)}%",
            onChanged: (value) => setState(() => _value = value),
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

  const _StyledTextField({
    required this.hintText,
    this.prefixText,
    this.prefixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            height: 2.5,
            color: Colors.white,
          ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 36, right: 12),
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
                    child: Icon(
                      prefixIcon,
                      color: Colors.white,
                      size: 22,
                    ),
                  )
                : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
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