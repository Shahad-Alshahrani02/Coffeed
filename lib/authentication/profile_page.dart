import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/authentication/user_viewModel.dart';
import 'package:template/features/authentication/widgets/ProfileItem.dart';
import 'package:template/features/authentication/widgets/change_password_page.dart';
import 'package:template/features/toggleBetweenUsers/background_page.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserViewModel viewModel = UserViewModel();
  @override
  void initState() {
    viewModel.getUserById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kBackgroundColor,
        leading: InkWell(
          onTap: () => UI.pop(),
          child: const Icon(Icons.arrow_back_ios_outlined),
        ),
        shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            )
        ),
        toolbarHeight: 100.sp,
        centerTitle: true,
        title: Text("Profile", style: AppStyles.kTextStyleHeader26,),
      ),
      backgroundColor: AppColors.kBackgroundColor,
      body: BackgroundPage(
        child: BlocBuilder<GenericCubit<User>,
            GenericCubitState<User>>(
          bloc: viewModel.userCubit,
          builder: (context, state) {
            var profile = state.data;
            return profile.type == null?
            const Loading():
            Container(
              color: AppColors.kWhiteColor,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 110.sp,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(90),
                                bottomRight: Radius.circular(90)
                            ),
                          ),
                        ),

                        Container(
                          height: 70.sp,
                          decoration: const BoxDecoration(
                            color: AppColors.kBackgroundColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(120),
                                bottomRight: Radius.circular(120)
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          left: 20,
                          right: 20,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              color: AppColors.kSearchColor
                            ),
                            padding: EdgeInsets.all(20.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                profile.profile_image != null ?
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: Image.network(
                                      profile.profile_image ?? "",
                                      height: 80.sp,
                                      width: 80.sp,
                                      fit: BoxFit.fill,
                                    )
                                ): ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child:  Image.asset(Resources.user,
                                      height: 100.sp,
                                      width: 100.sp,
                                      fit: BoxFit.fill,
                                    )
                                ),
                                AppSize.h16.pw,
                                Expanded(child: Text( profile.name ?? "", style: AppStyles.kTextStyleHeader20,)),
                                InkWell(
                                  onTap: (){
                                    if(profile.type == 1 )
                                      UI.push(AppRoutes.adminRegisterPage , arguments: profile);
                                    else if(profile.type == 3)
                                      UI.push(AppRoutes.coffeeRegisterPage, arguments: profile);
                                    else
                                      UI.push(AppRoutes.customerRegisterPage, arguments: profile);
                                  },
                                  child: Image.asset(
                                    Resources.edit_profile,
                                    height: 25.sp
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSize.h10.ph,
                          ProfileItem(AppStyles.kTextStyle16, profile.phone, Resources.phone),
                          ProfileItem(AppStyles.kTextStyle14.copyWith(fontWeight: FontWeight.bold), profile.email, Resources.email),
                          ProfileItem(AppStyles.kTextStyle18, profile.address , Resources.location),

                          AppSize.h30.ph,

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomButton(title: "Edit password",
                                      onClick: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
                                  }),
                                ),

                                AppSize.h30.pw,

                                Expanded(
                                  child: CustomButton(title: "Logout",
                                      btnColor: AppColors.redColor757,
                                      onClick: (){
                                    PrefManager.clearUserData();
                                    UI.pushWithRemove(AppRoutes.loginPage);
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
