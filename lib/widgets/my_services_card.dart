import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reserve.dart';

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
    final reservesItems = Provider.of<Reserve>(context).items;

    return RefreshIndicator(
      onRefresh: refreshMainScreen,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: reservesItems.length,
              itemBuilder: (ctx, i) {
                return Card(
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
                        title: Text(reservesItems[i].title),
                        subtitle: Text('persons: ${reservesItems[i].persons}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            reservesItems[i].reserveStatus == 'accepted'
                                ? Text(
                                    '${reservesItems[i].reserveStatus}',
                                    style: TextStyle(
                                        backgroundColor: Colors.green),
                                  )
                                : reservesItems[i].reserveStatus == 'waiting'
                                    ? Text('${reservesItems[i].reserveStatus}',
                                        style: TextStyle(
                                            backgroundColor: Colors.yellow))
                                    : reservesItems[i].reserveStatus ==
                                            'rejected'
                                        ? Text(
                                            '${reservesItems[i].reserveStatus}',
                                            style: TextStyle(
                                                backgroundColor: Color.fromARGB(
                                                    255, 247, 77, 3)))
                                        : Text(
                                            '${reservesItems[i].reserveStatus}'),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    _expanded = !_expanded;
                                  });
                                },
                                icon: Icon(
                                  _expanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                )),
                          ],
                        ),
                      ),
                      reservesItems[i].reserveStatus == 'accepted'
                          ? Text(
                              'برجاء التوجه للنقابة في موعد اقصاه 48 ساعة لاستكمال اجرائات الحجز')
                          : Container(),
                      if (_expanded)
                        Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: Text('Alert'),
                                              content:
                                                  Text('Delete this reserve?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        Provider.of<Reserve>(
                                                                context,
                                                                listen: false)
                                                            .deleteItem(
                                                                reservesItems[i]
                                                                    .id);
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: Text('Yes')),
                                                TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: Text('No')),
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ],
                            ))
                    ],
                  ),
                );
              }),
    );
  }
}
