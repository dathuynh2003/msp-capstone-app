import 'package:flutter/material.dart';

class ModernProjectCard extends StatelessWidget {
  final String title;
  final String? description;
  final String owner;
  final String startDate;
  final String? endDate;
  final Color color;
  final VoidCallback? onTap;

  const ModernProjectCard({
    super.key,
    required this.title,
    this.description,
    required this.owner,
    required this.startDate,
    this.endDate,
    this.onTap,
    this.color = const Color(0xFFFFD7BA), // ✅ Pastel default
  });

  String formatDate(String dt) {
    if (dt.length >= 10) {
      final parts = dt.substring(0, 10).split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    }
    return dt;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        // ✅ PASTEL gradient - nhẹ nhàng hơn
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            Color.lerp(
              color,
              Colors.white,
              0.3,
            )!, // ✅ Blend with white for pastel
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2), // ✅ Very soft shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          0.6,
                        ), // ✅ More white for pastel
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.folder_special,
                        color: Color(
                          0xFFFF9966,
                        ), // ✅ Brighter icon for contrast
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 119, 22),
                              height: 1.3,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (description != null &&
                              description!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              description!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black, // ✅ Medium brown
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Divider
                Divider(
                  color: Colors.white.withOpacity(0.6), // ✅ Lighter divider
                  height: 1,
                ),

                const SizedBox(height: 12),

                // Footer info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Manager info
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 14,
                              color: Color(0xFFFF9966),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              owner,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6D4C41),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Timeline
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Color(0xFFFF9966),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '${formatDate(startDate)} - ${endDate != null && endDate!.isNotEmpty ? formatDate(endDate!) : "N/A"}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6D4C41),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
