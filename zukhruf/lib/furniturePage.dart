import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zukhruf/welcome.dart';
import './addForm.dart';
import './myPage.dart';
import 'package:oktoast/oktoast.dart';

Map this_user = Map();

class furniturePage extends StatefulWidget {
  const furniturePage({Key? key}) : super(key: key);
  @override
  State<furniturePage> createState() => _furniturePageState();
}

class _furniturePageState extends State<furniturePage> {
  final user = FirebaseAuth.instance.currentUser!;

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then((snapshot) => ({this_user = snapshot.docs[0].data()}));
    setState(() {});
  }

  List myList = [];
  bool rented_bool = false;

  Future<void> queryValues() async {
    // getting all the documents from fb snapshot
    final snapshot =
        await FirebaseFirestore.instance.collection("collection").get();

    // check if the collection is not empty before handling it
    if (snapshot.docs.isNotEmpty) {
      // add all items to myList
      myList.addAll(snapshot.docs);
    }
  }

  Future rent_item(name, desc, price, rented, image_url, renter_id) async {
    this_user['email'];
    print('rent');
    Map obj = {
      'name': name,
      'desc': desc,
      'price': price,
      'rented': rented,
      'image_url': image_url,
      'renter_id': ''
    };

    Map new_obj = {
      'name': name,
      'desc': desc,
      'price': price,
      'rented': true,
      'image_url': image_url,
      'renter_id': renter_id
    };

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('furniture', arrayContains: obj)
        .get();

    querySnapshot.docs.forEach((doc) {
      // 5. Update the 'Full Name' field in this document
      doc.reference.update({
        'furniture': FieldValue.arrayRemove([obj])
      });
    });

    querySnapshot.docs.forEach((doc) {
      // 5. Update the 'Full Name' field in this document
      doc.reference.update({
        'furniture': FieldValue.arrayUnion([new_obj])
      });
    });

    rented = true;

    setState(() {});
  }

  Future return_item(name, desc, price, rented, image_url, renter_id) async {
    if (renter_id == user.email) {
      Map obj = {
        'name': name,
        'desc': desc,
        'price': price,
        'rented': rented,
        'image_url': image_url,
        'renter_id': renter_id
      };

      Map new_obj = {
        'name': name,
        'desc': desc,
        'price': price,
        'rented': false,
        'image_url': image_url,
        'renter_id': ''
      };

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('furniture', arrayContains: obj)
          .get();

      querySnapshot.docs.forEach((doc) {
        // 5. Update the 'Full Name' field in this document
        doc.reference.update({
          'furniture': FieldValue.arrayRemove([obj])
        });
      });

      querySnapshot.docs.forEach((doc) {
        // 5. Update the 'Full Name' field in this document
        doc.reference.update({
          'furniture': FieldValue.arrayUnion([new_obj])
        });
      });

      rented = true;

      setState(() {});
    } else {
      showToast(
          'لست من قام بإيجار هذه القطعة، الرجاء الانتظار حتى يعيدها المؤجر الحالي');
    }
  }

  String owner_name = '';
  String owner_address = '';
  String owner_phone = '';

  Future get_user(name, desc, price, rented, image_url, renter_id) async {
    Map obj = {
      'name': name,
      'desc': desc,
      'price': price,
      'rented': rented,
      'image_url': image_url,
      'renter_id': renter_id
    };

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('furniture', arrayContains: obj)
        .get();

    var my_user = querySnapshot.docs[0].data() as Map<String, dynamic>;

    owner_name = my_user['name'];
    print(owner_name);
    owner_address = my_user['address'];
    owner_phone = my_user['phone'];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 101, 83, 59),
            title: const Text('استعرض الأثاث'),
            actions: <Widget>[
              ElevatedButton(
                child: Text("تسجيل الخروج"),
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
        bottomNavigationBar: Container(
          height: 55.0,
          child: BottomAppBar(
            color: Color.fromARGB(255, 101, 83, 59),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => myPage()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.chair, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 242, 234, 219),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: FutureBuilder(
                future: FirebaseFirestore.instance.collection('users').get(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    // iterate through the documents returned by the query
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot<Map<String, dynamic>>
                            documentSnapshot = snapshot.data!.docs[index];

                        if (documentSnapshot.data()!['furniture'] != null) {
                          List<dynamic> furnitureList =
                              documentSnapshot.data()!['furniture'];
                          //iterate through the furniture items in the current document
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: furnitureList.map((e) {
                              bool rented = e['rented'];
                              String rented_s = '';
                              if (rented) {
                                rented_s = 'مؤجر';
                              } else {
                                rented_s = 'غير مؤجر';
                              }

                              var my_rented = false;
                              if (e['renter_id'] == user.email) {
                                my_rented = true;
                              }
                              String desc = e['desc'];
                              String name = e['name'];
                              String price = e['price'];
                              String img_url = e['image_url'];
                              get_user(name, desc, price, rented, img_url,
                                  e['renter_id']);

                              return InkWell(
                                  onTap: () async => {
                                        await get_user(name, desc, price,
                                            rented, img_url, e['renter_id']),
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 60.0,
                                                          right: 60.0,
                                                          top: 50,
                                                          bottom: 50),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 220, 206, 181),
                                                  content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Image.network(img_url,
                                                            fit: BoxFit.cover,
                                                            height: 100,
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                          return Icon(
                                                              Icons.error);
                                                        }),
                                                        SizedBox(height: 40),
                                                        Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    'مالك قطعة الأثاث',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            57,
                                                                            44,
                                                                            27),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(owner_name,
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            101,
                                                                            83,
                                                                            59),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    height: 20),
                                                                Text(
                                                                    'عنوان المالك',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            57,
                                                                            44,
                                                                            27),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(
                                                                    owner_address,
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            101,
                                                                            83,
                                                                            59),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    height: 20),
                                                                Text(
                                                                    'هاتف المالك',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            57,
                                                                            44,
                                                                            27),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(
                                                                    owner_phone,
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            101,
                                                                            83,
                                                                            59),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ],
                                                            ),
                                                            SizedBox(width: 50),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    'اسم قطعة الأثاث',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          57,
                                                                          44,
                                                                          27),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right),
                                                                Text('${name}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          101,
                                                                          83,
                                                                          59),
                                                                    )),
                                                                SizedBox(
                                                                    height: 20),
                                                                Text(
                                                                    'وصف قطعة الأثاث',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            57,
                                                                            44,
                                                                            27),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text('${desc}',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            101,
                                                                            83,
                                                                            59),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    height: 20),
                                                                Text(
                                                                    'سعر قطعة الأثاث',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            57,
                                                                            44,
                                                                            27),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(
                                                                    '${price} SR',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            101,
                                                                            83,
                                                                            59),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    height: 20),
                                                                Text(
                                                                    'حالة قطعة الأثاث',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            57,
                                                                            44,
                                                                            27),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(
                                                                    '${rented_s}',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            101,
                                                                            83,
                                                                            59),
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 40),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    'إغلاق',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          45,
                                                                          36,
                                                                          24),
                                                                      fontSize:
                                                                          20,
                                                                    )),
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            241,
                                                                            241,
                                                                            241))),
                                                            SizedBox(width: 60),
                                                            Visibility(
                                                                visible:
                                                                    !rented,
                                                                child:
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          rent_item(
                                                                              name,
                                                                              desc,
                                                                              price,
                                                                              rented,
                                                                              img_url,
                                                                              user.email);
                                                                        },
                                                                        child: Text(
                                                                            'استأجر',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 20,
                                                                            )),
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Color.fromARGB(
                                                                                255,
                                                                                101,
                                                                                83,
                                                                                59)))),
                                                            Visibility(
                                                                visible: rented &&
                                                                    my_rented,
                                                                child:
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          return_item(
                                                                              name,
                                                                              desc,
                                                                              price,
                                                                              rented,
                                                                              img_url,
                                                                              user.email);
                                                                        },
                                                                        child: Text(
                                                                            'إعادة',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color.fromARGB(255, 101, 83, 59),
                                                                              fontSize: 20,
                                                                            )),
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Color.fromARGB(
                                                                                255,
                                                                                221,
                                                                                221,
                                                                                221)))),
                                                          ],
                                                        )
                                                      ]));
                                            })
                                      },
                                  child: Card(
                                    elevation: 10.0,
                                    margin: new EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: Container(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                          leading: Image.network(img_url,
                                              fit: BoxFit.cover, errorBuilder:
                                                  (context, error, stackTrace) {
                                            return Icon(Icons.error);
                                          }),
                                          title: Text(
                                            '${name} | ${desc}',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 101, 83, 59),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                          subtitle: Row(
                                            children: <Widget>[
                                              Text('${price} SR',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 101, 83, 59))),
                                              SizedBox(width: 3),
                                              Text('- ${rented_s}',
                                                  style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0)))
                                            ],
                                          ),
                                          trailing: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Visibility(
                                                  visible: !rented,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        rent_item(
                                                            name,
                                                            desc,
                                                            price,
                                                            rented,
                                                            img_url,
                                                            user.email);
                                                      },
                                                      child: Text('استأجر',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                          )),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Color.fromARGB(
                                                                      255,
                                                                      101,
                                                                      83,
                                                                      59)))),
                                              Visibility(
                                                  visible: rented && my_rented,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        return_item(
                                                            name,
                                                            desc,
                                                            price,
                                                            rented,
                                                            img_url,
                                                            user.email);
                                                      },
                                                      child: Text('إعادة',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    101,
                                                                    83,
                                                                    59),
                                                            fontSize: 15,
                                                          )),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Color.fromARGB(
                                                                      255,
                                                                      221,
                                                                      221,
                                                                      221)))),
                                            ],
                                          ),
                                        )),
                                  ));
                            }).toList(),
                          );
                        }
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
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
          onPressed: () {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => myPage()));
          },
        ),
        IconButton(
          icon: Icon(Icons.chair, color: Colors.white),
          onPressed: () {},
        ),
      ],
    ),
  ),
);
