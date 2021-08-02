// ignore_for_file: unused_field

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'construction_info.dart';
import 'package:nagar_parishad/dbhelper.dart';
import '../model/sharedprefmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../customer.dart';
import '../main.dart';

late SharedPreferences prefs;

class BasicInfo extends StatefulWidget {
  const BasicInfo({Key? key}) : super(key: key);

  @override
  _BasicInfoState createState() => _BasicInfoState();

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }
}

class _BasicInfoState extends State<BasicInfo> {

  bool isLoading = false;
  double footTometer = 0.3048;

  double initialtotalArea = 0.0, initialRentArea = 0.0;

  late String surveyNo,
      plotNo,
      propertyNoOld,
      propertyNoNew,
      address,
      totalAreaF,
      rentAreaF;

  // ignore: prefer_final_fields
  TextEditingController _controller = TextEditingController();

  // ignore: prefer_final_fields
  bool _enabled = false;

  final dbHelper = DatabaseHelper.instance;

  // ignore: prefer_final_fields
  var _formKey = GlobalKey<FormState>();
  dynamic _zoneSelected, _wardSelected, _propertyType, _rentStatus;
  List zoneList=[], wardList=[], propertyList=[], rentList = [{'status': 'Yes', 'rent_id': '1'}, {'status': 'No', 'rent_id': '0'}];

  Future<String> getZoneList() async {
    String link = "http://www.internsorbit.com:8080/nagarparishad/zonelistmob/";

    await SharedPrefsModel.init();
    // ignore: avoid_print
    print(SharedPrefsModel().getAuthKey());

    var res = await http.post(
      Uri.parse(link),

      headers: {
        "auth_key": SharedPrefsModel().getAuthKey(),
        'email': SharedPrefsModel().getEmail()
      },
    );
    var resBody = json.decode(res.body);

    setState(() {
      zoneList = resBody['data'];
    });

    return "Success";
  }

  Future<String> getPropertyList() async {
    String link = "http://www.internsorbit.com:8080/nagarparishad/proplistmob/";

    await SharedPrefsModel.init();

    var res = await http.post(
      Uri.parse(link),
      headers: {
        "auth_key": SharedPrefsModel().getAuthKey(),
        'email': SharedPrefsModel().getEmail()
      },
    );
    var resBody = json.decode(res.body);

    setState(() {
      propertyList = resBody['data'];
    });

    return "Success";
  }

  Future<String> getWardList() async {
    String link = "http://www.internsorbit.com:8080/nagarparishad/wardlistmob/$_zoneSelected";

    await SharedPrefsModel.init();

    var res = await http.post(
      Uri.parse(link),

      headers: {
        "auth_key": SharedPrefsModel().getAuthKey(),
        'email': SharedPrefsModel().getEmail()
      },
    );
    var resBody = json.decode(res.body);

    setState(() {
      wardList = resBody['data'];
    });

    return "Success";
  }

  _displaySnackBar(BuildContext context) {
    const snackBar = SnackBar(content: Text('Please fill all details!'));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _submit(BuildContext context) {
    _formKey.currentState!.save();
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      isLoading = true;

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ConstructionInfo(surveyNo: surveyNo, zoneNo: _zoneSelected, wardNo: _wardSelected,
          plotNo: plotNo, propertyOld: propertyNoOld, propertyNew: propertyNoNew, address: address, propertyType: _propertyType,
          totalAreaF: totalAreaF, rentStatus: _rentStatus, rentAreaF: rentAreaF)));

      isLoading = false;
      // _insert(surveyNo, _zoneSelected, _wardSelected, plotNo, propertyNoOld, propertyNoNew,
      // address, totalAreaF, initialtotalArea.toString(), rentAreaF, initialRentArea.toString(), _propertyTypeSelected, _rentStatusSelected);
    });
  }

  Future _insert(
      surveyNo,
      zoneNo,
      wardNo,
      plotNo,
      propertyNoOld,
      propertyNoNew,
      address,
      totalAreaF,
      totalAreaM,
      rentAreaF,
      rentAreaM,
      propertyType,
      rentStatus) async {
    Map<String, dynamic> row = {
      DatabaseHelper.surveyNo: surveyNo,
      DatabaseHelper.zoneNo: zoneNo,
      DatabaseHelper.wardNo: wardNo,
      DatabaseHelper.plotNo: plotNo,
      DatabaseHelper.propertyNoOld: propertyNoOld,
      DatabaseHelper.propertyNoNew: propertyNoNew,
      DatabaseHelper.address: address,
      DatabaseHelper.totalAreaF: totalAreaF,
      DatabaseHelper.totalAreaM: totalAreaM,
      DatabaseHelper.rentAreaF: rentAreaF,
      DatabaseHelper.rentAreaM: rentAreaM,
      DatabaseHelper.propertyType: propertyType,
      DatabaseHelper.rentStatus: rentStatus,
    };

    Customer car = Customer.fromMap(row);
    final id = await dbHelper.insert(car);
    _showMessageInScaffold('inserted row id: $id');

    isLoading = false;

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ConstructionInfo()));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  // Future<void> zoneapiService() async {
  //   ZoneApi apiService = ZoneApi();
  //   await apiService.zoneApiService().then((value) {
  //
  //   });
  // }

  @override
  void initState() {
    super.initState();
    BasicInfo.init();
    getZoneList();
    getPropertyList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Basic Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BasicInfo.init();

              showDialog(
                context: context,
                builder: (ctx) =>
                    AlertDialog(
                      actionsPadding: const EdgeInsets.all(20.0),
                      titlePadding: const EdgeInsets.all(20.0),
                      title: const Text("Are you sure want to logout!", style: TextStyle(fontSize: 15.0),),
                      actions: [
                       Row(
                         children: [
                           Expanded(child: GestureDetector(
                             onTap: () {
                               Navigator.of(ctx).pop();
                             },
                             child: const Text("No", textAlign: TextAlign.center,),
                           ),),
                           Expanded(child: GestureDetector(
                             onTap: () {
                               BasicInfo.init();
                               Navigator.of(ctx).pop();
                               prefs.clear();
                               prefs.commit();
                               Navigator.pushReplacement(context,
                                   MaterialPageRoute(builder: (context) => const Login()));
                             },
                             child: const Text("Yes", textAlign: TextAlign.center,),
                           ),),
                         ],
                        )
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body:  Builder(
    builder: (context) => Form(
        key: _formKey,
        child: Column(children: [
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              thickness: 5.0,
              radius: const Radius.circular(10.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: const Text('Survey number: '),
                            margin: const EdgeInsets.only(
                              top: 20.0,
                              left: 15.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.left,
                              onSaved: (value) => surveyNo = value!,
                              validator: (value) {
                                if (value!.isEmpty) return 'Enter survey no.';
                                return null;
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(5.0),
                              ),
                            ),
                            margin:
                                const EdgeInsets.only(top: 10.0, right: 10.0),
                          ),
                        ),
                      ],
                    ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Zone number: '),
                          margin: const EdgeInsets.only(top: 15.0, left: 15.0),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 5.0, right: 10.0, left: 15.0),
                          child: DropdownButton(
                            items: zoneList.map((item) {
                              return DropdownMenuItem(
                                child: Text(item['zone_name']),
                                value: item['zone_id'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              print(newVal);
                              setState(() {
                                _zoneSelected = newVal;
                              });
                              getWardList();
                            },
                            value: _zoneSelected,
                          ),
                        ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text('Ward number: '),
                      margin: const EdgeInsets.only(top: 15.0, left: 15.0),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 5.0, right: 10.0, left: 15.0),
                      child: DropdownButton(
                        items: wardList.map((item) {
                          return DropdownMenuItem(
                            child: Text(item['ward_name']),
                            value: item['ward_id'].toString(),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _wardSelected = newVal;
                          });
                        },
                        value: _wardSelected,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: const Text('Plot number: '),
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              left: 15.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.left,
                              onSaved: (value) => plotNo = value!,
                              validator: (value) {
                                if (value!.isEmpty) return 'Enter plot no.';
                                return null;
                              },
                              decoration: const InputDecoration(
                                // hintText: 'Email',
                                contentPadding: EdgeInsets.all(5.0),
                              ),
                            ),
                            margin:
                                const EdgeInsets.only(top: 10.0, right: 10.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: const Text('Property number (Old): '),
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              left: 15.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.left,
                              onSaved: (value) => propertyNoOld = value!,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Enter old property no.';
                                return null;
                              },
                              decoration: const InputDecoration(
                                // hintText: 'Email',
                                contentPadding: EdgeInsets.all(5.0),
                              ),
                            ),
                            margin:
                                const EdgeInsets.only(top: 10.0, right: 10.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: const Text('Property number (New): '),
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              left: 15.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.left,
                              onSaved: (value) => propertyNoNew = value!,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Enter new property no.';
                                return null;
                              },
                              decoration: const InputDecoration(
                                // hintText: 'Email',
                                contentPadding: EdgeInsets.all(5.0),
                              ),
                            ),
                            margin:
                                const EdgeInsets.only(top: 10.0, right: 10.0),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15.0, top: 15.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Address:',
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        maxLines: 3,
                        onSaved: (value) => address = value!,
                        validator: (value) {
                          if (value!.isEmpty) return 'Enter address.';
                          return null;
                        },
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)))),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text('Property Type: '),
                      margin: const EdgeInsets.only(top: 15.0, left: 15.0),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 5.0, right: 10.0, left: 15.0),
                      child: DropdownButton(
                        items: propertyList.map((item) {
                          return DropdownMenuItem(
                            child: Text(item['name']),
                            value: item['prop_type_id'].toString(),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _propertyType = newVal;
                          });
                        },
                        value: _propertyType,
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                        Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, top: 15.0, right: 15.0),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Total area in foot: ',
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.left,
                                controller: _controller,
                                onSaved: (value) => totalAreaF = value!,
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return 'Enter total area (f)';
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    // ignore: curly_braces_in_flow_control_structures
                                    if (value.isEmpty)
                                      initialtotalArea = 0.0;
                                    // ignore: curly_braces_in_flow_control_structures
                                    else
                                      initialtotalArea =
                                          (double.parse(value) * footTometer);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(
                                  right: 15.0, left: 15.0, top: 15.0),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Total area in meter:',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(
                                  right: 15.0, left: 15.0, top: 7.0),
                              child: Text(
                                double.parse(
                                        (initialtotalArea).toStringAsFixed(3))
                                    .toString(),
                                style: const TextStyle(fontSize: 17.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    Row(children: [
                      Expanded(
                        child: Container(
                          child: const Text('Rent status: '),
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 15.0, right: 15.0),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10.0, right: 10.0),
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                          child: DropdownButton(
                            items: rentList.map((item) {
                              return DropdownMenuItem(
                                child: Text(item['status']),
                                value: item['rent_id'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                _rentStatus = newVal;
                              });
                            },
                            value: _rentStatus,
                          ),
                        ),
                      ),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                        Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, top: 15.0, right: 15.0),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Rent area in foot: ',
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.left,
                                onSaved: (value) => rentAreaF = value!,
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return 'Enter rent area (f)';
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    // ignore: curly_braces_in_flow_control_structures
                                    if (value.isEmpty)
                                      initialRentArea = 0.0;
                                    // ignore: curly_braces_in_flow_control_structures
                                    else
                                      initialRentArea =
                                          (double.parse(value) * footTometer);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(
                                  right: 15.0, top: 15.0, left: 15.0),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Rent area in meter:',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(
                                  right: 15.0, left: 15.0, top: 7.0),
                              child: Text(
                                double.parse(
                                        (initialRentArea).toStringAsFixed(3))
                                    .toString(),
                                style: const TextStyle(fontSize: 17.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(5.0),
            child: (isLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                        color: Colors.blueAccent)))),
                    onPressed: () {
                      if (_zoneSelected==null || _wardSelected==null || _propertyType==null || _rentStatus==null) {
                        _displaySnackBar(context);
                      }
                      else {
                        _submit(context);
                      }
                    },
                    child: const Text(
                      "Save & Next",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ]),
      ),
    ));
  }
}
