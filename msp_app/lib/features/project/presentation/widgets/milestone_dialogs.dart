import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/project.dart';

/// Dialog widgets for milestone operations
class MilestoneDialogs {
  static void showCreateMilestoneDialog(BuildContext context, Project project) {
    _showMilestoneDialog(context, project, isUpdate: false);
  }

  static void showUpdateMilestoneDialog(BuildContext context, Project project, int milestoneIndex) {
    _showMilestoneDialog(context, project, isUpdate: true, milestoneIndex: milestoneIndex);
  }

  static void _showMilestoneDialog(
    BuildContext context,
    Project project, {
    required bool isUpdate,
    int? milestoneIndex,
  }) {
    final titleController = TextEditingController(
      text: isUpdate ? project.milestones[milestoneIndex!].title : '',
    );
    final descriptionController = TextEditingController(
      text: isUpdate ? project.milestones[milestoneIndex!].description : '',
    );
    DateTime selectedDate = isUpdate
        ? project.milestones[milestoneIndex!].dueDate
        : DateTime.now().add(const Duration(days: 7));

    // Mock: collect all tasks names within project (if schema available)
    final List<String> allTasks = _collectProjectTaskNames(project);
    final Set<String> selectedTasks = {
      if (isUpdate) ..._collectMilestoneTaskNames(project, milestoneIndex!),
    };

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isUpdate ? Icons.edit : Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isUpdate ? 'Cập nhật cột mốc' : 'Tạo cột mốc',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabeledTextField(
                            'Tên cột mốc',
                            'Nhập tên cột mốc',
                            titleController,
                          ),
                          const SizedBox(height: 10),
                          _buildLabeledTextField(
                            'Mô tả',
                            'Nhập mô tả',
                            descriptionController,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 10),
                          _buildDatePickerField(
                            context,
                            'Ngày hết hạn',
                            selectedDate,
                            (date) {
                              if (date != null) {
                                selectedDate = date;
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Chọn nhiệm vụ liên kết',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (allTasks.isEmpty)
                            Text(
                              'Chưa có nhiệm vụ nào',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            )
                          else
                            ...allTasks.map(
                              (taskName) => CheckboxListTile(
                                value: selectedTasks.contains(taskName),
                                onChanged: (v) {
                                  if (v == true) {
                                    selectedTasks.add(taskName);
                                  } else {
                                    selectedTasks.remove(taskName);
                                  }
                                  setDialogState(() {});
                                },
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  taskName,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                activeColor: Colors.orange,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text(
                              'Hủy',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isUpdate
                                        ? 'Đã cập nhật cột mốc'
                                        : 'Đã tạo cột mốc mới',
                                  ),
                                  backgroundColor: isUpdate
                                      ? Colors.blue
                                      : Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: Text(
                              isUpdate ? 'Cập nhật' : 'Tạo',
                              style: const TextStyle(fontSize: 14),
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
        ),
      ),
    );
  }

  static Widget _buildLabeledTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildDatePickerField(
    BuildContext context,
    String label,
    DateTime date,
    ValueChanged<DateTime?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
            );
            onChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static List<String> _collectProjectTaskNames(Project project) {
    // Best-effort extraction of task names; depends on your data model
    final List<String> names = [];
    for (final m in project.milestones) {
      // m.tasks may be a list of task objects with a 'title' or 'name' field
      try {
        // ignore: avoid_dynamic_calls
        for (final t in m.tasks) {
          final dynamic title = t.title;
          names.add(title.toString());
        }
      } catch (_) {
        // If structure unknown, skip
      }
    }
    return names.toSet().toList();
  }

  static List<String> _collectMilestoneTaskNames(Project project, int milestoneIndex) {
    final List<String> names = [];
    final m = project.milestones[milestoneIndex];
    try {
      for (final t in m.tasks) {
        final dynamic title = t.title;
        names.add(title.toString());
      }
    } catch (_) {}
    return names.toSet().toList();
  }
}
