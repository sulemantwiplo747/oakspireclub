import 'package:bourboneur/Core/Apis/Bluebook.dart';
import 'package:bourboneur/Core/Apis/Collection.dart';
import 'package:bourboneur/Core/Apis/Favorite.dart';
import 'package:bourboneur/Core/Apis/Rating.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/Core/Controllers/Favorite.dart';
import 'package:bourboneur/Core/Controllers/Rating.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/checkbox_input.dart';

import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/bottles_list/search_input.dart';
import 'package:bourboneur/pages/bottles_search.dart';
import 'package:bourboneur/pages/pour_note.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PourPage extends StatefulWidget {
  PourPage({super.key, this.id});

  String? id;

  @override
  State<PourPage> createState() => _PourPageState();
}

class _PourPageState extends State<PourPage> {
  Controller controller = Get.find<Controller>();

  BlueBook? blueBook;
  Collection? collection;
  Favorite? favorite;

  bool isLoading = false;
  bool isCollectionLoading = false;
  bool isSubmitting = false;
  bool isRemoving = false;
  bool isRated = false;

  String note = "";
  double nose = 0;
  double palate = 0;
  double finish = 0;

  @override
  void initState() {
    // Write code
    // if id is found preload
    _getData();

    super.initState();
  }

  _getData() async {
    if (widget.id == null) return;

    setState(() {
      isLoading = true;
    });

    // else
    Rating rating = await RatingApi.getById(widget.id!);
    blueBook = rating.blueBook!;
    note = rating.notes!;
    nose = double.parse(rating.nose!);
    palate = double.parse(rating.palate!);
    finish = double.parse(rating.finish!);

    // Check if is in wish list.
    var data = await CollectionApi.isInCollection(
        controller.user.value.id!, blueBook!.id!, CollectionType.wishlist);

    collection = data != false ? Collection.fromJson(data) : null;

    favorite = await FavoriteApi.isFavorite(
          controller.user.value.id!, blueBook!.id!);      

    setState(() {
      isLoading = false;
    });
  }

  _handleSelect(BlueBook b) async {
    setState(() {
      isLoading = true;
    });

    Navigator.pop(context);
    blueBook = b;

    Rating? rating = await RatingApi.getByUserIdBluebookId(
      controller.user.value.id!,
      b.id!
    );

    if ( rating == null ) {
      var data = await CollectionApi.isInCollection(
          controller.user.value.id!, blueBook!.id!, CollectionType.wishlist);

      collection = data != false ? Collection.fromJson(data) : null;
      
      favorite = await FavoriteApi.isFavorite(
          controller.user.value.id!, blueBook!.id!);      

      setState(() {
        isLoading = false;
      });

      return;
    }

    widget.id = rating.id!;

    _getData();

  }

  _handleWishlist(value) async {
    if (value == true) {
      var data = await CollectionApi.add(
          blueBook!.id!, controller.user.value.id!, CollectionType.wishlist);
      collection = Collection.fromJson(data);
    } else {
      CollectionApi.remove(collection!.id!);
      collection = null;
    }

    setState(() {});
  }

  _handleFavorite(value) async {
    if (value == true) {
      favorite = await FavoriteApi.mark(
          blueBook!.id!, controller.user.value.id!);      
    } else {
      FavoriteApi.unmark(favorite!.id!);
      favorite = null;
    }

    setState(() {});
  }

  _handleNoteButton() async {
    if (blueBook == null) {
      Utils().showToast('Error', 'Please add a bottle first');
      return;
    }

    Get.to(() => PourNote(
        imageUrl: blueBook!.image == null
            ? controller.config.value.pourImagePlaceHolder!
            : controller.config.value.uploadUrl! + '/' + blueBook!.image!,
        name: blueBook!.bottleName!,
        onNoteChange: _handleNoteChange,
        note: note));
  }

  _handleNoteChange(String value) {
    note = value.trim();
  }

  _handleSubmit() async {
    if (blueBook == null) {
      Utils().showToast('Error', 'Please add a bottle first');
      return;
    }

    if ( isSubmitting == true ) return;

    setState(() {
      isSubmitting = true;
    });

    // handle submit
    var data = await RatingApi.rate(
        blueBook!.id!, controller.user.value.id!, nose, palate, finish, note);

    if ( data != null && data != false )
    {
      widget.id = data['id'];
      Utils().showToast('Success', "Successfully saved.");
    }

    setState(() {
      isSubmitting = false;
    });
  }

  _handleRemoveRating() async {
    if ( widget.id == null ) return;

    if ( isRemoving == true ) return;

    setState(() {
      isRemoving = true;
    });

    // handle submit
    await RatingApi.remove(widget.id!);

    widget.id = null;
    note = "";
    nose = 0;
    palate = 0;
    finish = 0;

    Utils().showToast('Success', "Successfully removed rating.");
    Navigator.pop(context);
    
    // setState(() {
    //   isRemoving = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      child: !isLoading
          ? SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      BottlesSearchInput(
                        readOnly: true,
                        onTap: () {
                          Get.to(() => BottlesSearchPage(
                                pageType: SearchPageType.rating,
                                onSelect: _handleSelect,
                              ));
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
                if (blueBook != null)
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          blueBook!.bottleName!,
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
                                      image: NetworkImage(blueBook!.image ==
                                              null
                                          ? controller.config.value
                                              .pourImagePlaceHolder!
                                          : controller.config.value.uploadUrl! +
                                              '/' +
                                              blueBook!.image!),
                                      fit: BoxFit.contain)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [                                                               
                                CustomCheckBox(
                                  label: "make a favorite",
                                  checked: favorite != null,
                                  onChanged: _handleFavorite,
                                ),
                                CustomCheckBox(
                                  label: "add to my wish list",
                                  checked: collection != null,
                                  onChanged: _handleWishlist,
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                if (blueBook != null)
                  const SizedBox(
                    height: 30,
                  ),
                if (blueBook != null)
                  const Text(
                    "0 is the worst and 10 is the best",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff97881e)),
                  ),
                const SizedBox(
                  height: 5,
                ),
                RangeSlider(
                  label: "nose",
                  max: 10,
                  divide: 10,
                  initialValue: nose,
                  onChange: (value) => nose = value,
                ),
                const SizedBox(
                  height: 15,
                ),
                RangeSlider(
                  label: "palate",
                  max: 10,
                  divide: 10,
                  initialValue: palate,
                  onChange: (value) => palate = value,
                ),
                const SizedBox(
                  height: 15,
                ),
                RangeSlider(
                  label: "finish",
                  max: 10,
                  divide: 10,
                  initialValue: finish,
                  onChange: (value) => finish = value,
                ),
                const SizedBox(
                  height: 30,
                ),
                PourButton(
                  text: "add your notes ${note.length > 0 ? '(*)' : ''}",
                  color: const Color(0xffc05916),
                  onTap: _handleNoteButton,
                ),
                PourButton(
                  text: "Submit",
                  color: const Color(0xffead400),
                  onTap: _handleSubmit,
                  isLoading: isSubmitting,
                ),
                if ( widget.id != null )
                PourButton(
                  text: "Remove rating",
                  color: Color.fromARGB(255, 253, 68, 68),
                  onTap: _handleRemoveRating,
                  isLoading: isRemoving,
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ))
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: const Color.fromARGB(52, 0, 0, 0),
              child: const Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xffe17f2f),
                  ),
                ),
              ),
            ),
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
      this.onChange,
      required this.label});

  double initialValue;
  double max;
  double min;
  int divide;
  String label;
  void Function(double)? onChange;

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
      padding: EdgeInsets.only(left: 10, right: 0, top: 0),
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
              Container(
                padding: EdgeInsets.only(left: 0, right: 0),
                child: SliderTheme(
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

                        // call on change
                        if (widget.onChange != null) widget.onChange!(value);
                      },
                      divisions: widget.divide,
                      max: widget.max,
                      min: widget.min,
                      label: _currentSliderValue!.round().toString(),
                      thumbColor: Colors.white,
                      activeColor: const Color(0xfffe8003),
                      inactiveColor: const Color(0xfffe8003),
                    )),
              ),
              _buildNumber()
            ],
          ),
        )
      ],
    );
  }
}

class PourButton extends StatelessWidget {
  PourButton(
      {super.key, required this.text, this.color, this.onTap, this.isLoading});

  final String text;
  final Color? color;
  void Function()? onTap;
  bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: color,
              border: Border(
                  top: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.background))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    fontFamily: 'TradeGothic',
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              if (isLoading != null && isLoading != false)
              const SizedBox( width: 20 ),
              if (isLoading != null && isLoading != false)
              const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
