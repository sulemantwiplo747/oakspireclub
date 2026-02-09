import 'package:bourboneur/Core/Apis/Rating.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/GroupedCollection.dart';
import 'package:bourboneur/Core/Controllers/Rating.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:bourboneur/pages/bluebook/bluebook_single.dart';
import 'package:bourboneur/pages/my_bottles/add_to_collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyBottlesSingle extends StatefulWidget {
  MyBottlesSingle({super.key, required this.collection});

  GroupedCollection collection;

  @override
  State<MyBottlesSingle> createState() => _MyBottlesSingleState();
}

class _MyBottlesSingleState extends State<MyBottlesSingle> {
  int _animationIndex = 0;
  Controller controller = Get.find<Controller>();
  Rating? rating;
  TextEditingController notesInput = TextEditingController();

  @override
  void initState() {
    _getRatings();
    super.initState();
  }

  String get diff {
    double pricePaid = double.parse(widget.collection.pricePaid!);
    double avgPrice = double.parse(widget.collection.blueBook!.average!);
    double d = avgPrice - pricePaid;
    return d.toStringAsFixed(2);
  }

  double get fill {
    double fill = double.parse(widget.collection.fill!);
    return fill / 100;
  }

  String get trend {
    double pricePaid = double.parse(widget.collection.pricePaid!);
    double avgPrice = double.parse(widget.collection.blueBook!.average!);
    double d = avgPrice - pricePaid;

    var movement = (d / pricePaid * 100) - 100;
    // print( d / pricePaid * 100);
    String o = "stable";
    if (movement > 2) {
      o = "up";
    } else if (movement < 2) {
      o = "down";
    }

    return o;
  }

  String get date {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(
      int.parse(widget.collection.createdAt!) * 1000,
    );

    // Only time (24-hour)
    String time24 = DateFormat('dd/MM/yyyy').format(dt);
    return time24;
  }

  void _getRatings() async {
    var r = await RatingApi.getByUserIdBluebookId(
      controller.user.value.id!,
      widget.collection.blueBook!.id!,
    );
    if (r is Rating) {
      rating = r;
      notesInput.value = TextEditingValue(text: rating?.notes ?? "");
    }

    setState(() {});
  }

  void _onSubmitRating() async {
     if (!mounted) return;

    final nose = rating?.nose ?? "0";
    final palate = rating?.palate ?? "0";
    final finish = rating?.finish ?? "0";
    

    await RatingApi.rate(
      widget.collection.blueBook!.id!,
      controller.user.value.id!,
      double.parse(nose),
      double.parse(palate),
      double.parse(finish),
      notesInput.text,
    );

    Utils().showToast("Success", "Saved notes!");

    Navigator.pop(context);

    setState(() {});
  }

  void _showAddTestingNotesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows it to take more space
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A), // dark background like your theme
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 45,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add Testing Notes",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfffe8003), // your accent orange
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // const Divider(color: Colors.grey[800], height: 1),

              // Text field area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextField(
                    controller: notesInput,
                    maxLines: null,
                    minLines: 8,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText:
                          "Enter your tasting notes, observations, score...",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xfffe8003),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white70),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onSubmitRating,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfffe8003),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Save Note",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      showBottomNavigator: false,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StaggeredItemAnimation(
                  index: ++_animationIndex,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Cheers, ${controller.user.value.name}.",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xfffe8003),
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                StaggeredItemAnimation(
                  index: ++_animationIndex,
                  fadeOnly: true,
                  child: Container(
                    // padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          widget.collection.image == null
                              ? controller.config.value.pourImagePlaceHolder!
                              : controller.config.value.uploadUrl! +
                                    '/' +
                                    widget.collection.image!,
                          height: 270,
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                () => AddToCollection(
                                  blueBook: widget.collection.blueBook!,
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.edit_outlined,
                              size: 32,
                              color: Color(0xfffe8003),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StaggeredItemAnimation(
                  index: ++_animationIndex,
                  fadeOnly: true,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MoreItems(
                          label: "Price Paid",
                          value: "\$${widget.collection.pricePaid}",
                        ),
                        MoreItems(
                          label: "Blue Book Value",
                          value: "\$${widget.collection.blueBook!.average}",
                          info: "+\$${diff}",
                        ),
                        MoreItems(
                          label: "Price Status",
                          value: trend.toUpperCase(),
                          valueColor: trend == "down"
                              ? Colors.red
                              : const Color(0xff89d050),
                        ),
                        MoreItems(label: "Date Added", value: date),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                StaggeredItemAnimation(
                  index: ++_animationIndex,
                  child: Container(
                    child: CenteredProgressBar(
                      progress: fill,
                      progressColor: Color(0xffff7520),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                StaggeredItemAnimation(
                  index: ++_animationIndex,
                  child: GestureDetector(
                    onTap: () {
                      _showAddTestingNotesBottomSheet(context);
                      // Get.to(() => BlueBook());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Add Testing Notes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xffadbfbf),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                StaggeredItemAnimation(
                  index: ++_animationIndex,
                  child: GestureDetector(
                    onTap: () {

                       Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Back to My Bottles",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xffadbfbf),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MoreItems extends StatelessWidget {
  MoreItems({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
    this.info,
  });

  String label;
  String value;
  Color valueColor;
  String? info;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, color: Colors.white, height: 1.5),
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 20, color: valueColor, height: 1.5),
            ),
            if (info != null) SizedBox(width: 5),
            if (info != null)
              Text(
                "($info)",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff89d050),
                  height: 1.5,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class CenteredProgressBar extends StatelessWidget {
  final double progress; // value between 0.0 and 1.0
  final double height;
  final Color backgroundColor;
  final Color progressColor;

  const CenteredProgressBar({
    super.key,
    required this.progress,
    this.height = 50,
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.progressColor = Colors.greenAccent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          // Background bar
          ClipPath(
            // borderRadius: BorderRadius.circular(12),
            child: Container(
              height: height,

              // color: backgroundColor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: backgroundColor,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),

          // Progress fill
          ClipPath(
            child: FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              alignment: Alignment.center,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Percentage text in center
          Center(
            child: Text(
              "${(progress * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                // shadows: [
                //   Shadow(
                //     blurRadius: 3,
                //     color: Colors.black87,
                //     offset: Offset(1, 1),
                //   ),
                // ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
