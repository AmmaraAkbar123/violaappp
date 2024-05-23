import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/auth/view_model.dart';
import 'package:viola/pages/login_page.dart';
import 'package:viola/providers/user_provider.dart';
import 'package:viola/widgets/address_selection_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            userHeader(userProvider),
            SizedBox(height: 20),
            _customListTile(
                title: 'سياسة التطبيق',
                icon: Icons.policy_outlined,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LocationsScreen()))),
            _customListTile(
                title: 'نبزة عن التطبيق',
                icon: Icons.info_outline,
                onTap: () => _showNotImplementedMessage()),
            _customListTile(
                title: 'تواصل معنا',
                icon: Icons.contact_phone_outlined,
                onTap: () => _showNotImplementedMessage()),
            if (userProvider.user.isLoggedIn)
              _customListTile(
                title: 'تسجيل الخروج',
                icon: Icons.logout_outlined,
                onTap: () => _handleLogout(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget userHeader(UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.only(right: 25),
      color: Color.fromRGBO(239, 224, 243, 1),
      height: 200,
      child: userProvider.user.isLoggedIn
          ? loggedInUserView(userProvider)
          : guestUserView(),
    );
  }

  Widget loggedInUserView(UserProvider userProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/no-avatar.jpg'),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            userProvider.user.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(75, 0, 95, 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget guestUserView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أهلا بك',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(75, 0, 95, 1)),
        ),
        SizedBox(height: 5),
        Text(
          'تسجيل الدخول أو إنشاء حساب جديد',
          style: TextStyle(fontSize: 16, color: Colors.purple),
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          icon: Icon(Icons.exit_to_app_outlined, color: Colors.white),
          label: Text('الدخول والتسجيل', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Provider.of<SignInViewModel>(context, listen: false)
                .resetOTPState();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginPageScreen()));
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(75, 0, 95, 1)),
        ),
      ],
    );
  }

  void _handleLogout(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.pop(context); // Close the drawer after logging out
  }

  void _showNotImplementedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("This feature is not implemented yet."),
      duration: Duration(seconds: 1),
    ));
  }

  Widget _customListTile(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blueGrey),
            Container(
              height: 20,
              width: 1,
              color: Colors.blueGrey,
              margin: EdgeInsets.symmetric(horizontal: 12),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }
}
