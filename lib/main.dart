import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:social_media_integration/google_auth.dart';

import 'Animation/FadeAnimation.dart';
import 'google_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media Integration',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic _userData;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.isLogged;
    if (accessToken != null) {
      FacebookAuth.instance.getUserData().then((userData) {
        setState(() => _userData = userData);
      });
    }
  }

  _login() async {
    final result = await FacebookAuth.instance.login();
    switch (result.status) {
      case FacebookAuthLoginResponse.ok:
        final userData = await FacebookAuth.instance.getUserData();

        AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() => _userData = userData);

        break;
      case FacebookAuthLoginResponse.cancelled:
        print("login cancelled");
        break;
      default:
        print("login failed");
        break;
    }
  }

  _logOut() async {
    await FacebookAuth.instance.logOut();
    setState(() => _userData = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "The Sparks Foundation",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _userData != null
                                    ? Column(
                                        children: <Widget>[
                                          Card(
                                            child: Container(
                                                width: 120,
                                                height: 120,
                                                color: Colors.grey,
                                                child: Image.network(
                                                  _userData['picture']['data']
                                                      ['url'],
                                                  fit: BoxFit.fill,
                                                )),
                                            semanticContainer: true,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            elevation: 5,
                                            margin: EdgeInsets.all(10),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Name: ${_userData['name']}\nEmail: ${_userData['email']}',
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      12.0),
                                            ),
                                            padding: EdgeInsets.all(12),
                                            textColor: Colors.white,
                                            color: _userData != null
                                                ? Colors.red
                                                : Colors.blue[900],
                                            onPressed: () => _userData != null
                                                ? _logOut()
                                                : _login(),
                                            child: Text(
                                              _userData != null
                                                  ? 'Log Out'
                                                  : 'Login With Facebook',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: _userData != null
                                        ? SizedBox(
                                            height: 10,
                                          )
                                        : RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      12.0),
                                            ),
                                            padding: EdgeInsets.all(16),
                                            onPressed: () {
                                              authService.googleSignIn();
                                              signInWithGoogle(context);
                                            },
                                            color: Colors.white,
                                            textColor: Colors.blue[900],
                                            child: Text('Login With Google',
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      _userData != null
                          ? SizedBox(
                              height: 10,
                            )
                          : SizedBox(
                              height: 70,
                            ),
                      _userData != null
                          ? SizedBox(
                              height: 10,
                            )
                          : FadeAnimation(
                              1.5,
                              Text(
                                "By SAKSHI GUPTA",
                                style: TextStyle(
                                    color: Color.fromRGBO(143, 148, 251, 1)),
                              )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Media Integration'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _userData != null ?
          Column(
            children: <Widget>[
              Card(
                child: Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey,
                    child: Image.network(
                      _userData['picture']['data']['url'], fit: BoxFit.fill,)
                ),
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Name: ${_userData['name']}\nEmail: ${_userData['email']}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              )
            ],
          ) :
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("NO LOGGED \n\nPlease Touch the Facebook Log In Button",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.all(16),
                textColor: Colors.white,
                color: _userData != null ? Colors.black : Colors.blue[900],
                onPressed: () => _userData != null ? _logOut() : _login(),
                child: Text(_userData != null ? 'Log Out' : 'Facebook Log In',
                  style: TextStyle(fontSize: 20),),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () {
              authService.googleSignIn();
              signInWithGoogle(context);
            },
            color: Colors.red,
            textColor: Colors.white,
            child: Text('Login With Google'),

          ),
        ],
      ),
    );
  }
*/
  void signInWithGoogle(BuildContext context) async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Profile()));
  }
}
