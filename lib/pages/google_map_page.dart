import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:viola/providers/myprovider.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        context.read<MapProvider>().determineCurrentPosition();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: buildSearchBar(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            Consumer<MapProvider>(builder: (contextr, mapprovider, child) {
              return GoogleMap(
                initialCameraPosition: mapprovider.defaultPosition,
                mapType: MapType.normal,
                markers: mapprovider.markers,
                onMapCreated: mapprovider.onMapCreated,
                onTap: mapprovider.handleTap,
                onCameraMove: mapprovider.onCameraMove,
                onCameraMoveStarted: mapprovider.onCameraMoveStarted,
                onCameraIdle: mapprovider.onCameraIdle,
                myLocationEnabled: true, // Show blue dot for current location
                myLocationButtonEnabled: true, // Optional: show location button
                padding: EdgeInsets.only(top: 80), // Add padding at the top
              );
            }),
            Consumer<MapProvider>(builder: (context, mapprovider, child) {
              if (mapprovider.showCard) {
                return buildInfoCard();
              } else {
                return SizedBox
                    .shrink(); // Return an empty widget when not showing the card
              }
            }) // Conditional rendering
          ],
        ),
      ),
    );
  }

  //Start Search Bar
  Widget buildSearchBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 48,
          margin: EdgeInsets.only(right: 10, left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Consumer<MapProvider>(builder: (context, mapprovider, child) {
            return TextField(
              controller: mapprovider.searchController,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 16),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: mapprovider.onSearchChanged,
            );
          }),
        ),
        Consumer<MapProvider>(builder: (context, mapprovider, child) {
          return Visibility(
            visible: mapprovider.showSuggestions &&
                mapprovider.suggestions.isNotEmpty,
            child: Container(
              height: 100,
              color: Colors.red, // Temporary background color
              child:
                  Consumer<MapProvider>(builder: (context, mapprovider, child) {
                return ListView.builder(
                  itemCount: mapprovider.suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(mapprovider.suggestions[index]),
                      onTap: () {
                        mapprovider
                            .selectSuggestion(mapprovider.suggestions[index]);
                      },
                    );
                  },
                );
              }),
            ),
          );
        })
      ],
    );
  }
  //End Search Bar

  //Start Google Map
  Widget buildBody() {
    return Stack(
      children: [
        Consumer<MapProvider>(builder: (context, mapprovider, child) {
          return GoogleMap(
            initialCameraPosition: mapprovider.defaultPosition,
            mapType: MapType.normal,
            markers: mapprovider.markers,
            onMapCreated: mapprovider.onMapCreated,
            onTap: mapprovider.handleTap,
          );
        }),
        buildInfoCard(),
      ],
    );
  }
  //End Google Map

  Widget buildInfoCard() {
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
                      ListTile(
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
                            Text(
                              'الكامل العنوان',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(75, 0, 95, 1),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 22,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Consumer<MapProvider>(
                                      builder: (context, mapprovider, child) {
                                    return Text(
                                      mapprovider.currentAddress,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                        color: Color.fromRGBO(75, 0, 95, 1),
                                      ),
                                    );
                                  }),
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
                      child: Consumer<MapProvider>(
                          builder: (context, mapprovider, child) {
                        return ElevatedButton(
                          onPressed: () {
                            String query = mapprovider.searchController.text
                                .trim(); // Get the search query
                            mapprovider.searchAndNavigate(
                                query); // Call searchAndNavigate with the query
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(75, 0, 95, 1),
                            ),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(vertical: 15)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Text(
                            'اخترهنا',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }),
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
    //End location info Card with Button
  }
}

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController _mapController;
//   final TextEditingController _searchController = TextEditingController();
//   String _currentAddress = 'Fetching address...';
//   Set<Marker> _markers = {};
//   List<String> _suggestions = [];
//   bool _showSuggestions = false;
//   bool _showCard = true;
  
//   // Default coordinates
//   final CameraPosition _defaultPosition = CameraPosition(
//     target: LatLng(31.473427, 74.266420), 
//     zoom: 14,
//   );
//   late LatLng _lastMapPosition = _defaultPosition.target;

//   @override
//   void initState() {
//     super.initState();
//     _determineCurrentPosition();
//   }

//   // Start Determine Current Position
//   Future<void> _determineCurrentPosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     _updateCameraPosition(position.latitude, position.longitude);
//   }
//   // End Determine Current Position

//   //Start Remove Card when Camera Move
//   void _onCameraMoveStarted() {
//     setState(() {
//       _showCard = false;
//     });
//   }
//   //End Remove Card when Camera Move

//   //Start When Camera is not Moving
//   void _onCameraIdle() {
//     _getAddressFromLatLng(_lastMapPosition.latitude, _lastMapPosition.longitude)
//         .then((address) {
//       setState(() {
//         _showCard = true;
//         _currentAddress = address; 
//         _markers = {
//           Marker(
//             markerId: MarkerId("currentLocation"),
//             position: _lastMapPosition,
//             infoWindow: InfoWindow(title: _currentAddress),
//           ),
//         };
//       });
//     }).catchError((error) {
//       // Handle errors here
//       print("Error fetching address: $error");
//       setState(() {
//         _currentAddress = "Failed to get address";
//       });
//     });
//   }
//   //End When Camera is not Moving

//   //Start When Camera is on Move
//   void _onCameraMove(CameraPosition position) {
//     _lastMapPosition = position.target;
//     setState(() {
//       // Update the marker position in real-time with the camera
//       _markers = {
//         Marker(
//           markerId: MarkerId("currentLocation"),
//           position: _lastMapPosition,
//         ),
//       };
//     });
//   }
//   //End When Camera is on Move

//   void _updateCameraPosition(double latitude, double longitude) {
//     _mapController
//         .animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
//   }

//   //Start Set Marker on Tap
//   void _handleTap(LatLng tappedPoint) async {
//     await _getAddressFromLatLng(tappedPoint.latitude, tappedPoint.longitude);

//     setState(() {
//       _markers.clear();
//       _markers.add(
//         Marker(
//           markerId: MarkerId(tappedPoint.toString()),
//           position: tappedPoint,
//           infoWindow: InfoWindow(title: 'Selected Location'),
//         ),
//       );
//     });
//     _mapController.animateCamera(CameraUpdate.newLatLng(tappedPoint));
//   }
//   //End Set Marker on Tap

//   // Start Get Address from Coordinates

//   Future<String> _getAddressFromLatLng(
//       double latitude, double longitude) async {
//     try {
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(latitude, longitude);
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         String street = place.street ?? 'Street unknown';
//         String locality = place.locality ?? 'City unknown';
//         String country = place.country ?? 'Country unknown';
//         return "$street, $locality, $country"; // Returning the formatted address
//       } else {
//         return "No address found";
//       }
//     } catch (e) {
//       return "Failed to get address: ${e.toString()}"; // Returning error message
//     }
//   }

//   // End Get Address from Coordinates

//   // Start Get Place Details

//   Future<LatLng> fetchPlaceDetails(String placeId, String apiKey) async {
//     final String url =
//         'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey';
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final result = json.decode(response.body);
//         if (result['status'] == 'OK') {
//           final location = result['result']['geometry']['location'];
//           return LatLng(location['lat'], location['lng']);
//         }
//         throw Exception(result['error_message']);
//       } else {
//         throw Exception('Failed to fetch place details');
//       }
//     } catch (e) {
//       throw Exception('Failed to fetch place details: $e');
//     }
//   }
//   // End Get Place Details

//    // Start Suggestions
//   Future<List<String>> fetchSuggestions(String input, String apiKey) async {
    
//     final String baseURL =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json';
//     String request = '$baseURL?input=$input&key=$apiKey';

//     try {
//       final response = await http.get(Uri.parse(request));
//       if (response.statusCode == 200) {
//         final result = json.decode(response.body);
//         if (result['status'] == 'OK') {
//           return (result['predictions'] as List)
//               .map<String>((p) => p['description'] as String)
//               .toList();
//         }
//         if (result['status'] == 'ZERO_RESULTS') {
//           return [];
//         }
//         throw Exception(result['error_message']);
//       } else {
//         throw Exception('Failed to fetch suggestions');
//       }
//     } catch (e) {
//       throw Exception('Failed to fetch suggestions: $e');
//     }
//   }
//   // End Suggestions

//   //Start Changes made on Search Suggestions

//   void _onSearchChanged(String query) async {
//     if (query.isNotEmpty) {
//       var results = await fetchSuggestions(
//           query, 'AIzaSyAL4OhK2DnU0XMcj0VZgwfc4DKRKLdOdv0'); 
//       setState(() {
//         _suggestions = results;
//         _showSuggestions = true;
//       });
//     } else {
//       setState(() {
//         _suggestions = [];
//         _showSuggestions = false;
//       });
//     }
//   }
//   //End Changes made on Search Suggestions

//   // Start Search and Navigation

//   void _searchAndNavigate() {
//     final query = _searchController.text.trim();
//     if (query.isNotEmpty) {
//       fetchPlaceDetails(query, 'AIzaSyAL4OhK2DnU0XMcj0VZgwfc4DKRKLdOdv0')
//           .then((latLng) {
//         _updateCameraPosition(latLng.latitude, latLng.longitude);
//         setState(() {
//           _showCard = true;
//           _markers.clear();
//           _markers.add(
//             Marker(
//               markerId: MarkerId('searchedLocation'),
//               position: latLng,
//               infoWindow: InfoWindow(title: query),
//             ),
//           );
//           _getAddressFromLatLng(latLng.latitude, latLng.longitude);
//         });
//       }).catchError((e) {
//         print("Search Error: $e");
//       });
//     }
//   }
//   // End Search and Navigation

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           title: buildSearchBar(),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.grey),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: Stack(
//           children: [
//             GoogleMap(
//               initialCameraPosition: _defaultPosition,
//               mapType: MapType.normal,
//               markers: _markers,
//               onMapCreated: (GoogleMapController controller) {
//                 _mapController = controller;
//               },
//               onTap: _handleTap,
//               onCameraMove: _onCameraMove,
//               onCameraMoveStarted: _onCameraMoveStarted,
//               onCameraIdle: _onCameraIdle,
//               myLocationEnabled: true, // Show blue dot for current location
//               myLocationButtonEnabled: true, // Optional: show location button
//               padding: EdgeInsets.only(top: 80), // Add padding at the top
//             ),
//             if (_showCard) buildInfoCard(), // Conditional rendering
//           ],
//         ),
//       ),
//     );
//   }

//   //Start Search Bar
//   Widget buildSearchBar() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           height: 48,
//           margin: EdgeInsets.only(right: 10, left: 10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintStyle: TextStyle(fontSize: 16),
//               border: InputBorder.none,
//               prefixIcon: Icon(Icons.search, color: Colors.grey),
//             ),
//             onChanged: _onSearchChanged,
//           ),
//         ),
//         Visibility(
//           visible: _showSuggestions && _suggestions.isNotEmpty,
//           child: Container(
//             height: 100,
//             color: Colors.red, // Temporary background color
//             child: ListView.builder(
//               itemCount: _suggestions.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_suggestions[index]),
//                   onTap: () {
//                     _searchController.text = _suggestions[index];
//                     _showSuggestions = false;
//                     _searchAndNavigate();
//                     setState(() {});
//                   },
//                 );
//               },
//             ),
//           ),
//         )
//       ],
//     );
//   }
//   //End Search Bar

//   //Start Google Map
//   Widget buildBody() {
//     return Stack(
//       children: [
//         GoogleMap(
//           initialCameraPosition: _defaultPosition,
//           mapType: MapType.normal,
//           markers: _markers,
//           onMapCreated: (GoogleMapController controller) {
//             _mapController = controller;
//           },
//           onTap: _handleTap,
//         ),
//         buildInfoCard(),
//       ],
//     );
//   }
//   //End Google Map

//   Widget buildInfoCard() {
//     return Positioned.fill(
//       child: Container(
//         margin: EdgeInsets.only(
//             top: kToolbarHeight + MediaQuery.of(context).padding.top),
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               //Start Card Area
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Card(
//                   child: Column(
//                     children: [
//                       ListTile(
//                         title: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               ' أضف إلى عنواني',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Color.fromRGBO(75, 0, 95, 1),
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Row(
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.description_outlined,
//                                   size: 22,
//                                   color: Colors.grey,
//                                 ),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     'عنوان',
//                                     style: TextStyle(
//                                         fontSize: 12, color: Colors.grey),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       ListTile(
//                         title: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               'الكامل العنوان',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Color.fromRGBO(75, 0, 95, 1),
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Row(
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.location_on_outlined,
//                                   size: 22,
//                                   color: Colors.grey,
//                                 ),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     _currentAddress,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12,
//                                       overflow: TextOverflow.ellipsis,
//                                       color: Color.fromRGBO(75, 0, 95, 1),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //End Card Area
//               //Start Button
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () => _searchAndNavigate(),
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                             Color.fromRGBO(75, 0, 95, 1),
//                           ),
//                           foregroundColor:
//                               MaterialStateProperty.all<Color>(Colors.white),
//                           padding: MaterialStateProperty.all<EdgeInsets>(
//                               EdgeInsets.symmetric(vertical: 15)),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         child: Text(
//                           'اخترهنا',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               //End Button
//             ],
//           ),
//         ),
//       ),
//     );
//     //End location info Card with Button
//   }
// }