import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/coffee/advertisment/advertisment_viewModel.dart';
import 'package:template/features/coffee/advertisment/models/advertisment.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';

class AdvertismentPage extends StatefulWidget {
  final AdvertismentViewModel viewModel;
  const AdvertismentPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<AdvertismentPage> createState() => _AdvertismentPageState();
}

class _AdvertismentPageState extends State<AdvertismentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            BlocBuilder<GenericCubit<List<Advertisment>>, GenericCubitState<List<Advertisment>>>(
                bloc: widget.viewModel.advertisments,
                builder: (context, state) {
                  return state is GenericLoadingState?
                  Loading():
                  state.data.isEmpty?
                  const EmptyData():
                  Container(
                    child: Column(
                      children: [
                        Text("Coffee ${state.data.first.coffeeShopData?.name} Advertisement", style: AppStyles.kTextStyleHeader20,),
                        AppSize.h10.ph,
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
                                          Expanded(child: Text(menu.title ?? "", style: AppStyles.kTextStyleHeader13.copyWith(
                                              fontWeight: FontWeight.bold
                                          ),)),
                                          Row(
                                            children: [
                                              Text(menu.startDate.toString() ?? "", style: AppStyles.kTextStyle20,),
                                              AppSize.h5.pw,
                                              Text("-", style: AppStyles.kTextStyleHeader20,),
                                              AppSize.h5.pw,
                                              Text(menu.endDate.toString() ?? "", style: AppStyles.kTextStyleHeader20,)
                                            ],
                                          )
                                        ],
                                      ),
                                      AppSize.h10.ph,
                                      Text(menu.description ?? "")
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index){
                              return AppSize.h5.pw;
                            },
                            itemCount: state.data.length
                        ),
                      ],
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
