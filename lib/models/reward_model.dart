import 'package:cloud_firestore/cloud_firestore.dart';

class Reward {
  final String id;
  final String rewardName;
  final String rewardDescription;
  final String rewardDate;
  final String rewardPIC;
  final String rewardQuantity;
  final String rewardStatus;
  final String rewardPoint;
  final String imageUrl;

  Reward({
    required this.id,
    required this.rewardName,
    required this.rewardDescription,
    required this.rewardDate,
    required this.rewardQuantity,
    required this.rewardPIC,
    required this.rewardStatus,
    required this.rewardPoint,
    required this.imageUrl,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] ?? '',
      rewardName: json['rewardName'] ?? '',
      rewardDescription: json ['rewardDescription'] ?? '',
      rewardDate: json ['rewardDate'] ?? '',
      rewardPIC: json ['rewardPIC'] ?? '',
      rewardQuantity: json ['rewardQuantity'] ?? '',
      rewardStatus: json ['rewardQuantity'] ?? '',
      rewardPoint: json ['rewardPoint'] ?? '',
      imageUrl: _parseImageUrl(json['imageUrl']),
    );
  }
}

// Helper function to parse imageUrl
String _parseImageUrl(dynamic imageUrlData) {
  if (imageUrlData is String) {
    return imageUrlData; // Return imageUrl if it's already a String
  } else if (imageUrlData is List<dynamic>) {
    // If imageUrl is stored as a List, handle accordingly (e.g., take the first item)
    if (imageUrlData.isNotEmpty && imageUrlData[0] is String) {
      return imageUrlData[0]; // Return the first imageUrl if available
    } else {
      print('Invalid imageUrl format: $imageUrlData');
      return ''; // Return an empty string as a fallback
    }
  } else {
    print('Invalid imageUrl format: $imageUrlData');
    return ''; // Return an empty string as a fallback
  }
}
