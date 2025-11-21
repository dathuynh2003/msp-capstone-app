import 'package:flutter/material.dart';
import 'folder_clipper.dart';
import 'package:marquee/marquee.dart';

class FolderProjectCard extends StatelessWidget {
  final String title;
  final String? description;
  final String owner;
  final String startDate;
  final String? endDate;
  final Color color;
  final VoidCallback? onTap;

  const FolderProjectCard({
    super.key,
    required this.title,
    this.description,
    required this.owner,
    required this.startDate,
    this.endDate,
    this.onTap,
    this.color = const Color(0xFFFFA463),
  });

  String formatDate(String dt) {
    // Chuyển dạng ISO sang dd/MM/yyyy
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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipPath(
              clipper: FolderClipper(),
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.08),
                      blurRadius: 14,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(5, 12, 5, 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.folder_special, color: color, size: 18),
                        SizedBox(width: 7),
                        Expanded(
                          child: title.length > 13
                              ? SizedBox(
                                  height:
                                      20, // chiều cao 1 dòng text, điều chỉnh cho fit
                                  child: Marquee(
                                    text: title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                      fontSize: 16,
                                      letterSpacing: 0.1,
                                    ),
                                    scrollAxis: Axis.horizontal,
                                    velocity: 35,
                                    blankSpace: 32,
                                    pauseAfterRound: Duration(seconds: 2),
                                    startAfter: Duration(milliseconds: 700),
                                  ),
                                )
                              : Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                    fontSize: 16,
                                    letterSpacing: 0.1,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9), // spacing dưới title
                    if (description != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mô tả: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                description!,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Text(
                          'Project Manager: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            owner,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Thời gian: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          formatDate(startDate) +
                              (endDate != null && endDate!.isNotEmpty
                                  ? ' - ${formatDate(endDate!)}'
                                  : ''),
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
