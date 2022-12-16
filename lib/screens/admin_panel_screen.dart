import 'package:eng/screens/manage_services_screen.dart';
import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  static const routeName = 'admin-panel';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(ManageServiceScreen.routeName);
                  },
                  child: Text('Add New Service')),
              ElevatedButton(onPressed: () {}, child: Text("Create New User")),
              ElevatedButton(
                  onPressed: () {}, child: Text('Update Current User')),
            ],
          ),
        ),
      ),
    );
  }
}
