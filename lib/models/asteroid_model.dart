import 'package:intl/intl.dart';

class AsteroidModel {
  final String name;
  final double diameterMin;
  final double diameterMax;
  final bool isHazardous;
  final String closeApproachDate;
  final DateTime? approachTime;
  final String velocity;
  final String missDistance;

  AsteroidModel({
    required this.name,
    required this.diameterMin,
    required this.diameterMax,
    required this.isHazardous,
    required this.closeApproachDate,
    required this.approachTime,
    required this.velocity,
    required this.missDistance,
  });

  String get formattedTime {
    if (approachTime != null) {
      return DateFormat('h:mm a').format(approachTime!);
    }
    return "00:00";
  }

  factory AsteroidModel.fromJson(Map<String, dynamic> json) {
    // Extract diameter
    final estimatedDiameter = json['estimated_diameter']['meters'];
    final double min =
        estimatedDiameter['estimated_diameter_min']?.toDouble() ?? 0.0;
    final double max =
        estimatedDiameter['estimated_diameter_max']?.toDouble() ?? 0.0;

    // Extract close approach data
    final List<dynamic> closeApproachData = json['close_approach_data'];
    final Map<String, dynamic> approach =
        closeApproachData.isNotEmpty ? closeApproachData[0] : {};

    // Robust Time Parsing
    DateTime? parsedTime;
    if (approach.isNotEmpty) {
      // 1. Try epoch first (most reliable)
      if (approach['epoch_date_close_approach'] != null) {
        parsedTime = DateTime.fromMillisecondsSinceEpoch(
            approach['epoch_date_close_approach']);
      }
      // 2. Fallback to full date string parsing
      else if (approach['close_approach_date_full'] != null) {
        try {
          // Expected: "2024-Sep-12 14:23"
          parsedTime = DateFormat("yyyy-MMM-dd HH:mm")
              .parse(approach['close_approach_date_full']);
        } catch (e) {
          // Parsing failed
        }
      }
    }

    return AsteroidModel(
      name: json['name'] ?? 'Unknown',
      diameterMin: min,
      diameterMax: max,
      isHazardous: json['is_potentially_hazardous_asteroid'] ?? false,
      closeApproachDate: approach['close_approach_date'] ?? 'Unknown',
      approachTime: parsedTime,
      velocity: approach['relative_velocity']?['kilometers_per_hour'] ?? '0',
      missDistance: approach['miss_distance']?['kilometers'] ?? '0',
    );
  }
}
