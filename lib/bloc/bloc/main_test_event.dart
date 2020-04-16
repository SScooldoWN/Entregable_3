part of 'main_test_bloc.dart';

abstract class MainTestEvent extends Equatable {
  const MainTestEvent();
}

class TakePicture extends MainTestEvent {
    final ImageSource source;

    TakePicture({
      @required this.source,
    });

    @override
    List<Object> get props => [];
}

class FilterImage extends MainTestEvent {
    final File image;
    
    FilterImage({
      @required this.image,
    });

    @override
    List<Object> get props => [];
}