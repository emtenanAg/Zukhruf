import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'myPage.dart';
import 'package:oktoast/oktoast.dart';

class Rigester extends StatelessWidget {
  const Rigester({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _passwordTextController = TextEditingController();
    TextEditingController _emailTextController = TextEditingController();
    TextEditingController _nameTextController = TextEditingController();
    TextEditingController _adressTextController = TextEditingController();
    TextEditingController _phoneTextController = TextEditingController();

    Future addUser() async {
      await FirebaseFirestore.instance.collection('users').add({
        'name': _nameTextController.text,
        'address': _adressTextController.text,
        'phone': _phoneTextController.text,
        'email': _emailTextController.text
      });
    }

    Future signUp() async {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text)
          .then((value) {
        addUser();
        showToast("تم إنشاء حساب جديد");
        print("Created New Account");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => myPage()));
      }).onError((error, stackTrace) {
        showToast(
            'فشل التسجيل، تأكد من أن البيانات معبأة بشكل صحيح وأن الإيميل لم يتم استعماله مقدما');
        print("Error ${error.toString()}");
      });
    }

    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 101, 83, 59),
          title: const Text('تسجيل حساب جديد'),
        ),
        backgroundColor: Color.fromARGB(255, 242, 234, 219),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(50, 20, 50, 40),
          child: ListView(shrinkWrap: true, children: [
            Form(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                        image: const AssetImage('assets/images/header.png'),
                        width: width),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameTextController,
                      textDirection: TextDirection.ltr,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: 'الاسم',
                          hintText: '',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailTextController,
                      textDirection: TextDirection.ltr,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'الإيميل',
                        hintText: "",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _adressTextController,
                      textDirection: TextDirection.ltr,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.home),
                        labelText: 'العنوان',
                        hintText: "",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneTextController,
                      textDirection: TextDirection.ltr,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'رقم الجوال',
                        hintText: "",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordTextController,
                      textDirection: TextDirection.ltr,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'كلمة المرور',
                        hintText: "",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: null,
                          icon: Icon(Icons.remove_red_eye_sharp),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          signUp();
                        },
                        child: Text('تسجيل',
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
            )
          ]),
        ));
  }
}
