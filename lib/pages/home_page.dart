import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:viola/json_models/feature_model.dart';
import 'package:viola/pages/category_screen.dart';
import 'package:viola/pages/google_map_page.dart';
import 'package:viola/providers/adress_provider.dart';
import 'package:viola/providers/myprovider.dart';
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
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
@override
void initState() {
  super.initState();
  SchedulerBinding.instance.addPostFrameCallback((_) {
    _loadInitialData();
    // Ensure determineAndSetCurrentAddress is called after the build is completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressProvider>(context, listen: false)
          .determineAndSetCurrentAddress();
    });
  });
  _scrollController.addListener(_handleScroll);
}


  @override
  void dispose() {
    // Proper disposal of the scroll controller to prevent memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  // Initial data loading function
  void _loadInitialData() {
    Provider.of<MyDataApiProvider>(context, listen: false).fetchData();
    Provider.of<FeatureProvider>(context, listen: false).fetchFeaturedData();
  }

  // Refresh function for pull-to-refresh functionality
  Future<void> _handleRefresh() async {
    await Provider.of<MyDataApiProvider>(context, listen: false).fetchData();
  }

  // Scroll listener function to handle lazy loading
  void _handleScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      var provider = Provider.of<MyDataApiProvider>(context, listen: false);
      if (provider.hasMore) { // Checking if there's more data to load
        provider.fetchData(fetchNextPage: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(250, 226, 225, 225),
     appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(75, 0, 95, 1),
        title: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => GoogleMapPage()));
          },
          child:  Container(
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
                  TextFormField(
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
                            'العروض',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
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
                            'مفتوح',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => CategoryPage()),
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
                            children: List.generate(2, (index) {// Limiting the list to two items
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
                              final salon = dataProvider
                                  .mydata!.data.data[index + 2];
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
                            itemCount: dataProvider
                                    .mydata!.data.data.length -
                                7, // Display items excluding the first seven
                            itemBuilder: (context, index) {
                              final salon = dataProvider
                                  .mydata!.data.data[index + 7];
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
