import 'package:active_ecommerce_cms_demo_app/custom/device_info.dart';
import 'package:active_ecommerce_cms_demo_app/custom/useful_elements.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/category_response.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/category_repository.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/product_repository.dart';
import 'package:active_ecommerce_cms_demo_app/ui_elements/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoryProducts extends StatefulWidget {
  CategoryProducts({Key? key, required this.slug, required this.name}) : super(key: key);
  final String slug;
  final String name;

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  int _page = 1;
  int? _totalData = 0;
  bool _isInitial = true;
  String _searchKey = "";
  Category? categoryInfo;
  bool _showSearchBar = false;
  List<dynamic> _productList = [];
  bool _showLoadingContainer = false;
  List<Category> _subCategoryList = [];

  // getSubCategory() async {
  //   var res = await CategoryRepository().getCategories(parent_id: widget.slug);
  //   _subCategoryList.addAll(res.categories!);
  //   setState(() {});
  // }
  getSubCategory() async {
    var res = await CategoryRepository().getCategories(parent_id: widget.slug);
    if (res.categories != null) {
      _subCategoryList.addAll(res.categories!);
    }
    setState(() {});
  }

  getCategoryInfo() async {
    var res = await CategoryRepository().getCategoryInfo(widget.slug);
    print(res.categories.toString());
    if (res.categories?.isNotEmpty ?? false) {
      categoryInfo = res.categories?.first ?? null;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryInfo();
    fetchAllDate();

    _xcrollController.addListener(() {
      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  fetchData() async {
    var productResponse = await ProductRepository()
        .getCategoryProducts(id: widget.slug, page: _page, name: _searchKey);
    _productList.addAll(productResponse.products!);
    _isInitial = false;
    _totalData = productResponse.meta!.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  fetchAllDate() {
    fetchData();
    getSubCategory();
  }

  reset() {
    _subCategoryList.clear();
    _productList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAllDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.mainColor,
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          buildProductList(),
          Align(
              alignment: Alignment.bottomCenter, child: buildLoadingContainer())
        ],
      ),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _productList.length
            ? AppLocalizations.of(context)!.no_more_products_ucf
            : AppLocalizations.of(context)!.loading_more_products_ucf),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final double subCatHeight = _subCategoryList.isEmpty ? 0 : 100;
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: DeviceInfo(context).height! / 10 + subCatHeight,
      backgroundColor: MyTheme.mainColor,
      forceMaterialTransparency: true,
      bottom: PreferredSize(
          child: AnimatedContainer(
            height: subCatHeight,
            color: MyTheme.mainColor,
            duration: Duration(milliseconds: 300),
            child:  buildSubCategory(subCatHeight),
          ),
          preferredSize: Size.fromHeight(-35)),
      title: buildAppBarTitle(context),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Widget buildAppBarTitle(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: buildAppBarTitleOption(context),
        secondChild: buildAppBarSearchOption(context),
        firstCurve: Curves.fastOutSlowIn,
        secondCurve: Curves.fastOutSlowIn,
        crossFadeState: _showSearchBar
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 500));
  }

  Padding buildAppBarTitleOption(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 8, end: 20),
      child: Row(
        children: [
          UsefulElements.backButton(context, color: "black"),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 10),
              child: Text(
                categoryInfo?.name ?? widget.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
              width: 20,
              child: GestureDetector(
                  onTap: () {
                    _showSearchBar = true;
                    setState(() {});
                  },
                  child: Image.asset('assets/search.png')))
        ],
      ),
    );
  }

  Container buildAppBarSearchOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      width: DeviceInfo(context).width,
      height: 40,
      child: TextField(
        controller: _searchController,
        onChanged: (txt) {
          _searchKey = txt;
          reset();
          fetchData();
        },
        onSubmitted: (txt) {
          _searchKey = txt;
          reset();
          fetchData();
        },
        autofocus: false,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              _showSearchBar = false;
              setState(() {});
            },
            icon: Icon(
              Icons.clear,
              color: MyTheme.grey_153,
            ),
          ),
          filled: true,
          fillColor: MyTheme.white.withOpacity(0.6),
          hintText: "${AppLocalizations.of(context)!.search_products_from} : " +
              "" //widget.category_name!
          ,
          hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.font_grey),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
              borderRadius: BorderRadius.circular(6)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
              borderRadius: BorderRadius.circular(6)),
          contentPadding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }

  ListView buildSubCategory(double subCatHeight) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CategoryProducts(
                    name: _subCategoryList[index].name ?? '',
                    slug: _subCategoryList[index].slug!,
                  );
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 80,
            child: Column(
              children: [
                Expanded(
                  flex: 12,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: _subCategoryList[index].coverImage ??'',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 5,
                  child: Text(
                    _subCategoryList[index].name!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(width: 10),
      itemCount: _subCategoryList.length,
    );
  }

  buildProductList() {
    if (_isInitial && _productList.length == 0) {
      return SingleChildScrollView(
        child: ShimmerHelper().buildProductGridShimmer(
          scontroller: _scrollController,
        ),
      );
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            itemCount: _productList.length,
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // 3
              return ProductCard(
                  id: _productList[index].id,
                  slug: _productList[index].slug,
                  image: _productList[index].thumbnail_image,
                  name: _productList[index].name,
                  main_price: _productList[index].main_price,
                  stroked_price: _productList[index].stroked_price,
                  discount: _productList[index].discount,
                  is_wholesale: _productList[index].isWholesale,
                  has_discount: _productList[index].has_discount);
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_data_is_available));
    } else {
      return Container();
    }
  }
}
