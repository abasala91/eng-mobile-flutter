import 'package:eng/models/http_exception.dart';
import 'package:eng/screens/my_services_screen.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/services.dart';
import '../providers/reserve.dart';
import '../screens/applicants_screen.dart';

class ServicesDetailsScreen extends StatefulWidget {
  static const routeName = 'service-details';

  @override
  State<ServicesDetailsScreen> createState() => _ServicesDetailsScreenState();
}

class _ServicesDetailsScreenState extends State<ServicesDetailsScreen> {
  var _isInit = true;
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
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Services>(context).fetchAndGet();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  int _currentValue = 0;
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    final serviceId = ModalRoute.of(context).settings.arguments as String;
    final loadedService = Provider.of<Services>(
      context,
      listen: false,
    ).findById(serviceId);
    if (loadedService == null) {
      _showDialoge('something failed', 'Error');
    }
    final reserveData = Provider.of<Reserve>(context, listen: false);
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
                    height: 500,
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
                child: Text(loadedService.description),
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
                              // DropdownButton(
                              //   // Initial Value
                              //   value: dropdownvalue,

                              //   // Down Arrow Icon
                              //   icon: const Icon(Icons.keyboard_arrow_down),

                              //   // Array list of items
                              //   items: items.map((String items) {
                              //     return DropdownMenuItem(
                              //       value: items,
                              //       child: Text(items),
                              //     );
                              //   }).toList(),
                              //   // After selecting the desired option,it will
                              //   // change button value to selected value
                              //   onChanged: (String newValue) {
                              //     setState(() {
                              //       dropdownvalue = newValue;
                              //     });
                              //   },
                              // ),
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
                      ? ElevatedButton(
                          onPressed: () async {
                            try {
                              await reserveData
                                  .addItem(serviceId, _currentValue.toString())
                                  .then((value) => _showDialoge(
                                      'تم التسجيل بنجاح و سيتم اعلامكم بنتيجة القرعة بعد انتهاء مهلة الاعلان',
                                      'Success'));
                              // Navigator.of(context).pushReplacementNamed('/');
                              // ScaffoldMessenger.of(context)
                              //     .showSnackBar(const SnackBar(
                              //   content: Text('Good! Successfully registred!'),
                              // ));
                              // Navigator.of(context).pushReplacementNamed('/');
                            } on HttpException catch (e) {
                              var errorMessage = '${e}';
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(errorMessage),
                                      action: SnackBarAction(
                                          label: 'go to my services',
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                MyServicesScreen.routeName);
                                          })));
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text("!سجل الان"))
                      : Container(
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    ApplicantsScreen.routaName,
                                    arguments: serviceId);
                              },
                              child: Text('اظهار اسماء المتقدمين')),
                        )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
