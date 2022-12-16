import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import '../providers/services.dart';
import 'package:provider/provider.dart';
import '../providers/reserve.dart';
import '../widgets/my_services_card.dart';

class MyServicesScreen extends StatefulWidget {
  static const routeName = '/favourities';

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Reserve>(context).getItems();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final reservesItems = Provider.of<Reserve>(context).items;
    return Scaffold(
      appBar: AppBar(title: Text('My Services')),
      body: reservesItems.isEmpty
          ? Center(
              child: Text(
                'No reserves added yet!',
                style: TextStyle(fontSize: 20),
              ),
            )
          : Container(child: myServicesCard()),
      drawer: AppDrawer(),
    );
  }
}
