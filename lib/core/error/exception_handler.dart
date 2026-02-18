import 'failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Either<Failure, T>> convertException<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on AuthException catch (e) {
    return Left(ServerFailure(message: e.message));
  } on PostgrestException catch (e) {
    return Left(ServerFailure(message: e.message));
  } catch (e) {
    return Left(ServerFailure(message: e.toString()));
  }
}