import 'package:eng/models/http_exception.dart';
import 'package:eng/screens/my_services_screen.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/services.dart';
import '../providers/reserve.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../screens/applicants_screen.dart';

class ServicesDetailsScreen extends StatefulWidget {
  static const routeName = 'service-details';

  @override
  State<ServicesDetailsScreen> createState() => _ServicesDetailsScreenState();
}

class _ServicesDetailsScreenState extends State<ServicesDetailsScreen> {
  var _isLoading = false;
  String dropdownvalue = '0';
  // List of items in our dropdown menu
  var items = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  void _showDialoge(String message, String boxTitle) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(boxTitle),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  @override
  int _currentValue = 0;
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    final reserveData = Provider.of<Reserve>(context, listen: false);
    final serviceId = ModalRoute.of(context).settings.arguments as String;
    final loadedService = Provider.of<Services>(
      context,
      listen: false,
    ).findById(serviceId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedService.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    // height: 500,
                    width: MediaQuery.of(context).size.width * 0.99,
                    child: Image.network(
                      loadedService.imgUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                child: Text(
                  loadedService.description,
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              loadedService.isReserve
                  ? loadedService.validDays.compareTo(
                              new DateTime(now.year, now.month, now.day)) >=
                          0
                      ? Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              loadedService.maxPersons > 0
                                  ? Column(
                                      children: <Widget>[
                                        NumberPicker(
                                          value: _currentValue,
                                          minValue: 0,
                                          maxValue: loadedService.maxPersons,
                                          onChanged: (value) => setState(
                                              () => _currentValue = value),
                                        ),
                                        Text('العدد: $_currentValue'),
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(
                                width: 20,
                              ),
                              loadedService.maxPersons > 0
                                  ? const Text("برجاء اختيار عدد المرافقين")
                                  : Container()
                            ],
                          ),
                        )
                      : Text(
                          'انتهى هذا الاعلان في ${loadedService.validDays.toString().substring(0, 10)}')
                  : Container(),
              loadedService.isReserve
                  ? loadedService.validDays.compareTo(
                              new DateTime(now.year, now.month, now.day)) >=
                          0
                      ? _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  await reserveData
                                      .addItem(
                                          serviceId, _currentValue.toString())
                                      .then((value) => AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.success,
                                            animType: AnimType.rightSlide,
                                            title: 'Done!',
                                            desc:
                                                'تم التسجيل بنجاح و سيتم اعلامكم بنتيجة القرعة بعد انتهاء مهلة الاعلان',
                                            btnOkOnPress: () {},
                                          ).show());
                                } on HttpException catch (e) {
                                  var errorMessage = '${e}';
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    animType: AnimType.rightSlide,
                                    title: 'Alert!',
                                    desc: errorMessage,
                                    btnOkOnPress: () {},
                                  ).show();
                                } catch (e) {
                                  print(e);
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                              child: Text("!سجل الان"))
                      : Container(
                          // child: TextButton(
                          //     onPressed: () {
                          //       Navigator.of(context).pushNamed(
                          //           ApplicantsScreen.routaName,
                          //           arguments: serviceId);
                          //     },
                          //     child: Text('اظهار اسماء المتقدمين')),
                          )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
