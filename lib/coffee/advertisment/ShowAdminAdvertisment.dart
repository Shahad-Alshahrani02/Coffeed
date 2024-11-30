import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:template/features/coffee/advertisment/advertisment_viewModel.dart';
import 'package:template/features/coffee/advertisment/models/advertisment.dart';
import 'package:template/features/toggleBetweenUsers/background_page.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class ShowAdminAdvertisment extends StatefulWidget {
  const ShowAdminAdvertisment({Key? key}) : super(key: key);

  @override
  State<ShowAdminAdvertisment> createState() => _ShowAdminAdvertismentState();
}

class _ShowAdminAdvertismentState extends State<ShowAdminAdvertisment> {
  AdvertismentViewModel viewModel = AdvertismentViewModel();

  @override
  void initState() {
    viewModel.getAllAdvertisementsForAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kWhiteColor,
        title: Text("All Advertisements", style: AppStyles.kTextStyleHeader20,),
        centerTitle: true,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
            borderSide: BorderSide.none
        ),
      ),
      body: BackgroundPage(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100.sp, left: 10.sp, right: 10.sp, top: 20.sp),
          child: Column(
            children: [
              BlocBuilder<GenericCubit<List<Advertisment>>, GenericCubitState<List<Advertisment>>>(
                  bloc: viewModel.allAdvertisments,
                  builder: (context, state) {
                    return state is GenericLoadingState?
                    const Loading():
                    state.data.isEmpty?
                    const EmptyData():
                    ListView.separated(
                        shrinkWrap: true,
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(menu.title ?? "",
                                          maxLines: 20,
                                          style: AppStyles.kTextStyleHeader13.copyWith(
                                            fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                      Row(
                                        children: [
                                          Text(DateFormat("yyyy-MM-dd").format(menu.startDate!), style: AppStyles.kTextStyle14,),
                                          AppSize.h5.pw,
                                          Text("/", style: AppStyles.kTextStyleHeader20,),
                                          AppSize.h5.pw,
                                          Text(DateFormat("yyyy-MM-dd").format(menu.endDate!), style: AppStyles.kTextStyle14,),
                                        ],
                                      ),
                                    ],
                                  ),
                                  AppSize.h10.ph,
                                  Row(
                                    children: [
                                      Expanded(child: Text(menu.description ?? "")),
                                      AppSize.h10.pw,
                                      menu.isApporved != null ? Row(
                                        children: [
                                          Icon(Icons.cloud_done_outlined),
                                          AppSize.h10.pw,
                                          Text(menu.isApporved! ? "Accepted": "Rejected")
                                        ],
                                      ):SizedBox()
                                    ],
                                  ),
        
                                  menu.isApporved != null ?
                                  SizedBox():
                                  Row(
                                    children: [
                                      Expanded(
                                        child: BlocBuilder<GenericCubit<bool>,
                                            GenericCubitState<bool>>(
                                            bloc: viewModel.loading,
                                            builder: (context, state) {
                                              return state.data
                                                  ? const Loading()
                                                  :  CustomButton(title: "Accept",
                                                  btnColor: AppColors.kSearchColor,
                                                  textColor: AppColors.kBlackCColor,
                                                  radius: 40,
                                                  textSize: 25.sp,
                                                  onClick: (){
                                                    viewModel.updateAdvertisementStatus(menu, true);
                                              });
                                            }
                                        ),
                                      ),
        
                                      AppSize.h20.pw,
        
                                      Expanded(
                                        child: BlocBuilder<GenericCubit<bool>,
                                            GenericCubitState<bool>>(
                                            bloc: viewModel.loading,
                                            builder: (context, state) {
                                              return state.data
                                                  ? const Loading()
                                                  :  CustomButton(title: "Reject",
                                                  btnColor: AppColors.kSearchColor,
                                                  textColor: AppColors.kBlackCColor,
                                                  radius: 40,
                                                  textSize: 25.sp,
                                                  onClick: (){
                                                    viewModel.updateAdvertisementStatus(menu, false);
                                              });
                                            }
                                        ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
