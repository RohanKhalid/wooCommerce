import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final String apiUrl = '${AppConfig.BASE_URL}/wc/store/cart/items';
  final String consumerKey = AppConfig.Consumer_Key;
  final String consumerSecret = AppConfig.Consumer_Secret;
  List<dynamic> cartItems = [];
  String nonce = '';
  String cartToken = '';

  Future<Map<String, dynamic>> fetchCartItems() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(
          utf8.encode('$consumerKey:$consumerSecret'),
        )}',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final nonce = response.headers['nonce'];
      final cartToken = response.headers['cart-token'];

      // Save nonce and cart token in shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('nonce', nonce!);
      prefs.setString('cartToken', cartToken!);

      return {
        'items': responseBody,
        'nonce': nonce,
        'cartToken': cartToken,
      };
    } else {
      throw Exception('Failed to fetch cart items: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNonceAndCartToken();
  }

  Future<void> fetchNonceAndCartToken() async {
    final prefs = await SharedPreferences.getInstance();
    final nonce = prefs.getString('nonce') ?? '';
    final cartToken = prefs.getString('cartToken') ?? '';

    // Use the nonce and cart token as needed
    print('Nonce: $nonce');
    print('Cart Token: $cartToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          final itemName = item['name'];
          final itemPrice = item['price'];
          // Add other item details as needed

          return ListTile(
            title: Text(itemName),
            subtitle: Text('Price: $itemPrice'),
            // Display other item details
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nonce: $nonce'),
            Text('Cart Token: $cartToken'),
          ],
        ),
      ),
    );
  }
}
