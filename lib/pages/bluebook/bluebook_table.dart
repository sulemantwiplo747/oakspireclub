import 'package:bourboneur/Core/Apis/Bluebook.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BlueBookTable extends StatefulWidget {
  BlueBookTable({
    super.key,
    this.keyword,
    required this.showLoading,
    required this.onReachedBottom,
    required this.bluebooks,
    required this.onTap,
  });

  final String? keyword;
  final bool showLoading;
  final VoidCallback? onReachedBottom;
  final List<BlueBook> bluebooks;
  final void Function(BlueBook) onTap;

  @override
  State<BlueBookTable> createState() => _BlueBookTableState();
}

class _BlueBookTableState extends State<BlueBookTable> {
  final Controller controller = Get.find<Controller>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      const delta = 100.0;

      if (maxScroll - currentScroll <= delta) {
        widget.onReachedBottom?.call();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main scrollable content
        ListView.builder(
          controller: _scrollController,
          itemCount: widget.bluebooks.length + (widget.showLoading ? 1 : 0),
          itemBuilder: (context, index) {
            // Loading row at the bottom
            if (index == widget.bluebooks.length && widget.showLoading) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    "Loading more...",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }

            final bluebook = widget.bluebooks[index];
            return _buildRow(bluebook);
          },
        ),

        // Fixed header
        Container(
          color: const Color(0xffd9e5f8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const SizedBox(width: 12),
              SizedBox(
                width: 170,
                child: Text(
                  "Bottle",
                  style: GoogleFonts.bebasNeue(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Average",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Low",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    "High",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(BlueBook bluebook) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 73, 73, 73),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.onTap != null)  widget.onTap!(bluebook);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 170,
                  child: Text(
                    bluebook.bottleName ?? "—",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    bluebook.average ?? "—",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    bluebook.low ?? "—",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    bluebook.high ?? "—",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
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