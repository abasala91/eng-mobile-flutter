import 'package:eng/models/http_exception.dart';
import 'package:eng/screens/my_services_screen.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/services.dart';
import '../providers/reserve.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../screens/applicants_screen.dart';
import 'package:intl/intl.dart';

class ServicesDetailsScreen extends StatefulWidget {
  static const routeName = 'service-details';
  @override
  State<ServicesDetailsScreen> createState() => _ServicesDetailsScreenState();
}

class _ServicesDetailsScreenState extends State<ServicesDetailsScreen> {
  var _isLoading = false;
  int _currentValue = 0;
  int _currentAdults = 0;
  int _currentTeens = 0;
  int _currentChairs = 0;
  int _total = 0;
  int get _totalPersons {
    _total = _currentAdults + _currentTeens + _currentChairs + _currentValue;
    return _total;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final reserveData = Provider.of<Reserve>(context, listen: false);
    final serviceId = ModalRoute.of(context).settings.arguments as String;
    final loadedService = Provider.of<Services>(
      context,
      listen: false,
    ).findById(serviceId);

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Text(
                    loadedService.title,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(thickness: 2),
              loadedService.serviceType == 'socialDay'
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 5,
                        color: Colors.amber,
                        child: SizedBox(
                          width: 220,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                    ' رمضان ${loadedService.socialDays[0]['ramadan']}'),
                                Text(loadedService.socialDays[0]['greg']),
                                FittedBox(
                                  child: Text(
                                      ' الأماكن المتبقية لهذا اليوم ${loadedService.attendance - loadedService.applicants < 0 ? 0 : loadedService.attendance - loadedService.applicants}'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    child: Image.network(
                      loadedService.imgUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Chip(
                  label: SizedBox(
                width: 200,
                child: Center(
                  child: FittedBox(
                    child: Text(
                        ' ${DateFormat.yMMMMd().format(loadedService.timeStamp).toString()}تاريخ الاعلان '),
                  ),
                ),
              )),
              loadedService.isReserve == true
                  ? Chip(
                      label: SizedBox(
                      width: 200,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                              '  ${DateFormat.yMMMMd().format(loadedService.validDays).toString()}ينتهي في '),
                        ),
                      ),
                    ))
                  : Container(),
              const SizedBox(
                height: 5,
              ),
              Container(
                child: Text(
                  loadedService.description,
                  textAlign: TextAlign.right,
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              loadedService.isReserve
                  ? loadedService.validDays.compareTo(
                              DateTime(now.year, now.month, now.day)) >=
                          0
                      ? Center(
                          child: Container(),
                        )
                      : Text(
                          'انتهى هذا الاعلان في ${loadedService.validDays.toString().substring(0, 10)}')
                  : Container(),
              loadedService.isReserve
                  ? loadedService.validDays.compareTo(
                              DateTime(now.year, now.month, now.day)) >=
                          0
                      ? _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SizedBox(
                                            height: 300,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  loadedService.serviceType ==
                                                          "longTrip"
                                                      ? Column(
                                                          children: [
                                                            const Text(
                                                                ":برجاء اختيار عدد المرافقين"),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 70,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        const Text(
                                                                            'بالغين'),
                                                                        NumberPicker(
                                                                          value:
                                                                              _currentAdults,
                                                                          minValue:
                                                                              0,
                                                                          maxValue:
                                                                              loadedService.maxPersons,
                                                                          onChanged: (value) =>
                                                                              setState(() => _currentAdults = value),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            border:
                                                                                Border.all(color: Colors.black26),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 70,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        const Text(
                                                                            '6-12 سنة'),
                                                                        NumberPicker(
                                                                          value:
                                                                              _currentTeens,
                                                                          minValue:
                                                                              0,
                                                                          maxValue:
                                                                              loadedService.maxPersons,
                                                                          onChanged: (value) =>
                                                                              setState(() => _currentTeens = value),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            border:
                                                                                Border.all(color: Colors.black26),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 70,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        const Text(
                                                                          'مقاعد اضافية في الباص؟',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                        NumberPicker(
                                                                          value:
                                                                              _currentChairs,
                                                                          minValue:
                                                                              0,
                                                                          maxValue:
                                                                              loadedService.maxPersons,
                                                                          onChanged: (value) =>
                                                                              setState(() => _currentChairs = value),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            border:
                                                                                Border.all(color: Colors.black26),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ],
                                                        )
                                                      : loadedService
                                                                  .maxPersons >
                                                              0
                                                          ? Column(
                                                              children: [
                                                                const Text(
                                                                    ":برجاء اختيار عدد المرافقين"),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                NumberPicker(
                                                                  value:
                                                                      _currentValue,
                                                                  minValue: 0,
                                                                  maxValue:
                                                                      loadedService
                                                                          .maxPersons,
                                                                  haptics: true,
                                                                  onChanged: (value) =>
                                                                      setState(() =>
                                                                          _currentValue =
                                                                              value),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black26),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),
                                                  if (_isLoading)
                                                    CircularProgressIndicator()
                                                  else
                                                    ElevatedButton(
                                                        child: const Text(
                                                            '!سجل الان'),
                                                        onPressed: () async {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });

                                                          try {
                                                            await reserveData
                                                                .addItem(
                                                                    serviceId,
                                                                    _currentValue
                                                                        .toString(),
                                                                    _currentAdults
                                                                        .toString(),
                                                                    _currentTeens
                                                                        .toString(),
                                                                    _currentChairs
                                                                        .toString())
                                                                .then((value) {
                                                              AwesomeDialog(
                                                                context:
                                                                    context,
                                                                dialogType:
                                                                    DialogType
                                                                        .success,
                                                                animType: AnimType
                                                                    .rightSlide,
                                                                title: 'Done!',
                                                                desc: value,
                                                                btnOkOnPress:
                                                                    () {},
                                                              ).show();
                                                            });
                                                          } on HttpException catch (e) {
                                                            var errorMessage =
                                                                '${e}';

                                                            AwesomeDialog(
                                                              context: context,
                                                              dialogType:
                                                                  DialogType
                                                                      .info,
                                                              animType: AnimType
                                                                  .rightSlide,
                                                              title: 'Alert!',
                                                              desc:
                                                                  errorMessage,
                                                              btnOkOnPress:
                                                                  () {},
                                                            ).show();
                                                          } catch (e) {
                                                            var errorMessage =
                                                                '${e}';
                                                            print(errorMessage);
                                                            AwesomeDialog(
                                                              context: context,
                                                              dialogType:
                                                                  DialogType
                                                                      .info,
                                                              animType: AnimType
                                                                  .rightSlide,
                                                              title: 'Alert!',
                                                              desc:
                                                                  errorMessage,
                                                              btnOkOnPress:
                                                                  () {},
                                                            ).show();
                                                          }
                                                          setState(() {
                                                            _isLoading = false;
                                                          });
                                                        }),
                                                  loadedService.maxPersons > 0
                                                      ? Text(
                                                          'اجمالي عدد المرافقين: $_totalPersons')
                                                      : Container()
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Text("التسجيل في هذه الخدمة"))
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
