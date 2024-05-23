import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/providers/category_provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 8),
                buildHandleBar(),
                Text('الخدمت',
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
        margin: EdgeInsets.symmetric(vertical: 8),
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
                // Check if any category is selected
                if (provider.selectedCategories.contains(true)) {
                  try {
                    await provider.fetchSalonsByCategory();
                    // Navigate to home screen after successful data fetch
                    Navigator.of(context).pushReplacementNamed('/home');
                  } catch (e) {
                    // Show error Snackbar on current screen
                    _showSnackBar(
                        context, 'Failed to fetch data: ${e.toString()}');
                  }
                } else {
                  // Show Snackbar if no categories are selected
                  _showSnackBar(context, 'Please select at least one category');
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(75, 0, 95, 1)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              child: Text('أختر',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                provider.clearSelectedCategories();
                Navigator.of(context).pop(); // Close the bottom sheet
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(75, 0, 95, 1)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              child: Text('امسح',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message,
      [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8), // Space between the icon and text
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
