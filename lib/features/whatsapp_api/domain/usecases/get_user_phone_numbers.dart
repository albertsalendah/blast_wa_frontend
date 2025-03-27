import 'package:fpdart/fpdart.dart';
import 'package:whatsapp_blast/core/errors/failure.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/entities/phone_number.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/repositories/whatsapp_api_repository.dart';
import '../../../../core/usecase/usecase.dart';

class GetUserPhoneNumbers implements UseCase<List<PhoneNumber>, String> {
  final WhatsappApiRepository repository;
  const GetUserPhoneNumbers(this.repository);
  @override
  Future<Either<Failure, List<PhoneNumber>>> call(String param) async {
    return await repository.getPhoneNumbers(email: param);
  }
}
