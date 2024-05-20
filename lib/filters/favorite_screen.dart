import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/pages/salon_detail_page.dart';
import 'package:viola/providers/favorite_provider.dart';
import 'package:viola/services/api_services/api_mydata_service.dart';
import 'package:viola/widgets/main_containers.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'المتاجر المفضلة',
            style: TextStyle(color: Colors.purple),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.purple),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              if (favoritesProvider.favorites.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 120,
                      ),
                      Image.asset(
                        "assets/images/favoriteicon.png",
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Text('No favorites added'),
                    ],
                  ),
                );
              }

              return _buildFavoriteSalonsList(context, favoritesProvider);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteSalonsList(
      BuildContext context, FavoritesProvider favoritesProvider) {
    return ListView.builder(
      itemCount: favoritesProvider.favorites.length,
      itemBuilder: (context, index) {
        int salonId = favoritesProvider.favorites.elementAt(index);
        return _buildSalonItem(context, salonId, favoritesProvider);
      },
    );
  }

  Widget _buildSalonItem(
      BuildContext context, int salonId, FavoritesProvider favoritesProvider) {
    DataApiService apiService = DataApiService();
    return FutureBuilder(
      future: apiService.fetchSalonDetails(salonId),
      builder: (context, AsyncSnapshot<Datum> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a placeholder widget while data is loading
          return SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          Datum salon = snapshot.data!;
          return GestureDetector(
            onTap: () {
              // Navigate to SalonDetailPage instead of toggling favorites
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SalonDetailPage(
                    salonId: salonId,
                  ),
                ),
              );
            },
            child: MainContainers(data: salon),
          );
        } else {
          return const Text('No data available.');
        }
      },
    );
  }
}
