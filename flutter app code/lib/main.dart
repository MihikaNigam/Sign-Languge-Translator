import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minorproject/searchbar.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const MaterialColor kPrimaryColor = const MaterialColor(
      0xffFEA652,
      const <int, Color>{
        50: const Color(0xffFEA652),
        100: const Color(0xffFEA652),
        200: const Color(0xffFEA652),
        300: const Color(0xffFEA652),
        400: const Color(0xffFEA652),
        500: const Color(0xffFEA652),
        600: const Color(0xffFEA652),
        700: const Color(0xffFEA652),
        800: const Color(0xffFEA652),
        900: const Color(0xffFEA652),
      },
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'Raleway',
          primarySwatch: kPrimaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _outputs;
  File _image;

  @override
  void initState() {
    super.initState();
    
    loadModel().then((value) {
      setState(() {});
    });
  }

  loadModel() async {
    print('im  here');
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  pickImage() async {
    print('inside pick image');
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    var decodedImage =
        await decodeImageFromList(File(image.path).readAsBytesSync());
    print("size : $decodedImage");

    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  clickImage() async {
    print('inside click image');
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 200, maxWidth: 200);

    var decodedImage =
        await decodeImageFromList(File(image.path).readAsBytesSync());
    print("size : $decodedImage");
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  classifyImage(File image) async {
    print('inside classify');
    var output = await Tflite.runModelOnImage(
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      asynch: true,
      threshold: 0.4,
      path: image.path,
    );
    print("predict = " + output.toString());
    setState(() {
      _outputs = output;
    });
    int i = output.toString().indexOf('l');
    print(i);
    return showDialog(
        context: context,
        builder: (ctx) => Center(
              child: Container(
                padding: EdgeInsets.all(2),
                color: Color(0xffFEA652),
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white,
                        child: Text(
                          output
                              .toString()
                              .substring(i + 6, output.toString().length - 2),
                          style: TextStyle(fontSize: 50, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xffFEA652))),
                            child: Text("OK",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        barrierDismissible: true);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Text('Welcome!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              SizedBox(height: 15),
              Text('You may translate your gestures here',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 15)),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Color(0xff59D8A4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.insert_photo_outlined,
                                size: 40, color: Colors.white),
                            Text('Library',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    wordSpacing: 1))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  GestureDetector(
                    onTap: clickImage,
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Color(0xff4FB2FE),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined,
                                size: 37, color: Colors.white),
                            Text('Camera',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    wordSpacing: 1))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Text('You may translate your text here',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 15)),
              SizedBox(height: 30),
              SearchBar()
            ],
          ),
        ),
      ),
    );
  }
}

