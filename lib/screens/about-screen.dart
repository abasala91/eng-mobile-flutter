import 'package:eng/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import '../widgets/my_flutter_app_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "مشروع التحول الرقمي لنقابة المهندسين بدمياط",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Text(
                  "هذا العمل اهداء لبيتنا الثاني ( نقابة مهندسين دمياط) من اجل التيسير على السادة المهندسين في التسجيل و الاشتراك في الخدمات التي تقدمها النقابة و لضمان التوزيع العادل للخدمات",
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Column(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/images/badawy.png"),
                        backgroundColor: Colors.black.withOpacity(0.1),
                      ),
                      Text(
                        "احمد محمد عبد السلام بدوي",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("المشرف على المشروع"),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () async {
                              await launch(
                                  'https://www.linkedin.com/in/eng-ahmedbadawy/');
                            },
                            child: Icon(
                              MyFlutterApp.linkedin_circled,
                              color: Color.fromRGBO(10, 102, 194, 100),
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/images/ouf.png"),
                        backgroundColor: Colors.black.withOpacity(0.1),
                      ),
                      Text(
                        "احمد ابراهيم عوف بصله",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("التصميم و البرمجة"),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () async {
                              await launch(
                                  'https://www.linkedin.com/in/ahmed-ebrahim-49439b14b/');
                            },
                            child: Icon(
                              MyFlutterApp.linkedin_circled,
                              color: Color.fromRGBO(10, 102, 194, 100),
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/images/ayoti.png"),
                        backgroundColor: Colors.black.withOpacity(0.1),
                      ),
                      Text(
                        "محمود محمد صادق العيوطي",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("النشر و الحماية"),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () async {
                              await launch(
                                  'https://www.linkedin.com/in/mahmoud-elayouty/');
                            },
                            child: Icon(
                              MyFlutterApp.linkedin_circled,
                              color: Color.fromRGBO(10, 102, 194, 100),
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage("assets/images/yasmeen.png"),
                        backgroundColor: Colors.black.withOpacity(0.1),
                      ),
                      Text(
                        "ياسمين رزق صلاح رضوان",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("التحليل و الاختبار و المراجعة"),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () async {
                              await launch(
                                  'https://www.linkedin.com/in/yasmeenradwan/');
                            },
                            child: Icon(
                              MyFlutterApp.linkedin_circled,
                              color: Color.fromRGBO(10, 102, 194, 100),
                              size: 20,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
