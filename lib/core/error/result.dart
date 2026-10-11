import 'package:equatable/equatable.dart';

import 'failure.dart';

class Result<T> extends Equatable {
  const Result.success(this.value) : failure = null;

  const Result.failure(this.failure) : value = null;

  final T? value;
  final AppFailure? failure;

  bool get ok => failure == null;

  @override
  List<Object?> get props => [value, failure];
}
