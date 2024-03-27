import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String id;
  final String serviceName;
  final String serviceDescription;
  final String serviceDate;
  final String servicePIC;
  final String serviceQuantity;
  final String imageUrl;

  Service({
    required this.id,
    required this.serviceName,
    required this.serviceDescription,
    required this.serviceDate,
    required this.servicePIC,
    required this.serviceQuantity,
    required this.imageUrl,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      serviceDescription: json ['serviceDescription'] ?? '',
      serviceDate: json ['serviceDate'] ?? '',
      servicePIC: json ['servicePIC'] ?? '',
      serviceQuantity: json ['serviceQuantity'] ?? '',
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
