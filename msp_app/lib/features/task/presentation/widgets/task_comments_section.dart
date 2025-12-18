import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msp_app/features/task/data/models/task_comment_dto.dart';

class TaskCommentsSection extends StatefulWidget {
  final List<TaskCommentDto> comments;
  final int totalComments;
  final Color statusColor;
  final String? highlightCommentId; // ✅ ADD
  final VoidCallback? onLoadMore;
  final VoidCallback? onReload;
  final bool isLoadingMore;
  final bool isReloading;

  const TaskCommentsSection({
    super.key,
    required this.comments,
    required this.totalComments,
    required this.statusColor,
    this.highlightCommentId, // ✅ ADD
    this.onLoadMore,
    this.onReload,
    this.isLoadingMore = false,
    this.isReloading = false,
  });

  @override
  State<TaskCommentsSection> createState() => _TaskCommentsSectionState();
}

class _TaskCommentsSectionState extends State<TaskCommentsSection> {
  // ✅ ADD: Map to store GlobalKeys for each comment
  final Map<String, GlobalKey> _commentKeys = {};
  String? _highlightedCommentId;

  @override
  void initState() {
    super.initState();

    // ✅ ADD: Set highlighted comment
    if (widget.highlightCommentId != null) {
      _highlightedCommentId = widget.highlightCommentId;

      // Scroll to specific comment after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToComment(widget.highlightCommentId!);

        // Remove highlight after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _highlightedCommentId = null;
            });
          }
        });
      });
    }
  }

  // ✅ ADD: Scroll to specific comment
  void _scrollToComment(String commentId) {
    try {
      debugPrint('');
      debugPrint('========================================');
      debugPrint('💬 [TaskCommentsSection] Scrolling to comment');
      debugPrint('💬 CommentId: $commentId');
      debugPrint('========================================');

      final key = _commentKeys[commentId];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.2, // Position in viewport
        );
        debugPrint('✅ [TaskCommentsSection] Scroll to comment executed');
      } else {
        debugPrint('❌ [TaskCommentsSection] Comment key/context not found');
      }
    } catch (e) {
      debugPrint('❌ [TaskCommentsSection] Scroll error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.statusColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.statusColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.comment_outlined,
                  size: 20,
                  color: widget.statusColor,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Reload button
              if (widget.onReload != null)
                IconButton(
                  onPressed: widget.isReloading ? null : widget.onReload,
                  icon: widget.isReloading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.statusColor,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.refresh,
                          size: 20,
                          color: widget.statusColor,
                        ),
                  tooltip: 'Reload comments',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),

              const SizedBox(width: 8),

              // Comment count badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.statusColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '${widget.totalComments}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: widget.statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Comments List
          if (widget.comments.isEmpty)
            _buildEmptyState()
          else
            ...widget.comments.map((comment) {
              // ✅ CREATE: GlobalKey for each comment
              _commentKeys.putIfAbsent(comment.id, () => GlobalKey());
              return _buildCommentItem(comment);
            }),

          // Load More Button
          if (widget.comments.isNotEmpty &&
              widget.comments.length < widget.totalComments)
            _buildLoadMoreButton(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.comment_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No comments yet',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Be the first to comment!',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(TaskCommentDto comment) {
    // ✅ CHECK: Is this the highlighted comment?
    final isHighlighted = _highlightedCommentId == comment.id;

    return Container(
      key: _commentKeys[comment.id], // ✅ ASSIGN KEY
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // ✅ HIGHLIGHT: Yellow background if highlighted
        color: isHighlighted
            ? Colors.amber.shade100
            : widget.statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // ✅ HIGHLIGHT: Thicker border if highlighted
          color: isHighlighted
              ? Colors.amber.shade600
              : widget.statusColor.withOpacity(0.2),
          width: isHighlighted ? 2.5 : 1,
        ),
        // ✅ HIGHLIGHT: Box shadow if highlighted
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: Colors.amber.shade300,
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.statusColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  image: comment.user?.avatarUrl.isNotEmpty == true
                      ? DecorationImage(
                          image: NetworkImage(comment.user!.avatarUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: comment.user?.avatarUrl.isEmpty != false
                    ? Icon(Icons.person, size: 20, color: widget.statusColor)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            comment.user?.fullName ?? 'Unknown User',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // ✅ HIGHLIGHT: Show badge if highlighted
                        if (isHighlighted)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade600,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(comment.createdAt),
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (comment.user?.role.isNotEmpty == true)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    comment.user!.role,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: widget.statusColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment.content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.isLoadingMore ? null : widget.onLoadMore,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.statusColor.withOpacity(0.1),
          foregroundColor: widget.statusColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: widget.statusColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
        ),
        icon: widget.isLoadingMore
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.statusColor),
                ),
              )
            : const Icon(Icons.expand_more, size: 20),
        label: Text(
          widget.isLoadingMore
              ? 'Loading...'
              : 'Load More (${widget.totalComments - widget.comments.length} remaining)',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
