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

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadLocationsFromPrefs();
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
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final locations = userProvider.savedLocations;
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (locations.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 80),
                          Image.asset("assets/images/location.png",
                              height: 200),
                          const SizedBox(height: 20),
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
                          itemCount: locations.length,
                          itemBuilder: (context, index) {
                            return _buildRadioTile(context, index, locations);
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRadioTile(
      BuildContext context, int index, List<LocationData> locations) {
    final dataProvider = Provider.of<MyDataApiProvider>(context, listen: false);
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String name = locations[index].name;
    LatLng latLng = locations[index].position;

    return Column(
      children: [
        ListTile(
          leading: Radio<int>(
            value: index,
            groupValue: _selectedOption,
            onChanged: (int? value) {
              _selectedOption = value;
              dataProvider.updateLocation(
                  latLng.longitude.toString(), latLng.latitude.toString());
              mapProvider.updateCurrentAddress(name);
              userProvider.addLocation(name, latLng);
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
