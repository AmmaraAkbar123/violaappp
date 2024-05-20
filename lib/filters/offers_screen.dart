import 'package:flutter/material.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/services/api_services/api_mydata_service.dart';
import 'package:viola/utils/padding_margin.dart';
import 'package:viola/widgets/main_containers.dart';

class OffersScreen extends StatelessWidget {
  final List<Datum> storesWithOffers;

  const OffersScreen({Key? key, required this.storesWithOffers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataApiService apiService = DataApiService();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('عروض المتجر'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Datum>>(
          future: apiService.fetchAllFeaturedStores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return MainContainers(data: snapshot.data![index]);
                },
              ).paddingOnly(left: 20, right: 20, top: 5, bottom: 5);
            } else {
              return Center(child: Text('No featured stores found.'));
            }
          },
        ),
      ),
    );
  }
}
