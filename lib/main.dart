import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yibe_final_ui/model/acType.dart';
import 'package:yibe_final_ui/auth/NewUser.dart';
import 'package:yibe_final_ui/pages/PageHandler.dart';
import 'package:yibe_final_ui/pages/Settings.dart';
import 'package:yibe_final_ui/pages/setUpProfAc.dart';
import 'package:yibe_final_ui/auth/LogInPage.dart';
import 'package:yibe_final_ui/auth/SignupPage.dart';
import 'package:yibe_final_ui/pages/splash.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/pages/EditPrivateProfile.dart';
import 'package:yibe_final_ui/pages/EditProfProfile.dart';
import 'package:yibe_final_ui/pages/Conversation.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>AcType(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        navigatorKey: NavigationService.instance.navigatorKey,
        initialRoute: FirebaseAuth.instance.currentUser != null ? 'splash': 'firstView',
        routes: {
          'splash': (context) => SplashScreen(),
          'pageHandler': (context) => PageHandler(),
          'logIn': (context)=>LogInPage(),
          'signUp':(context)=>SignUp(),
          'settings': (context)=> Settings(),
          'firstView' : (context)=>FirstView(),
          'setUpProfAc' :(context)=>SetUpProfessionalAccount(),
          'editPrivate':(context)=>EditPrivateProfile(),
          'editProfessional':(context)=>EditProfProfile(),

          //home: SplashScreen(),
          //onGenerateRoute: (routeSettings) {
          // if (routeSettings.name == Notifications.routeName + 'Right Swipe')
          //   return PageTransition(
          //     child: Notifications(),
          //     type: PageTransitionType.leftToRight,
          //     settings: routeSettings,
          //   );
          // if (routeSettings.name == CollegeSectionPage.routeName + 'Right Swipe')
          //   return PageTransition(
          //     child: CollegeSectionPage(),
          //     type: PageTransitionType.leftToRight,
          //     settings: routeSettings,
          //   );
          // if (routeSettings.name == Money.routeName + 'Right Swipe')
          //   return PageTransition(
          //     child: CollegeSectionPage(),
          //     type: PageTransitionType.leftToRight,
          //     settings: routeSettings,
          //   );
          // if (routeSettings.name == Messages.routeName + 'Left Swipe')
          //   return PageTransition(
          //     child: Messages(),
          //     type: PageTransitionType.rightToLeft,
          //     settings: routeSettings,
          //   );
          // else
          //  return null;
        },
        // routes: {
        // Messages.routeName: (context) => Messages(),
        // Notifications.routeName: (context) => Notifications(),
        // CollegeSectionPage.routeName: (context) => CollegeSectionPage(),
        // Money.routeName: (context) => Money()
        //},
      ),
    );
  }
}

