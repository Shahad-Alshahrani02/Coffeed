import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/coffee/advertisment/advertisment_viewModel.dart';
import 'package:template/features/coffee/advertisment/models/advertisment.dart';
import 'package:template/features/coffee/advertisment/widgets/AddAdvertisement.dart';
import 'package:template/features/coffee/home/home_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';

class ListAdvertisement extends StatelessWidget {
  final HomeViewModel homeViewModel;
  final AdvertismentViewModel viewModel;
  const ListAdvertisement({Key? key, required this.viewModel, required this.homeViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<List<Advertisment>>, GenericCubitState<List<Advertisment>>>(
        bloc: viewModel.advertisments,
        builder: (context, state) {
          return state is GenericLoadingState?
          Loading():
          state.data.isEmpty?
          const EmptyData(): ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 100.sp),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              var menu = state.data.elementAt(index);
              return Card(
                color: AppColors.kWhiteColor,
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(10.sp),
                  width: 220.sp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: Image.network(
                              menu.image ?? "",
                              height: 50.sp,
                              width: 50.sp,
                              fit: BoxFit.cover,
                            ),
                          ),
                          AppSize.h10.pw,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(menu.title ?? "", style: AppStyles.kTextStyleHeader16.copyWith(
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                    Text(menu.coffeeShopData?.name ?? "", style: AppStyles.kTextStyleHeader16.copyWith(
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ],
                                ),
                                AppSize.h5.pw,
                                Row(
                                  children: [
                                    Text("Start Date: ", style: AppStyles.kTextStyle16),
                                    Text(DateFormat('yyyy-MM-dd').format(menu.startDate!)?? "",
                                      style: AppStyles.kTextStyle16,),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("End Date: ", style: AppStyles.kTextStyle16,),
                                    Text(DateFormat('yyyy-MM-dd').format(menu.endDate!) ?? "",
                                      style: AppStyles.kTextStyle16,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppSize.h10.ph,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          menu.image ?? "",
                          height: 120.sp,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      AppSize.h10.ph,
                      Text(menu.description ?? ""),
                      AppSize.h5.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                              title: "Update",
                              height: 30.sp,
                              width: 80.sp,
                              textSize: 13.sp,
                              btnColor: AppColors.kMainColor,
                              onClick: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddAdvertisement(viewModel: homeViewModel, advertismentViewModel: viewModel, advertisment: menu,)));
                              }),
                          AppSize.h20.pw,
                          BlocBuilder<GenericCubit<bool>,
                              GenericCubitState<bool>>(
                              bloc: viewModel.loading,
                              builder: (context, state) {
                                return state.data
                                    ? const Loading()
                                    : CustomButton(
                                  title: "Delete",
                                  height: 30.sp,
                                  width: 80.sp,
                                  textSize: 13.sp,
                                  btnColor: AppColors.kRedColor,
                                  onClick: (){
                                    viewModel.deleteAdvertisement(menu.id ?? "");
                                  });
                            }
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index){
              return AppSize.h5.pw;
            },
            itemCount: state.data.length
        );
      }
    );
  }
}
