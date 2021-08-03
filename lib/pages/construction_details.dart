import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/sharedprefmodel.dart';
import 'construction_info.dart';

class FriendTextFields extends StatefulWidget {
  final int index;
  FriendTextFields(this.index);
  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  double constAreaM = 0.0;

  List floorList=[], constTypeList=[], usableTypeList=[], constYeardate=[];
  dynamic floorId, constId, usableId;

  Future<String> getFloorList() async {
    String link = "http://www.internsorbit.com:8080/nagarparishad/floorlistmob/";

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
      floorList = resBody['data'];
    });

    return "Success";
  }

  Future<String> getConstList() async {
    String link = "http://www.internsorbit.com:8080/nagarparishad/consttypelistmob/";

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
      constTypeList = resBody['data'];
    });

    return "Success";
  }

  Future<String> getUsableList() async {
    String link = "http://www.internsorbit.com:8080/nagarparishad/usetypelistmob/";

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
      usableTypeList = resBody['data'];
    });

    return "Success";
  }

  @override
  void initState() {
    super.initState();
    getFloorList();
    getConstList();
    getUsableList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   _nameController.text = ConstructionInfoState.floorIdList[widget.index]
    //       ?? '';
    // });
    getFloorList();
    getConstList();
    getUsableList();

    return Column(
      children: [
        Row(children: [
          Expanded(
            flex: 2,
            child: Container(
              child: const Text('Floor id: '),
              margin: const EdgeInsets.only(left: 10.0),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: DropdownButton(
                items: floorList.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['name']),
                    value: item['floor_id'].toString(),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    floorId = newVal;
                  });
                  ConstructionInfoState.floorIdList[widget.index] = newVal;
                },
                value: floorId,
              ),
            ),
          ),
        ]),
        Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  margin:
                  EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Construction year: '),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(child: TextFormField(
                  readOnly: true,
                  style: TextStyle(fontSize: 13.0),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 13.0),
                    hintText: ConstructionInfoState.constYear[widget.index],
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => handleReadOnlyInputClick(context),
                ), margin: EdgeInsets.only(top: 5.0, right: 10.0),
              )),
            ]),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text('Construction type id: '),
          margin: const EdgeInsets.only(top: 15.0, left: 15.0),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 5.0, right: 10.0, left: 15.0),
          child: DropdownButton(
            items: constTypeList.map((item) {
              return DropdownMenuItem(
                child: Text(item['name']),
                value: item['const_type_id'].toString(),
              );
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                constId = newVal;
              });
              ConstructionInfoState.constTypeid[widget.index] = newVal;
            },
            value: constId,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text('Usable type id: '),
          margin: const EdgeInsets.only(top: 15.0, left: 15.0),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 5.0, right: 10.0, left: 15.0),
          child: DropdownButton(
            items: usableTypeList.map((item) {
              return DropdownMenuItem(
                child: Text(item['name']),
                value: item['use_type_id'].toString(),
              );
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                usableId = newVal;
              });
              ConstructionInfoState.usableTypeId[widget.index] = newVal;
            },
            value: usableId,
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, top: 15.0, right: 15.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Construction area in foot: ',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 5.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.left,
                        // onSaved: (value) => totalAreaF = value!,
                        validator: (value) {
                          if (value!.isEmpty) return 'Enter total area (f)';
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            // ignore: curly_braces_in_flow_control_structures
                            if (value.isEmpty) constAreaM = 0.0;
                            // ignore: curly_braces_in_flow_control_structures
                            else {
                              constAreaM = (double.parse(value) * 0.3048);
                            }
                            ConstructionInfoState.constAreaF[widget.index] = value;
                            ConstructionInfoState.constAreaM[widget.index] = constAreaM.toStringAsFixed(3);
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
                        'Construction area in meter:',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(
                          right: 15.0, left: 15.0, top: 7.0),
                      child: Text(
                        double.parse((constAreaM).toStringAsFixed(3)).toString(),
                        style: const TextStyle(
                            fontSize: 17.0
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ],
    );
  }

  void handleReadOnlyInputClick(context) {
    showBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          child: YearPicker(
            selectedDate: DateTime.now(),
            firstDate: DateTime(1000),
            lastDate: DateTime.now(),
            onChanged: (val) {
              setState(() {
                ConstructionInfoState.constYear[widget.index] = val.year.toString();
              });
              Navigator.pop(context);
            },
          ),
        )
    );
  }
}