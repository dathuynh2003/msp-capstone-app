import 'package:flutter/material.dart';

/// PM Projects Header Section - Hiển thị header cho danh sách dự án trong PM Dashboard
class PMProjectsHeaderSection extends StatelessWidget {
  final VoidCallback onViewAllProjects;

  const PMProjectsHeaderSection({
    super.key,
    required this.onViewAllProjects,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Dự án gần đây',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: onViewAllProjects,
            child: const Text('Xem tất cả', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
