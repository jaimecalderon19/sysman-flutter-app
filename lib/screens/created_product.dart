import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sysman_prueba/components/text_field.dart';

class ProductAddScreen extends StatefulWidget {
  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  File? _image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _precioProductoController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _cantidadController.dispose();
    _precioProductoController.dispose();
    super.dispose();
  }


   Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
    
    await storeProduct();
    
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  
Future<void> storeProduct() async {
    try {


    }catch (e) {
      
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear un Producto'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF0F0F0),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? Container(
                        width: 200,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/upload.svg',
                              width: 80,
                              height: 80,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Por favor, sube una imagen del producto.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[900]),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover),
                      ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _nameController,
                inputType: TextInputType.text,
                label: "Nombre del Producto",
                placeholder: "Escriba el nombre del producto",
              ),
              const SizedBox(height: 5),
              CustomTextField(
                controller: _descriptionController,
                inputType: TextInputType.text,
                maxLines: 7,
                label: "Descripción",
                placeholder: "Escriba una descripción para el producto",
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Acción para guardar cambios
                  storeProduct();
                },
                child: Text(
                  'Guardar Producto',
                  style: const TextStyle(fontSize: 18),
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
            ],
          ),
        ),
      ),
    );
  }
}
