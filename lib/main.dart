import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String recognizedText = 'Recognized text will appear here';
  bool isProcessing = false;
  String text="";
  final TextRecognizer textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  Future<void> processImage() async {
    setState(() {
      isProcessing = true;
    });

    try {
      final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        final InputImage inputImage = InputImage.fromFile(File(pickedImage.path));
        RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
        text=recognizedText.text;
        debugPrint(text);
        setState(() {
          text=recognizedText.text;
        });
      } else {
        setState(() {
          recognizedText = 'No image selected';
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        appBar: AppBar(
          title: Text('Google OCR Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: isProcessing ? null : processImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 20.0),
              Text(
                isProcessing ? 'Processing...' : text,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
