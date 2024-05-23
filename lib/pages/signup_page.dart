import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/auth/view_model.dart';
import 'package:viola/pages/home_page.dart';
import 'package:viola/pages/login_page.dart';
import 'package:viola/providers/adress_provider.dart';
import 'package:viola/providers/user_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _registerUser() async {
    FocusScope.of(context).unfocus(); // Close the keyboard
    await Future.delayed(const Duration(
        seconds: 2)); // Wait a bit for the keyboard to fully close

    String cityName = await Provider.of<AddressProvider>(context, listen: false)
        .getCurrentCityName();

    if (cityName.startsWith("Failed") || cityName.startsWith("Location")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(cityName),
        backgroundColor: Colors.red.withOpacity(0.7),
      ));
      return;
    }

    final signInViewModel =
        Provider.of<SignInViewModel>(context, listen: false);
    signInViewModel.nameController.text = _nameController.text;
    signInViewModel.locationController.text = cityName;

    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    var result = await Future.delayed(
        const Duration(seconds: 3), () => signInViewModel.signUp(context));

    // Close the loading dialog
    Navigator.of(context).pop();

    if (result['success']) {
      int userId = result['userId']; // Assuming the user ID is returned here
      Provider.of<UserProvider>(context, listen: false)
          .login(_nameController.text, userId, result['token']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Registration failed. Please try again.'),
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(75, 0, 95, 1),
        title: const Text(
          'انشاء حساب جديد',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
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
          Future.delayed(Duration(milliseconds: 100));
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.2,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(75, 0, 95, 1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Viola',
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
                  offset: const Offset(0, -55),
                  child: Center(
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
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
                _buildNameInputCard(),
                //Phone Number Field
                _buildPhoneNumberField(),
                //Location Display Card with City Name using FutureBuilder
                _buildLocationDisplayCard(),
                //Registration Button
                _buildRegistrationButton(),
                //Sign In Text Navigation
                _buildSignInText(),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameInputCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
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
            leading: Icon(Icons.person_outline, color: Colors.grey[700]),
            title: TextField(
              controller: _nameController,
              style: const TextStyle(
                color: Color.fromRGBO(75, 0, 95, 1),
              ),
              decoration: const InputDecoration(
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
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
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
                const Text(
                  'رقم الهاتف',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(75, 0, 95, 1),
                  ),
                ),
                const SizedBox(height: 10),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/flag-icon.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '+966', // Country code
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(75, 0, 95, 1),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Builder(
                          builder: (BuildContext context) {
                            print(viewModel.phoneController
                                .text); // Print phone number for debugging
                            return Text(
                              viewModel.phoneController
                                  .text, // Display the phone number
                              style: const TextStyle(
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
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
            future: Provider.of<AddressProvider>(context, listen: false)
                .getCurrentCityName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return ListTile(
                  leading: Icon(Icons.person_outline, color: Colors.grey[700]),
                  title: const Text(
                    "Fetching city name...",
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(75, 0, 95, 1)),
                  ),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  leading: const Icon(Icons.error_outline, color: Colors.red),
                  title: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                );
              } else {
                return ListTile(
                  leading: Icon(Icons.person_outline, color: Colors.grey[700]),
                  title: Text(
                    snapshot.data ?? "City not available",
                    style: const TextStyle(
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

  Widget _buildRegistrationButton() {
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
                    color: const Color.fromRGBO(75, 0, 95, 1).withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _registerUser,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(75, 0, 95, 1),
                  ),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(vertical: 14)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: const Text(
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
        Provider.of<SignInViewModel>(context, listen: false)
            .resetOTPState(); // Reset the state
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPageScreen()));
      },
      child: const Text(
        'اذا كان لديك حساب، اضغط هنا',
        style: TextStyle(
          color: Color.fromRGBO(75, 0, 95, 1),
        ),
      ),
    );
  }
}
