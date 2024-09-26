import 'dart:io';

import 'package:bootcampflutter/data/datasources/document_local_datasource.dart';
import 'package:bootcampflutter/data/models/document_model.dart';
import 'package:flutter/material.dart';

import '../core/colors.dart';

class SaveDocumentPage extends StatefulWidget {
  final String pathImage;
  const SaveDocumentPage({
    super.key,
    required this.pathImage,
  });

  @override
  State<SaveDocumentPage> createState() => _SaveDocumentPageState();
}

class _SaveDocumentPageState extends State<SaveDocumentPage> {
  TextEditingController? nameController;
  String? selectCategory;

  final List<String> categoires = [
    'Kartu',
    'Nota',
    'Surat',
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Document'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.file(File(widget.pathImage))),
          SizedBox(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
              )),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nama Dokumen',
            ),
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            value: selectCategory,
            onChanged: (String? value) {
              setState(() {
                selectCategory = value;
              });
            },
            items: categoires
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Kateogri',
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          DocumentModel model = DocumentModel(
            name: nameController!.text,
            path: widget.pathImage,
            category: selectCategory!,
            createdAt: DateTime.now().toString(),
          );

          DocumentLocalDatasource.instance.saveDocument(model);
          Navigator.pop(context);
          const snackbar = SnackBar(
            content: Text('Dokumen Berhasil Disimpan'),
            backgroundColor: AppColors.primary,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 52,
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              "Simpan Dokumen",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
