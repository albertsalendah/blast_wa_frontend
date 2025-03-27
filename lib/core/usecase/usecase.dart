import 'package:fpdart/fpdart.dart';
import '../errors/failure.dart';

// Type is the return type of the use case if successful, while Params is the parameter type

abstract interface class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
// use this if there is no need for parameters
class NoParams {}
