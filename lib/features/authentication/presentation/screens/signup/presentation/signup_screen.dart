import 'package:faith_connect/core/common/widgets/editable_profile_image.dart';
import 'package:faith_connect/features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/common/widgets/app_image.dart';
import '../../../../../../core/common/widgets/common_snackbar.dart';
import '../../../../../../core/common/widgets/common_text_form_field.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/common/widgets/gradient_button.dart';
import '../../../../../../core/common/widgets/loading_indicator.dart';
import '../../../../../../core/constants/constant_images.dart';
import '../../../../../../core/constants/constant_strings.dart';
import '../../../../../../core/routes/route_names.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';
import '../signup_bloc/signup_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late bool _isDialogOpen;
  late FocusNode _bioNode;
  late FocusNode _emailNode;
  late FocusNode _faithNode;
  late FocusNode _passwordNode;
  late FocusNode _fullNameNode;

  late TextEditingController _bioController;
  late TextEditingController _roleController;
  late TextEditingController _faithController;
  late TextEditingController _emailController;
  late TextEditingController _fullNameController;
  late TextEditingController _passwordController;


  @override
  void initState() {
    super.initState();
    final state = context.read<OnBoardingBloc>().state;
    _isDialogOpen = false;
    _bioNode = FocusNode();
    _faithNode = FocusNode();
    _emailNode = FocusNode();
    _passwordNode = FocusNode();
    _fullNameNode = FocusNode();

    _bioController = TextEditingController();
    if (state is CurrentOnboardingState) {
      _roleController = TextEditingController(text: state.role!.toUpperCase());
      context.read<SignupBloc>().add(SignupRoleChanged(state.role!));
    } else {
      _roleController = TextEditingController();
    }
    _faithController = TextEditingController();
    _emailController = TextEditingController();
    _fullNameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _bioNode.dispose();
    _emailNode.dispose();
    _faithNode.dispose();
    _passwordNode.dispose();
    _fullNameNode.dispose();

    _bioController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _faithController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _showFaithPicker(BuildContext signupContext) {
    final List<String> faiths = ['Hinduism', 'Christianity', 'Islam', 'Judaism', 'Buddhism', 'Other'];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) {
        return Container(
          color: AppColors.white,
          padding: EdgeInsets.all(20.r),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(text: "Select Your Faith", fontSize: 20.sp, fontWeight: FontWeight.bold, textColor: AppColors.black,),
                SizedBox(height: 10.h),
                Divider(),
                ...faiths.map((faith) => ListTile(
                  title: Text(faith),
                  onTap: () {
                    _faithController.text = faith;
                    signupContext.read<SignupBloc>().add(SignupFaithChanged(_faithController.text));
                    Navigator.pop(context);
                  },
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (previous, current) {
        if (previous.status != current.status) return true;
        if (current.status == SignupStatus.failure && previous.failureTimeStamp != current.failureTimeStamp) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state.status == SignupStatus.loading) {
          _isDialogOpen = true;
          iOSLoadingDialog(context, message: "Creating your account, Please wait...");
        }
        if (state.status == SignupStatus.success) {
          if (_isDialogOpen) {
            hideLoadingDialog(context);
            _isDialogOpen = false;
          }
          /// Go router will handle it...
        }
        if (state.status == SignupStatus.failure && state.errorMessage.isNotEmpty) {
          if (_isDialogOpen) {
            hideLoadingDialog(context);
            _isDialogOpen = false;
          }
          showSnackBar(context: context, message: state.errorMessage);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15.w, vertical: 12.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppImage(
                    width: MediaQuery.of(context).size.height * 0.3,
                    path: ConstantImages.appLogo2,
                  ),
                  SizedBox(height: 5.h),

                  CustomText(
                    text: ConstantStrings.signupTitleText,
                    fontSize: 24.sp,
                    textColor: AppColors.velvet,
                    fontWeight: FontWeight.w600,
                  ),

                  CustomText(
                    text: ConstantStrings.signupSubTitleText,
                    maxLines: 2,
                    fontSize: 16.sp,
                    textAlign: TextAlign.center,
                    textColor: AppColors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(height: 10.h),

                  BlocBuilder<SignupBloc, SignupState>(
                    builder: (context, state) {
                      return EditableProfileImage(
                        radius: 35.r,
                        localImage: state.profileImage,
                        onPickGallery: () => context.read<SignupBloc>().add(SignupGalleryImageRequested()),
                        onPickCamera: () => context.read<SignupBloc>().add(SignupCameraImageRequested()),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),

                  BlocBuilder<SignupBloc, SignupState>(
                    buildWhen: (previous, current) => previous.fullName != current.fullName,
                    builder: (context, state) {
                      return CommonTextFormField(
                        isSuffix: false,
                        maximumLines: 1,
                        hintText: 'Full Name',
                        focusNode: _fullNameNode,
                        prefixIcon: Icons.text_format,
                        controller: _fullNameController,
                        onFieldSubmitting: (_) =>  FocusScope.of(context).requestFocus(_emailNode),
                        onValueChanged: (value) => context.read<SignupBloc>().add(SignupNameChanged(value)),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),

                  BlocBuilder<SignupBloc, SignupState>(
                    buildWhen: (previous, current) => previous.email != current.email,
                    builder: (context, state) {
                      return CommonTextFormField(
                        isSuffix: false,
                        maximumLines: 1,
                        hintText: "Email",
                        isObscureText: false,
                        focusNode: _emailNode,
                        controller: _emailController,
                        prefixIcon: Icons.mail_outline,
                        onFieldSubmitting: (_) => FocusScope.of(context).requestFocus(_passwordNode),
                        onValueChanged: (value) => context.read<SignupBloc>().add(SignupEmailChanged(value)),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),

                  BlocBuilder<SignupBloc, SignupState>(
                    buildWhen: (previous, current) => previous.isPasswordVisible != current.isPasswordVisible || previous.password != current.password,
                    builder: (context, state) {
                      return CommonTextFormField(
                        isSuffix: true,
                        maximumLines: 1,
                        hintText: 'Password',
                        prefixIcon: Icons.lock,
                        focusNode: _passwordNode,
                        controller: _passwordController,
                        isObscureText: !state.isPasswordVisible,
                        suffixIcon: state.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        onFieldSubmitting: (_) =>  FocusScope.of(context).requestFocus(_faithNode),
                        onSuffixClick: () => context.read<SignupBloc>().add(SignupPasswordVisibilityToggled()),
                        onValueChanged: (value) => context.read<SignupBloc>().add(SignupPasswordChanged(value)),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),

                  CommonTextFormField(
                    readOnly: true,
                    isSuffix: false,
                    maximumLines: 1,
                    hintText: 'Role',
                    controller: _roleController,
                    prefixIcon: Icons.accessibility,
                  ),
                  SizedBox(height: 10.h),

                  CommonTextFormField(
                    isSuffix: true,
                    readOnly: true,
                    maximumLines: 1,
                    hintText: 'Select your faith',
                    focusNode: _faithNode,
                    prefixIcon: Icons.front_hand,
                    controller: _faithController,
                    suffixIcon: Icons.arrow_drop_down_circle_outlined,
                    onFieldSubmitting: (_) =>  FocusScope.of(context).requestFocus(_bioNode),
                    onTap: () => _showFaithPicker(context),
                  ),
                  SizedBox(height: 10.h),

                  BlocBuilder<SignupBloc, SignupState>(
                      buildWhen: (previous, current) => previous.bio != current.bio,
                      builder: (context, state) {
                      return CommonTextFormField(
                        isSuffix: false,
                        isPrefix: false,
                        hintText: 'Bio',
                        maximumLines: 2,
                        focusNode: _bioNode,
                        controller: _bioController,
                        keyboardType: TextInputType.multiline,
                        onValueChanged: (value) => context.read<SignupBloc>().add(SignupBioChanged(value)),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),

                  GradientButton(
                    onTap: () => context.read<SignupBloc>().add(SignupSubmitted()),
                    height: 40.h,
                    buttonText: 'Signup',
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Already have an account?",
                        fontSize: 14.sp,
                        textColor: AppColors.black,
                      ),
                      TextButton(
                        onPressed: () => context.goNamed(RouteNames.loginName),
                        child:CustomText(
                          text: "Login",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.velvet,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
