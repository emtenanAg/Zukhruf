import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './myPage.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cross_file/cross_file.dart';
import 'package:mime_type/mime_type.dart';
import 'package:oktoast/oktoast.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'dart:typed_data';

class addForm extends StatefulWidget {
  const addForm({Key? key}) : super(key: key);

  @override
  State<addForm> createState() => _addFormState();
}

class _addFormState extends State<addForm> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String _photo = '';
  final ImagePicker _picker = ImagePicker();
  String imgUrl = '';

  Future imgFromGallery() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = pickedFile.path;
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  // Future uploadFile() async {
  //   print('in');
  //   if (_photo == null) return;
  //   final fileName = basename(_photo);
  //   final destination = '$fileName';

  //   if (kIsWeb) {
  //     print('web');
  //     final metadata = firebase_storage.SettableMetadata(
  //       contentType: 'image/png',
  //     );
  //     try {
  //       Uint8List imageData = await XFile(_photo).readAsBytes();
  //       print('imageData');
  //       final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
  //       await ref.putData(imageData, metadata);
  //       print('putdata');
  //       imgUrl = await ref.getDownloadURL();
  //       print('success');
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     try {
  //       final ref = firebase_storage.FirebaseStorage.instance
  //           .ref(destination)
  //           .child('images');
  //       await ref.putFile(File(_photo));
  //       imgUrl = await ref.getDownloadURL();
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  String image_url = '';

  Future uploadFile() async {
    var dio = Dio();

    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = await pickedFile.readAsBytes();

      String filename = pickedFile.path.split('/').last;

      FormData data = FormData.fromMap({
        'key': 'af3f54d9156be3e66fc1bbb2a9a976c9',
        'image': MultipartFile.fromBytes(file, filename: filename),
      });

      var response = await dio.post(
        "https://api.imgbb.com/1/upload",
        data: data,
        onSendProgress: (int sent, int total) {
          print('$sent, $total');
        },
      );

      print(response.data['data']['url']);
      image_url = response.data['data']['url'];
    } else {
      print("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    double width = MediaQuery.of(context).size.width;

    TextEditingController _nameTextController = TextEditingController();
    TextEditingController _descTextController = TextEditingController();
    TextEditingController _priceTextController = TextEditingController();

    final user = FirebaseAuth.instance.currentUser!;
    Future getDocId() async {
      print('getdoc');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (_nameTextController.text.isNotEmpty &&
          _descTextController.text.isNotEmpty &&
          _priceTextController.text.isNotEmpty &&
          image_url.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          // 5. Update the 'Full Name' field in this document
          doc.reference.update({
            'furniture': FieldValue.arrayUnion([
              {
                'name': _nameTextController.text,
                'desc': _descTextController.text,
                'price': _priceTextController.text,
                'rented': false,
                'image_url': image_url,
                'renter_id': ''
              }
            ])
          });
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const myPage()),
        );
      } else {
        showToast('تأكد من أن جميع البيانات معبأة بشكل صحيح');
      }
    }

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
                    controller: _nameTextController,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                        labelText: 'عنوان الأثاث',
                        hintText: '',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descTextController,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      labelText: 'الوصف',
                      hintText: "",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _priceTextController,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      labelText: 'السعر لكل يوم',
                      hintText: "",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      uploadFile();
                    },
                    child: Text('ارفع صورة + ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 101, 83, 59),
                          fontSize: 25,
                        )),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 212, 193, 168)),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: image_url.isNotEmpty,
                    child: new Text('تم إضافة الصورة'),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        getDocId();
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
