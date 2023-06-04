import 'package:flutter/material.dart';
import './login.dart';
import './Rigester.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 206, 181),
      body: Container(
        padding: const EdgeInsets.fromLTRB(50, 20, 50, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
                image: const AssetImage('assets/images/welcome.png'),
                height: height * 0.6),
            Column(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Text("أهلًا بك في زخرف!",
                          style: const TextStyle(
                            fontFamily: 'dubai',
                            color: Color.fromARGB(255, 137, 116, 89),
                            fontSize: 30,
                          ),
                          textDirection: TextDirection.rtl),
                    )),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Text("حضر نفسك لرحلاتٍ عديدة في عالم الأثاث...",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 101, 83, 59),
                            fontSize: 15,
                          ),
                          textDirection: TextDirection.rtl),
                    )),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: Text('تسجيل الدخول',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25,
                          )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 101, 83, 59),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Rigester()),
                        );
                      },
                      child: Text('حساب جديد',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25,
                          )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 171, 153, 123),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
