import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBAKTBcW12w0Izj29lDmlrEqjtM7Z3fMHk",
        authDomain: "picsgram-2a08c.firebaseapp.com",
        databaseURL:
            "https://picsgram-2a08c-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "picsgram-2a08c",
        storageBucket: "picsgram-2a08c.appspot.com",
        messagingSenderId: "410390726149",
        appId: "1:410390726149:web:1df8f80f7cf39d2115be6c",
        measurementId: "G-32X614JB1E",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Picsgram',
        theme: ThemeData.dark().copyWith(
            useMaterial3: true,
            scaffoldBackgroundColor: mobileBackgroundColor,
            appBarTheme: const AppBarTheme(
              color: mobileBackgroundColor,
              surfaceTintColor: mobileBackgroundColor,
            ),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
              color: blueColor,
            )))),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
