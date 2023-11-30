import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'app_config.dart';
import 'category_products.dart';
import 'models/product_category.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final String apiUrl = '${AppConfig.BASE_URL}/wc/v3/products/categories';
  final String consumerKey = AppConfig.Consumer_Key;
  final String consumerSecret = AppConfig.Consumer_Secret;

  List<ProductCategory> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl?consumer_key=$consumerKey&consumer_secret=$consumerSecret'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        categories = responseData.map((categoryData) {
          return ProductCategory(
            id: categoryData['id'],
            name: categoryData['name'],
            slug: categoryData['slug'],
          );
        }).toList();
      });
    } else {
      print('Fetching categories failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            leading: Text(category.id.toString()),
            title: Text(category.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductsInCategoryScreen(categoryId: category.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
