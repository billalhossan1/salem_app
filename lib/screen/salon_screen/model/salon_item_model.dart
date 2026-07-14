import 'package:get/get.dart';

class SalonItemModel {
  final String id;
  final String createdBy;
  final Admin admin;
  final String businessName;
  final String businessType;
  final String city;
  final String subscriptionType;
  final String startDate;
  final String expiryDate;
  final String salonId;
  final String phone;
  final String email;
  final String activeStatus;
  final String description;

  final String location;
  final String distance;
  final String service;
  final String lat;
  final String lon;
  final bool isVisited;
  final List<OpeningTime> openingTime;
  final String createdAt;
  final String updatedAt;
  final int v;
  final int visitor;
  final bool isRewardAvailable;

  SalonItemModel({
    required this.id,
    required this.createdBy,
    required this.admin,
    required this.businessName,
    required this.businessType,
    required this.city,
    required this.subscriptionType,
    required this.startDate,
    required this.expiryDate,
    required this.salonId,
    required this.phone,
    required this.email,
    required this.activeStatus,
    required this.description,
    required this.location,
    required this.service,
    required this.openingTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.visitor,
    required this.isRewardAvailable,
    required this.lat,
    required this.lon, required this.distance, required this.isVisited,
  });

  factory SalonItemModel.empty() {
    return SalonItemModel(
      id: '',
      createdBy: '',
      admin: Admin.empty(),
      businessName: '',
      businessType: '',
      city: '',
      subscriptionType: '',
      startDate: '',
      expiryDate: '',
      salonId: '',
      phone: '',
      email: '',
      activeStatus: '',
      description: '',
      location: '',
      service: '',
      openingTime: [],
      createdAt: '',
      updatedAt: '',
      v: 0,
      visitor: 0,
      isRewardAvailable: false,
      lat: '',
      lon: '', distance: '',isVisited: false
    );
  }

  factory SalonItemModel.fromJson(Map<String, dynamic> json) {
    return SalonItemModel(
      id: json['_id']?.toString() ?? '',
      createdBy: json['createdBy']?.toString() ?? '',
      admin: json['admin'] != null
          ? Admin.fromJson(json['admin'])
          : Admin.empty(),
      businessName: json['businessName']?.toString() ?? '',
      businessType: json['businessType']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      subscriptionType: json['subscriptionType']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      expiryDate: json['expiryDate']?.toString() ?? '',
      salonId: json['salonId']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      activeStatus: json['activeStatus']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      service: json['service']?.toString() ?? '',
      openingTime:
          (json['openingTime'] as List?)
              ?.map((e) => OpeningTime.fromJson(e))
              .toList() ??
          [],
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      v: json['__v'] is int
          ? json['__v']
          : int.tryParse(json['__v']?.toString() ?? '') ?? 0,
      visitor: json['visitor'] is int
          ? json['visitor']
          : int.tryParse(json['visitor']?.toString() ?? '') ?? 0,
      isRewardAvailable: json['isRewardAvailable'] ?? false,
     isVisited: json['isVisited'] ??false, lat: json['lat']?.toString() ?? '',
      lon: json['lon']?.toString() ?? '', distance: json['distance']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'createdBy': createdBy,
      'admin': admin.toJson(),
      'businessName': businessName,
      'businessType': businessType,
      'city': city,
      'subscriptionType': subscriptionType,
      'startDate': startDate,
      'expiryDate': expiryDate,
      'salonId': salonId,
      'phone': phone,
      'email': email,
      'activeStatus': activeStatus,
      'description': description,
      'location': location,
      'service': service,
      'openingTime': openingTime.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'visitor': visitor,
      'isRewardAvailable': isRewardAvailable,
    };
  }
}

class Admin {
  final String id;
  final String name;
  final String email;
  final String image;

  Admin({required this.id, required this.name, required this.email,required this.image});

  factory Admin.empty() {
    return Admin(id: '', name: '', email: '',image: '');
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'email': email,'image': image};
  }
}

class OpeningTime {
  final String id;
  final String day;
  final String openingTime;
  final String closingTime;
  final bool isClosed;

  OpeningTime({
    required this.id,
    required this.day,
    required this.openingTime,
    required this.closingTime,
    required this.isClosed,
  });

  factory OpeningTime.empty() {
    return OpeningTime(
      id: '',
      day: '',
      openingTime: '',
      closingTime: '',
      isClosed: false,
    );
  }

  factory OpeningTime.fromJson(Map<String, dynamic> json) {
    return OpeningTime(
      id: json['_id']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
      openingTime: json['openingTime']?.toString() ?? '',
      closingTime: json['closingTime']?.toString() ?? '',
      isClosed: json['isClosed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'day': day,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'isClosed': isClosed,
    };
  }
}
