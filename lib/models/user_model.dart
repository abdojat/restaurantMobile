class UserModel {
  final int? id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String? phoneNumber;
  final int? roleId;
  final String? avatarPath;
  final String? address;
  final DateTime? dateOfBirth;
  final String? preferredLocale;
  final bool isBanned;
  final DateTime? bannedAt;
  final int failedDeliveriesCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? rememberToken;
  
  // Related models (simplified for mobile use)
  final String? roleName;
  final List<String>? roleNames;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.phoneNumber,
    this.roleId,
    this.avatarPath,
    this.address,
    this.dateOfBirth,
    this.preferredLocale,
    this.isBanned = false,
    this.bannedAt,
    this.failedDeliveriesCount = 0,
    this.createdAt,
    this.updatedAt,
    this.rememberToken,
    this.roleName,
    this.roleNames,
  });

  // JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] != null 
          ? DateTime.parse(json['email_verified_at']) 
          : null,
      phoneNumber: json['phone_number'] as String?,
      roleId: json['role_id'] as int?,
      avatarPath: json['avatar_path'] as String?,
      address: json['address'] as String?,
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.parse(json['date_of_birth']) 
          : null,
      preferredLocale: json['preferred_locale'] as String?,
      isBanned: json['is_banned'] as bool? ?? false,
      bannedAt: json['banned_at'] != null 
          ? DateTime.parse(json['banned_at']) 
          : null,
      failedDeliveriesCount: json['failed_deliveries_count'] as int? ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      rememberToken: json['remember_token'] as String?,
      roleName: json['role']?['name'] as String?,
      roleNames: json['roles'] != null 
          ? (json['roles'] as List).map((role) => role['name'] as String).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'phone_number': phoneNumber,
      'role_id': roleId,
      'avatar_path': avatarPath,
      'address': address,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'preferred_locale': preferredLocale,
      'is_banned': isBanned,
      'banned_at': bannedAt?.toIso8601String(),
      'failed_deliveries_count': failedDeliveriesCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'remember_token': rememberToken,
    };
  }

  // Role checking methods
  bool hasRole(String role) {
    if (roleName != null && roleName == role) return true;
    if (roleNames != null) return roleNames!.contains(role);
    return false;
  }

  bool hasAnyRole(List<String> roles) {
    return roles.any((role) => hasRole(role));
  }

  bool get isAdmin => hasRole('admin');
  bool get isManager => hasRole('manager');
  bool get isCashier => hasRole('cashier');
  bool get isCustomer => hasRole('customer');

  bool get canManageUsers => isAdmin || isManager;
  bool get canManageMenu => isAdmin || isManager;
  bool get canManageOrders => isAdmin || isManager || isCashier;

  // Utility methods
  String get displayName => name;
  String get avatarUrl => avatarPath ?? '';
  
  // Copy with method for easy updates
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    DateTime? emailVerifiedAt,
    String? phoneNumber,
    int? roleId,
    String? avatarPath,
    String? address,
    DateTime? dateOfBirth,
    String? preferredLocale,
    bool? isBanned,
    DateTime? bannedAt,
    int? failedDeliveriesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? rememberToken,
    String? roleName,
    List<String>? roleNames,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      roleId: roleId ?? this.roleId,
      avatarPath: avatarPath ?? this.avatarPath,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      preferredLocale: preferredLocale ?? this.preferredLocale,
      isBanned: isBanned ?? this.isBanned,
      bannedAt: bannedAt ?? this.bannedAt,
      failedDeliveriesCount: failedDeliveriesCount ?? this.failedDeliveriesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rememberToken: rememberToken ?? this.rememberToken,
      roleName: roleName ?? this.roleName,
      roleNames: roleNames ?? this.roleNames,
    );
  }
}
