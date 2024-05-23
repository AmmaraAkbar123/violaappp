import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viola/auth/api_constant.dart';
import 'package:viola/pages/home_page.dart';
import 'package:viola/pages/signup_page.dart';
import 'package:viola/providers/user_provider.dart';

class SignInViewModel extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  bool isOTPRequested = false; // Controls OTP field visibility in UI
  bool? isUserRegistered; // Tracks if user is registered
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  //Start Verify User Registration with Number
  Future<void> verifyPhoneNumber(BuildContext context) async {
    String? token = await _storage.read(key: 'auth_token');
    if (phoneController.text.isEmpty || phoneController.text.length < 9) {
      _showSnackBar(context, 'Please enter a valid phone number.');
      return;
    }

    var response = await http.post(
      Uri.parse(ApiConstants.verifyPhoneNumberUrl),
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
      _showSnackBar(context, responseData['message'], Colors.green);
      sendOTP(context); // Always proceed to send OTP after initial check
    } else {
      _showServerError(context, response.body);
    }
  }
  //End Verify User Registration with Number

  //Start Send OTP
  void sendOTP(BuildContext context) async {
    var response = await http.post(
      Uri.parse(ApiConstants.verifyPhoneNumberUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "phone_number": "+966${phoneController.text.trim()}",
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
  //End Send OTP

  //Start SignIn User after OTP verification
  void verifyOTP(BuildContext context) async {
    var response = await http.post(
      Uri.parse(ApiConstants.verifyOtpUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "phone_number": "+966" + phoneController.text.trim(),
        "otp": otpController.text,
        "login": true // Indicates an attempt to log in the user
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      if (responseData['success']) {
        if (responseData['user'] != null) {
          int userId = responseData['user']['id'];
          String userName = responseData['user']['name'];
          String token = responseData['user']['api_token'];

          // Ensuring userId is valid
          if (userId > 0) {
            // Update UserProvider for a registered user
            Provider.of<UserProvider>(context, listen: false)
                .updateUserAfterOTP(userName, userId, token);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            _showSnackBar(context, 'Invalid user ID received.', Colors.red);
          }
        } else {
          // Handle unregistered user scenario
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        }
      } else {
        // OTP verification failed
        _showSnackBar(
            context,
            responseData['message'] ?? 'Invalid OTP, please try again.',
            Colors.red);
      }
    } else {
      // Handle HTTP errors
      _showServerError(context, response.body);
    }
  }
  //End SignIn User after OTP verification

  //Start Show Message
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
  //End Show Message

  //Start Show Error Message
  void _showServerError(BuildContext context, String message) {
    _showSnackBar(context, 'Server error: $message');
  }
  //End Show Error Message

  // Start Sign Up a new user
  Future<Map<String, dynamic>> signUp(BuildContext context) async {
    if (!_areFieldsValid()) {
      _showSnackBar(context, 'Please ensure all fields are filled correctly.');
      return {'success': false};
    }

    Map<String, dynamic> data = {
      "name": nameController.text.trim(),
      "phone_number": "+966${phoneController.text.trim()}",
      "city": locationController.text.trim(),
      "device_token":
          "" // This might be used for push notifications, adjust as needed
    };

    var response = await http.post(
      Uri.parse(ApiConstants.registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      if (responseData['success'] == true &&
          responseData.containsKey('data') &&
          responseData['data'] != null) {
        String? token = responseData['data']['api_token'];
        if (token != null && token.isNotEmpty) {
          int userId = responseData['data']['id']; // Ensure 'id' exists
          String userName = responseData['data']
              ['name']; // Assuming 'name' is part of responseData

          await _saveToken(token);
          // Save user details just like after OTP verification in sign-in
          await saveUserDetails(context, userName, userId, token);
          return {'success': true, 'token': token, 'userId': userId};
        } else {
          _showSnackBar(context, 'Registration failed: No token provided');
          return {'success': false};
        }
      } else {
        _showSnackBar(
            context,
            responseData['message'] ??
                'Registration failed: Unexpected server response.');
        return {'success': false};
      }
    } else {
      _showServerError(context, response.body);
      return {'success': false};
    }
  }
  // End Sign Up a new user

  // Updated function with context as a parameter
  Future<void> saveUserDetails(
      BuildContext context, String userName, int userId, String token) async {
    // Accessing UserProvider using the provided context
    Provider.of<UserProvider>(context, listen: false)
        .updateUserAfterOTP(userName, userId, token);

    // Navigate to HomeScreen or other appropriate screen
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  // Start Check if the registration data fields are valid
  bool _areFieldsValid() {
    return !(nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        locationController.text.isEmpty ||
        phoneController.text.length < 9);
  }
  // End Check if the registration data fields are valid

  // Start Save token
  Future<void> _saveToken(String token) async {
    try {
      await _storage.write(key: 'auth_token', value: token);
    } catch (e) {
      print("Failed to save token: $e");
    }
  }
  // End Save token

  // Start Reset OTP state and clear controllers
  void resetOTPState() {
    isOTPRequested = false;
    otpController.clear();
    phoneController.clear();
    notifyListeners();
  }
  // End Reset OTP state and clear controllers
}
