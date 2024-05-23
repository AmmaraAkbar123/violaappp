import 'package:flutter/material.dart';

class ConnectWithUs extends StatelessWidget {
  const ConnectWithUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(75, 0, 95, 1),
            title: const Text(
              "اتصل بنا",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "في حال الرغبة في التواصل معنا فيما يخص التطبيق ، او الاستفسار، او تقديم الا قتراحات، او الشكاوى يمكنك التواصل على",
                  style: TextStyle(color: Colors.purple),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "البريد الالكتروني........................  واتس.........................",
                  style: TextStyle(color: Colors.purple),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "وسنكون متواجدين لخدمتك دائما",
                  style: TextStyle(color: Colors.purple),
                ),
              ],
            ),
          )),
    );
  }
}
