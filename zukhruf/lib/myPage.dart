import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zukhruf/welcome.dart';
import './addForm.dart';

Map this_user = Map();

class myPage extends StatefulWidget {
  const myPage({Key? key}) : super(key: key);
  @override
  State<myPage> createState() => _myPageState();
}

class _myPageState extends State<myPage> {
  final user = FirebaseAuth.instance.currentUser!;

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then((snapshot) => ({this_user = snapshot.docs[0].data()}));
  }

  Future deleteFur(int index) async {
    print('delete');
    Map obj = {
      'name': this_user['furniture'][index]['name'],
      'desc': this_user['furniture'][index]['desc'],
      'price': this_user['furniture'][index]['price'],
      'rented': this_user['furniture'][index]['rented']
    };

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get();

    querySnapshot.docs.forEach((doc) {
      // 5. Update the 'Full Name' field in this document
      doc.reference.update({
        'furniture': FieldValue.arrayRemove([obj])
      });
    });
  }

  Future getFur() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get();

    String owner_id = querySnapshot.docs.first.id;

    QuerySnapshot fur_snapshot = await FirebaseFirestore.instance
        .collection('furniture')
        .where('owner_id', isEqualTo: owner_id)
        .get();
    List<DocumentSnapshot> docs = fur_snapshot.docs;
    print(docs[0].data());
    if (docs.isEmpty) {
      return;
    } else {
      return docs;
    }
  }

  @override
  void initState() {
    getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    double width = MediaQuery.of(context).size.width;
    getDocId();
    var count = this_user['furniture'] ?? 0;
    int num = 0;
    if (count != 0) {
      List<dynamic> items = this_user['furniture'];
      num = items.length;
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 101, 83, 59),
            title: const Text('صفحتي الشخصية'),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Logout"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 101, 83, 59)),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    print("Signed Out");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Welcome()));
                  });
                },
              ),
            ]),
        bottomNavigationBar: makeBottom,
        backgroundColor: Color.fromARGB(255, 242, 234, 219),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: FutureBuilder(
                future: getDocId(),
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(this_user['name'] ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 101, 83, 59),
                                        fontSize: 30,
                                      ),
                                      textDirection: TextDirection.rtl),
                                  Text(this_user['address'] ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 101, 83, 59),
                                        fontSize: 25,
                                      ),
                                      textDirection: TextDirection.rtl),
                                ],
                              ),
                              Icon(Icons.person,
                                  color: Color.fromARGB(255, 101, 83, 59),
                                  size: width * 0.3),
                            ]),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const addForm()),
                          );
                        },
                        child: Text('+ أضف قطعة أثاث',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25,
                            )),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 101, 83, 59),
                            minimumSize: Size.fromHeight(40)),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                          child: FutureBuilder(
                        future: getFur(),
                        builder: (context, AsyncSnapshot fur_snapshot) {
                          if (fur_snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          print(fur_snapshot.data);
                          if (fur_snapshot == null) {
                            return Text('No furniture found');
                          }
                          if (fur_snapshot.hasData) {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: fur_snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 10.0,
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 6.0),
                                  child: Container(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10.0),
                                        leading: Icon(Icons.chair, size: 50),
                                        title: Text(
                                          '${fur_snapshot.data![index]['name']} | ${fur_snapshot.data![index]['discreption']}',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 101, 83, 59),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                        subtitle: Row(
                                          children: <Widget>[
                                            Text(
                                                '${fur_snapshot.data![index]['price_per_day']}SR',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 101, 83, 59))),
                                            SizedBox(width: 5),
                                            Icon(
                                              Icons.person,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                            Text(
                                                '${fur_snapshot.data![index]['rented']}',
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 0)))
                                          ],
                                        ),
                                        trailing: GestureDetector(
                                          child: const Icon(
                                            Icons.delete,
                                            color: Color.fromARGB(
                                                255, 223, 127, 120),
                                          ),
                                          onTap: () {
                                            deleteFur(index);
                                          },
                                        ),
                                      )),
                                );
                              },
                            );
                          } else {
                            return SizedBox(width: 5);
                          }
                        },
                      ))
                    ],
                  );
                })));
  }
}

final makeCard = Card(
  elevation: 10.0,
  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  child: Container(
    decoration: BoxDecoration(color: Colors.white),
    child: makeListTile,
  ),
);

final makeListTile = ListTile(
  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  leading: Image.asset('/images/chair.png'),
  title: Text(
    '',
    style: TextStyle(
        color: Color.fromARGB(255, 101, 83, 59), fontWeight: FontWeight.bold),
  ),
  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

  subtitle: Row(
    children: <Widget>[
      Text("50 SR", style: TextStyle(color: Color.fromARGB(255, 101, 83, 59))),
      SizedBox(width: 5),
      Icon(
        Icons.check,
        color: Colors.green,
      ),
      Text("مأجرة", style: TextStyle(color: Colors.green))
    ],
  ),
  trailing: GestureDetector(
    child: const Icon(
      Icons.delete,
      color: Color.fromARGB(255, 223, 127, 120),
    ),
    onTap: () {},
  ),
);

final makeBottom = Container(
  height: 55.0,
  child: BottomAppBar(
    color: Color.fromARGB(255, 101, 83, 59),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.chair, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.shopping_cart_checkout, color: Colors.white),
          onPressed: () {},
        ),
      ],
    ),
  ),
);
