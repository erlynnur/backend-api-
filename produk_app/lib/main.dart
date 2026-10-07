import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Produk CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List products = [];
  bool isLoading = true;

  final String apiUrl = 'https://backend-api-dg96.onrender.com/api/products';

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        setState(() {
          products = decoded['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addProduct(String name, String price) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'name': name, 'price': int.parse(price)}),
      );
      print('Response Status POST: ${response.statusCode}');
      print('Response Body POST: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        fetchProducts();
      }
    } catch (e) {
      print('Error Add: $e');
    }
  }

  Future<void> updateProduct(int id, String name, String price) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'name': name, 'price': int.parse(price)}),
      );
      print('Response Status PUT: ${response.statusCode}');
      print('Response Body PUT: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        fetchProducts();
      }
    } catch (e) {
      print('Error Update: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
        headers: {'Accept': 'application/json'},
      );
      print('Response Status DELETE: ${response.statusCode}');
      print('Response Body DELETE: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        fetchProducts();
      }
    } catch (e) {
      print('Error Delete: $e');
    }
  }

  void showFormDialog({Map? product}) {
    final nameController = TextEditingController(
      text: product != null ? product['name'].toString() : '',
    );
    final priceController = TextEditingController(
      text: product != null ? product['price'].toString() : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Tambah Produk' : 'Edit Produk'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  isLoading = true;
                });

                if (product == null) {
                  await addProduct(nameController.text, priceController.text);
                } else {
                  int id = int.parse(product['id'].toString());
                  await updateProduct(
                    id,
                    nameController.text,
                    priceController.text,
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Produk CRUD')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text('Tidak ada data produk.'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(
                      item['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Rp ${item['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showFormDialog(product: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteProduct(item['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
