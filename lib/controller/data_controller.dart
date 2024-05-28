import 'dart:convert';
import 'package:flutter_application_1/model/employee.dart';
import 'package:flutter_application_1/model/product.dart';

class DataController {
  static const _defaultData = '''
  {
    "company": "Tech Solutions",
    "location": "San Francisco",
    "employees": [
      {
        "name": "Alice",
        "age": 30,
        "position": "Developer",
        "skills": ["Dart", "Flutter", "Firebase"]
      },
      {
        "name": "Bob",
        "age": 25,
        "position": "Designer",
        "skills": ["Photoshop", "Illustrator"]
      }
    ],
    "products": [
      {
        "name": "Product A",
        "price": 29.99,
        "inStock": true
      },
      {
        "name": "Product B",
        "price": 49.99,
        "inStock": false
      }
    ]
  }
  ''';

  Map<String, dynamic> _data = jsonDecode(_defaultData);

  Future<Map<String, dynamic>> loadData() async {
    return _data;
  }

  Future<void> saveData(Map<String, dynamic> data) async {
    _data = data;
  }

  Future<List<Employee>> getEmployees() async {
    List<dynamic> employeesJson = _data['employees'];
    return employeesJson.map((json) => Employee.fromJson(json)).toList();
  }

  Future<List<Product>> getProducts() async {
    List<dynamic> productsJson = _data['products'];
    return productsJson.map((json) => Product.fromJson(json)).toList();
  }

  Future<void> addEmployee(Employee employee) async {
    List<dynamic> employeesJson = _data['employees'];
    employeesJson.add(employee.toJson());
    _data['employees'] = employeesJson;
    await saveData(_data);
  }

  Future<void> addProduct(Product product) async {
    List<dynamic> productsJson = _data['products'];
    productsJson.add(product.toJson());
    _data['products'] = productsJson;
    await saveData(_data);
  }
}
