import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:viola/providers/myprovider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Your Categories'),
          centerTitle: true,
        ),
        body: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            return ListView.builder(
              itemCount: categoryProvider.categories.length,
              itemBuilder: (context, index) {
                final category = categoryProvider.categories[index];
                return CheckboxListTile(
                  title: Text(category.name),
                  value: categoryProvider.selectedCategories[index],
                  onChanged: (bool? value) {
                    categoryProvider.toggleCategorySelection(index,value);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
