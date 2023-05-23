import '../../models/photo.dart';

abstract class PhotoState {
  const PhotoState();
}

class PhotoLoading extends PhotoState {
  const PhotoLoading();
}

class PhotoLogged extends PhotoState {
  final Map<int, PhotoModel> data;

  const PhotoLogged({required this.data});
}

class PhotoError extends PhotoState {
  final String message;

  const PhotoError(this.message);
}
