import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:viola/pages/home_page.dart';
import 'package:viola/pages/signup_page.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Secure storage

class SignInViewModel extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  bool isOTPRequested = false;
  bool? isUserRegistered;
  String _hardcodedOTP = "1234";
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Verify phone number and handle response
  Future<void> verifyPhoneNumber(BuildContext context) async {
    String? token = await _storage.read(key: 'auth_token');  // Load token securely

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
        'phone_number': '+966' + phoneController.text.trim(),
        'send_otp': true  // Assuming we want to send OTP
      }),
    );

    if (response.statusCode == 200) {
      _handlePhoneVerificationResponse(context, response);
    } else {
      _showServerError(context, response.body);
    }
  }

  // Handle the phone verification response
  void _handlePhoneVerificationResponse(BuildContext context, http.Response response) {
    try {
        var responseData = jsonDecode(response.body);
        // Safely get isRegistered status, defaulting to false if not present or null
        isUserRegistered = responseData['isRegistered'] as bool? ?? false;
        // Send OTP only if user is not registered
        if (isUserRegistered != true) {
            sendOTP(context);
        }
    } catch (e) {
        _showSnackBar(context, 'Error processing data: $e');
    }
}

  // Send OTP notification
  void sendOTP(BuildContext context) {
    isOTPRequested = true;
    notifyListeners();
    _showSnackBar(context, 'OTP has been sent. Please verify to continue.', Colors.green.withOpacity(0.7));
  }

  // Verify the OTP and navigate accordingly
  void verifyOTP(BuildContext context) {
    if (otpController.text == _hardcodedOTP) {
      _navigateBasedOnRegistrationStatus(context);
    } else {
      _showSnackBar(context, 'Invalid OTP entered');
    }
    otpController.clear();
  }

  // Navigation based on registration status
  void _navigateBasedOnRegistrationStatus(BuildContext context) {
    // If isUserRegistered is null, default it to false.
    if (isUserRegistered ?? false) {
        Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => HomePage())
        );
    } else {
        Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => SignUpScreen())
        );
    }
    otpController.clear();
    
}

  // Sign up a new user
  Future<Map<String, dynamic>> signUp(BuildContext context) async {
  if (!_areFieldsValid()) {
    _showSnackBar(context, 'Please ensure all fields are filled correctly.');
    return {'success': false};
  }

  Map<String, dynamic> data = {
    'name': nameController.text.trim(),
    'phone_number': '+966' + phoneController.text.trim(),
    'city': locationController.text.trim(),
    'device_token': '',  // Add device token if applicable
  };

  var response = await http.post(
    Uri.parse('https://dev.viola.myignite.online/api/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    if (responseData['success']) {
      String token = responseData['token'] ?? '';
      await _saveToken(token);  // Save the token
      return {'success': true, 'token': token};
    } else {
      _showSnackBar(context, 'Registration failed: ${responseData['message']}');
      return {'success': false};
    }
  } else {
    _showServerError(context, response.body);
    return {'success': false};
  }
}

  // Check if the registration data fields are valid
  bool _areFieldsValid() {
    return !(nameController.text.isEmpty || phoneController.text.isEmpty || locationController.text.isEmpty || phoneController.text.length < 9);
  }

  // Handle registration response and manage token
  bool _handleRegistrationResponse(BuildContext context, http.Response response) {
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
    await _storage.write(key: 'auth_token', value: token);
  }

  // Display snack bar for messages
  void _showSnackBar(BuildContext context, String message, [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  // Display server error messages
  void _showServerError(BuildContext context, String message) {
    _showSnackBar(context, 'Server error: $message');
  }

  // Reset OTP state and clear controllers
  void resetOTPState() {
    isOTPRequested = false;
    otpController.clear();
    notifyListeners();
  }
}