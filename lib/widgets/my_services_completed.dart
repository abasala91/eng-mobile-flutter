import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reserve.dart';
import 'package:eng/models/http_exception.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class myServicesCompleted extends StatefulWidget {
  @override
  State<myServicesCompleted> createState() => _myServicesCompletedState();
}

class _myServicesCompletedState extends State<myServicesCompleted> {
  var _expanded = false;

  @override
  @override
  Future<void> refreshMainScreen() async {
    await Provider.of<Reserve>(context, listen: false).getItems();
    Provider.of<Reserve>(context).getTosServices();
  }

  Widget build(BuildContext context) {
    final reservesItems = Provider.of<Reserve>(context).getTosServices();

    return ListView.builder(
        itemCount: reservesItems.length,
        itemBuilder: (ctx, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                      leading: Container(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            reservesItems[i].imgUrl,
                            fit: BoxFit.cover,
                          )),
                      title: FittedBox(child: Text(reservesItems[i].title)),
                      subtitle: Text('persons: ${reservesItems[i].persons}'),
                      trailing: null),
                  reservesItems[i].reserveStatus == 'accepted' &&
                          reservesItems[i].isBenefit
                      ? Text(
                          'تم الدفع و تأكيد الحجز',
                          style: TextStyle(color: Colors.green),
                          textAlign: TextAlign.right,
                        )
                      : reservesItems[i].reserveStatus == 'accepted' &&
                              !reservesItems[i].isBenefit
                          ? Text(
                              ' برجاء التوجه للنقابة خلال 48 ساعة لاستكمال اجرائات الحجز',
                              style: TextStyle(color: Colors.green),
                              textAlign: TextAlign.right,
                            )
                          : reservesItems[i].reserveStatus == 'rejected'
                              ? Text(
                                  'عفوا لم يحالفكم الحظ هذه المرة!',
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.right,
                                )
                              : reservesItems[i].reserveStatus == 'waiting'
                                  ? Text(
                                      'تم اجراء القرعة و انت على قائمة الانتظار',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 204, 191, 77)),
                                      textAlign: TextAlign.right,
                                    )
                                  : Container(),
                ],
              ),
            ),
          );
        });
  }
}
