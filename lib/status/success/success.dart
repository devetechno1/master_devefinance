import '../status.dart';

class Success<T> extends Status<T> {
  @override
  final T data;
  const Success(this.data);
}
