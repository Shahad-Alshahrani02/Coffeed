import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/features/admin/home/admin_home_viewModel.dart';
import 'package:template/features/coffee/home/home_viewModel.dart';
import 'package:template/features/coffee/home/models/coffee_shop.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/custom_dropdown.dart';
import 'package:template/shared/ui/componants/custom_field.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBar.dart';

class AddCategory extends StatefulWidget {
  final AdminHomeViewModel viewModel;
  const AddCategory({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  HomeViewModel viewModel = HomeViewModel();

  @override
  void initState() {
    widget.viewModel.selectedCoffee.onUpdateData(null);
    widget.viewModel.name = TextEditingController(text: "");
    viewModel.getAllCoffeeShops();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Add New Category", context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: widget.viewModel.formKey,
          child: ListView(
            children: [
              CustomField(
                controller: widget.viewModel.name,
                hint: "Coffee name",
                validator:  (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a coffee name';
                  }
                  return null;
                },
              ),
              AppSize.h20.ph,

              BlocBuilder<GenericCubit<List<CoffeeShope>>, GenericCubitState<List<CoffeeShope>>>(
                  bloc: viewModel.allCoffeeShopes,
                  builder: (context, coffeState) {
                    return BlocBuilder<GenericCubit<CoffeeShope?>, GenericCubitState<CoffeeShope?>>(
                      bloc: widget.viewModel.selectedCoffee,
                      builder: (context, state) {
                        print(state.data);
                        return coffeState is GenericLoadingState ?
                        Loading(): CustomDropdown(
                            value: state.data,
                            hint: "Select Coffee Shop",
                            items: coffeState.data.map((e){
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e.name ?? "", style:  AppStyles.kTextStyleHeader14.copyWith(
                                  color: AppColors.kBlackColor,
                                ),),
                              );
                            }).toList(),
                            onChange: (e){
                              print(e.id);
                              print(e.name);
                              widget.viewModel.selectedCoffee.onUpdateData(e);
                            }
                        );
                      }
                  );
                }
              ),
              AppSize.h40.ph,
              BlocBuilder<GenericCubit<bool>,
                  GenericCubitState<bool>>(
                  bloc: widget.viewModel.loading,
                  builder: (context, state) {
                    return state is GenericLoadingState || state.data
                        ? const Loading()
                        :  CustomButton(title: "Add Coffee Shop", onClick: widget.viewModel.addCategory);
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
