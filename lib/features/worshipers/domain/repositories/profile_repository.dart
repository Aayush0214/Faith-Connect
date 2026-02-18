import 'package:faith_connect/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, Map<String, int>>> getWorshiperStats();
}