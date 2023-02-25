import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/complaints_widget.dart';

class ContactUsScreen extends StatelessWidget {
  static const routeName = '/contact';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Us")),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          reverse: true,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('For inquiries and communication',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30.0),
                  TextButton(
                    onPressed: () async {
                      String telephoneNumber = '01033737325';
                      String telephoneUrl = "tel:$telephoneNumber";
                      await launch(telephoneUrl);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.phone,
                            color: Color.fromARGB(218, 2, 160, 10)),
                        SizedBox(width: 20.0),
                        Text('01033737325',
                            style: TextStyle(
                                color: Color(0xFFA294C2),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var whatsappUrl = "whatsapp://send?phone=201033737345";
                      await launch(whatsappUrl);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.whatsapp_outlined,
                            color: Color.fromARGB(255, 95, 252, 123)),
                        SizedBox(width: 20.0),
                        Text('01033737345',
                            style: TextStyle(
                                color: Color(0xFFA294C2),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      String email = 'domiatsyn@gmail.com';
                      String subject = '';
                      String body = '';

                      String emailUrl =
                          "mailto:$email?subject=$subject&body=$body";
                      await launch(emailUrl);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.mail_outline,
                            color: Color.fromARGB(255, 232, 41, 38)),
                        SizedBox(width: 20.0),
                        Text('domiatsyn@gmail.com',
                            style: TextStyle(
                                color: Color(0xFFA294C2),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      const url =
                          'fb://syndicate.engineers.damietta/397657474294285';
                      final result = await launch(url);
                      if (!result) {
                        await launch(
                            'https://www.facebook.com/syndicate.engineers.damietta');
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.facebook_outlined,
                            color: Color.fromARGB(255, 23, 169, 253)),
                        SizedBox(width: 20.0),
                        FittedBox(
                          child: Text('syndicate.engineers.damietta',
                              style: TextStyle(
                                  color: Color(0xFFA294C2),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ComplaintsWidget()
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
