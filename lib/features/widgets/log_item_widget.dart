import 'package:flutter/material.dart';
import 'package:logbook_app_077/features/logbook/models/log_model.dart';

class LogItemWidget extends StatelessWidget {
  final LogModel log;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LogItemWidget({
    super.key,
    required this.log,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getCategoryColor() {
    switch (log.category) {
      case "Urgent":
        return const Color.fromARGB(255, 255, 240, 240); 
      case "Pekerjaan":
        return const Color.fromARGB(255, 232, 244, 253); 
      case "Pribadi":
        return const Color.fromARGB(255, 243, 229, 245); 
      default:
        return const Color.fromARGB(255, 255, 255, 255); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 158, 101, 140);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getCategoryColor(), 
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack( 
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                log.timestamp,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                log.title,
                style: const TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                log.description,
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.black.withValues(alpha: 0.7), 
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCircularButton(
                  icon: Icons.edit_rounded,
                  iconColor: primaryColor,
                  onTap: onEdit,
                ),
                const SizedBox(width: 10),
                _buildCircularButton(
                  icon: Icons.delete_rounded,
                  iconColor: const Color.fromARGB(255, 239, 83, 80), 
                  onTap: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255).withValues(alpha: 0.6), 
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}