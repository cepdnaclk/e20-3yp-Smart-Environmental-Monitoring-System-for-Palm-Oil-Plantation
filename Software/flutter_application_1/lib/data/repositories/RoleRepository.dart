import 'package:flutter_application_1/domain/entities/Role.dart';

class RoleRepository {
  static final List<Role> _roles = [Role("Laborer"), Role("Manager")];

  List<Role> getRoles() {
    return _roles;
  }

  void addRole(String roleName) {
    if (!_roles.any((role) => role.name == roleName)) {
      _roles.add(Role(roleName));
    }
  }
}
