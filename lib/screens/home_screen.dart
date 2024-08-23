
// ignore_for_file: sort_child_properties_last

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sysman_prueba/components/search_input.dart';
import 'package:sysman_prueba/helper/database_helper.dart';
import 'package:sysman_prueba/models/product.dart';
import 'package:sysman_prueba/screens/created_product.dart';

class HomeScreen extends StatefulWidget {
const HomeScreen({Key? key, required this.title, required this.themeMode}) : super(key: key);

  final String title;
  final ValueNotifier<ThemeMode> themeMode;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
 
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Producto> _productos = [] ;
  List<Producto> _productosCopy = [] ;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

  void _toggleTheme() {
    final newThemeMode = widget.themeMode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    widget.themeMode.value = newThemeMode;
  }

  Future<void> _loadProductos() async {
    try {
      final productos = await _dbHelper.getProductos();
      _productosCopy = List.from(productos);
      setState(() {
        _productos = productos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar productos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _productos = List.from(_productosCopy);
      } else {
        _productos = _productosCopy
            .where((producto) =>
                producto.nombre.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _navigateToProductForm(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductForm()),
    );
    if (result == true) {
      _loadProductos();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final isDarkMode = widget.themeMode.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomSearchBar(
              placeholder: "Buscar ...",
              controller: _searchController,
              onChanged: (query) {
                _filterProducts(query);
              },
              onClear: () {
                _searchController.clear();
                _filterProducts('');
              },
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: () {
                  _navigateToProductForm(context);
                },
                child: const Row(
                  children: [
                    Text(
                      'Crear Producto',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Icon(Icons.add_rounded)
                  ],
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF00BF6D)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10,),
            const Text(
              'Lista de productos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10,),
             Expanded(
              child: ListView.builder(
              itemCount: _productos.length,
              itemBuilder: (context, index) {
                final producto = _productos[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('\$${producto.precio}'),
                  leading: producto.imagen.isNotEmpty
                      ? Image.file(File(producto.imagen), width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.image),
                  onTap: () {
                    // Aquí puedes navegar a una pantalla de detalles del producto
                  },
                );
              },
            ) 
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleTheme,
        tooltip: 'Cambiar tema',
        child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
      ),
    );
  }
}
