import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/providers/category_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String && errorMessage == null) {
      errorMessage = args;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 500),
            content: Text(errorMessage!),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch categories as soon as the widget is initialized and rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                buildHandleBar(),
                const Text('الخدمت',
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: categoryProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryProvider.categories[index];
                      return CheckboxListTile(
                        title: Text(category.name),
                        value: categoryProvider.selectedCategories[index],
                        onChanged: (bool? value) {
                          categoryProvider.toggleCategorySelection(
                              index, value);
                        },
                      );
                    },
                  ),
                ),
                buildActionButtons(context, categoryProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHandleBar() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget buildActionButtons(BuildContext context, CategoryProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await provider.fetchSalonsByCategory();
                  Navigator.of(context).pushReplacementNamed('/home');
                } catch (e) {
                  Navigator.of(context).pushReplacementNamed(
                    '/category',
                    arguments: e.toString(),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(75, 0, 95, 1)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(vertical: 15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              child: const Text('أختر',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                provider.clearSelectedCategories();
                Navigator.of(context).pop(); // Close the bottom sheet
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(75, 0, 95, 1)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(vertical: 15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              child: const Text('امسح',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
