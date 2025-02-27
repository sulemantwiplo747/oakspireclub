import 'package:bourboneur/common/checkbox_input.dart';
import 'package:bourboneur/common/custom_button.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/bottles_list/search_input.dart';
import 'package:bourboneur/pages/bottles_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PourNote extends StatefulWidget {
  PourNote({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onNoteChange,
    required this.note
  });

  String name;
  String imageUrl;
  String note;
  void Function(String) onNoteChange;

  @override
  State<PourNote> createState() => _PourNoteState();
}

class _PourNoteState extends State<PourNote> {
  // bool searching = false;

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.value = TextEditingValue(text: widget.note);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Padding(
          //   padding: EdgeInsets.only(left: 15, right: 15),
          //   child: Column(
          //     children: [
          //       BottlesSearchInput(
          //         readOnly: true,
          //         onTap: () =>
          //             {Get.to(() => BottlesSearchPage(isWishList: false))},
          //       ),
          //       SizedBox(
          //         height: 50,
          //       )
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffe48235)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 130,
                      height: 230,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(widget.imageUrl),
                          fit: BoxFit.fill
                        )
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Add your notes below.",
                      style: TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            decoration: const BoxDecoration(color: Color(0xfffe8003)),
            child: const Text(
              "tasting notes",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        Padding(
          padding: const EdgeInsets.all(15),
          child:   TextField(       
            controller: textEditingController,
            onChanged: widget.onNoteChange,     
            maxLines: 7,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 18
            ),
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(              
              fillColor: Colors.white,
              filled: true,
              hintText: "Enter your notes here",
              hintStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 18
              ),
              
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xfffe9227)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xfffe9227)),
              ),
            ),
          ),
        )
        ],
      )),
    );
  }
}

class RangeSlider extends StatefulWidget {
  RangeSlider(
      {super.key,
      this.initialValue = 0,
      this.max = 5,
      this.min = 0,
      this.divide = 5,
      required this.label});

  double initialValue;
  double max;
  double min;
  int divide;
  String label;

  @override
  State<RangeSlider> createState() => _RangeSliderState();
}

class _RangeSliderState extends State<RangeSlider> {
  double? _currentSliderValue;

  @override
  void initState() {
    _currentSliderValue = widget.initialValue;
    super.initState();
  }

  Widget _buildNumber() {
    List<Widget> list = [];

    double start = widget.min;
    list.add(_buildNumberText(start.toInt().toString()));

    while (start < widget.max) {
      start += (widget.max - widget.min) / widget.divide;
      list.add(_buildNumberText(start.toInt().toString()));
    }

    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: list,
      ),
    );
  }

  Widget _buildNumberText(String string) {
    return Text(
      string,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xfffe8003)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          decoration: const BoxDecoration(color: Color(0xfffe8003)),
          child: Text(
            widget.label,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 7,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 13),
                    trackShape: const RectangularSliderTrackShape(),
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(
                    value: _currentSliderValue!,
                    onChanged: (value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                    divisions: widget.divide,
                    max: widget.max,
                    min: widget.min,
                    label: _currentSliderValue!.round().toString(),
                    thumbColor: Colors.white,
                    activeColor: const Color(0xfffe8003),
                    inactiveColor: const Color(0xfffe8003),
                  )),
              _buildNumber()
            ],
          ),
        )
      ],
    );
  }
}
