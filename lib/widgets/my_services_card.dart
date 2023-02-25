import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reserve.dart';
import 'package:eng/models/http_exception.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../screens/services_details_screen.dart';

class myServicesCard extends StatefulWidget {
  @override
  State<myServicesCard> createState() => _myServicesCardState();
}

class _myServicesCardState extends State<myServicesCard> {
  var _expanded = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;

      Provider.of<Reserve>(context)
          .getItems()
          .then((value) => _isLoading = false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Future<void> refreshMainScreen() async {
    await Provider.of<Reserve>(context, listen: false).getItems();
  }

  Widget build(BuildContext context) {
    final reservesItems = Provider.of<Reserve>(context).getPendingServices();

    return RefreshIndicator(
      onRefresh: refreshMainScreen,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
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
                          subtitle:
                              Text('persons: ${reservesItems[i].persons}'),
                          trailing: IconButton(
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  // animType: AnimType.rightSlide,
                                  title: 'Warning!',
                                  desc: 'Do you want to delete this reserve?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    try {
                                      await Provider.of<Reserve>(context,
                                              listen: false)
                                          .deleteItem(reservesItems[i].id);
                                    } on HttpException catch (e) {
                                      var errorMessage = '${e}';
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(errorMessage),
                                      ));
                                    } catch (e) {}
                                  },
                                ).show();
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          // Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     IconButton(
                          //         onPressed: () {
                          //           setState(() {
                          //             _expanded = !_expanded;
                          //           });
                          //         },
                          //         icon: Icon(
                          //           _expanded
                          //               ? Icons.expand_less
                          //               : Icons.expand_more,
                          //         )),
                          //   ],
                          // ),
                        ),
                        reservesItems[i].reserveStatus == 'accepted' &&
                                reservesItems[i].isBenefit
                            ? Text(
                                'تم الدفع و تأكيد الحجز',
                                style: TextStyle(color: Colors.green),
                                textAlign: TextAlign.right,
                              )
                            : reservesItems[i].reserveStatus == 'accepted' &&
                                    reservesItems[i].isBenefit == false
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
                                    : reservesItems[i].reserveStatus ==
                                            'waiting'
                                        ? Text(
                                            'تم اجراء القرعة و انت على قائمة الانتظار',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 191, 77)),
                                            textAlign: TextAlign.right,
                                          )
                                        : Container(),
                        // if (_expanded)
                        //   Container(
                        //       height: 50,
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           IconButton(
                        //               onPressed: () {
                        //                 AwesomeDialog(
                        //                   context: context,
                        //                   dialogType: DialogType.warning,
                        //                   // animType: AnimType.rightSlide,
                        //                   title: 'Warning!',
                        //                   desc:
                        //                       'Do you want to delete this reserve?',
                        //                   btnCancelOnPress: () {},
                        //                   btnOkOnPress: () async {
                        //                     try {
                        //                       await Provider.of<Reserve>(
                        //                               context,
                        //                               listen: false)
                        //                           .deleteItem(
                        //                               reservesItems[i].id);
                        //                     } on HttpException catch (e) {
                        //                       var errorMessage = '${e}';
                        //                       ScaffoldMessenger.of(context)
                        //                           .showSnackBar(SnackBar(
                        //                         content: Text(errorMessage),
                        //                       ));
                        //                     } catch (e) {}
                        //                   },
                        //                 ).show();
                        //               },
                        //               icon: Icon(
                        //                 Icons.delete,
                        //                 color: Colors.red,
                        //               )),
                        //         ],
                        //       ))
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
