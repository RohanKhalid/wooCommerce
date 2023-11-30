import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_config.dart';

class ProductsInCategoryScreen extends StatefulWidget {
  final int categoryId;

  ProductsInCategoryScreen({required this.categoryId});

  @override
  _ProductsInCategoryScreenState createState() =>
      _ProductsInCategoryScreenState();
}

class _ProductsInCategoryScreenState extends State<ProductsInCategoryScreen> {
  final String apiUrl = '${AppConfig.BASE_URL}/wc/v3/products';
  final String consumerKey = AppConfig.Consumer_Key;
  final String consumerSecret = AppConfig.Consumer_Secret;

  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProductsInCategory();
  }

  Future<void> fetchProductsInCategory() async {
    final response = await http.get(
      Uri.parse(
        '$apiUrl?category=${widget.categoryId}&consumer_key=$consumerKey&consumer_secret=$consumerSecret',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
      });
    } else {
      print('Fetching products in category failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products in Category'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final title = product['name'];
          final price = product['price'];
          final imageUrl = product['images'][0]['src'];

          return ListTile(
            leading: Image.network(imageUrl),
            title: Text(title),
            subtitle: Text('Price: $price'),
          );
        },
      ),
    );
  }
}
