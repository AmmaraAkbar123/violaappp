import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:viola/filters/offers_screen.dart';
import 'package:viola/filters/open_stores_screen.dart';
import 'package:viola/json_models/feature_model.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/pages/category_screen.dart';
import 'package:viola/pages/google_map_page.dart';
import 'package:viola/providers/adress_provider.dart';
import 'package:viola/providers/feature_data_provider.dart';
import 'package:viola/pages/salon_detail_page.dart';
import 'package:viola/providers/data_api_provider.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  // TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
      Provider.of<AddressProvider>(context, listen: false)
          .determineAndSetCurrentAddress();
    });
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // _searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    Provider.of<MyDataApiProvider>(context, listen: false).fetchData();
    Provider.of<FeatureDataProvider>(context, listen: false).getDataApi();
  }

  Future<void> _handleRefresh() async {
    await Provider.of<MyDataApiProvider>(context, listen: false).fetchData();
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

  //search salon
  // void _searchSalon(BuildContext context) async {
  //   String query =
  //       Provider.of<TextEditingController>(context, listen: false).text;
  //   try {
  //     List<String> results =
  //         await Provider.of<SearchProvider>(context, listen: false)
  //             .searchSalon(query);
  //     Provider.of<List<String>>(context, listen: false).clear();
  //     Provider.of<List<String>>(context, listen: false).addAll(results);
  //   } catch (e) {
  //     print('Error searching salons: $e');
  //   }
  // }

  // void performSearch(String query) async {
  //   try {
  //     List<Datum> results = await searchSalonByName(query);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => SearchResultsScreen(results: results),
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error searching salons: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(248, 235, 229, 229),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(75, 0, 95, 1),
        title: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GoogleMapPage()));
          },
          child: Container(
            width: double.infinity,
            child: Consumer<AddressProvider>(
              builder: (context, addressProvider, child) {
                // Print the current address for debugging
                print('Current Address: ${addressProvider.currentAddress}');
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset('assets/images/map.png', width: 24, height: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        addressProvider.currentAddress,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Icon(Icons.location_on_outlined, color: Colors.white),
                  ],
                );
              },
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: const NavBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 13),
              child: Column(
                children: [
                  //search textfield
                  TextField(
                    // controller: Provider.of<TextEditingController>(
                    //     context), // Add TextEditingController
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'ابحث عن موقع',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 12),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () => _searchSalon(context),
                  //   child: Text('Search'),
                  // ),
                  // SizedBox(height: 20),
                  // Add a Consumer to display search results
                  // Consumer<List<String>>(
                  //   builder: (context, searchResults, _) {
                  //     if (searchResults.isEmpty) {
                  //       return Text('No results');
                  //     } else {
                  //       return Expanded(
                  //         child: ListView.builder(
                  //           itemCount: searchResults.length,
                  //           itemBuilder: (context, index) {
                  //             return ListTile(
                  //               title: Text(searchResults[index]),
                  //             );
                  //           },
                  //         ),
                  //       );
                  //     }
                  //   },
                  //),
                  CarouselSlider(
                    items: carouselItems
                        .map(
                          (e) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: NetworkImage(e.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      height: 150,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
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
                                // Ensure data is loaded
                                if (dataProvider.mydata == null) {
                                  await dataProvider.fetchData();
                                }
                                dataProvider.mydata!.data.data.forEach((datum) {
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
                                padding: EdgeInsets.symmetric(
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
                                if (dataProvider.mydata == null) {
                                  await dataProvider.fetchData();
                                }
                                List<Datum> openStores = dataProvider
                                    .mydata!.data.data
                                    .where((store) => !store.closed)
                                    .toList();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OpenStoresScreen(
                                        openStores: openStores),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
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
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => CategoryScreen()),
                          ),
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

                  // MainContainers//
                  //Start First two items of Vertical Card
                  Consumer<MyDataApiProvider>(
                    builder: (context, dataProvider, child) {
                      if (dataProvider.mydata != null) {
                        if (dataProvider.mydata!.data.data.isNotEmpty) {
                          return Column(
                            children: List.generate(
                              2,
                              (index) {
                                // Limiting the list to two items
                                final salon =
                                    dataProvider.mydata!.data.data[index];
                                return InkWell(
                                  onTap: () {
                                    // Navigate to the detail page when the card is tapped
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SalonDetailPage(salonId: salon.id),
                                      ),
                                    );
                                  },
                                  child: MainContainers(data: salon),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(child: Text("No data available"));
                        }
                      } else if (dataProvider.error != null) {
                        return Text('Error: ${dataProvider.error}');
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  //End First two items of Vertical Card
                  /// //Horizontal list card

                  Consumer<FeatureDataProvider>(
                    builder: (context, featureProvider, child) {
                      return FutureBuilder<Featured>(
                        future: featureProvider.featureData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          var featuredData = snapshot.data!;
                          return SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: featuredData.data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: HorizontalCard(
                                      data: featuredData.data[index]),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  //Start of Next five items of Vertical Card
                  Consumer<MyDataApiProvider>(
                    builder: (context, dataProvider, child) {
                      if (dataProvider.mydata != null) {
                        if (dataProvider.mydata!.data.data.length > 7) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 5, // Limit to 5 items
                            itemBuilder: (context, index) {
                              // Starts from the 3rd item (index + 2)
                              final salon =
                                  dataProvider.mydata!.data.data[index + 2];
                              return InkWell(
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
                              );
                            },
                          );
                        } else {
                          return Center(child: Text("No data available"));
                        }
                      } else if (dataProvider.error != null) {
                        return Text('Error: ${dataProvider.error}');
                      }
                      if (dataProvider.mydata == null &&
                          dataProvider.error == null) {
                        Future.microtask(() => dataProvider.fetchData());
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  //End of Next five items of Vertical Card

                  //Banner
                  const BannerCard(),

                  Consumer<MyDataApiProvider>(
                    builder: (context, dataProvider, child) {
                      if (dataProvider.mydata != null) {
                        if (dataProvider.mydata!.data.data.length > 7) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: dataProvider.mydata!.data.data.length -
                                7, // Display items excluding the first seven
                            itemBuilder: (context, index) {
                              final salon =
                                  dataProvider.mydata!.data.data[index + 7];
                              return InkWell(
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
                              );
                            },
                          );
                        } else {
                          return Center(child: Text("No data available"));
                        }
                      } else if (dataProvider.error != null) {
                        return Text('Error: ${dataProvider.error}');
                      }
                      if (dataProvider.mydata == null &&
                          dataProvider.error == null) {
                        Future.microtask(() => dataProvider.fetchData());
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  ),

                  // End of Remaining items of Vertical Card

                  //loader of pagination
                  if (Provider.of<MyDataApiProvider>(context).isPaginating)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
