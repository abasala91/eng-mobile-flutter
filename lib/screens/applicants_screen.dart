import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reserve.dart';

class ApplicantsScreen extends StatefulWidget {
  static const routaName = '/applicants';

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final serviceId = ModalRoute.of(context).settings.arguments as String;
      Provider.of<Reserve>(context).getAllReserves(serviceId);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  AppBar appBar = AppBar(
    title: const Text('المتقدمين للخدمة'),
  );

  @override
  Widget build(BuildContext context) {
    final totals = Provider.of<Reserve>(context).totaApplicants;
    final reserves = Provider.of<Reserve>(context).items;
    return Scaffold(
      appBar: appBar,
      body: Container(
        child: Column(
          children: [
            Center(
              child: Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).viewPadding.bottom -
                        MediaQuery.of(context).viewPadding.top) *
                    0.07,
                child: Text(
                  'اجمالي عدد المتقدمين: $totals',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).viewPadding.bottom -
                      MediaQuery.of(context).viewPadding.top) *
                  0.93,
              child: ListView.builder(
                  itemCount: reserves.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color.fromARGB(255, 241, 193, 243),
                      child: ListTile(
                        leading: Text(''),
                        trailing: Text('${index + 1}'),
                        title: Center(child: Text(reserves[index].name)),
                        subtitle: Center(
                            child:
                                Text('المرافقين :${reserves[index].persons}')),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
