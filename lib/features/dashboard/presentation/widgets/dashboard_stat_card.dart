import 'package:flutter/material.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact =
            constraints.maxHeight < 125 || constraints.maxWidth < 145;

        final padding = isCompact ? 12.0 : 16.0;
        final iconSize = isCompact ? 34.0 : 42.0;
        final valueFontSize = isCompact ? 21.0 : 25.0;
        final titleFontSize = isCompact ? 11.0 : 13.0;
        final spacing = isCompact ? 8.0 : 14.0;

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8EDF5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: iconSize,
                width: iconSize,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: isCompact ? 19 : 22),
              ),
              SizedBox(height: spacing),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF172B4D),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: const Color(0xFF718096),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
