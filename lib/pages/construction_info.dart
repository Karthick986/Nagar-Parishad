import 'dart:convert';
import 'package:flutter/material.dart';
import 'owner_info.dart';
import '../model/sharedprefmodel.dart';
import 'construction_details.dart';

class ConstructionInfo extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final surveyNo, zoneNo, wardNo, plotNo, propertyOld, propertyNew, address, propertyType, totalAreaF,
      totalAreaM, rentStatus, rentAreaF, rentAreaM;

  const ConstructionInfo({Key? key, this.surveyNo, this.zoneNo, this.wardNo, this.plotNo, this.propertyOld, this.propertyNew,
    this.address, this.propertyType, this.totalAreaF, this.totalAreaM, this.rentStatus, this.rentAreaF, this.rentAreaM}) : super(key: key);

  @override
  ConstructionInfoState createState() => ConstructionInfoState();
}

class ConstructionInfoState extends State<ConstructionInfo> {
  static List floorIdList = [null];
  static List constYear = [null];
  static List constTypeid = [null];
  static List usableTypeId = [null];
  static List constAreaF = [null];
  static List constAreaM = [null];

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

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
          context, MaterialPageRoute(builder: (context) => OwnerInfo(floorId: floorIdList, constYear: constYear,
          constTypeId: constTypeid, usableTypeId: usableTypeId, constAreaF: constAreaF, constAreaM: constAreaM, surveyNo: widget.surveyNo, zoneNo: widget.zoneNo,
          wardNo: widget.wardNo, plotNo: widget.plotNo, propertyOld: widget.propertyOld, propertyNew: widget.propertyNew,
          address: widget.address, propertyType: widget.propertyType, totalAreaF: widget.totalAreaF, totalAreaM: widget.totalAreaM, rentStatus: widget.rentStatus,
          rentAreaF: widget.rentAreaF, rentAreaM: widget.rentAreaM)));

      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Construction Information'),
        ),
        body: Builder(
        builder: (context) => Form(
            key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Scrollbar(
                          isAlwaysShown: true,
                          thickness: 5.0,
                          radius: const Radius.circular(10.0),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(child
                                  : Text(
                                  'Add Construction Info',
                                ), margin: EdgeInsets.only(bottom: 10.0),),
                                ..._getFriends(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(5.0),
                        child: (isLoading) ? const Center(child: CircularProgressIndicator(),) :
                        ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(color: Colors.blueAccent)
                                  )
                              )
                          ),
                          onPressed: () {
                            if (floorIdList.isEmpty || constYear.isEmpty || constTypeid.isEmpty || usableTypeId.isEmpty
                                || constAreaF.isEmpty) {
                              _displaySnackBar(context);
                            }
                            else {_submit(context);}
                          },
                          child: const Text(
                            "Save & Next",
                            style: TextStyle(
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ]))));
  }

  List<Widget> _getFriends() {
    List<Widget> friendsTextFieldsList = [];
    for (int i = 0; i < floorIdList.length; i++) {
      friendsTextFieldsList.add(
        Column(
          children: [
            FriendTextFields(i),
            Container(height: 1.0, margin: EdgeInsets.all(10.0), color: Colors.black12,),
            Container(
              child: _addRemoveButton(i == floorIdList.length - 1, i),
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 10.0),
            ),
          ],
        ),
      );
    }
    return friendsTextFieldsList;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          floorIdList.insert(0, floorIdList[index]);
          constYear.insert(0, constYear[index]);
          constTypeid.insert(0, constTypeid[index]);
          usableTypeId.insert(0, usableTypeId[index]);
          constAreaF.insert(0, constAreaF[index]);
          constAreaM.insert(0, constAreaM[index]);
        } else {
          floorIdList.removeAt(index);
          constYear.removeAt(index);
          constTypeid.removeAt(index);
          usableTypeId.removeAt(index);
          constAreaF.removeAt(index);
          constAreaM.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}
