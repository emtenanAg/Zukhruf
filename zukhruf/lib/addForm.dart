import 'package:flutter/material.dart';
import './myPage.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 101, 83, 59),
          title: const Text('أضف قطعة أثاث'),
        ),
        backgroundColor: Color.fromARGB(255, 242, 234, 219),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(50, 20, 50, 40),
          child: Center(
              child: Form(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.08),
                  TextFormField(
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                        labelText: 'عنوان الأثاث',
                        hintText: '',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.fingerprint),
                      labelText: 'الوصف',
                      hintText: "",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const myPage()),
                        );
                      },
                      child: Text('إضافة ',
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
