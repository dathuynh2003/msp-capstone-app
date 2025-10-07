import '../entities/user.dart';

class UserMockData {
  static final List<User> initializedUsers = [
    User(
      id: '5',
      name: 'John Doe',
      email: 'dathtv',
      password: '1',
      role: UserRole.member,
      avatar: 'https://via.placeholder.com/40',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    User(
      id: '2',
      name: 'Sarah Johnson',
      email: 'sarah.johnson@company.com',
      password: '1',
      role: UserRole.businessOwner,
      avatar: 'https://via.placeholder.com/40',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    User(
      id: '3',
      name: 'Mike Chen',
      email: 'mike.chen@company.com',
      password: '1',
      role: UserRole.adminSystem,
      avatar: 'https://via.placeholder.com/40',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    User(
      id: '4',
      name: 'Emily Davis',
      email: 'emily.davis@company.com',
      password: '1',
      role: UserRole.member,
      avatar: 'https://via.placeholder.com/40',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    User(
      id: '1',
      name: 'Alex Rodriguez',
      email: 'pm@gmail.com',
      password: '1',
      role: UserRole.projectManager,
      avatar: 'https://via.placeholder.com/40',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  static User? authenticateUser(String email, String password) {
    try {
      return initializedUsers.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  static User? getUserById(String id) {
    try {
      return initializedUsers.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static User? getUserByEmail(String email) {
    try {
      return initializedUsers.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }
}
