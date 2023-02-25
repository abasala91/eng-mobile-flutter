import 'package:flutter/material.dart';
import '../screens/my_services_screen.dart';
import '../screens/contact-us-screen.dart';
import '../screens/about-screen.dart';
import '../screens/user_profile_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello !'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('My Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(UserProfileScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('My Services'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(MyServicesScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(
              Icons.phone,
            ),
            title: const Text(
              'Contact Us',
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ContactUsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(
              Icons.help,
            ),
            title: const Text(
              'About',
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AboutScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text(
              'Log out',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
