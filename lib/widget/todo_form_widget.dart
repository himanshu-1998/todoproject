import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/todos.dart';

class TodoFormWidget extends StatefulWidget {
  final String title;
  final String description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final VoidCallback onSavedTodo;

  const TodoFormWidget({
    Key? key,
    this.title = '',
    this.description = '',
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onSavedTodo,
  }) : super(key: key);

  @override
  State<TodoFormWidget> createState() => _TodoFormWidgetState();
}

class _TodoFormWidgetState extends State<TodoFormWidget> {

  CollectionReference _reference =
  FirebaseFirestore.instance.collection('shopping_list');

  String imageUrl = '';

  @override
  Widget build(BuildContext context) =>
      SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(),
            SizedBox(height: 8),
            buildDescription(),
            SizedBox(height: 16),
            buildButton(),
            SizedBox(height: 16),
            buildImagePicker(),
          ],
        ),
      );

  Widget buildTitle() =>
      TextFormField(
        maxLines: 1,
        initialValue: widget.title,
        onChanged: widget.onChangedTitle,
        validator: (title) {
          if (title == "") {
            return 'The title cannot be empty';
          }
          return null;
        },
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Title',
        ),
      );

  Widget buildDescription() =>
      TextFormField(
        maxLines: 3,
        initialValue: widget.description,
        onChanged: widget.onChangedDescription,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Description',
        ),
      );

  Widget buildButton() =>
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
          onPressed: widget.onSavedTodo,
          child: Text('Save'),
        ),
      );

  Widget buildImagePicker() =>
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
          onPressed: () async {
            /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */

            /*Step 1:Pick image*/
            //Install image_picker
            //Import the corresponding library

            ImagePicker imagePicker = ImagePicker();
            XFile? file =
            await imagePicker.pickImage(source: ImageSource.camera);
            print('${file?.path}');

            if (file == null) return;
            //Import dart:core
            String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();

            /*Step 2: Upload to Firebase storage*/
            //Install firebase_storage
            //Import the library

            //Get a reference to storage root
            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages =
            referenceRoot.child('images');

            //Create a reference for the image to be stored
            Reference referenceImageToUpload =
            referenceDirImages.child(uniqueFileName);

            //Handle errors/success
            try {
              //Store the file
              await referenceImageToUpload.putFile(File(file!.path));
              //Success: get the download URL
              imageUrl = await referenceImageToUpload.getDownloadURL();
            } catch (error) {
              //Some error occurred
            }

            setState(() {
              final provider = Provider.of<TodosProvider>(context, listen: false);
              provider.imageUrl = imageUrl;
            });
          },
          child: Text('Select Image'),
        ),
      );
}
