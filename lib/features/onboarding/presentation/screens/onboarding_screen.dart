import 'package:faith_connect/core/common/widgets/app_image.dart';
import 'package:faith_connect/core/common/widgets/dot_indicator.dart';
import 'package:faith_connect/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/widgets/gradient_button.dart';
import '../widgets/onboarding_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constant_images.dart';
import '../../../../core/constants/constant_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:faith_connect/features/onboarding/presentation/bloc/on_boarding_bloc.dart';

import '../widgets/role_selection_page.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnBoardingBloc, OnBoardingState>(
        listener: (context, state) {
          if (state is CurrentOnboardingState){
            if (state.isComplete) {
              context.goNamed(RouteNames.signupName);
            } else {
              _pageController.animateToPage(
                state.currentStep,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          }
        },
        builder: (context, state) {
          if (state is! CurrentOnboardingState) {
            return const Center(child: CircularProgressIndicator());
          }
          final int currentIndex = state.currentStep;
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppImage(
                  height: MediaQuery.of(context).size.height * 0.06,
                  path: ConstantImages.appLogo2,
                ),
                SizedBox(height: 10.h),

                Expanded(
                  child: PageView(
                    pageSnapping: true,
                    controller: _pageController,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index) {
                      context.read<OnBoardingBloc>().add(OnPageChangedEvent(pageIndex: index));
                    },
                    children: [
                      OnboardingPage(
                        image: ConstantImages.onBoarding1,
                        title: ConstantStrings.onBoardingTitle1,
                        subtitle: ConstantStrings.onBoardingSubTitle1,
                      ),
                      OnboardingPage(
                        image: ConstantImages.onBoarding2,
                        title: ConstantStrings.onBoardingTitle2,
                        subtitle: ConstantStrings.onBoardingSubTitle2,
                      ),
                      RoleSelectionPage(
                        roleImage1: ConstantImages.worshiperLogo,
                        roleImage2: ConstantImages.leaderLogo,
                        title: ConstantStrings.onBoardingTitle3,
                        subTitle: ConstantStrings.onBoardingSubTitle3,
                        roleTitleFirst: ConstantStrings.roleSelectionTitle1,
                        roleTitleSecond: ConstantStrings.roleSelectionTitle2,
                        roleSubTitleFirst: ConstantStrings.roleSelectionSubTitle1,
                        roleSubTitleSecond: ConstantStrings.roleSelectionSubTitle2,
                        onButtonFirstTapped: () => context.read<OnBoardingBloc>().add(SetOnBoardingStatusEvent(role: "worshiper")),
                        onButtonSecondTapped: () => context.read<OnBoardingBloc>().add(SetOnBoardingStatusEvent(role: "leader")),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),

                CustomDotIndicator(
                  dotsCount: state.totalSteps,
                  currentPosition: currentIndex.toDouble(),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentIndex != 0) Expanded(
                      child: GradientButton(
                        height: 40.h,
                        onTap: () {
                          if (currentIndex != 0) {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        buttonText: "Previous",
                      ),
                    ),
                    if (currentIndex != state.totalSteps - 1) Expanded(
                      child: GradientButton(
                        height: 40.h,
                        onTap: () {
                          debugPrint("page no. :${state.currentStep}");
                          if (currentIndex != state.totalSteps - 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        buttonText: "Next",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
