// import 'package:flutter/material.dart';
// import 'package:viola/json_models/mydata_model.dart';
// import 'package:viola/pages/salon_detail_page.dart';
// import 'package:viola/services/api_services/api_mydata_service.dart';
// import 'package:viola/widgets/main_containers.dart';

// class SalonsFilterByCategoryScreen extends StatelessWidget {
//   final List<Datum> storesWithSalonsFilterByCategory;

//   const SalonsFilterByCategoryScreen(
//       {super.key, required this.storesWithSalonsFilterByCategory});

//   @override
//   Widget build(BuildContext context) {
//     DataApiService apiService = DataApiService();

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('عروض المتجر'),
//           centerTitle: true,
//         ),
//         body: FutureBuilder<List<Datum>>(
//           future: apiService.fetchAllFeaturedStores(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.hasData) {
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   return InkWell(
//                     onTap: () {
//                       // Navigate to the detail page when the card is tapped
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SalonDetailPage(
//                               salonId: snapshot.data![index].id),
//                         ),
//                       );
//                     },
//                     child: MainContainers(data: snapshot.data![index]),
//                   );
//                 },
//               );
//             } else {
//               return Center(child: Text('No featured stores found.'));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
