import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nagar_parishad/api_service/loginapi.dart';
import 'pages/basic_info.dart';
import 'model/sharedprefmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

Future<void> main() async {
  runApp(const Login());
}

late SharedPreferences prefs;

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nagar Parishad',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }
}

class _LoginPageState extends State<LoginPage> {

  Future<bool> isLoggedIn() async {
    await LoginPage.init();
    if (prefs.getString('auth_key') == null) {
      const Login();
    } else {
      isLogin = true;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BasicInfo()));
    }
    return isLogin;
  }

  Future<void> goToHome() async {
    // ignore: await_only_futures
    await isLoggedIn();
  }

  bool _isHidden = true, isLoading = false, isLogin=false;

  late String username, password;

  // ignore: prefer_final_fields
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  saveSharedPrefs(Map<String, dynamic> value) async {
    await LoginPage.init();
    SharedPrefsModel model = SharedPrefsModel();

    prefs.setString('auth_key', value['auth_key']);
    prefs.setString('email', value['user_email']);
    prefs.setString('user_id', value['user_id']);

    model.saveSharedPrefs();
  }

  void _submit(BuildContext context) {
    _formKey.currentState!.save();
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      isLoading = true;
      APIService apiService = APIService();
      apiService.login(username, password, context).then((value) {
        if (value['status'] == 200) {
          saveSharedPrefs(value['data']);

          isLoading = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BasicInfo()));
        } else if (value['status'] != 200) {
          setState(() {
            isLoading = false;
          });
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goToHome();
  }

  @override
  Widget build(BuildContext context) {
    // goToHome();

    return Scaffold(backgroundColor: Colors.white, body: FutureBuilder(future: goToHome(),
        builder: (context, snapshot) {
          return isLogin ? Center(
              child: Container(
                child: CircularProgressIndicator(),
                margin: EdgeInsets.only(top: 10.0),
                color: Colors.white,
              )): Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: const Text('Login'),
            ),
            body: Builder(builder: (context) =>
          SingleChildScrollView(child: Center(
                  child: Form(key: _formKey, child: Column(children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                            top: 30.0, left: 20.0, right: 20.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.left,
                          validator: (value) {
                            if (value!.isEmpty) return 'Enter your email';
                            return null;
                          },
                          onSaved: (value) => username = value!,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5.0))),
                          ),
                        ),
                      ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0),
                      child: TextFormField(
                        obscureText: _isHidden,
                        textAlign: TextAlign.left,
                        onSaved: (input) => password = input!,
                        validator: (input) =>
                        input!.length < 3
                            ? "Password should be more than 3 characters"
                            : null,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)),
                          ),
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                _isHidden = !_isHidden;
                              });
                            },
                            child: Icon(
                              _isHidden ? Icons.visibility_off : Icons
                                  .visibility,
                            ),
                          ),),
                      ),
                    ),
                    (isLoading) ? Center(child: Container(
                      margin: const EdgeInsets.only(top: 30.0),
                      child: const CircularProgressIndicator(),)) :
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      width: 150.0,
                      height: 50.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                        color: Colors.blueAccent)
                                )
                            )
                        ),
                        onPressed: () => _submit(context),
                        // }),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  ),
                  ),),
        )));
    }));
  }
}
