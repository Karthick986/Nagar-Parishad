import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'evidence_info.dart';
import 'package:image_picker/image_picker.dart';

class EvidenceFields extends StatefulWidget {
  final int index;

  EvidenceFields(this.index);

  @override
  _EvidenceFieldsState createState() => _EvidenceFieldsState();
}

class _EvidenceFieldsState extends State<EvidenceFields> {
  late String fileName;

  dynamic _evidentType;
  List evidenceList = [{'evidence': 'Image', 'id': '0'}, {'evidence': 'Map', 'id': '1'}];

  late File _imageFile;

  bool isLoading = false;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

//     final PickedFile? image = await ImagePicker.platform.pickImage(source: ImageSource.camera);
//
// // getting a directory path for saving
//     final String path = await getApplicationDocumentsDirectory().path;
//
// // copy the file to a new path
//     final File newImage = await image.copy('$path/image1.png');
//
//     setState(() {
//       _image = newImage;
//     });

    // setState(() {
    //   _imageFile = File(pickedFile!.path);
    //   fileName = basename(_imageFile.path);
    //   EvidenceState.evidenceList[widget.index] = _imageFile.path;
    //   GallerySaver.saveImage(pickedFile.path);
    // });
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
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   _nameController.text = ConstructionInfoState.floorIdList[widget.index]
    //       ?? '';
    // });
    return Column(
      children: [
        Row(children: [
          Expanded(
            child: Container(
              child: const Text('Evidence: '),
              margin: const EdgeInsets.only(left: 10.0),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(right: 10.0),
              child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: Colors.blueAccent)))),
                      onPressed: () {
                        pickImage();
                      },
                      child: const Text(
                        "Click image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              // child: ClipRRect(
              //   child: (_imageFile != null)
              //       ? Image.file(_imageFile)
              //       : FlatButton(
              //     child: Icon(
              //       Icons.add_a_photo,
              //       size: 50,
              //     ),
              //     onPressed: pickImage,
              //   ),
              // ),
            ),
          ),
        ]),
        Row(children: [
          Expanded(
            child: Container(
              child: const Text('Type: '),
              margin: const EdgeInsets.only(left: 10.0, top: 5.0),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: DropdownButton(
                items: evidenceList.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['evidence']),
                    value: item['id'].toString(),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    _evidentType = newVal;
                  });
                  EvidenceState.typeList[widget.index] = newVal;
                },
                value: _evidentType,
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
