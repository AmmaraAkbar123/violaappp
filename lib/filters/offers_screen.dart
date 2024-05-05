import 'package:flutter/material.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/widgets/main_containers.dart';

class OffersScreen extends StatelessWidget {
  final List<Datum> storesWithOffers;

  const OffersScreen({Key? key, required this.storesWithOffers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('عروض المتجر'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: storesWithOffers.length,
          itemBuilder: (context, index) {
            return MainContainers(data: storesWithOffers[index]);
          },
        ),
      ),
    );
  }
}
