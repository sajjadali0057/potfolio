import 'package:equatable/equatable.dart';

class AppFailure extends Equatable {
  const AppFailure(this.code, {this.detail});

  final String code;
  final String? detail;

  static const notFound = 'not_found';
  static const unexpected = 'unexpected';

  @override
  List<Object?> get props => [code, detail];
}
