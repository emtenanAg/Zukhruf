import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 206, 181),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
                image: const AssetImage('assets/images/welcome.png'),
                height: height * 0.6),
            Column(
              children: [
                Text("Welcome to Zukhruf!",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 137, 116, 89),
                        fontSize: 50)),
                Text("Sign up and start your funiture journey now",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('Log In'),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Sign up'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
