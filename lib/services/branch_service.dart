import 'package:clinicease/models/branch_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BranchService {
  final CollectionReference branchCollection = FirebaseFirestore.instance.collection('branch');

  Future<List<BranchModel>> getBranches() async {
    List<BranchModel> branches = [];

    try {
      QuerySnapshot querySnapshot = await branchCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        BranchModel branch = BranchModel.fromJson(data);
        branch.branchId = doc.id;
        branches.add(branch);
      }
    } catch (e) {
      print("Error getting services: $e");
    }

    return branches;
  }

}


