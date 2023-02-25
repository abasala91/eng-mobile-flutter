import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import '../providers/services.dart';
import 'package:provider/provider.dart';
import '../providers/reserve.dart';
import '../widgets/my_services_card.dart';
import '../widgets/my_services_completed.dart';

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

  int _selectedIndex = 0;

  List pages = [myServicesCard(), myServicesCompleted()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservesItems = Provider.of<Reserve>(context).items;
    return Scaffold(
      appBar: AppBar(title: Text('My Services')),
      body: reservesItems.isEmpty
          ? Center(
              child: Text(
                'No reservations added yet!',
                style: TextStyle(fontSize: 20),
              ),
            )
          : Container(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.purple[100],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.pending), label: 'pending'),
          BottomNavigationBarItem(
              icon: Icon(Icons.beenhere), label: 'completed')
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
