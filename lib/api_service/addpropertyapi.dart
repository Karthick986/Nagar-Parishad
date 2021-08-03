import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../model/sharedprefmodel.dart';

class AddPropertyApi {
  Future<Map<String, dynamic>> addPropertyService(surveyNo, zoneNo, wardNo, plotNo, propertyOld, propertyNew, address,
      propertyType, totalAreaF, totalAreaM, rentStatus, rentAreaF, rentAreaM, floorId, constYear, constTypeId, usableTypeId,
      constAreaF, constAreaM, name, ownerAddress, contactNo, email, adhaarNo, BuildContext context) async {

    String url = "http://www.internsorbit.com:8080/nagarparishad/addproperty/";

    List<Map> carOptionJson = [];
    for (int i=0; i<floorId.length; i++) {
      ConstInfo constInfoList = ConstInfo(
          floorId[i], constYear[i], constTypeId[i], usableTypeId[i],
          constAreaF[i], constAreaM[i]);
      carOptionJson.add(constInfoList.TojsonData());
    }

    var body = {
      "basic_info": {
        "survey_no": surveyNo,
        "zone_name": zoneNo,
        "ward_name": wardNo,
        "plot_no": plotNo,
        "property_no_old": propertyOld,
        "property_no_new": propertyNew,
        "address": address,
        "property_type": propertyType,
        "total_area_in_foot": totalAreaF,
        "total_area_in_meter": totalAreaM,
        "rent_status": rentStatus,
        "rent_area_in_foot": rentAreaF,
        "rent_area_in_meter": rentAreaM,
        "latitude": "21.1458",
        "longitude": "79.0882",
        "user_id": "CM74"
      },
      "construction_info":
        carOptionJson,
      "evidence": [
      {
          "evidence": "",
          "type": "1"
        },
      ],
      "owner": {
        "name": name,
        "address": ownerAddress,
        "contact_no": contactNo,
        "email": email,
        "aadhar_no": adhaarNo
      }
    };

    Map<String, dynamic> responseData;

    final response = await http.post(Uri.parse(url),
        headers: {
          "auth_key": SharedPrefsModel().getAuthKey(),
          'email': SharedPrefsModel().getEmail(),
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body)
    );

    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
      if (responseData['status'] != 200) {
       _displaySnackBar(context);
      }
    } else {
      _displaySnackBar(context);
      throw Exception();
    }
    return responseData;
  }

  _displaySnackBar(BuildContext context) {
    const snackBar = SnackBar(content: Text('Error occurred!'));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

class ConstInfo {
  String floorId, constYear, constTypeId, usableTypeId, constAreaF, constAreaM;
  ConstInfo(this.floorId, this.constYear, this.constTypeId, this.usableTypeId, this.constAreaF, this.constAreaM);
  Map<String, dynamic> TojsonData() {
    var map = new Map<String, dynamic>();
    map["floor_id"] = floorId;
    map["const_year"] = constYear;
    map["const_type_id"] = constTypeId;
    map["usable_type_id"] = usableTypeId;
    map["const_area_foot"] = constAreaF;
    map["const_area_meter"] = constAreaM;
    return map;
  }
}