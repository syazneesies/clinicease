import 'package:json_annotation/json_annotation.dart';

// Create a ImageUrlConverter class
class ImageUrlConverter implements JsonConverter<String, dynamic> {
  const ImageUrlConverter();

  @override
  String fromJson(dynamic imageUrlData) {
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

  @override
  dynamic toJson(String imageUrl) => imageUrl;
}