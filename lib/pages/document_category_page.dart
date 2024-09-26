import 'package:flutter/material.dart';
import 'package:bootcampflutter/data/models/document_model.dart';
import 'package:bootcampflutter/pages/latest_documents_page.dart';
import '../data/datasources/document_local_datasource.dart';

class DocumentCategoryPage extends StatefulWidget {
  final String categoryTitle;
  const DocumentCategoryPage({
    super.key,
    required this.categoryTitle,
  });

  @override
  State<DocumentCategoryPage> createState() => _DocumentCategoryPageState();
}

class _DocumentCategoryPageState extends State<DocumentCategoryPage> {
  List<DocumentModel> documents = [];

  // Memuat data dari local datasource
  loadData() async {
    documents = await DocumentLocalDatasource.instance
        .getDocumentByCategory(widget.categoryTitle);
    setState(() {}); // Memperbarui UI setelah data di-load
  }

  @override
  void initState() {
    super.initState();
    // Memanggil loadData ketika halaman dimuat
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents in ${widget.categoryTitle}'),
      ),
      body: documents.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Tampilkan loading jika dokumen belum dimuat
          : Column(
              children: [
                Expanded(
                  child: LatestDocumentsPage(
                    documents: documents,
                  ),
                ),
              ],
            ),
    );
  }
}
