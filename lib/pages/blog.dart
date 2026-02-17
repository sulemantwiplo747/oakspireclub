import 'package:bourboneur/Core/Apis/Blog.dart';
import 'package:bourboneur/Core/Controllers/Blog.dart' as cBlog;
import 'package:bourboneur/Core/BlogController.dart';
import 'package:bourboneur/Core/Utils.dart';
import 'package:bourboneur/common/login_wrapper.dart';
import 'package:bourboneur/pages/blog/blog_item.dart';
import 'package:bourboneur/pages/blog/blog_navigation.dart';
import 'package:bourboneur/pages/blog/blog_search_input.dart';
import 'package:bourboneur/pages/blog_single.dart';
import 'package:bourboneur/pages/search_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Blog extends StatefulWidget {
  Blog({super.key});

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  final BlogController _blogController = Get.find<BlogController>();
  bool isLoading = true;
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  Utils utils = Utils();

  @override
  void initState() {
    getData(1);
    super.initState();
  }

  void getData(page) async {
    setState(() {
      isLoading = true;
    });    
    var response = await BlogApi.all(page);    
    setState(() {
      isLoading = false;
    });    
    // scrollController.jumpTo(0);
  }

  void _handleNext() {
    int currentPage = int.parse(_blogController.currentPage!);
    int nextPage = (currentPage + 1);
    getData(nextPage);    
  }

   void _handlePrev() {
    int currentPage = int.parse(_blogController.currentPage!);
    int nextPage = (currentPage - 1);
    getData(nextPage);
  }

  
  void _handleOnTapSearch() {
    if ( searchController.value.text.trim() == "" )
    {
      utils.showToast("Error", "Write something before search.");
      return;
    }

    String keyword = searchController.value.text;
    Get.to(() => SearchBlog(keyword: keyword));
    
    searchController.value = const TextEditingValue(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return LoginWrapper(
      showBottomNavigator: false,
      child: !isLoading ? SingleChildScrollView(
        controller: scrollController,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: const BoxDecoration(                      
                      image: DecorationImage(
                          repeat: ImageRepeat.noRepeat,
                          image: AssetImage("assets/images/blog-header.webp"),
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center)),
                )),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(
                height: 30,
              ),
              Text("Bourboneur Blog",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Arial',
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 35,
                      height: 1)),
              const SizedBox(
                height: 50,
              ),
              // Text.rich(
              //   textAlign: TextAlign.center,
              //   style: GoogleFonts.notoSerif(
              //     color: Theme.of(context).textTheme.titleMedium?.color,
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              //   TextSpan(text: "HOME", children: [
              //     TextSpan(
              //         recognizer: TapGestureRecognizer()
              //           ..onTap = () {
              //             Get.to(() => DashboardPage());
              //           },
              //         text: "\n>"),
              //     const TextSpan(
              //       text: "\nBOURBON BLOG",
              //     )
              //   ]),
              // ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: BlogSearchInput(
                  controller: searchController,
                  onTapSearch: _handleOnTapSearch
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              
            ]..addAll(_prepareBlogs(_blogController.blogs.value)))
          ],
        ),
      ) :  const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFff8202),
                ),
              ),
    );
  }

  List<Widget> _prepareBlogs(List<cBlog.Blog> result) {    
    List<Widget> list = [];

    for ( var item in  result ) {
      list.add(BlogItem(
        id: item.id!,
        title: item.title!,
        image: item.imgUrl!,
        postedAt: item.postDate!,
        shortDec: item.shortDescription!,
      ));
    }

    int totalPages = int.parse(_blogController.totalPages!);
    int currentPage = int.parse(_blogController.currentPage!);

    if ( list.isNotEmpty && totalPages > 1 ) {
      list.add(BlogNavigation(
        currentPage: currentPage,
        totalPages: totalPages,
        onTapNext: _handleNext,
        onTapPrevious: _handlePrev,
      ));
    }

    return list;
  }
}
