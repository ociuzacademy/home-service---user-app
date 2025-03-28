import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:home_ease/utils/preference_value.dart';
import 'package:home_ease/view/home.dart';
import 'package:home_ease/view/introduction_screen.dart';
import 'package:home_ease/view/login/page/login.dart';

        
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isFirstLaunch = await PreferenceValues.getIntroScreenStatus();
  bool isLoggedIn = await PreferenceValues.getLoginStatus();

  Widget initialScreen;
  if (isFirstLaunch) {
    initialScreen = const OnboardingPage1();
  } else {
    if (isLoggedIn) {
      initialScreen = const HomePage();
    } else {
      initialScreen = const UserLoginPage();
    }
  }
  runApp(MyApp(
    initialScreen: initialScreen,
  ));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),
      home: AnimatedSplashScreen(
        splash: Center(
          child: Image.asset(
            'assets/icons/home_ease_logo.png',
            height: 200, // Set the height
            width: 200, // Set the width
            fit: BoxFit.contain, // Ensure the image fits within the container without cropping
          ),
        ),
        backgroundColor: Colors.white, // Background color of the splash screen
        splashTransition: SplashTransition.scaleTransition, // Use scale transition
        nextScreen: initialScreen, // Next screen after splash
        duration: 3000, // Duration of the splash screen
        splashIconSize: 250, // Increase the size of the splash icon container
        centered: true, // Center the splash widget
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}