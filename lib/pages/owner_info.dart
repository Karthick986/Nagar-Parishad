import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nagar_parishad/api_service/addpropertyapi.dart';

import 'basic_info.dart';
import '../main.dart';

class OwnerInfo extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final floorId, constYear, constTypeId, usableTypeId, constAreaF, constAreaM, surveyNo, zoneNo, wardNo,
      // ignore: prefer_typing_uninitialized_variables
      plotNo, propertyOld, propertyNew, address, propertyType, totalAreaF, totalAreaM, rentStatus, rentAreaF, rentAreaM;

  const OwnerInfo({Key? key, this.floorId, this.constYear, this.constTypeId, this.usableTypeId, this.constAreaF, this.constAreaM,
    this.surveyNo, this.zoneNo, this.wardNo, this.plotNo, this.propertyOld, this.propertyNew, this.address, this.propertyType,
    this.totalAreaF, this.totalAreaM, this.rentStatus, this.rentAreaF, this.rentAreaM}) : super(key: key);

  @override
  _OwnerInfoState createState() => _OwnerInfoState();
}

class _OwnerInfoState extends State<OwnerInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  late String name, ownerAddress, contactNo, email, adhaarNo;

  void _submit(BuildContext context) {
    _formKey.currentState!.save();
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      isLoading = true;
      AddPropertyApi apiService = AddPropertyApi();
      apiService.addPropertyService(widget.surveyNo, widget.zoneNo, widget.wardNo, widget.plotNo, widget.propertyOld,
          widget.propertyNew, widget.address, widget.propertyType, widget.totalAreaF, widget.totalAreaM, widget.rentStatus,
          widget.rentAreaF, widget.rentAreaM, widget.floorId, widget.constYear, widget.constTypeId, widget.usableTypeId, widget.constAreaF, widget.constAreaF,
          name, ownerAddress, contactNo, email, adhaarNo, context).then((value) {
        if (value['status'] == 200) {

          setState(() {
            isLoading = false;
          });

          showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  actionsPadding: const EdgeInsets.all(20.0),
                  titlePadding: const EdgeInsets.all(20.0),
                  title: const Text("Your information has been saved!", style: TextStyle(fontSize: 15.0),),
                  actions: [
                    ElevatedButton(onPressed: () {
                      Navigator.pushReplacement(context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const BasicInfo(),
                            ),
                          );
                    }, child: const Text('Okay'))
                  ],
                ),
          );
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Owner Information'),
        ),
        body: Builder(builder: (context) => Form(
            key: _formKey,
            child: Column(children: [
              Expanded(
                  flex: 9,
                  child: Scrollbar(
                      isAlwaysShown: true,
                      thickness: 5.0,
                      radius: const Radius.circular(10.0),
                      child: SingleChildScrollView(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: [
                            Container(
                              alignment: Alignment.centerLeft,
                                    child: const Text('Owner name: '),
                                    margin: const EdgeInsets.only(
                                      top: 20.0,
                                      left: 10.0,
                                    ),
                                  ),
                               Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.name,
                                      textAlign: TextAlign.left,
                                      onSaved: (value) => name = value!,
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return 'Enter owner name';
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0, top: 15.0),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Address:',
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: TextFormField(
                                keyboardType: TextInputType.streetAddress,
                                maxLines: 3,
                                onSaved: (value) => ownerAddress = value!,
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
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: const Text('Contact number: '),
                                    margin: const EdgeInsets.only(
                                      top: 20.0,
                                      left: 10.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.left,
                                      onSaved: (value) => contactNo = value!,
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return 'Enter contact no.';
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(5.0),
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(
                                        top: 10.0, right: 10.0),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text('Email: '),
                              margin: const EdgeInsets.only(
                                top: 20.0,
                                left: 10.0,
                              ),
                            ),
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.left,
                                onSaved: (value) => email = value!,
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return 'Enter email address';
                                  return null;
                                },
                                decoration: const InputDecoration(
                                ),
                              ),
                              margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: const Text('Adhaar number: '),
                                    margin: const EdgeInsets.only(
                                      top: 20.0,
                                      left: 10.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.left,
                                      onSaved: (value) => adhaarNo = value!,
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return 'Enter adhaar no.';
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(5.0),
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(
                                        top: 10.0, right: 10.0),
                                  ),
                                ),
                              ],
                            ),
                          ])))),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(5.0),
                child: (isLoading) ? Center(child: Container(child: const CircularProgressIndicator(), margin: EdgeInsets.only(bottom: 10.0),),) :
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
                    _submit(context);
                    // Navigator.push(context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) => const EvidenceInfo(),
                    //   ),
                    // );
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white),
                  ),
                ),
              ),
            ]))));
  }
}
