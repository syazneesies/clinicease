import 'package:clinicease/helpers/geopoint_json.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'branch_model.g.dart';

@JsonSerializable()
class BranchModel {
  String? branchId;
  final String? branchName;
  @GeoPointConverter()
  final GeoPoint? branchLocation;

  BranchModel(
    this.branchId,
    this.branchName, 
    this.branchLocation,
  );

  factory BranchModel.fromJson(Map<String, dynamic> json)=> _$BranchModelFromJson(json);
  Map<String, dynamic> toJson() => _$BranchModelToJson(this);

  
}