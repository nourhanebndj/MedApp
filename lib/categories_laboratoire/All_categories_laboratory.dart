import 'package:flutter/material.dart';
import 'package:mediloc/categories_laboratoire/categorieslaboratorydetailspage.dart';
import 'package:mediloc/generated/l10n.dart';
import 'package:mediloc/model/category_laboratory.dart';
import 'package:mediloc/provider/category_laboratory_provider.dart';
import 'package:provider/provider.dart';

class AlllaboratoryCategoriesPage extends StatelessWidget {
  final String selectedLanguage;

  const AlllaboratoryCategoriesPage({Key? key, required this.selectedLanguage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.of(context).Categories),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Directionality(
        textDirection:
            selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Consumer<Myproviderlaboratory>(
          builder: (context, myProvider, _) {
            return FutureBuilder<void>(
              future: myProvider.getCategorylaboratoire(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<CategorylaboratoryModel> categories =
                      myProvider.getCategorylaboratoryModelList;
                  if (categories.isEmpty) {
                    return const Center(child: Text("No categories found"));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                         onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategorylaboratoryDetailPage(category: category,selectedLanguage:selectedLanguage,),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    category.image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
