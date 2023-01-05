import '../screens/complaints_screen.dart';
import 'package:flutter/material.dart';
import '../screens/my_services_screen.dart';
import '../screens/about_screen.dart';
import '../screens/user_profile_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<Auth>(context).userData;
    // final userNameIndex = userData.name.indexOf(' ');
    // final userName = userData.name.substring(0, userNameIndex);

    // bool isAdmin = Provider.of<Auth>(context, listen: false).isAdmin;
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
              Icons.rate_review,
            ),
            title: const Text(
              'Complaints and suggestions',
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ComplaintsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(
              Icons.help,
            ),
            title: const Text(
              'Help',
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AboutScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
