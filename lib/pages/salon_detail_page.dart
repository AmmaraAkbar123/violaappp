import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/providers/data_api_provider.dart';
import 'package:viola/providers/favorite_provider.dart';
import 'package:viola/widgets/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class SalonDetailPage extends StatefulWidget {
  final int salonId;
  const SalonDetailPage({super.key, required this.salonId});

  @override
  // ignore: library_private_types_in_public_api
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
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Consumer<MyDataApiProvider>(
          builder: (context, provider, child) {
            if (provider.salonDetails != null) {
              return buildSalonDetail(context, provider.salonDetails!);
            } else if (provider.error != null) {
              return Center(child: Text('Error: ${provider.error}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget buildSalonDetail(BuildContext context, Datum salon) {
    // Consume the FavoritesProvider to listen to changes
    return Consumer<FavoritesProvider>(
      builder: (context, favorites, child) {
        // Determine if the salon is favorited
        bool isFavorited = favorites.favorites.contains(salon.id);

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
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child:
                              Icon(Icons.arrow_back_ios, color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Provider.of<FavoritesProvider>(context,
                                    listen: false)
                                .toggleFavorite(context, salon.id);
                            // Force rebuild by calling setState if inside a StatefulWidget, or using another state management approach
                          },
                          child: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorited ? Colors.red : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(300.0),
                  child: buildMainCard(salon)),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [buildInfoCards(salon)],
              ),
            ),
          ],
        );
      },
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

    void _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    void makePhoneCall(String phoneNumber) async {
      final url = 'tel:$phoneNumber';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    void _openMap(BuildContext context, double latitude, double longitude) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('اختر تطبيق الخريطة'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (Platform.isIOS) ...[
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Apple Maps'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _launchURL(
                          'http://maps.apple.com/?q=$latitude,$longitude');
                    },
                  ),
                ],
                ListTile(
                  leading: Icon(Icons.map),
                  title: Text('Google Maps'),
                  onTap: () {
                    if (Platform.isIOS) {
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Google Maps is not available on iOS.'),
                        duration: Duration(seconds: 2),
                      );
                    } else {
                      Navigator.of(context).pop();
                      _launchURL(
                          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
                    }
                  },
                ),
                if (Platform.isAndroid) ...[
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Apple Maps'),
                    onTap: () {
                      SnackBar(
                        backgroundColor: Colors.red,
                        content:
                            Text('Apple Maps is not available on Android.'),
                        duration: Duration(seconds: 2),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      );
    }

    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 15),
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
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(75, 0, 95, 1)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                  decoration: BoxDecoration(
                      color: isClosed
                          ? Colors.red.withOpacity(0.5)
                          : Colors.green.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(openCloseText,
                      style: const TextStyle(
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
                const Text("اتصل بنا", style: TextStyle(color: Colors.purple)),
                Text(
                  "${salon.distance.toStringAsFixed(1)} كم", // Displays the distance with two decimal places
                  style: const TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
            const Text('إزا كان لديك أي سؤال!',
                style: TextStyle(color: Colors.grey)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: const Color.fromARGB(255, 241, 222, 245),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.xTwitter,
                      color: const Color.fromRGBO(75, 0, 95, 1),
                    ),
                    onPressed: () => _launchURL('https://twitter.com/'),
                  ),
                ),
                Card(
                  color: const Color.fromARGB(255, 241, 222, 245),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.instagram,
                      color: const Color.fromRGBO(75, 0, 95, 1),
                    ),
                    onPressed: () => _launchURL('https://instagram.com/'),
                  ),
                ),
                Card(
                  color: const Color.fromARGB(255, 241, 222, 245),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.phone,
                      color: const Color.fromRGBO(75, 0, 95, 1),
                    ),
                    onPressed: () => makePhoneCall(salon.phoneNumber),
                  ),
                ),
                Card(
                  color: const Color.fromARGB(255, 241, 222, 245),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.whatsapp,
                      color: const Color.fromRGBO(75, 0, 95, 1),
                    ),
                    onPressed: () => _launchURL("https://www.whatsapp.com/"),
                  ),
                ),
                Card(
                  color: const Color.fromARGB(255, 241, 222, 245),
                  child: IconButton(
                    icon: Icon(
                      Icons.directions,
                      color: const Color.fromRGBO(75, 0, 95, 1),
                    ),
                    onPressed: () =>
                        _openMap(context, salon.latitude, salon.longitude),
                  ),
                ),
              ],
            ),
            salon.bookingMethod.isNotEmpty
                ? Text(
                    'طريقة الحجز: ${salon.bookingMethod}',
                    style: const TextStyle(color: Colors.purple),
                  )
                : const SizedBox.shrink(),
          ],
        ),
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
              ? buildInfoCard(
                  "الملاحظات اليومية", const Divider(), salon.dailyNotes)
              : const SizedBox.shrink(),

          salon.generalNotes.isNotEmpty
              ? buildInfoCard(
                  "الملاحظات العامة", const Divider(), salon.generalNotes)
              : const SizedBox.shrink(),

          salon.promotions.isNotEmpty
              ? buildInfoCard("العروض", const Divider(), salon.promotions)
              : const SizedBox.shrink(),

          salon.tags.isNotEmpty
              ? buildInfoCard("الشريط الأصفر", const Divider(), salon.tags)
              : const SizedBox.shrink(),

          salon.addressDesc.isNotEmpty
              ? buildInfoCard(
                  "نبزة عن الصالون", const Divider(), salon.addressDesc)
              : const SizedBox.shrink(),

          buildScheduleCard(salon.availabilityHours),

          salon.serviceDesc.isNotEmpty
              ? buildServiceCard("الخدمات", const Divider(), salon.serviceDesc)
              : buildServiceCard(
                  "الخدمات", const Divider(), 'لم يتم العثورعلى خدمة'),

          const SizedBox(
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
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildServiceCard(String title, Widget divider, String content) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              height: 300,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Asset image
                  Expanded(
                    child: Image.asset(
                      'assets/images/service.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 10), // Spacer
                  // Texts
                  const Text(
                    'تفاصيل الخدمة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "عرض الخدمة",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10), // Spacer
                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 120, 2, 141)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'عرض',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 4,
        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
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
              padding: const EdgeInsets.fromLTRB(18, 5, 18, 5),
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
                padding: const EdgeInsets.fromLTRB(18, 5, 18, 5),
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
        dayWidgets.add(const Divider());
      }
    });
    // Add the bottom sheet widget

    return Card(
      elevation: 4,
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
            const Divider(),
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
