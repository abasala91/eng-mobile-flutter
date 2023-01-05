import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/services.dart';
import '../widgets/overview_grid.dart';

class OverViewScreen extends StatefulWidget {
  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
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

  Future<void> refreshMainScreen() async {
    await Provider.of<Services>(context, listen: false).fetchAndGet();
  }

  @override
  Widget build(BuildContext context) {
    var servicesData = Provider.of<Services>(context).items.reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
        actions: [
          ElevatedButton(
            onPressed: refreshMainScreen,
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshMainScreen,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : servicesData.isEmpty
                ? Center(
                    child: Container(
                      child: Column(
                        children: [
                          Image.asset('assets/images/sad.png'),
                          Text(
                            'No Services At This Time!',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, i) {
                      return ChangeNotifierProvider.value(
                        value: servicesData[i],
                        child: OverviewGrid(refreshMainScreen),
                      );
                    },
                    itemCount: servicesData.length,
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
