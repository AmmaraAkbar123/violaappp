import 'package:flutter/material.dart';
import 'package:violaapp/utils/colors.dart';
import 'package:violaapp/utils/padding_margin.dart';

class LoginPage_Screen extends StatefulWidget {
  const LoginPage_Screen({Key? key});

  @override
  State<LoginPage_Screen> createState() => _LoginPage_ScreenState();
}

class _LoginPage_ScreenState extends State<LoginPage_Screen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(252, 249, 249, 249),
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios).marginOnly(right: 15),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: myTheme.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Viola',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color:Color.fromARGB(252, 249, 249, 249),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.13,
                      ),
                      Container(
                        height: screenHeight * 0.16,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          children: [
                            Text("hfuygasbc"),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Image.network(
                                        "https://c8.alamy.com/comp/2MEMD4E/letter-u-and-v-shape-logo-graphic-illustration-design-with-3d-purple-color-perfect-for-clothing-icons-company-logos-shops-and-more-2MEMD4E.jpg",
                                        fit: BoxFit.cover,
                                        height: screenHeight * 0.03,
                                        width: screenHeight * 0.05,
                                      ),
                                      SizedBox(width: 8),
                                      Text("+966"),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: "5xxxxxxxx",
                                            hintStyle: TextStyle(
                                              color: Colors.grey
                                            ),
                                            
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.10,
                      ),
                      Container(
                        height: screenHeight * 0.08,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                            color: myTheme.primaryColor,
                            borderRadius: BorderRadius.circular(18)),
                        child: Center(
                            child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: screenWidth * 0.5 - screenWidth * 0.15,
            top: screenHeight * 0.15,
            child: Container(
              height: screenWidth * 0.3,
              width: screenWidth * 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "https://c8.alamy.com/comp/2MEMD4E/letter-u-and-v-shape-logo-graphic-illustration-design-with-3d-purple-color-perfect-for-clothing-icons-company-logos-shops-and-more-2MEMD4E.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
