import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart';
import 'package:proyecto/camara.dart';

part 'main_test_event.dart';
part 'main_test_state.dart';

class MainTestBloc extends Bloc<MainTestEvent, MainTestState> {
  File _selectedFile;
  @override
  MainTestState get initialState => MainTestInitial();

  @override
  Stream<MainTestState> mapEventToState(
    MainTestEvent event,
  ) async* {
    if (event is TakePicture) {
      if(event.source == ImageSource.camera) {
        await getImage(ImageSource.camera);
      } else {
        await getImage(ImageSource.gallery);
      }
      yield ChoosenImage(image: _selectedFile);
    } else if (event is FilterImage) {
      _selectedFile = event.image;
      yield FilteredImage(filteredImage: _selectedFile);
    }
  }

  //Es el metodo para elegir una imagen, acepta si es de la galeria o de la camara
  getImage(ImageSource source) async {
    //Eleccion de imagen
    File image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      //Inicia la parte del cropper que es una Activity del manifest
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.blue,
            toolbarTitle: "Ajuste",
            statusBarColor: Colors.blue,
            backgroundColor: Colors.white,
          ));
      //Regresa la imagen modificada y cambia el estado
      _selectedFile = cropped;
    }
  }
}
