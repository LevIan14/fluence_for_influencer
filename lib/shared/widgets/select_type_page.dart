import 'package:fluence_for_influencer/category/bloc/category_bloc.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTypePage extends StatefulWidget {
  final List<CategoryType> selectedCategoryTypeList;

  const SelectTypePage({Key? key, required this.selectedCategoryTypeList})
      : super(key: key);

  @override
  State<SelectTypePage> createState() => _SelectTypePageState();
}

class _SelectTypePageState extends State<SelectTypePage> {
  late final CategoryBloc categoryBloc;
  final CategoryRepository categoryRepository = CategoryRepository();

  List<CategoryType> _selectedCategory = [];

  bool othersSelected = false;
  final TextEditingController _otherCategoryController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryBloc = CategoryBloc(categoryRepository: categoryRepository);
    categoryBloc.add(GetCategoryTypeListRequested());
    _selectedCategory = List.from(widget.selectedCategoryTypeList);
    if (_selectedCategory.isNotEmpty) {
      othersSelected = _selectedCategory.last.categoryTypeId.isEmpty &&
          _selectedCategory.last.categoryTypeName.isNotEmpty;

      if (othersSelected) {
        _otherCategoryController.text = _selectedCategory.last.categoryTypeName;
        _selectedCategory.removeLast();
      }
    }
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
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildCategoryTypeChips(state.categoryList),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            onPressed: () {
              if (othersSelected && _otherCategoryController.text.isNotEmpty) {
                CategoryType others =
                    CategoryType("", _otherCategoryController.text);
                if (_selectedCategory.isNotEmpty) {
                  if (_selectedCategory.last.categoryTypeId.isEmpty &&
                      _selectedCategory.last.categoryTypeName.isNotEmpty) {
                    _selectedCategory.last = others;
                  } else {
                    _selectedCategory.add(others);
                  }
                } else {
                  _selectedCategory.add(others);
                }
                Navigator.pop(context, _selectedCategory);
              } else if (!othersSelected) {
                if (_selectedCategory.isNotEmpty) {
                  Navigator.pop(context, _selectedCategory);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Pilih minimal satu kategori'),
                    backgroundColor: Colors.red[300],
                  ));
                }
              }
            },
            child: const Text('Kirim'),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryTypeChips(List<CategoryType> categories) {
    List<Widget> widgetChips = [];
    for (CategoryType category in categories) {
      bool selected = _selectedCategory
          .any((element) => element.categoryTypeId == category.categoryTypeId);
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
                _selectedCategory.add(category);
              } else {
                _selectedCategory.removeWhere((element) =>
                    element.categoryTypeId == category.categoryTypeId);
              }
            });
          });
      widgetChips.add(Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: chip,
      ));
    }

    Widget othersChip = FilterChip(
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 13.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        selectedColor: Constants.primaryColor.withOpacity(0.6),
        backgroundColor: Constants.secondaryColor.withOpacity(0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
              width: 0.5,
              color: othersSelected
                  ? Constants.grayColor.withOpacity(0.5)
                  : Constants.secondaryColor),
        ),
        elevation: othersSelected ? 0.5 : 0,
        checkmarkColor: othersSelected ? Colors.white : null,
        label: Text('Others',
            style: TextStyle(
                fontSize: 14.0,
                color: othersSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w400)),
        selected: othersSelected,
        onSelected: (bool value) {
          setState(() {
            if (!value) {
              _otherCategoryController.clear();
            }
            othersSelected = value;
          });
        });
    widgetChips.add(Container(
        margin: const EdgeInsets.only(bottom: 5.0), child: othersChip));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10.0,
          children: widgetChips,
        ),
        othersSelected
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: SizedBox(
                    width: double.infinity,
                    child: AppTextfield(
                      field: 'Lainnya',
                      fieldController: _otherCategoryController,
                      validator: (value) {
                        return value!.isEmpty ? 'Masukkan nama kategori' : null;
                      },
                    )))
            : Container()
      ],
    );
  }
}
