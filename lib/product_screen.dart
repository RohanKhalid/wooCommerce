// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce_app/my_theme.dart';

import 'app_config.dart';
import 'product_details.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final String apiUrl = '${AppConfig.BASE_URL}/wc/v3/products';
  final String consumerKey = AppConfig.Consumer_Key;
  final String consumerSecret = AppConfig.Consumer_Secret;

  List<dynamic> products = [];
  List<dynamic> featuredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');

    Navigator.pushNamed(context, '/');
  }

  // Future<void> fetchProducts() async {
  //   final response = await http.get(
  //     Uri.parse(
  //         '$apiUrl?consumer_key=$consumerKey&consumer_secret=$consumerSecret'),
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       products = json.decode(response.body);
  //       print(products.length);
  //     });
  //   } else {
  //     print('Fetching products failed: ${response.body}');
  //     throw Exception('Failed to fetch products');
  //   }
  // }

  Future<void> fetchProducts() async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl?consumer_key=$consumerKey&consumer_secret=$consumerSecret'),
    );

    if (response.statusCode == 200) {
      final allProducts = json.decode(response.body);

      // Filter featured products
      final featuredProducts =
          allProducts.where((product) => product['featured'] == true).toList();

      setState(() {
        products = allProducts;
        this.featuredProducts = featuredProducts;
        print(products.length);
        print(featuredProducts.length);
      });
    } else {
      print('Fetching products failed: ${response.body}');
      throw Exception('Failed to fetch products');
    }
  }

  Future<void> addToCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final nonce = prefs.getString('nonce') ?? '';
    final cartToken = prefs.getString('cartToken') ?? '';
    final response = await http.post(
      Uri.parse('${AppConfig.BASE_URL}/wc/store/cart/add-item'),
      headers: {
        'Authorization': 'Basic ${base64Encode(
          utf8.encode('$consumerKey:$consumerSecret'),
        )}',
        'Content-Type': 'application/json',
        'X-WC-Store-API-Nonce': nonce,
        'X-WC-Store-Cart-Token': cartToken,
      },
      body: jsonEncode({
        'product_id': productId,
        'quantity': 1,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print('Product added to cart: ${responseData}');
      Fluttertoast.showToast(
          msg: 'Product added to cart', toastLength: Toast.LENGTH_LONG);
      // You can navigate to a success page or perform other actions.
      Navigator.pushNamed(context, '/');
    } else {
      print('Failed to add product to cart: ${response.body}');

      Fluttertoast.showToast(
          msg: 'Failed to add product to cart', toastLength: Toast.LENGTH_LONG);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme.background_color,
        extendBody: true,
        // appBar: AppBar(
        //   title: const Text('WooCommerce Products'),
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.exit_to_app),
        //       onPressed: () {
        //         logoutUser();
        //       },
        //     ),
        //   ],
        // ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image
            Image.asset(
              'assets/banner.png', // Replace with your banner image asset path
              width: double.infinity,
              height: 150,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Products',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.accent_color),
              ),
            ),
            const SizedBox(height: 10),
            // Featured Products Section (Add your horizontal scroll here)
            // ...

            const SizedBox(height: 10),

            // All Products Grid
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final title = product['name'];
                  final price = product['price'];
                  final imageUrl = product['images'][0]['src'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(product: product),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: MyTheme.primary_color, // Border color
                          width: 5,
                        ),
                        borderRadius:
                            BorderRadius.circular(12), // Border radius
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyTheme.blue_grey),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Price: \$ $price',
                                style: TextStyle(
                                    fontSize: 14, color: MyTheme.blue_grey),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.shopping_cart,
                                  color: MyTheme.primary_color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
