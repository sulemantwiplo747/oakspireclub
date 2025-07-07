import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/Collection.dart';
import 'package:bourboneur/Core/Controllers/Config.dart';
import 'package:bourboneur/Core/Controllers/Favorite.dart';
import 'package:bourboneur/Core/Controllers/GoodPour.dart';
import 'package:bourboneur/Core/Controllers/GroupedCollection.dart';
import 'package:bourboneur/Core/Controllers/LastUpdate.dart';
import 'package:bourboneur/Core/Controllers/Package.dart';
import 'package:bourboneur/Core/Controllers/Rating.dart';
import 'package:bourboneur/Core/Controllers/User.dart';
import 'package:bourboneur/Core/Controllers/WOD.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  Rx<User> user = User().obs;
  RxList<BlueBook> bluebooks = <BlueBook>[].obs;
  RxList<Collection> collections = <Collection>[].obs;
  RxList<GroupedCollection> groupedCollections = <GroupedCollection>[].obs;
  RxList<Rating> ratings = <Rating>[].obs;
  RxList<Favorite> favorites = <Favorite>[].obs;
  Rx<LastUpdate> lastUpdate = LastUpdate().obs;
  RxList<Package> packages = <Package>[].obs;
  RxList<GoodPour> goodpour = <GoodPour>[].obs;
  RxList<WOD> wods = <WOD>[].obs;
  Rx<WOD> wod = WOD().obs;
  Rx<Config> config = Config().obs;

  ValueNotifier<List<BlueBook>> normalCollections = ValueNotifier([]); 
  ValueNotifier<List<BlueBook>> wishlistCollections = ValueNotifier([]); 
}