import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:bourboneur/Core/Apis/Import.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({super.key});

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  // For BoozApp URL input
  final TextEditingController _urlController = TextEditingController();
  Controller controller = Get.find<Controller>();

  bool importing = false;

  Future<void> _pickCsvFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        final path = file.path;
        final name = file.name;

        // final String content = utf8.decode(file.bytes!);
        final ioFile = File(file.path!);
        final String content = await ioFile.readAsString(encoding: utf8);

        setState(() {
          importing = true;
        });

        var r = await ImportApi.csv(controller.user.value.id!, content);
        if (r == false) {
          setState(() {
            importing = true;
          });

          return;
        }

        Navigator.pop(context);
        Utils().showToast("Success", "Bottles successfully imported.");
      }
    } catch (e) {
      Utils().showToast("Error", "Error: " + e.toString());
    }
  }

  void _handleUrlSubmit() async {
    if (importing) return;

    final url = _urlController.text.trim();
    Navigator.pop(context);

    if (url.isNotEmpty && url.startsWith('http')) {
      setState(() {
        importing = true;
      });

      var result = await ImportApi.baxus(url, controller.user.value.id!);
      if (result == false) {
        // Utils().showToast("Error", "Import not complete, please try again.");
        setState(() {
          importing = false;
        });

        return;
      }

      Navigator.pop(context);
      Utils().showToast("Success", "Bottles successfully imported.");
    } else {
      Utils().showToast("Error", "Please enter a valid url");
    }
    _urlController.clear();
  }

  void _showBoozAppUrlDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // rounded corners
            side: const BorderSide(
              color: Colors.white, // or Color(0xffe97132) to match your theme
              width: 2,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Import from BoozApp",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
              const Text(
                "Paste your collection URL",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _urlController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter here ...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xffbfbfbf),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),

              onPressed: _handleUrlSubmit,
              child: const Text(
                "Import",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      showBottomNavigator: false,
      child: Stack(
        children: [
          Container(height: double.infinity),
          Positioned.fill(
            bottom: 0,
            child: Image.asset(
              'assets/images/new_bg.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(17),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Import and Export",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ImportExportTabButtons(
                          image: "assets/images/import.png",
                          text: "Import",
                          onTap: () {}, // can leave empty or switch tabs later
                          isActive: true,
                        ),
                        const SizedBox(width: 10),
                        ImportExportTabButtons(
                          image: "assets/images/export.png",
                          text: "Export",
                          onTap: () {
                               String? url = controller
                                        .config.value.collectionDownloadUrl;
                                    String? userId = controller.user.value.id;
                                    launchUrl(
                                        Uri.parse(url! +
                                            '?&user_id=' +
                                            userId! +
                                            "&type=normal"),
                                        mode: LaunchMode.externalApplication);
                          },
                          isActive: false, // usually inactive on import page
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Button 1 – CSV
                          GestureDetector(
                            onTap: _pickCsvFile,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Import from CSV",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    Transform.rotate(
                                      angle: 150 * math.pi / 100,
                                      child: const Icon(
                                        Icons.expand_more,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "OnlyDrams Export (OnlyDrams collection format)\n\n"
                                  "Choose a CSV file from your device to import.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffbfbfbf),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Button 2 – BoozApp
                          GestureDetector(
                            onTap: _showBoozAppUrlDialog,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Import from BoozApp",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    Transform.rotate(
                                      angle: 150 * math.pi / 100,
                                      child: const Icon(
                                        Icons.expand_more,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "Import your collection URL\n\n"
                                  "1. BoozApp Collection page\n"
                                  "2. Copy the URL from your browser\n"
                                  "3. Paste it in the import dialogue box",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffbfbfbf),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (importing)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromARGB(88, 0, 0, 0),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xffff7522)),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}

class ImportExportTabButtons extends StatelessWidget {
  ImportExportTabButtons({
    required this.image,
    required this.text,
    required this.onTap,
    required this.isActive,
  });

  String image;
  String text;
  VoidCallback onTap;
  bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(image, width: 45),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                // softWrap: true,
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (isActive)
            Container(
              height: 2,
              width: 120,
              alignment: Alignment.centerLeft, // or center — your choice
              child: FractionallySizedBox(
                widthFactor: isActive ? 1.0 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffe97132),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
