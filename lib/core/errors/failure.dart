class Failure {
  final String message;
  Failure([this.message = 'An unexpected error occured']);
}
class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

