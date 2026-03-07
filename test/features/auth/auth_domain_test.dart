import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';

void main() {
  test('AuthEntity props contains core fields', () {
    const entity = AuthEntity(
      authId: '1',
      fullName: 'Test User',
      email: 'test@example.com',
      userName: 'test',
    );

    expect(entity.props.contains('1'), true);
    expect(entity.fullName, 'Test User');
  });
}
