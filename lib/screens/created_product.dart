import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sysman_prueba/components/text_field.dart';
import 'package:sysman_prueba/helper/database_helper.dart';
import 'package:sysman_prueba/models/product.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  

  File? _imagen;
  String _imagePath = '';

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _imagen = File(pickedFile.path);
      });
    }
  }

  Future<String> _saveImage() async {
    if (_imagen == null) return '';

    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(_imagen!.path);
    final savedImage = await _imagen!.copy('${directory.path}/$name');

    return savedImage.path;
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _imagePath = await _saveImage();

      final product = Producto(
        nombre: _nameController.text,
        descripcion: _descriptionController.text,
        precio: double.parse(_priceController.text),
        imagen: _imagePath,
      );

      await _dbHelper.insertProduct(product);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto guardado con éxito')),
      );

      // Limpia el formulario después de guardar
      _formKey.currentState!.reset();
      setState(() {
        _imagen = null;
      });

      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nuevo Producto')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            GestureDetector(
            onTap: _pickImage,
            child: _imagen == null
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
                    child: Image.file(_imagen!, width: 200, height: 200, fit: BoxFit.cover),
                  ),
          ),
          const SizedBox(height: 10,),
          CustomTextField(
            controller: _nameController,
            inputType: TextInputType.text,
            label: "Nombre del Producto",
            placeholder: "Escriba el nombre del producto",
            isRequired: true,
          ),
          const SizedBox(height: 5),
          CustomTextField(
            controller: _descriptionController,
            inputType: TextInputType.text,
            maxLines: 7,
            label: "Descripción",
            placeholder: "Escriba una descripción para el producto",
            isRequired: true,
          ),
          const SizedBox(height: 5),
          CustomTextField(
            controller: _descriptionController,
            inputType: TextInputType.number,
            label: "Precio",
            placeholder: "Por favor ingrese un precio",
            isRequired: true,
          ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  _submitForm(context);
                },
                child: const Text(
                      'Guardar Producto',
                      style: TextStyle(fontSize: 18),
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
    );
  }
}