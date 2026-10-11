import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_local_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._local);

  final ProfileLocalDataSource _local;

  @override
  Future<Profile> getProfile() async => _local.profile();
}
