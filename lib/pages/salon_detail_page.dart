import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/providers/data_api_provider.dart';
import 'package:viola/widgets/cached_network_image.dart';

class SalonDetailPage extends StatefulWidget {
  final int salonId;
  SalonDetailPage({required this.salonId});

  @override
  _SalonDetailPageState createState() => _SalonDetailPageState();
}

class _SalonDetailPageState extends State<SalonDetailPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<MyDataApiProvider>(context, listen: false)
        .fetchSalonDetails(widget.salonId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Consumer<MyDataApiProvider>(
          builder: (context, provider, child) {
            if (provider.salonDetails != null) {
              return buildSalonDetail(context, provider.salonDetails!);
            } else if (provider.error != null) {
              return Center(child: Text('Error: ${provider.error}'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

 Widget buildSalonDetail(BuildContext context, Datum salon) {
  return CustomScrollView(
    slivers: [
      SliverAppBar(
        automaticallyImplyLeading: false,
        floating: true,
        expandedHeight: MediaQuery.of(context).size.height * 0.3,
        flexibleSpace: Stack(
          children: [
            buildImageCarousel(context, salon.media),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios, color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.favorite_outline, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(200.0),
          child: buildMainCard(salon),
        ),
      ),
      // SliverPadding(
      //   padding: const EdgeInsets.only(top: 70),
      //   sliver: 
      // ),
      SliverList(
          delegate: SliverChildListDelegate(
            [buildInfoCards(salon)],
          ),
        ),
    ],
  );
}
  Widget buildImageCarousel(BuildContext context, List<Media> mediaList) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.3,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        autoPlay: true,
      ),
      items: mediaList.map((mediaItem) {
        return Builder(builder: (BuildContext context) {
          return CustomImageHandler(mediaItem.url).displayImage();
        });
      }).toList(),
    );
  }

  Widget buildMainCard(Datum salon) {
    bool isClosed = salon.closed;
    String openCloseText = isClosed ? "مغلق" : "مفتوح";

    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  salon.name.en,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(75, 0, 95, 1)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                  decoration: BoxDecoration(
                      color: isClosed
                          ? Colors.red.withOpacity(0.5)
                          : Colors.green.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(openCloseText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("اتصل بنا", style: TextStyle(color: Colors.purple)),
                Text(
                  "${salon.distance.toStringAsFixed(1)} كم", // Displays the distance with two decimal places
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
            Text('إزا كان لديك أي سؤال!', style: TextStyle(color: Colors.grey)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconCard(FontAwesomeIcons.xTwitter),
                IconCard(FontAwesomeIcons.instagram),
                IconCard(Icons.phone),
                IconCard(FontAwesomeIcons.whatsapp),
                IconCard(Icons.directions),
              ],
            ),
            salon.bookingMethod.isNotEmpty
                ? Text(
                    'طريقة الحجز: ${salon.bookingMethod}',
                    style: TextStyle(color: Colors.purple),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget IconCard(IconData icon) {
    return Card(
      color: Color.fromARGB(255, 241, 222, 245),
      child: IconButton(
        icon: Icon(
          icon,
          color: Color.fromRGBO(75, 0, 95, 1),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget buildInfoCards(Datum salon) {
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<MyDataApiProvider>(context, listen: false)
            .fetchSalonDetails(widget.salonId);
      },
      child: Column(
        children: [
          salon.dailyNotes.isNotEmpty
              ? buildInfoCard("الملاحظات اليومية", Divider(), salon.dailyNotes)
              : SizedBox.shrink(),

          salon.generalNotes.isNotEmpty
              ? buildInfoCard("الملاحظات العامة", Divider(), salon.generalNotes)
              : SizedBox.shrink(),

          salon.promotions.isNotEmpty
              ? buildInfoCard("العروض", Divider(), salon.promotions)
              : SizedBox.shrink(),

          salon.tags.isNotEmpty
              ? buildInfoCard("الشريط الأصفر", Divider(), salon.tags)
              : SizedBox.shrink(),

          salon.addressDesc.isNotEmpty
              ? buildInfoCard("نبزة عن الصالون", Divider(), salon.addressDesc)
              : SizedBox.shrink(),

          buildScheduleCard(salon.availabilityHours),

          salon.serviceDesc.isNotEmpty
              ? buildServiceCard("الخدمات", Divider(), salon.serviceDesc)
              : buildServiceCard("الخدمات", Divider(), 'لم يتم العثورعلى خدمة'),

          SizedBox(
            height: 20,
          )

          // Additional cards as needed...
        ],
      ),
    );
  }

  Widget buildInfoCard(String title, Widget divider, String content) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: ListTile(
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.purple[700])),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            divider,
            Text(
              content,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildServiceCard(String title, Widget divider, String content) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: ListTile(
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.purple[700])),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            divider,
            Text(
              content,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScheduleCard(List<AvailabilityHour> hours) {
    // Map of English day names to Arabic
    Map<String, String> dayNameMap = {
      'monday': 'الإثنين',
      'tuesday': 'الثلاثاء',
      'wednesday': 'الأربعاء',
      'thursday': 'الخميس',
      'friday': 'الجمعة',
      'saturday': 'السبت',
      'sunday': 'الأحد'
    };

    // Grouping hours by day, assuming day is non-nullable
    Map<String, List<AvailabilityHour>> groupedHours = {};
    for (var hour in hours) {
      groupedHours.putIfAbsent(hour.day, () => []).add(hour);
    }

    // Define all days of the week to ensure all days are displayed
    List<String> allDays = [
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
    ];

    // Building the widget list within a single card
    List<Widget> dayWidgets = [];
    allDays.forEach((day) {
      List<AvailabilityHour> hoursForDay = groupedHours[day] ?? [];
      Widget dayWidget;
      if (hoursForDay.isEmpty) {
        dayWidget = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dayNameMap[day] ?? 'Unknown',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.purple[700],
                )),
            Container(
              padding: EdgeInsets.fromLTRB(18, 5, 18, 5),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                'مغلق',
                style: TextStyle(fontSize: 12, color: Colors.purple[700]),
              ),
            ),
          ],
        );
      } else {
        List<Widget> timeButtons = hoursForDay.map((hour) {
          return Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: Container(
                padding: EdgeInsets.fromLTRB(18, 5, 18, 5),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'من ' +
                      formatTime(hour.startAt) +
                      ' - ' +
                      'إلى ' +
                      formatTime(hour.endAt),
                  style: TextStyle(color: Colors.purple[700]),
                )),
          );
        }).toList();

        dayWidget = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dayNameMap[day] ?? 'Unknown',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.purple[700],
                )),
            Column(children: timeButtons),
          ],
        );
      }

      dayWidgets.add(dayWidget);
      if (day != allDays.last) {
        dayWidgets.add(Divider());
      }
    });

    return Card(
      elevation: 4,
      surfaceTintColor: Colors.white,
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اوقات العمل',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.purple[700],
                )),
            Divider(),
            ...dayWidgets,
          ],
        ),
      ),
    );
  }

  String formatTime(String? time) {
    if (time == null || !time.contains(':'))
      return 'N/A'; // Handle null or incorrect time format safely

    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    String amPm = hour >= 12 ? 'ص' : 'م';
    hour = hour % 12;
    if (hour == 0) hour = 12;

    // Construct the time string with "from" for the first time and "to" for the second time
    return '${hour.toString().padLeft(2)}:${parts[1].padLeft(2)} $amPm';
  }
}
