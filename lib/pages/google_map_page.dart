import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:viola/pages/login_page.dart';
import 'package:viola/providers/category_provider.dart';
import 'package:viola/providers/data_api_provider.dart';
import 'package:viola/providers/map_provider.dart';
import 'package:viola/providers/user_provider.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapProvider>(context, listen: false)
          .determineCurrentPosition(context);
      Provider.of<MapProvider>(context, listen: false).resetPositionFetched();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: buildSearchBar(context, mapProvider),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: mapProvider.defaultPosition,
              mapType: MapType.normal,
              onMapCreated: (controller) =>
                  mapProvider.onMapCreated(controller, context),
              onTap: (tappedPoint) => mapProvider.handleTap(tappedPoint),
              onCameraMove: (position) => mapProvider.onCameraMove(position),
              onCameraMoveStarted: () => mapProvider.onCameraMoveStarted(),
              onCameraIdle: () => mapProvider.onCameraIdle(),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              padding: const EdgeInsets.only(top: 80, bottom: 40),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Icon(Icons.location_pin, size: 40, color: Colors.red),
              ),
            ),
            if (mapProvider.showCard) buildInfoCard(mapProvider),
          ],
        ),
      ),
    );
  }

  //Start Search Bar
  Widget buildSearchBar(BuildContext context, MapProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 48,
          margin: const EdgeInsets.only(right: 10, left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: provider.searchController,
            decoration: const InputDecoration(
              hintStyle: TextStyle(fontSize: 16),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
            onChanged: provider.onSearchChanged,
          ),
        ),
        Visibility(
          visible: provider.showSuggestions && provider.suggestions.isNotEmpty,
          child: Container(
            height: 100,
            color: Colors.red, // Temporary background color
            child: ListView.builder(
              itemCount: provider.suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(provider.suggestions[index]),
                  onTap: () {
                    provider.selectSuggestion(provider.suggestions[index]);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
  //End Search Bar

  Widget buildInfoCard(MapProvider provider) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dataProvider = Provider.of<MyDataApiProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final mapProvider = Provider.of<MapProvider>(context, listen: false);

    return Positioned.fill(
      child: Container(
        margin: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Start Card Area
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  child: Column(
                    children: [
                      const ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              ' أضف إلى عنواني',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(75, 0, 95, 1),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.description_outlined,
                                  size: 22,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'عنوان',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'الكامل العنوان',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(75, 0, 95, 1),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 22,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    provider.currentAddress,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      color: Color.fromRGBO(75, 0, 95, 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //End Card Area
              //Start Button
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (userProvider.user.isLoggedIn) {
                            // Fetch position only when button is pressed
                            await mapProvider.determineCurrentPosition(context);
                            double latitude = provider.lastMapPosition.latitude;
                            double longitude =
                                provider.lastMapPosition.longitude;
                            String address = await mapProvider
                                .getAddressFromLatLng(latitude, longitude);

                            dataProvider.updateLocation(
                                longitude.toString(), latitude.toString());

                            //Clear selected categories filter
                            categoryProvider.clearSelectedCategories();

                            // Navigate to the home screen and clear the navigation stack
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (route) => false);
                            //save locations in address selection screen
                            userProvider.addLocation(
                                address, LatLng(latitude, longitude));
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginPageScreen()),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(
                                  75, 0, 95, 1) // Deep purple color
                              ),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(vertical: 15)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: const Text(
                          'اخترهنا',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //End Button
            ],
          ),
        ),
      ),
    );
  }
}
