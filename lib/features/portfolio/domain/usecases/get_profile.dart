import '../../../../core/usecases/use_case.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class GetProfile implements UseCase<Profile, NoParams> {
  GetProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Profile> call(NoParams params) => _repository.getProfile();
}
