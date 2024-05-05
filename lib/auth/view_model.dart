import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:viola/pages/home_page.dart';
import 'package:viola/pages/signup_page.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viola/providers/user_provider.dart'; // Secure storage

class SignInViewModel extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  bool isOTPRequested = false; // Controls OTP field visibility in UI
  bool? isUserRegistered; // Tracks if user is registered
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> verifyPhoneNumber(BuildContext context) async {
    String? token = await _storage.read(key: 'auth_token');
    if (phoneController.text.isEmpty || phoneController.text.length < 9) {
      _showSnackBar(context, 'Please enter a valid phone number.');
      return;
    }

    var response = await http.post(
      Uri.parse('https://dev.viola.myignite.online/api/verify-phone-no'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : '',
      },
      body: jsonEncode({
        "phone_number": "+966" + phoneController.text.trim(),
        "send_otp": false // Initially just checking the registration status
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      isUserRegistered = responseData['success'];
      print("Is user registered: $isUserRegistered");
      _showSnackBar(context, responseData['message'], Colors.blue);
      sendOTP(context); // Always proceed to send OTP after initial check
    } else {
      _showServerError(context, response.body);
    }
  }

  void sendOTP(BuildContext context) async {
    var response = await http.post(
      Uri.parse('https://dev.viola.myignite.online/api/verify-phone-no'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "phone_number": "+966" + phoneController.text.trim(),
        "send_otp": true // Requesting to send OTP
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print("Full response data: $responseData");

      // Adjust based on your actual backend response.
      // Use message content to determine if OTP was sent, regardless of success status
      if (responseData['message'].toLowerCase().contains("otp send") ||
          responseData['message'].toLowerCase().contains("otp is send")) {
        isOTPRequested = true; // Set this to show the OTP input field
        notifyListeners(); // Notify UI to update
        _showSnackBar(
            context,
            'OTP has been sent to your phone. Please verify to continue.',
            Colors.green);
      } else {
        // If message indicates failure or unexpected condition
        _showSnackBar(
            context,
            responseData['message'] ?? 'Failed to send OTP. Please try again.',
            Colors.red);
      }
    } else {
      _showServerError(context, response.body);
    }
  }

  void verifyOTP(BuildContext context) async {
    var response = await http.post(
      Uri.parse('https://dev.viola.myignite.online/api/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "phone_number": "+966" + phoneController.text.trim(),
        "otp": otpController.text,
        "login":
            true // Assumed this flag asks the backend to attempt logging in the user
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      if (responseData['success']) {
        // Check if user details are present which indicates a registered user
        if (responseData['user'] != null) {
          String userName = responseData['user']['name'];
          String token = responseData['user']['api_token'];

          // Update UserProvider for a registered user
          Provider.of<UserProvider>(context, listen: false)
              .updateUserAfterOTP(userName, token: token);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          // No user details means user is unregistered
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        }
      } else {
        // OTP verification itself failed
        _showSnackBar(
            context,
            responseData['message'] ?? 'Invalid OTP, please try again.',
            Colors.red);
      }
    } else {
      _showServerError(context, response.body);
    }
  }

  Future<void> _saveUserDetails(Map<String, dynamic> userDetails) async {
    try {
      await _storage.write(key: 'user_name', value: userDetails['name']);
      // Store other details as needed
    } catch (e) {
      print("Failed to save user details: $e");
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void _showSnackBar(BuildContext context, String message,
      [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8), // Space between the icon and text
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showServerError(BuildContext context, String message) {
    _showSnackBar(context, 'Server error: $message');
  }

  // Navigation based on registration status
  void _navigateBasedOnRegistrationStatus(BuildContext context) {
    // If isUserRegistered is null, default it to false.
    if (isUserRegistered ?? false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUpScreen()));
    }
  }

  // Sign up a new user
  Future<Map<String, dynamic>> signUp(BuildContext context) async {
    if (!_areFieldsValid()) {
      _showSnackBar(context, 'Please ensure all fields are filled correctly.');
      return {'success': false};
    }

    Map<String, dynamic> data = {
      "name": nameController.text.trim(),
      "phone_number": "+966" + phoneController.text.trim(),
      "city": locationController.text.trim(),
      "device_token": "" // Ensure this is supposed to be empty or set a value
    };

    var response = await http.post(
      Uri.parse('https://dev.viola.myignite.online/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    print("Received response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      // Check if the message key exists and handle it
      if (responseData['message'] == "Phone number already exist") {
        _showSnackBar(context,
            'Phone number already exists. Please use a different number.');
        return {'success': false};
      }

      // Check for a valid success response and a token
      if (responseData['success'] == true && responseData['data'] != null) {
        String? token = responseData['data']['api_token'];
        if (token != null && token.isNotEmpty) {
          await _saveToken(token);
          return {'success': true, 'token': token};
        } else {
          _showSnackBar(context, 'Registration failed: No token provided.');
          return {'success': false};
        }
      } else {
        _showSnackBar(
            context, 'Registration failed: Unexpected server response.');
        return {'success': false};
      }
    } else {
      _showServerError(context, response.body);
      return {'success': false};
    }
  }

  // Check if the registration data fields are valid
  bool _areFieldsValid() {
    return !(nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        locationController.text.isEmpty ||
        phoneController.text.length < 9);
  }

  // Handle registration response and manage token
  bool _handleRegistrationResponse(
      BuildContext context, http.Response response) {
    var responseData = jsonDecode(response.body);
    if (responseData['success']) {
      if (responseData.containsKey('token')) {
        _saveToken(responseData['token']);
      }
      return true;
    } else {
      _showSnackBar(context, 'Registration failed: ${responseData['message']}');
      return false;
    }
  }

  // Save token securely
  Future<void> _saveToken(String token) async {
    try {
      await _storage.write(key: 'auth_token', value: token);
    } catch (e) {
      print("Failed to save token: $e");
    }
  }

  // Reset OTP state and clear controllers
  void resetOTPState() {
    isOTPRequested = false;
    otpController.clear();
    notifyListeners();
  }
}
