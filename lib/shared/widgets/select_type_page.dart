import 'package:fluence_for_influencer/category/bloc/category_bloc.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTypePage extends StatefulWidget {
  const SelectTypePage({super.key});

  @override
  State<SelectTypePage> createState() => _SelectTypePageState();
}

class _SelectTypePageState extends State<SelectTypePage> {
  late final CategoryBloc categoryBloc;
  final CategoryRepository categoryRepository = CategoryRepository();

  final List<CategoryType> _selectedCategory = [];

  @override
  void initState() {
    super.initState();
    categoryBloc = CategoryBloc(categoryRepository: categoryRepository);
    categoryBloc.add(GetCategoryTypeListRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => categoryBloc,
      child: Scaffold(
        body: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (state is CategoryLoaded) {
              return SafeArea(
                child: Container(
                  color: Constants.backgroundColor,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildCategoryTypeChips(state.categoryList),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  onPressed: () {
                                    Navigator.pop(context, _selectedCategory);
                                  },
                                  child: const Text("Submit")),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildCategoryTypeChips(List<CategoryType> categories) {
    List<Widget> widgetChips = [];
    for (CategoryType category in categories) {
      bool selected = _selectedCategory.contains(category);
      Widget chip = FilterChip(
          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 13.0),
          labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          selectedColor: Constants.primaryColor.withOpacity(0.6),
          backgroundColor: Constants.secondaryColor.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
                width: 0.5,
                color: selected
                    ? Constants.grayColor.withOpacity(0.5)
                    : Constants.secondaryColor),
          ),
          elevation: selected ? 0.5 : 0,
          checkmarkColor: selected ? Colors.white : null,
          label: Text(category.categoryTypeName,
              style: TextStyle(
                  fontSize: 14.0,
                  color: selected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w400)),
          selected: selected,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                if (!_selectedCategory.contains(category)) {
                  _selectedCategory.add(category);
                }
              } else {
                if (_selectedCategory.contains(category)) {
                  _selectedCategory.remove(category);
                }
              }
            });
          });
      widgetChips.add(Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: chip,
      ));
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10.0,
      children: widgetChips,
    );
  }
}
