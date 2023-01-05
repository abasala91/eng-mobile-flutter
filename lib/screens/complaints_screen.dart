import 'package:eng/models/http_exception.dart';
import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ComplaintsScreen extends StatelessWidget {
  static const routeName = '/complaints';

  final _complaintController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaints and suggestions")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                maxLines: 10,
                controller: _complaintController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'leave your message here...(20-255 character)',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_complaintController.text.length < 20) {
                    return AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      // animType: AnimType.rightSlide,
                      title: 'Warning!',
                      desc: 'your message is too short',
                      // btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  } else if (_complaintController.text.length > 255) {
                    return AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      // animType: AnimType.rightSlide,
                      title: 'Warning!',
                      desc: 'your message is too long',
                      // btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  }
                  Provider.of<Auth>(context, listen: false)
                      .postComplaint(_complaintController.text)
                      .then((value) => AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            // animType: AnimType.rightSlide,
                            title: 'Done!',
                            desc: 'your message successfully sent',
                            // btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              _complaintController.text = '';
                            },
                          ).show())
                      .catchError((error) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      // animType: AnimType.rightSlide,
                      title: 'Error!',
                      desc: 'something failed',
                      // btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  });
                },
                child: Text('send'))
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
