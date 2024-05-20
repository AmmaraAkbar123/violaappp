import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:viola/auth/view_model.dart';
import 'package:viola/filters/offers_screen.dart';
import 'package:viola/filters/open_stores_screen.dart';
import 'package:viola/json_models/feature_model.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/pages/category_screen.dart';
import 'package:viola/filters/favorite_screen.dart';
import 'package:viola/pages/google_map_page.dart';
import 'package:viola/pages/login_page.dart';
import 'package:viola/pages/new_search_page.dart';
import 'package:viola/providers/category_provider.dart';
import 'package:viola/providers/feature_data_provider.dart';
import 'package:viola/pages/salon_detail_page.dart';
import 'package:viola/providers/data_api_provider.dart';
import 'package:viola/providers/map_provider.dart';
import 'package:viola/providers/user_provider.dart';
import 'package:viola/services/models/homePage_model.dart';
import 'package:viola/utils/padding_margin.dart';
import 'package:viola/widgets/banner_card.dart';
import 'package:viola/widgets/drawer.dart';
import 'package:viola/widgets/horizontal_card.dart';
import 'package:viola/widgets/main_containers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, checkLoading);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      handleRefresh();
      Provider.of<MapProvider>(context, listen: false)
          .determineCurrentPosition();
    });
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isLoading.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void checkLoading() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate data fetching
    _isLoading.value = false; // Hide loading indicator
  }

  Future handleRefresh() async {
    await Provider.of<MyDataApiProvider>(context, listen: false).fetchData();
    await Provider.of<FeatureDataProvider>(context, listen: false).getDataApi();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      var provider = Provider.of<MyDataApiProvider>(context, listen: false);
      if (provider.hasMore) {
        // Checking if there's more data to load
        provider.fetchData(fetchNextPage: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Color.fromARGB(248, 235, 229, 229),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(75, 0, 95, 1),
        title: InkWell(
          onTap: () {
            Provider.of<SignInViewModel>(context, listen: false)
                .resetOTPState();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => userProvider.user.isLoggedIn
                      ? GoogleMapPage()
                      : LoginPageScreen(),
                ));
          },
          child: Container(
            width: double.infinity,
            child: Consumer<MapProvider>(
              builder: (context, mapProvider, child) {
                // Print the current address for debugging
                print('Current Address: ${mapProvider.currentAddress}');
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset('assets/images/map.png', width: 25, height: 25),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        mapProvider.currentAddress,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Icon(Icons.location_on_outlined, color: Colors.white),
                  ],
                );
              },
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: const NavBar(),
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 13),
                child: Column(
                  children: [
                    //search textfield
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchResultScreen()),
                        );
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'ابحث عن موقع',
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),

                    CarouselSlider(
                      items: carouselItems
                          .map(
                            (e) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22.0),
                                image: DecorationImage(
                                  image: NetworkImage(e.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        height: 180,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: const Duration(seconds: 3),
                        viewportFraction: 1,
                      ),
                    ).paddingOnly(
                      top: 12,
                      bottom: 10,
                    ),
                    //all filter buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Provider.of<SignInViewModel>(context,
                                      listen: false)
                                  .resetOTPState();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      userProvider.user.isLoggedIn
                                          ? const FavoriteScreen()
                                          : const LoginPageScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'المفضلة',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Consumer<MyDataApiProvider>(
                            builder: (context, dataProvider, child) {
                              return ElevatedButton(
                                onPressed: () async {
                                  Provider.of<SignInViewModel>(context,
                                          listen: false)
                                      .resetOTPState();
                                  // Ensure data is loaded
                                  if (dataProvider.mydata == null) {
                                    await dataProvider.fetchData();
                                  }
                                  dataProvider.mydata!.data.data
                                      .forEach((datum) {
                                    print(
                                        "Store ID: ${datum.id}, Featured: ${datum.featured}");
                                  });

                                  List<Datum> storesWithOffers = dataProvider
                                      .mydata!.data.data
                                      .where((store) => store.featured)
                                      .toList();
                                  print(
                                      "Filtered Stores: ${storesWithOffers.length}");

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OffersScreen(
                                          storesWithOffers: storesWithOffers),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text(
                                  'العروض',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Consumer<MyDataApiProvider>(
                            builder: (context, dataProvider, child) {
                              return ElevatedButton(
                                onPressed: () async {
                                  Provider.of<SignInViewModel>(context,
                                          listen: false)
                                      .resetOTPState();
                                  // Ensure the homepageData is fetched
                                  if (dataProvider.mydata == null) {
                                    await dataProvider.fetchData();
                                  }
                                  // Navigate to the screen that uses OpenStoreProvider
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          userProvider.user.isLoggedIn
                                              ? OpenStoresScreen()
                                              : const LoginPageScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text(
                                  'مفتوح',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              if (userProvider.user.isLoggedIn) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return const CategoryScreen();
                                  },
                                );
                              } else {
                                Provider.of<SignInViewModel>(context,
                                        listen: false)
                                    .resetOTPState();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginPageScreen(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.filter_alt_outlined),
                          ),
                        ),
                      ],
                    ),

                    Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                      if (categoryProvider.filteredSalons.isNotEmpty) {
                        return Column(
                          children: categoryProvider.filteredSalons
                              .map(
                                (salon) => InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SalonDetailPage(salonId: salon.id),
                                      ),
                                    );
                                  },
                                  child: MainContainers(data: salon),
                                ),
                              )
                              .toList(),
                        );
                      } else if (categoryProvider.hasSelectedCategories) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Image.asset(
                              "assets/images/searches.png",
                              height: 120,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              'لم يتم العثور على صالونات',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.purple),
                            ),
                          ],
                        );
                      } else {
                        return
                            //Start Cards
                            ValueListenableBuilder(
                                valueListenable: _isLoading,
                                builder: (context, bool isLoading, _) {
                                  if (isLoading) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 170,
                                        ),
                                        CircularProgressIndicator(),
                                      ],
                                    );
                                  }

                                  return Column(
                                    children: [
                                      Consumer<MyDataApiProvider>(
                                        builder:
                                            (context, dataProvider, child) {
                                          if (dataProvider.mydata != null) {
                                            if (dataProvider
                                                .mydata!.data.data.isNotEmpty) {
                                              return Column(
                                                children: List.generate(
                                                  2,
                                                  (index) {
                                                    // Limiting the list to two items
                                                    final salon = dataProvider
                                                        .mydata!
                                                        .data
                                                        .data[index];
                                                    return InkWell(
                                                      onTap: () {
                                                        // Navigate to the detail page when the card is tapped
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                SalonDetailPage(
                                                                    salonId:
                                                                        salon
                                                                            .id),
                                                          ),
                                                        );
                                                      },
                                                      child: MainContainers(
                                                          data: salon),
                                                    );
                                                  },
                                                ),
                                              );
                                            } else {
                                              return const Center(
                                                  child: Text(
                                                      "No data available"));
                                            }
                                          } else if (dataProvider.error !=
                                              null) {
                                            return Text(
                                                'Error: ${dataProvider.error}');
                                          }
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      ),

                                      //horizontal cards //////////
                                      Consumer<FeatureDataProvider>(
                                        builder:
                                            (context, featureProvider, child) {
                                          return FutureBuilder<Featured>(
                                            future: featureProvider.featureData,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              }

                                              // Ensure that there is data to display
                                              if (snapshot.hasData &&
                                                  snapshot
                                                      .data!.data.isNotEmpty) {
                                                var featuredData =
                                                    snapshot.data!;
                                                return SizedBox(
                                                  height: 250,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: featuredData
                                                        .data.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var salon = featuredData
                                                              .data[
                                                          index]; // Get the specific salon data
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            // Navigate to the detail page when the card is tapped
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    SalonDetailPage(
                                                                        salonId:
                                                                            salon.id),
                                                              ),
                                                            );
                                                          },
                                                          child: HorizontalCard(
                                                              data: salon),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              } else {
                                                // Return a message or empty space if there is no data
                                                return const Center(
                                                    child: Text(
                                                        "No featured data available"));
                                              }
                                            },
                                          );
                                        },
                                      ),

                                      //Start of Next five items of Vertical Card
                                      Consumer<MyDataApiProvider>(
                                        builder:
                                            (context, dataProvider, child) {
                                          if (dataProvider.mydata != null) {
                                            if (dataProvider
                                                    .mydata!.data.data.length >
                                                7) {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    5, // Limit to 5 items
                                                itemBuilder: (context, index) {
                                                  // Starts from the 3rd item (index + 2)
                                                  final salon = dataProvider
                                                      .mydata!
                                                      .data
                                                      .data[index + 2];
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SalonDetailPage(
                                                                  salonId:
                                                                      salon.id),
                                                        ),
                                                      );
                                                    },
                                                    child: MainContainers(
                                                        data: salon),
                                                  );
                                                },
                                              );
                                            } else {
                                              return const Center(
                                                  child: Text(
                                                      "No data available"));
                                            }
                                          } else if (dataProvider.error !=
                                              null) {
                                            return Text(
                                                'Error: ${dataProvider.error}');
                                          }
                                          if (dataProvider.mydata == null &&
                                              dataProvider.error == null) {
                                            Future.microtask(
                                                () => dataProvider.fetchData());
                                          }

                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      ),
                                      //End of Next five items of Vertical Card

                                      //Banner
                                      const BannerCard(),

                                      Consumer<MyDataApiProvider>(
                                        builder:
                                            (context, dataProvider, child) {
                                          if (dataProvider.mydata != null) {
                                            if (dataProvider
                                                    .mydata!.data.data.length >
                                                7) {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: dataProvider.mydata!
                                                        .data.data.length -
                                                    7, // Display items excluding the first seven
                                                itemBuilder: (context, index) {
                                                  final salon = dataProvider
                                                      .mydata!
                                                      .data
                                                      .data[index + 7];
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SalonDetailPage(
                                                                  salonId:
                                                                      salon.id),
                                                        ),
                                                      );
                                                    },
                                                    child: MainContainers(
                                                        data: salon),
                                                  );
                                                },
                                              );
                                            } else {
                                              return const Center(
                                                  child: Text(
                                                      "No data available"));
                                            }
                                          } else if (dataProvider.error !=
                                              null) {
                                            return Text(
                                                'Error: ${dataProvider.error}');
                                          }
                                          if (dataProvider.mydata == null &&
                                              dataProvider.error == null) {
                                            Future.microtask(
                                                () => dataProvider.fetchData());
                                          }

                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      ),

                                      // End of Remaining items of Vertical Card

                                      //loader of pagination
                                      if (Provider.of<MyDataApiProvider>(
                                              context)
                                          .isPaginating)
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                    ],
                                  );
                                });
                        //End Cards
                      }
                    })
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
