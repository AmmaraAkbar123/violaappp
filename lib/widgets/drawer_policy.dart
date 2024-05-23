import 'package:flutter/material.dart';

class ApplicationPolicy extends StatelessWidget {
  const ApplicationPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(75, 0, 95, 1),
            title: const Text(
              "سياسة التطبيق",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "سياسة التطبيق :",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                    "فيولا هو تطبيق ودليل مجاني للصالونات، يهدف إلى تسهيل الوصول للصالونات وخدماتها."),
                SizedBox(
                  height: 30,
                ),
                Text(
                    "لزلك لايتحمل تطبيق فيولا أي مسؤولية تتعلق بلخدمت المقدمة من قبل الصالونات، أو جودة الادوات والمستحضرات المستخدمة، آو اختلاف وتغيير آسعار خدمت الصالونات أو عدم إلتزام أي من الصالونات بنظام الحجوزات أوفقدان الممتلكات الشخصية.")
              ],
            ),
          )),
    );
  }
}
