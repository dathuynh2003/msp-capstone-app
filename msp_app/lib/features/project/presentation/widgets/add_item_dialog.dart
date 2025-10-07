import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/project.dart';
import 'task_dialogs.dart';

/// Add Item Dialog - Dialog để thêm milestone, task, meeting
class AddItemDialog extends StatelessWidget {
  final Project? project;
  
  const AddItemDialog({Key? key, this.project}) : super(key: key);

  static void show(BuildContext context, {Project? project}) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm mới'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.flag, color: Colors.orange),
            title: const Text('Thêm Cột mốc'),
            onTap: () {
              Navigator.pop(context);
              _showCreateMilestoneDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.task, color: Colors.orange),
            title: const Text('Thêm Nhiệm vụ'),
            onTap: () {
              Navigator.pop(context);
              if (project != null) {
                TaskDialogs.showCreateTaskDialog(context, project!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Không thể tạo nhiệm vụ: Thiếu thông tin dự án'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.meeting_room, color: Colors.orange),
            title: const Text('Thêm Cuộc họp'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chức năng thêm Cuộc họp sẽ được implement')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCreateMilestoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final titleController = TextEditingController();
        final descriptionController = TextEditingController();
        DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
        
        // Mock: collect all tasks names within project
        final List<String> allTasks = _collectProjectTaskNames();
        final Set<String> selectedTasks = {};

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.add_task, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text('Thêm cột mốc', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              icon: const Icon(Icons.close, color: Colors.white, size: 18),
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
                              _buildLabeledTextField('Tên cột mốc', 'Nhập tên cột mốc', titleController),
                              const SizedBox(height: 10),
                              _buildLabeledTextField('Mô tả', 'Nhập mô tả', descriptionController, maxLines: 3),
                              const SizedBox(height: 10),
                              _buildDatePickerField(context, 'Ngày hết hạn', selectedDate, (date) {
                                if (date != null) {
                                  selectedDate = date;
                                }
                              }),
                              const SizedBox(height: 12),
                              const Text('Chọn nhiệm vụ liên kết', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                              const SizedBox(height: 6),
                              if (allTasks.isEmpty)
                                Text('Chưa có nhiệm vụ nào', style: TextStyle(fontSize: 12, color: Colors.grey[600]))
                              else
                                ...allTasks.map((taskName) => CheckboxListTile(
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
                                      title: Text(taskName, style: const TextStyle(fontSize: 12)),
                                      activeColor: Colors.orange,
                                    )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                          border: Border(top: BorderSide(color: Colors.grey.shade200)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                                child: const Text('Hủy', style: TextStyle(fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Đã tạo cột mốc mới'), backgroundColor: Colors.green),
                                  );
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 8)),
                                child: const Text('Tạo', style: TextStyle(fontSize: 14)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLabeledTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(BuildContext context, String label, DateTime date, ValueChanged<DateTime?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
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
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text('${date.day}/${date.month}/${date.year}', style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Mock: collect all tasks names within project
  List<String> _collectProjectTaskNames() {
    // Mock data - in real app, this would come from project.tasks
    return [
      'Thiết kế UI/UX',
      'Phát triển Backend API',
      'Tích hợp Database',
      'Testing và Debug',
      'Deploy lên Production',
    ];
  }
}
