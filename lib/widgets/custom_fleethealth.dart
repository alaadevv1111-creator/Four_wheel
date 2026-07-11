import 'package:flutter/material.dart';

class FleetHealthCard extends StatelessWidget {
  final int maintenanceCount;
  final int cleaningCount;

  const FleetHealthCard({
    super.key,
    required this.maintenanceCount,
    required this.cleaningCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "FLEET HEALTH",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xff6B7280),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),

            _FleetItem(
              title: "Maintenance Due",
              value: "$maintenanceCount CARS",
              color: const Color(0xffDC2626),
            ),

            const SizedBox(height: 12),

            _FleetItem(
              title: "In Cleaning",
              value: "$cleaningCount CARS",
              color: const Color(0xff2563EB),
            ),
          ],
        ),
      ),
    );
  }
}

class _FleetItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _FleetItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff374151),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}