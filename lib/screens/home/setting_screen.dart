import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mock user data - in a real app, this would come from your auth service
  final String _username = "admin";
  final String _userEmail = "admin@company.com";
  final String _userRole = "Quản trị viên";

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi hệ thống?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                _handleLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() {
    // Show logout confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã đăng xuất thành công'),
        backgroundColor: Colors.green,
      ),
    );
    GoRouter.of(context).go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cài đặt',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _username,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _userEmail,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _userRole,
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Settings Section
            Text(
              'Cài đặt ứng dụng',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 12),

            // // Dark Mode Toggle
            // Card(
            //   child: ListTile(
            //     leading: Container(
            //       padding: const EdgeInsets.all(8),
            //       decoration: BoxDecoration(
            //         color: Colors.purple.withOpacity(0.1),
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: Icon(
            //         widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            //         color: Colors.purple,
            //         size: 24,
            //       ),
            //     ),
            //     title: const Text(
            //       'Chế độ tối',
            //       style: TextStyle(fontWeight: FontWeight.w500),
            //     ),
            //     subtitle: Text(
            //       widget.isDarkMode 
            //           ? 'Đang sử dụng giao diện tối' 
            //           : 'Đang sử dụng giao diện sáng',
            //     ),
            //     trailing: Switch(
            //       value: widget.isDarkMode,
            //       onChanged: (value) {
            //         widget.onThemeChanged(value);
            //       },
            //       activeColor: theme.primaryColor,
            //     ),
            //   ),
            // ),

            // const SizedBox(height: 8),

            // Language Setting (Placeholder)
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.language,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Ngôn ngữ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Tiếng Việt'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tính năng đang được phát triển'),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Notifications Setting (Placeholder)
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Thông báo',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Quản lý thông báo ứng dụng'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tính năng đang được phát triển'),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Account Section
            Text(
              'Tài khoản',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 12),

            // Change Password (Placeholder)
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Thay đổi mật khẩu đăng nhập'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tính năng đang được phát triển'),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Logout Button
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Đăng xuất',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                subtitle: const Text('Thoát khỏi tài khoản hiện tại'),
                onTap: _showLogoutDialog,
              ),
            ),

            const SizedBox(height: 24),

            // App Info Section
            Text(
              'Thông tin ứng dụng',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: theme.primaryColor,
                        size: 24,
                      ),
                    ),
                    title: const Text(
                      'Phiên bản ứng dụng',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text('v1.0.0'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        color: Colors.teal,
                        size: 24,
                      ),
                    ),
                    title: const Text(
                      'Trợ giúp & Hỗ trợ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text('Liên hệ hỗ trợ kỹ thuật'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tính năng đang được phát triển'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}