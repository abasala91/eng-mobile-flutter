import 'package:flutter/material.dart';
import '../widgets/manage_services_grid.dart';
import 'package:provider/provider.dart';
import '../providers/services.dart';
import '../screens/add_service_screen.dart';
import '../widgets/app_drawer.dart';

class ManageServiceScreen extends StatefulWidget {
  static const routeName = '/manage-service';
  @override
  State<ManageServiceScreen> createState() => _ManageServiceScreenState();
}

class _ManageServiceScreenState extends State<ManageServiceScreen> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;

      Provider.of<Services>(context)
          .fetchAndGet()
          .then((value) => _isLoading = false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshMainScreen() async {
    await Provider.of<Services>(context, listen: false).fetchAndGet();
  }

  @override
  Widget build(BuildContext context) {
    final servicesData = Provider.of<Services>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Services'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddServiceScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMainScreen,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : servicesData.isEmpty
                ? Container()
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, i) {
                      return ChangeNotifierProvider.value(
                        value: servicesData[i],
                        child: ManageServicesGrid(),
                      );
                    },
                    itemCount: servicesData.length,
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
