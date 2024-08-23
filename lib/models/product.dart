class Producto {
  final int? id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;

  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
  });

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String,
      precio: map['precio'] as double,
      imagen: map['imagen'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'imagen': imagen,
    };
  }
}