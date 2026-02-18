import 'package:faith_connect/core/common/widgets/app_image.dart';
import 'package:faith_connect/core/common/widgets/common_text_form_field.dart';
import 'package:faith_connect/core/common/widgets/custom_text.dart';
import 'package:faith_connect/core/common/widgets/gradient_button.dart';
import 'package:faith_connect/core/constants/constant_images.dart';
import 'package:faith_connect/core/constants/constant_strings.dart';
import 'package:faith_connect/core/routes/route_names.dart';
import 'package:faith_connect/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/common/widgets/common_snackbar.dart';
import '../../../../../../core/common/widgets/loading_indicator.dart';
import '../../../widgets/social_login_buttons.dart';
import '../login_bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FocusNode _passFocus;
  late FocusNode _emailFocus;
  late bool _isDialogOpen;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;


  @override
  void initState() {
    super.initState();
    _isDialogOpen = false;
    _passFocus = FocusNode();
    _emailFocus = FocusNode();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passFocus.dispose();
    _emailFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) {
        if (previous.status != current.status) return true;
        if (current.status == LoginStatus.failure && previous.failureTimeStamp != current.failureTimeStamp) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state.status == LoginStatus.loading) {
          iOSLoadingDialog(context);
          _isDialogOpen = true;
        }
        if (state.status == LoginStatus.success) {
          if(_isDialogOpen) {
            hideLoadingDialog(context);
            _isDialogOpen = false;
          }
        }
        if (state.status == LoginStatus.failure && state.errorMessage.isNotEmpty) {
          if(_isDialogOpen) {
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
                    width: MediaQuery.of(context).size.height * 0.2,
                    path: ConstantImages.appLogo,
                  ),
                  SizedBox(height: 20.h),

                  CustomText(
                    text: ConstantStrings.loginTitleText,
                    fontSize: 25.sp,
                    textColor: AppColors.velvet,
                    fontWeight: FontWeight.w600,
                  ),

                  CustomText(
                    text: ConstantStrings.loginSubTitleText,
                    maxLines: 2,
                    fontSize: 18.sp,
                    textAlign: TextAlign.center,
                    textColor: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 30.h),

                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (previous, current) => previous.email != current.email,
                    builder: (context, state) {
                      return CommonTextFormField(
                        isSuffix: false,
                        focusNode: _emailFocus,
                        controller: _emailController,
                        hintText: "Enter your email",
                        prefixIcon: Icons.mail_outlined,
                        onValueChanged: (value) => context.read<LoginBloc>().add(EmailChanged(value)),
                        onFieldSubmitting: (_) => FocusScope.of(context).requestFocus(_passFocus),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),

                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (previous, current) => previous.isPasswordVisible != current.isPasswordVisible || previous.password != current.password,
                    builder: (context, state) {
                      return CommonTextFormField(
                        isSuffix: true,
                        maximumLines: 1,
                        focusNode: _passFocus,
                        prefixIcon: Icons.lock,
                        hintText: "Enter your password",
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        isObscureText: !state.isPasswordVisible,
                        suffixIcon: state.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        onValueChanged: (value) => context.read<LoginBloc>().add(PasswordChanged(value)),
                        onFieldSubmitting: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                        onSuffixClick: () => context.read<LoginBloc>().add(TogglePasswordVisibility()),
                      );
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: (){},
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.velvet,
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            )
                        ),
                        child: Text('Forgot Password?'),
                      )
                    ],
                  ),

                  GradientButton(
                    onTap: () => context.read<LoginBloc>().add(LoginSubmitted()),
                    height: 40.h,
                    buttonText: 'Login',
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Don't have an account?",
                        fontSize: 14.sp,
                        textColor: AppColors.black,
                      ),
                      TextButton(
                        onPressed: () => context.pushNamed(RouteNames.signupName),
                        child:CustomText(
                          text: "Signup",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.velvet,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SocialLoginButton(onTap: (){}, socialIconPath: ConstantImages.googleLogo, height: 25.w, width: 25.w),
                      SocialLoginButton(onTap: (){}, socialIconPath: ConstantImages.facebookLogo, height: 25.w, width: 25.w),
                      SocialLoginButton(onTap: (){}, socialIconPath: ConstantImages.appleLogo, height: 25.w, width: 25.w),
                    ],
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
