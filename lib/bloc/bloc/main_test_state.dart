part of 'main_test_bloc.dart';

abstract class MainTestState extends Equatable {
  const MainTestState();
}

class MainTestInitial extends MainTestState {
  @override
  List<Object> get props => [];
}


class ChoosenImage extends MainTestState {
  final File image;
  ChoosenImage({@required this.image});

  @override
  List<Object> get props => [image];
}

class FilteredImage extends MainTestState {
  final File filteredImage;
  FilteredImage({@required this.filteredImage});

  @override
  List<Object> get props => [filteredImage];
}