import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/data_controller.dart';
import 'package:flutter_application_1/model/employee.dart';
import 'package:flutter_application_1/model/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataController dataController = DataController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Data'),
      ),
      body: FutureBuilder(
        future: Future.wait(
            [dataController.getEmployees(), dataController.getProducts()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Employee> employees = snapshot.data![0] as List<Employee>;
            List<Product> products = snapshot.data![1] as List<Product>;
            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Employees:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ...employees.map((employee) => Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${employee.name}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Position: ${employee.position}'),
                            Text('Age: ${employee.age}'),
                            Text('Skills: ${employee.skills.join(', ')}'),
                          ],
                        ),
                      ),
                    )),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Products:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ...products.map((product) => Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Product Name: ${product.name}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Price: \$${product.price}'),
                            Text('In Stock: ${product.inStock ? 'Yes' : 'No'}'),
                          ],
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showAddEmployeeDialog(context);
                    },
                    child: const Text('Add Employee'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showAddProductDialog(context);
                    },
                    child: const Text('Add Product'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final positionController = TextEditingController();
    final skillsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: positionController,
                  decoration: const InputDecoration(labelText: 'Position')),
              TextField(
                  controller: skillsController,
                  decoration: const InputDecoration(
                      labelText: 'Skills (comma separated)')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final age = int.tryParse(ageController.text) ?? 0;
                final position = positionController.text;
                final skills = skillsController.text
                    .split(',')
                    .map((s) => s.trim())
                    .toList();
                final employee = Employee(
                    name: name, age: age, position: position, skills: skills);
                dataController.addEmployee(employee).then((_) {
                  setState(() {});
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    bool inStock = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Product'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'Product Name')),
                  TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number),
                  Row(
                    children: [
                      const Text('In Stock'),
                      Checkbox(
                        value: inStock,
                        onChanged: (value) {
                          setState(() {
                            inStock = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final name = nameController.text;
                    final price = double.tryParse(priceController.text) ?? 0.0;
                    final product =
                        Product(name: name, price: price, inStock: inStock);
                    dataController.addProduct(product).then((_) {
                      setState(() {});
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
