import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static bool _initialized = false;

  static const String serverClientId =
      '597471422195-kobtko5hqp6c2r63l4q477l3kr8cd9d3.apps.googleusercontent.com';

  static const List<String> _scopes = <String>[
    'email',
    'profile',
  ];

  static Future<void> init() async {
    if (_initialized) return;

    await _googleSignIn.initialize(
      serverClientId: serverClientId,
    );

        _initialized = true;
    }


  static Future<String?> signInAndGetIdToken() async {
    try {
      await init();

      final account = await _googleSignIn.authenticate();
      if(account==null){
        print("user cancel");
        return null;
      }

      final auth = await account.authentication;
      print("id: ${auth.idToken}");
      return auth.idToken;
    }catch(e){
      print('google sign error: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    await init();
    await _googleSignIn.signOut();
  }
}