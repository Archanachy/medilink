class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  // static const String baseUrl = 'http://10.0.2.2:5050/auth';

  // for physical device. 
  static const String baseUrl = 'http://172.25.10.119:5050/auth';

  // static const String baseUrl = 'http://localhost:3000/api/v1';
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Category Endpoints ============
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';

  // ============ User Endpoints ============
  static const String user = '/register';
  static const String userLogin = '/login';
  static const String userRegister = '/register';
  static String userById(String id) => '/users/$id';
  static String userPhoto(String id) => '/users/$id/photo';

  // ============ Patient Endpoints ============
  static String patientById(String id) => '/patients/$id';
  static String patientByUserId(String userId) => '/patients/user/$userId';

  // ============ Item Endpoints ============
  static const String items = '/items';
  static String itemById(String id) => '/items/$id';
  static String itemClaim(String id) => '/items/$id/claim';

  // ============ Comment Endpoints ============
  static const String comments = '/comments';
  static String commentById(String id) => '/comments/$id';
  static String commentsByItem(String itemId) => '/comments/item/$itemId';
  static String commentLike(String id) => '/comments/$id/like';
}