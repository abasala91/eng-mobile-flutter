import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/splash-screen.dart';
import './screens/overview_screen.dart';
import '../screens/auth-screen.dart';
import './screens/services_details_screen.dart';
import 'screens/my_services_screen.dart';
import 'screens/change_user_password_screen.dart';
import './screens/user_profile_screen.dart';
import 'screens/contact-us-screen.dart';
import './screens/applicants_screen.dart';
import './screens/about-screen.dart';
import './providers/auth.dart';
import './providers/services.dart';
import './providers/reserve.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Services>(
            update: (context, auth, previousServices) => Services(
              auth.token,
              previousServices == null ? [] : previousServices.items,
              auth.userId,
            ),
          ),
          ChangeNotifierProxyProvider<Auth, Reserve>(
              update: (context, auth, previousReserve) => Reserve(
                    auth.token,
                    previousReserve == null ? [] : previousReserve.items,
                    auth.userId,
                  )),
        ],
        child: Consumer<Auth>(
          builder: ((context, auth, _) => MaterialApp(
                title: 'Damietta Syndicate',
                theme: ThemeData(
                    primarySwatch: Colors.purple, fontFamily: 'Tajawal'),
                home: auth.isAuth
                    ? OverViewScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen(),
                      ),
                debugShowCheckedModeBanner: false,
                routes: {
                  ServicesDetailsScreen.routeName: (context) =>
                      ServicesDetailsScreen(),
                  MyServicesScreen.routeName: (context) => MyServicesScreen(),
                  UserProfileScreen.routeName: (context) => UserProfileScreen(),
                  ChangeUserPasswordScreen.routeName: (context) =>
                      ChangeUserPasswordScreen(),
                  ApplicantsScreen.routaName: (context) => ApplicantsScreen(),
                  ContactUsScreen.routeName: (context) => ContactUsScreen(),
                  AboutScreen.routeName: (context) => AboutScreen(),
                },
              )),
        ));
  }
}
