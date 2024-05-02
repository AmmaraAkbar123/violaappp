import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/auth/view_model.dart';
import 'package:viola/pages/home_page.dart';
import 'package:viola/pages/login_page.dart';
import 'package:viola/providers/adress_provider.dart';
import 'package:viola/providers/user_provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  void _registerUser() async {
  String cityName = await Provider.of<AddressProvider>(context, listen: false).getCurrentCityName();

  if (cityName.startsWith("Failed") || cityName.startsWith("Location")) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(cityName),
      backgroundColor: Colors.red.withOpacity(0.7),
    ));
    return;
  }

  final signInViewModel = Provider.of<SignInViewModel>(context, listen: false);
  signInViewModel.nameController.text = _nameController.text;
  signInViewModel.locationController.text = _locationController.text;

  var result = await signInViewModel.signUp(context);

  if (result['success']) {
    Provider.of<UserProvider>(context, listen: false).login(_nameController.text, result['token']);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Registration failed. Please try again.'),
      backgroundColor: Colors.red.withOpacity(0.7),
    ));
  }
}

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignInViewModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(75, 0, 95, 1),
        title: Text(
          'انشاء حساب جديد',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(75, 0, 95, 1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Voila',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -60),
                  child: Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/icon.png'),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                //Name Input Card
                _buildNameInputCard(viewModel),
                //Phone Number Field
                _buildPhoneNumberField(),
                //Location Display Card with City Name using FutureBuilder
                _buildLocationDisplayCard(),
                //Registration Button
                _buildRegistrationButton(viewModel),
                //Sign In Text Navigation
                _buildSignInText(),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameInputCard(SignInViewModel viewModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'الاسم',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(75, 0, 95, 1),
                ),
              ),
              Text(
                ' *',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          ListTile(
            leading:
                Icon(Icons.person_outline, color: Color.fromRGBO(75, 0, 95, 1)),
            title: TextField(
              controller: viewModel.nameController,
              decoration: InputDecoration(
                hintText: 'الاسم',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    final viewModel = Provider.of<SignInViewModel>(context, listen: false);

    return Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رقم الهاتف',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(75, 0, 95, 1),
                  ),
                ),
                SizedBox(height: 10),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/flag-icon.png',
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '+966',       // Country code
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(75, 0, 95, 1),
                          ),
                        ),
                        SizedBox(width: 10),
                        Builder(
                          builder: (BuildContext context) {
                            print(viewModel.phoneController
                                .text); // Print phone number for debugging
                            return Text(
                              viewModel.phoneController
                                  .text, // Display the phone number
                              style: TextStyle(
                                color: Color.fromRGBO(75, 0, 95, 1),
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDisplayCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'المدينة',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(75, 0, 95, 1),
                ),
              ),
              Text(
                ' *',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: Provider.of<AddressProvider>(context, listen: true)
                .getCurrentCityName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  leading: Icon(Icons.person_outline,
                      color: Color.fromRGBO(75, 0, 95, 1)),
                  title: Text(
                    "Fetching city name...",
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(75, 0, 95, 1)),
                  ),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  leading: Icon(Icons.error_outline, color: Colors.red),
                  title: Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                );
              } else {
                return ListTile(
                  leading: Icon(Icons.location_city,
                      color: Color.fromRGBO(75, 0, 95, 1)),
                  title: Text(
                    snapshot.data ?? "City not available",
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(75, 0, 95, 1)),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationButton(SignInViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(75, 0, 95, 1).withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _registerUser,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(75, 0, 95, 1),
                  ),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 14)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: Text(
                  'سجل',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInText() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginPageScreen()));
      },
      child: Text(
        'اذا كان لديك حساب، اضغط هنا',
        style: TextStyle(
          color: Color.fromRGBO(75, 0, 95, 1),
        ),
      ),
    );
  }
}
