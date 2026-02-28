import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/custom_button.dart';
import 'package:bourboneur/pages/bluebook/personal_use.dart';
import 'package:bourboneur/pages/bottles_search.dart';
import 'package:bourboneur/pages/tread_analyzer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TreadAnalyzerForm extends StatefulWidget {
  TreadAnalyzerForm({
    super.key,
    this.blueBook
  });

  BlueBook? blueBook;

  @override
  State<TreadAnalyzerForm> createState() => _TreadAnalyzerFormState();
}

class _TreadAnalyzerFormState extends State<TreadAnalyzerForm> {
  List<BlueBook> giving = [];
  List<BlueBook> receiving = [];

  @override
  void initState() {
    _preAddBottles();
    super.initState();
  }

  void _preAddBottles() {
    if ( widget.blueBook != null ) {
      giving.add(widget.blueBook!);
    }

    // Also check the storage
    
    setState(() {});
  }

  void _handleSelect(BlueBook bluebook, bool isGiving) {
    if (isGiving) {
      giving.add(bluebook);
    } else {
      receiving.add(bluebook);
    }

    setState(() {});
  }

  _handleClose(String value, bool isGiving) {
    int index = int.parse(value);

    if (isGiving) {
      giving.removeAt(index);
    } else {
      receiving.removeAt(index);
    }

    setState(() {});
  }

  _handleSubmit() {
    if (giving.length <= 0) {
      Utils().showToast("Error", "Pease add the bottle you are giving.");
      return;
    }

    if (receiving.length <= 0) {
      Utils().showToast("Error", "Pease add the bottle you are receiving.");
      return;
    }

    // calculate the price of giving.
    double givingPrice = 0;
    double receivingPrice = 0;

    giving.forEach((BlueBook element) {
      givingPrice += double.parse(element.average!);
    });

    receiving.forEach((BlueBook element) {
      receivingPrice += double.parse(element.average!);
    });

    Get.to(
      () => TreadAnalyzerLoadingPage(
        givingPrice: givingPrice,
        receivingPrice: receivingPrice,
      ),
    );
  }

  Widget _buildGiving() {
    List<AnalyzerInput> givingInputs = [];

    int i = 0;
    giving.forEach((element) {
      givingInputs.add(
        AnalyzerInput(
          value: i.toString(),
          text: element.bottleName!,
          onClose: (String value) {
            _handleClose(value, true);
          },
        ),
      );

      i++;
    });

    if (giving.length < 5) {
      givingInputs.add(
        AnalyzerInput(
          text: "search name(s) here",
          value: '',
          onTap: () {
            Get.to(
              () => BottlesSearchPage(
                pageType: SearchPageType.trade,
                onSelect: (BlueBook bluebook) {
                  _handleSelect(bluebook, true);
                },
              ),
            );
          },
        ),
      );
    }

    return Column(children: givingInputs);

    // return Column(
    //   children: giving.map((e) {
    //   })
  }

  Widget _buildReceiving() {
    List<AnalyzerInput> receivingInputs = [];

    int i = 0;

    receiving.forEach((element) {
      receivingInputs.add(
        AnalyzerInput(
          value: i.toString(),
          text: element.bottleName!,
          onClose: (String value) {
            _handleClose(value, false);
          },
        ),
      );
      i++;
    });

    if (giving.length < 5) {
      receivingInputs.add(
        AnalyzerInput(
          text: "search name(s) here",
          value: '',
          onTap: () {
            Get.to(
              () => BottlesSearchPage(
                pageType: SearchPageType.trade,
                onSelect: (BlueBook bluebook) {
                  _handleSelect(bluebook, false);
                },
              ),
            );
          },
        ),
      );
    }

    return Column(children: receivingInputs);

    // return Column(
    //   children: giving.map((e) {
    //   })
  }

  _onTapPersonalUse() {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return PersonalUse();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "GIVING",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              height: 1,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          _buildGiving(),
          const SizedBox(height: 20),
          const Text(
            "GETTING",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              height: 1,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          _buildReceiving(),
          const SizedBox(height: 20),
         GestureDetector(
          onTap: _handleSubmit,
          child: Container(
              // width: 300,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: const Text(
                "ANALYZE TRADE",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffbfbfbf),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
         ),
          SizedBox(height: 40),
          GestureDetector(
            onTap: _onTapPersonalUse,
            child: SizedBox(
              height: 20,
              child: Text(
                "*Personal Use Only",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color(0xffdcac00),
                  // decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationThickness: 2,
                  decorationColor: Color(0xffdcac00),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyzerInput extends StatelessWidget {
  AnalyzerInput({
    super.key,
    required this.text,
    required this.value,
    this.onTap,
    this.onClose,
  });

  String value;
  String text;
  void Function()? onTap;
  void Function(String)? onClose;

  Widget getInput() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 7),
      decoration: BoxDecoration(
        color: const Color(0xffb17e00),
        border: Border.all(width: 2, color: const Color(0xff622f15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (onTap == null && onClose != null)
            GestureDetector(
              onTap: () => {
                // pass the id
                onClose!(value),
              },
              child: const Icon(Icons.close, weight: 2, color: Colors.black),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return onTap != null
        ? GestureDetector(
            onTap: () {
              onTap!();
            },
            child: getInput(),
          )
        : getInput();
  }
}
