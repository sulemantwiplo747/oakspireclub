import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/good_pour/earty_fruit.dart';
import 'package:bourboneur/pages/good_pour/good_pour_table.dart';
import 'package:bourboneur/pages/good_pour/main_quad.dart';
import 'package:bourboneur/pages/good_pour/quad_box.dart';
import 'package:bourboneur/pages/good_pour/spicy_earthy.dart';
import 'package:bourboneur/pages/good_pour/sweet_fruit.dart';
import 'package:bourboneur/pages/good_pour/sweet_spicy.dart';
import 'package:flutter/material.dart';


class GoodPourPage extends StatefulWidget {
  const GoodPourPage({super.key});

  @override
  State<GoodPourPage> createState() => _GoodPourPageState();
}

class _GoodPourPageState extends State<GoodPourPage> {

  String currentPage = "main";
  int? tableType;

  _handleBackHandlerToMain () {
    setState(() {
      currentPage = "main";
      tableType = null;
    });
  }

  _handleBackToDetails () {
    switch (tableType) {
      case 1:
      case 2:
      case 3:
        currentPage = "sweetSpicy";
        break;
      case 4:
      case 5:
      case 6:
        currentPage = "spicyEarthy";
        break;
      case 7:
      case 8:
      case 9:
        currentPage = "earthyFruit";
        break;
      case 10:
      case 11:
      case 12:
        currentPage = "sweetFruit";      
        break;
      default:
        currentPage = "main";
    }
    tableType = null;
    setState(() {});
  }

  Widget getPage()
  {
    if ( currentPage == "main" ) {
      return MainQuad(
        onTapCenter: () {
          setState(() {
            currentPage = "table";
            tableType = 0;
          });
        },
        onTapSpicyEarthy: () {
          setState(() {
            currentPage = "spicyEarthy";
          });
        },
        onTapSweetSpicy: () {
          setState(() {
            currentPage = "sweetSpicy";
          });
        },
        onTapEarthyFruity: () {
          setState(() {
            currentPage = "earthyFruit";
          });
        },
        onTapSweetFruity: () {
          setState(() {
            currentPage = "sweetFruit";
          });
        },
      );
    }

    if ( currentPage == "sweetSpicy" ) {
      return SweetSpicyQuad(
        onTapMoreSweet: () {
          setState(() {
            currentPage = "table";
            tableType = 1;
          });
        },
        onTapSweetSpicy: () {
          setState(() {
            currentPage = "table";
            tableType = 2;
          });
        },
        onTapMoreSpicy: () {
          setState(() {
            currentPage = "table";
            tableType = 3;
          });
        },
        onTapBack: _handleBackHandlerToMain,
        onTapRefresh: _handleBackHandlerToMain,
      );
    }

    if ( currentPage == "spicyEarthy" ) {
      return SpicyEarthyQuad(
        onTapMoreSpicy: () {          
          setState(() {
            currentPage = "table";
            tableType = 4;            
          });
        },
        onTapSpicyEarthy: () {
          setState(() {
            currentPage = "table";
            tableType = 5;
          });
        },
        onTapMoreEarthy: () {
          setState(() {
            currentPage = "table";
            tableType = 6;
          });
        },        
        onTapBack: _handleBackHandlerToMain,
        onTapRefresh: _handleBackHandlerToMain,
      );
    }


    if ( currentPage == "earthyFruit" ) {
      return EarthyFruitQuad(
        onTapMoreEarthy: () {
           setState(() {
            currentPage = "table";
            tableType = 7;
          });
        },        
        onTapMoreEarthyFruit: () {
          setState(() {
            currentPage = "table";
            tableType = 8;
          });
        },
        onTapMoreFruit: () {
          setState(() {
            currentPage = "table";
            tableType = 9;
          });
        },
        onTapBack: _handleBackHandlerToMain,
        onTapRefresh: _handleBackHandlerToMain,
      );
    }

    if ( currentPage == "sweetFruit" ) {
      return SweetFruitQuad(
        onTapMoreFruit: () {
          setState(() {
            currentPage = "table";
            tableType = 10;
          });
        },
        onTapMoreSweetFruit: () {
           setState(() {
            currentPage = "table";
            tableType = 11;
          });
        },
        onTapMoreSweet: () {
           setState(() {
            currentPage = "table";
            tableType = 12;
          });
        },
        onTapBack: _handleBackHandlerToMain,
        onTapRefresh: _handleBackHandlerToMain,
      );
    }

    if ( currentPage == "table" ) {
      return GoodPourTable(
        tableType: tableType,
        onTapBack: _handleBackToDetails,
        onTapRefresh: _handleBackHandlerToMain,
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      showBottomNavigator: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            getPage()
          ],
        ),
      )
    );
  }
}

