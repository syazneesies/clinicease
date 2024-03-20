// import 'package:flutter/material.dart';
// import '../models/user_model.dart'; // Import the model

// class ProfilePage extends StatelessWidget {
//   final Profile profile; // Use the Profile model here

//   ProfilePage({required this.profile});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('My Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Profile Details',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             ProfileDetailRow(label: 'Full Name', value: profile.fullName),
//             ProfileDetailRow(label: 'Birthdate', value: profile.birthdate.toString()),
//             ProfileDetailRow(label: 'Identification Number', value: profile.identificationNumber),
//             ProfileDetailRow(label: 'Phone Number', value: profile.phoneNumber),
//             ProfileDetailRow(label: 'Email', value: profile.email),
//             ProfileDetailRow(label: 'Gender', value: profile.gender),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfileDetailRow extends StatelessWidget {
//   final String label;
//   final String value;

//   ProfileDetailRow({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 1,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(width: 20),
//           Expanded(
//             flex: 2,
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
// }

