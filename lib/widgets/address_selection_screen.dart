import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:viola/providers/data_api_provider.dart';
import 'package:viola/providers/map_provider.dart';
import 'package:viola/providers/user_provider.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  int? _selectedOption;
  List<LocationData> _locations = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadLocationsFromPrefs();
    setState(() {
      _locations = userProvider.savedLocations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'عناويني',
          style: TextStyle(
            color: Color.fromRGBO(75, 0, 95, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(75, 0, 95, 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (_locations.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Image.asset(
                        "assets/images/location.png",
                        height: 200,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Please add locations to see them here.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      itemCount: _locations.length,
                      itemBuilder: (context, index) {
                        return _buildRadioTile(index);
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile(int index) {
    final dataProvider = Provider.of<MyDataApiProvider>(context, listen: false);
    Provider.of<MapProvider>(context, listen: false);

    String name = _locations[index].name;
    LatLng latLng = _locations[index].position;

    return Column(
      children: [
        ListTile(
          leading: Radio<int>(
            value: index,
            groupValue: _selectedOption,
            onChanged: (int? value) {
              setState(() {
                _selectedOption = value;
              });

              // Update the provider with the selected LatLng
              dataProvider.updateLocation(
                  latLng.longitude.toString(), latLng.latitude.toString());

              // Navigate to the home screen and clear the navigation stack
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home', (route) => false);
            },
          ),
          title: Text(
            name,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.purple),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
