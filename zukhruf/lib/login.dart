import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './myPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Widget build(BuildContext context) {
    TextEditingController _passwordTextController = TextEditingController();
    TextEditingController _emailTextController = TextEditingController();
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 101, 83, 59),
          title: const Text('تسجيل الدخول'),
        ),
        backgroundColor: Color.fromARGB(255, 242, 234, 219),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
          child: Center(
              child: Form(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.08),
                  Image(
                      image: const AssetImage('assets/images/header.png'),
                      width: width),
                  SizedBox(height: height * 0.06),
                  TextFormField(
                    controller: _emailTextController,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_outlined),
                        labelText: 'الإيميل',
                        hintText: '',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordTextController,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.fingerprint),
                      labelText: 'كلمة المرور',
                      hintText: "",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: null,
                        icon: Icon(Icons.remove_red_eye_sharp),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                            .then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => myPage()));
                        }).onError((error, stackTrace) {
                          showToast(' ${error.toString()}');
                          print("Error ${error.toString()}");
                        });
                      },
                      child: Text('تسجيل الدخول',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25,
                          )),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 101, 83, 59)),
                    ),
                  ),
                ],
              )),
            ),
          )),
        ));
  }
}
