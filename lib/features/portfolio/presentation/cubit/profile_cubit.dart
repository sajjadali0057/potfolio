import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/use_case.dart';
import '../../domain/usecases/get_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfile) : super(const ProfileLoading());

  final GetProfile _getProfile;

  Future<void> load() async {
    try {
      final profile = await _getProfile(const NoParams());
      emit(ProfileReady(profile));
    } catch (error) {
      emit(ProfileFailure(error.toString()));
    }
  }
}
