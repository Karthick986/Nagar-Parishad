import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../model/sharedprefmodel.dart';

class AddPropertyApi {
  Future<Map<String, dynamic>> addPropertyService(surveyNo, zoneNo, wardNo, plotNo, propertyOld, propertyNew, address,
      propertyType, totalAreaF, rentStatus, rentAreaF, List floorId, constYear, constTypeId, usableTypeId, constAreaF, constAreaM,
      name, ownerAddress, contactNo, email, adhaarNo, BuildContext context) async {

    String url = "http://www.internsorbit.com:8080/nagarparishad/addproperty/";

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
        "total_area_in_meter": totalAreaF,
        "rent_status": rentStatus,
        "rent_area_in_foot": rentAreaF,
        "rent_area_in_meter": rentAreaF,
        "latitude": "21.1458",
        "longitude": "79.0882",
        "user_id": "CM74"
      },
      "construction_info": [
        {
          "floor_no": floorId[0],
          "construction_year": constYear[0],
          "construction_type_id": constTypeId[0],
          "usable_type_id": usableTypeId[0],
          "construction_area_foot": constAreaF[0],
          "construction_area_meter": constAreaM[0]
        },
        // {
        //   "floor_no": "FL18",
        //   "construction_year": "2020",
        //   "construction_type_id": "CT11",
        //   "usable_type_id": "UT11",
        //   "construction_area_foot": "2000",
        //   "construction_area_meter": "40"
        // }
      ],
      "evidence": [
      {
          "evidence": "",
          "type": "1"
        },
      ],
      "owner": {
        "name": name,
        "adddress": ownerAddress,
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