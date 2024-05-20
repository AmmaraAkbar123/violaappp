import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:viola/auth/view_model.dart';

class LoginPageScreen extends StatelessWidget {
  const LoginPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignInViewModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(75, 0, 95, 1),
        title: const Text(
          "Welcome",
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
                  offset: const Offset(0, -60),
                  child: Center(
                    child: Container(
                      height: 120,
                      width: 120,
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
                //otp screen
                viewModel.isOTPRequested
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'OTP',
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    viewModel.otpController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: '- - - -',
                                                  border: InputBorder.none,
                                                  counterText: "",
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLength:
                                                    4, // Set OTP maxLength to 4
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                              ),
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
                        ),
                      )
                    :
                    //Phone Number Field
                    Container(
                        margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 234, 234, 234),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/flag-icon.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            '+966',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromRGBO(75, 0, 95, 1),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller:
                                                  viewModel.phoneController,
                                              keyboardType: TextInputType.phone,
                                              decoration: const InputDecoration(
                                                  hintText: '5xxxxxxx',
                                                  border: InputBorder.none,
                                                  counterText: ""),
                                              textAlign: TextAlign.left,
                                              maxLength: 9,
                                            ),
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
                      ),
                const SizedBox(
                  height: 40,
                ),
                //Registration Button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(75, 0, 95, 1)
                              .withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Check if OTP has been requested and needs to be verified
                        if (viewModel.isOTPRequested) {
                          // Verify OTP
                          viewModel.verifyOTP(context);
                        } else {
                          // Otherwise, verify the phone number which should lead to OTP being sent
                          viewModel.verifyPhoneNumber(context);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(75, 0, 95, 1)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(vertical: 14)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      child: Text(
                        viewModel.isOTPRequested ? 'تحقق من الرمز' : 'الدخول',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(double screenHeight) {
    return Container(
      height: screenHeight * 0.2,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(75, 0, 95, 1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: const Center(
        child: Text(
          'Viola',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
