import 'package:uuid/uuid.dart';
import '../../model/user.dart';
import 'auth_repository.dart';
import '../exception/auth_exception.dart';

class AuthMemoryRepository implements AuthRepository {
  User? _currentUser;
  final _users = <String, User>{};
  final _passwords = <String, String>{};
  final _uuid = Uuid();

  @override
  Future<User?> login(String email, String password) async {
    try {
      final user = _users.values.firstWhere((user) => user.email == email);

      final storedPassword = _passwords[user.id];

      if (!(storedPassword == password)) {
        throw AuthException("Senha incorreta");
      }

      _currentUser = user;

      return user;
    } catch (e) {
      throw AuthException("Usuário não encontrado");
    }
  }

  @override
  Future<User> register(String email, String password) async {
    final emailAlreadyExists = _users.values.any((user) => user.email == email);

    if (emailAlreadyExists) {
      throw AuthException("E-mail já cadastrado");
    }

    final user = User(
      id: _uuid.v4(),
      email: email,
      name: "",
      profileImageUrl: null,
    );

    _users[user.id] = user;
    _passwords[user.id] = password;
    _currentUser = user;

    return user;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  User? currentUser() {
    return _currentUser;
  }
}
