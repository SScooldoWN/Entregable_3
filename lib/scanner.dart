import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EscanerPage extends StatefulWidget {
  @override
  _EscanerPageState createState() => _EscanerPageState();
}

class _EscanerPageState extends State<EscanerPage> {
  File _selectedFile;
  bool _inProcess = false;

  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile,
        width: 250,
        height: 350,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
       //TODO: Agreagar imagen
        "assets/placeholder.jpg",
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    }
  }

  getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    this.setState(() {
      _selectedFile = image;
      _inProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
       return Scaffold(
        appBar: AppBar( 
         title: Text('Escaner'),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  getImageWidget(),
                  MaterialButton(
                    color: Colors.blue,
                    child: Text(
                      "Tomar foto",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                  ),
                  MaterialButton(
                      color: Colors.blue,
                      child: Text(
                        'Escanear',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {}),
                ],
              ),
               ),
            (_inProcess)
                ? Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Center()
          ],
        ));
  }
}
