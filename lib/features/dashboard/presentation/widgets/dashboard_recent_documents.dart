import 'package:flutter/material.dart';

class DashboardRecentDocuments extends StatelessWidget {
  const DashboardRecentDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Documents',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 8),
        const _DocumentItem(
          name: 'Project Proposal.pdf',
          details: 'PDF • 2.4 MB • 16 Nov 2026',
          status: 'Approved',
          icon: Icons.picture_as_pdf_rounded,
          iconColor: Color(0xFFE53935),
          statusColor: Color(0xFF16A36A),
        ),
        const _DocumentItem(
          name: 'Employee Report.docx',
          details: 'DOCX • 1.2 MB • 15 Nov 2026',
          status: 'Pending',
          icon: Icons.description_rounded,
          iconColor: Color(0xFF2457D6),
          statusColor: Color(0xFFEA9B24),
        ),
        const _DocumentItem(
          name: 'Monthly Budget.xlsx',
          details: 'XLSX • 850 KB • 14 Nov 2026',
          status: 'Approved',
          icon: Icons.table_chart_rounded,
          iconColor: Color(0xFF16A36A),
          statusColor: Color(0xFF16A36A),
        ),
      ],
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final String name;
  final String details;
  final String status;
  final IconData icon;
  final Color iconColor;
  final Color statusColor;

  const _DocumentItem({
    required this.name,
    required this.details,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172B4D),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, color: Color(0xFF718096)),
        ],
      ),
    );
  }
}
