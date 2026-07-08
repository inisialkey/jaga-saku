import 'package:jaga_saku/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:jaga_saku/features/auth/domain/repositories/auth_status_repository.dart';

class AuthStatusRepositoryImpl implements AuthStatusRepository {
  final AuthLocalDatasource _datasource;

  const AuthStatusRepositoryImpl(this._datasource);

  @override
  bool get isLoggedIn => _datasource.isLoggedIn;
}
