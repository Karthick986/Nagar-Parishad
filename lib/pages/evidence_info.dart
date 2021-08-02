import 'package:flutter/material.dart';
import 'evidence_details.dart';

class EvidenceInfo extends StatefulWidget {
  const EvidenceInfo({Key? key}) : super(key: key);

  @override
  EvidenceState createState() => EvidenceState();
}

class EvidenceState extends State<EvidenceInfo> {
  static List<String?> evidenceList = [null];
  static List typeList = [null];

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

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
          title: Text('Evidence'),
        ),
        body: Form(
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
                                  'Add Evidence Info',
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
                            // _submit(context);
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                            }
                            print(evidenceList);
                            print(typeList);
                          },
                          // Navigator.push(context,
                          //   MaterialPageRoute(
                          //     builder: (BuildContext context) => const BasicInfo(),
                          //   ),
                          // );
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ])));
  }

  List<Widget> _getFriends() {
    List<Widget> friendsTextFieldsList = [];
    for (int i = 0; i < evidenceList.length; i++) {
      friendsTextFieldsList.add(
        Column(
          children: [
            EvidenceFields(i),
            Container(height: 1.0, margin: EdgeInsets.all(10.0), color: Colors.black12),
            Container(
              child: _addRemoveButton(i == evidenceList.length - 1, i),
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 10.0, bottom: 5.0),
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
          // add new text-fields at the top of all friends textfields
          evidenceList.insert(0, null);
          typeList.insert(0, null);
        } else {
          evidenceList.removeAt(index);
          typeList.removeAt(index);
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
