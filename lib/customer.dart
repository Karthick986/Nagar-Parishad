import 'dbhelper.dart';

class Customer {
  late String surveyNo, zoneNo, wardNo, plotNo, propertyNoOld, propertyNoNew,
      address, totalAreaF, totalAreaM, rentAreaF, rentAreaM, propertyType, rentStatus;

  // Car(this.surveyNo, this.zoneNo, this.wardNo);

  Customer.fromMap(Map<String, dynamic> map) {
    surveyNo = map['survey_no'];
    zoneNo = map['zone_no'];
    wardNo = map['ward_no'];
    plotNo = map['plot_no'];
    propertyNoOld = map['propertyno_old'];
    propertyNoNew = map['propertyno_new'];
    address = map['address'];
    totalAreaF = map['totalarea_foot'];
    totalAreaM = map['totalarea_meter'];
    rentAreaM = map['rentarea_meter'];
    rentAreaF = map['rentarea_foot'];
    propertyType = map['property_type'];
    rentStatus = map['rent_status'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.surveyNo: surveyNo,
      DatabaseHelper.zoneNo: zoneNo,
      DatabaseHelper.wardNo: wardNo,
      DatabaseHelper.wardNo: plotNo,
      DatabaseHelper.wardNo: propertyNoOld,
      DatabaseHelper.wardNo: propertyNoNew,
      DatabaseHelper.wardNo: address,
      DatabaseHelper.wardNo: totalAreaF,
      DatabaseHelper.wardNo: totalAreaM,
      DatabaseHelper.wardNo: rentAreaM,
      DatabaseHelper.wardNo: rentAreaF,
      DatabaseHelper.wardNo: propertyType,
      DatabaseHelper.wardNo: rentStatus,
    };
  }
}