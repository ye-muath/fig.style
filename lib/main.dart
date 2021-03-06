import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:figstyle/utils/push_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:figstyle/actions/users.dart';
import 'package:figstyle/components/full_page_loading.dart';
import 'package:figstyle/main_app.dart';
import 'package:figstyle/state/colors.dart';
import 'package:figstyle/state/topics_colors.dart';
import 'package:figstyle/state/user_state.dart';
import 'package:figstyle/utils/app_storage.dart';

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  return runApp(App());
}

class App extends StatefulWidget {
  AppState createState() => AppState();
}

class AppState extends State<App> {
  bool isReady = false;

  AppState();

  @override
  void initState() {
    super.initState();

    appStorage.initialize().then(
      (value) {
        final savedLang = appStorage.getLang();
        userState.setLang(savedLang);

        autoLogin();

        setState(() {
          isReady = true;
        });

        if (!kIsWeb) {
          PushNotifications.init();
        }
      },
    );

    appTopicsColors.fetchTopicsColors();
  }

  @override
  Widget build(BuildContext context) {
    if (isReady) {
      return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
          fontFamily: GoogleFonts.raleway().fontFamily,
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          stateColors.themeData = theme;
          return MainApp();
        },
      );
    }

    return MaterialApp(
      title: 'fig.style',
      home: Scaffold(
        body: FullPageLoading(),
      ),
    );
  }

  void autoLogin() async {
    try {
      final userCred = await userSignin();

      if (userCred == null) {
        userSignOut(context: context, autoNavigateAfter: false);
        PushNotifications.unlinkAuthUser();
      }
    } catch (error) {
      debugPrint(error.toString());
      userSignOut(context: context, autoNavigateAfter: false);
      PushNotifications.unlinkAuthUser();
    }
  }
}
