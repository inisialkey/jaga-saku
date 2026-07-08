import 'package:jaga_saku/core/utils/utils.dart';

abstract class AuthLocalDatasource {
  bool get isLoggedIn;
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final MainBoxMixin _box;

  AuthLocalDatasourceImpl(this._box);

  @override
  bool get isLoggedIn => (_box.getData<bool?>(MainBoxKeys.isLogin)) ?? false;
}
