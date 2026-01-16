import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/common/staggered_item_animation.dart';
import 'package:flutter/material.dart';

class MyBottlesSingle extends StatefulWidget {
  const MyBottlesSingle({super.key});

  @override
  State<MyBottlesSingle> createState() => _MyBottlesSingleState();
}

class _MyBottlesSingleState extends State<MyBottlesSingle> {
 int _animationIndex = 0;


  void _showAddTestingNotesBottomSheet(BuildContext context) {
  final TextEditingController _controller = TextEditingController();

  

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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                  controller: _controller,
                  maxLines: null,
                  minLines: 8,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Enter your tasting notes, observations, score...",
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
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        
                        final note = _controller.text.trim();
                        if (note.isNotEmpty) {
                          // You can show snackbar or save to state/database
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Note saved: $note"),
                              backgroundColor: const Color(0xfffe8003),
                            ),
                          );
                        }
                        Navigator.pop(context);
                      },
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
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Cheers, Nick.",
                          style: TextStyle(
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
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("assets/images/bottle.png", height: 270),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {},
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
                        MoreItems(label: "Price Paid", value: "\$55.00"),
                        MoreItems(
                          label: "Blue Book Value",
                          value: "\$55.00",
                          info: "+\$4.55",
                        ),
                        MoreItems(
                          label: "Price Status",
                          value: "STABLE",
                          valueColor: Colors.red,
                        ),
                        MoreItems(label: "Date Added", value: "10/31/25"),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                StaggeredItemAnimation(
                  index: ++_animationIndex,
                  child: Container(
                    child: CenteredProgressBar(
                      progress: .3,
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
