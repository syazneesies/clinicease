import 'package:flutter/material.dart';
import 'package:clinicease/models/service_model.dart';
import 'package:clinicease/services/services_service.dart';
import 'package:clinicease/models/user_model.dart';
import 'package:clinicease/services/auth_service.dart';
import 'package:clinicease/services/storage_service.dart';

class ServiceConfirmationScreen extends StatefulWidget {
  const ServiceConfirmationScreen({Key? key, required this.serviceId, required this.user }) : super(key: key);

  final String serviceId;
  final UserModel user;

  @override
  State<ServiceConfirmationScreen> createState() => _ServiceConfirmationState();
}

class _ServiceConfirmationState extends State<ServiceConfirmationScreen> {
  late Future<ServiceModel?> _serviceDataFuture;
  final ServiceService _serviceService = ServiceService(); 
  final AuthService _authService = AuthService();
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = StorageService.getUID();

    onRefresh();
  }

  onRefresh() {
    setState(() {
      _serviceDataFuture = _serviceService.getServiceData(widget.serviceId); 
    });

    _serviceDataFuture.then((service) {
      if (service != null) {
        print('Service UID fetched: ${widget.serviceId}');
      } else {
        print('Service data not found');
      }
    });

    _authService.getUserData('Service UID fetched: ${widget.user}');
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}