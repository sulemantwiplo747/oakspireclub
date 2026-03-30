import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/Explore/ExploreController.dart';
import 'package:bourboneur/pages/Explore/ExploreItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      showBottomNavigator: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 25),
          child: Column(
            children: [
              Container(
                // height: 220,
                padding: const EdgeInsets.only(left: 130, top: 50),
                constraints: BoxConstraints(
                  minHeight: 220
                ),
                decoration: const BoxDecoration(
                    // color: Colors.red,
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/BourBonDashboardBeer.png"),
                        alignment: Alignment.bottomLeft,
                        repeat: ImageRepeat.noRepeat)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Bourbon\nFlavor Guide",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Arial',
                          color: Theme.of(context).textTheme.titleMedium?.color,
                          fontSize: 32,
                          height: 1.2),
                    ),
                    Text(
                      "use our interactive guide below to explore your bourbon",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "I taste..(select one)",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontSize: 17, color: Color(0xffe17f2f)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ExploreItems(
                      items: const {
                        "grain": {
                          "is it spicy?": ["rye"],
                          "or is it sweet?": {
                            "has a malty taste": ["cereal", "cocoa"],
                            "doesn't taste malty": ["corn", "wheat"]
                          }
                        },
                        "spice": {
                          "is it earthy?": ["coffee", "leather", "tobacco"],
                          "is it aromatic?": [
                            "black pepper",
                            "cinnamon",
                            "clove",
                            "herbal tea",
                            "licorice",
                            "mint"
                          ]
                        },
                        "wood": {
                          "is it oaky?": ["new oak", "toasted oak"],
                          "taste a little nutty?": [
                            "almond",
                            "pecan",
                            "walnut"
                          ],
                          "like a conifer?": ["cedar", "pine"],
                        },
                        "fruit": {
                          "cooked": ["stewed apples", "candied fruit", "jam"],
                          "dried": ["apricot", "fig", "prunes", "raisins"],
                          "fresh": ["apple", "apricot", "peach", "prunes"],
                          "berry": [
                            "blackberry",
                            "blueberry",
                            "cherry",
                            "raspberry"
                          ],
                          "tropical": ["coconut", "lemon", "orange"],
                        },
                        "floral": ["potpourri", "rose"],
                        "sweet": {
                          "a buttery flavor": [
                            "caramel",
                            "maple syrup",
                            "vanila"
                          ],
                          "candy": ["butterscotch", "honey", "toffee"],
                          "bakery items": ["baked goods", "chocolate"]
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExploreItems extends StatefulWidget {
  ExploreItems({super.key, required this.items});

  Map<String, dynamic> items;

  @override
  State<ExploreItems> createState() => _ExploreItemsState();
}

class _ExploreItemsState extends State<ExploreItems> {
  String tapped = '';

  List<Widget> _handleItemsMap(BuildContext context, items, int level) {
    List<Widget> widgets = [];

    double leftPadding = 40;
    List<ExploreItemController> controllerList = [];

    if (items is Map) {
      items.forEach((key, value) {
        ExploreItemController controller = ExploreItemController();
        controllerList.add(controller);
        var ei = ExploreItem(
          controller: controller,
          onTapOpen: () {
            controllerList.forEach((element) {
              element.close!();
            });
          },
          text: key,
          childPadding: EdgeInsets.only(left: leftPadding * level),
          children: _handleItemsMap(context, value, level + 1),
        );
        widgets.add(ei);
      });
    } else {
      items.forEach((value) {
        widgets.add(ExploreItem(text: value));
      });
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _handleItemsMap(context, widget.items, 1),
    );
  }
}
