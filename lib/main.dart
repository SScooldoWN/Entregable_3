import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/photofilters.dart';
import 'package:path/path.dart';

import 'bloc/main_test_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Escaner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EscanerPage(),
    );
  }
}

class EscanerPage extends StatefulWidget {
  @override
  _EscanerPageState createState() => _EscanerPageState();
}

class _EscanerPageState extends State<EscanerPage> {
  File _selectedFile;
  bool _inProcess = false;
  MainTestBloc _mainbloc;
//Pantalla principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Escaner')),
      body: BlocProvider(
        create: (context) {
          _mainbloc = MainTestBloc();
          return _mainbloc;
        },
        child: BlocBuilder<MainTestBloc, MainTestState>(
          builder: (context, _appBloc) {
            if (_appBloc is ChoosenImage) {
              _selectedFile = _appBloc.image;
              print("AAAAAAAAAAAAAAAAAAAAAAAAAAAA\n\n\n\n");
            }
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      getImageWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              _mainbloc
                                  .add(TakePicture(source: ImageSource.camera));
                              //getImage(ImageSource.camera);
                            },
                            child: Text(
                              'Tomar foto',
                              style: TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              _mainbloc.add(
                                  TakePicture(source: ImageSource.gallery));
                              //getImage(ImageSource.gallery);
                            },
                            child: Text(
                              'Seleccionar imagen',
                              style: TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ],
                      ),
                      FlatButton(
                        child: Text(
                          'Agregar Filtro',
                          style: TextStyle(
                            color: Colors.purple,
                          ),
                        ),
                        onPressed: () {
                          agregarFiltro(context);
                        },
                      ),
                      //TODO: Generar pdf con imagen
                      RaisedButton(
                        onPressed: () {},
                        child: Text(
                          'Guardar como PDF',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                      ),
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
            );
          },
        ),
      ),
    );
  }

  //Checa si ya se eligio una imagen, si no muestra una de assets
  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile,
        width: 300,
        height: 300,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/placeholder.jpg",
        width: 300,
        height: 300,
        fit: BoxFit.cover,
      );
    }
  }

  Future agregarFiltro(context) async {
    Map imagefile = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoFilterSelector(
          title: Text("Agregar Filtro"),
          image: imageLib.decodeImage(_selectedFile.readAsBytesSync()),
          filters: presetFiltersList,
          filename: basename(_selectedFile.path),
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      _selectedFile = imagefile['image_filtered'];
      _mainbloc.add(FilterImage(image: _selectedFile));
    }
  }
}
