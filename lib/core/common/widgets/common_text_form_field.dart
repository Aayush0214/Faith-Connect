import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonTextFormField extends StatelessWidget {
  final bool _isSuffix;
  final bool _isPrefix;
  final bool _readOnly;
  final String _hintText;
  final int? _maximumLines;
  final String? _errorText;
  final bool _isObscureText;
  final FocusNode? _focusNode;
  final IconData? _prefixIcon;
  final IconData? _suffixIcon;
  final void Function()? _onTap;
  final TextInputType? _keyboardType;
  final VoidCallback? _onSuffixClick;
  final Function(String)? _onValueChanged;
  final Function(String)? _onFieldSubmitted;
  final List<TextInputFormatter>? _inputFormatter;
  const CommonTextFormField({
    super.key,
    required bool isSuffix,
    required String hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    String? errorText,
    bool isPrefix = true,
    int? maximumLines,
    bool isObscureText = false,
    bool readOnly = false,
    FocusNode? focusNode,
    void Function()? onTap,
    VoidCallback? onSuffixClick,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
    List<TextInputFormatter>? formatters,
    Function(String)? onFieldSubmitting,
    Function(String)? onValueChanged,
  }) : _isSuffix = isSuffix,
        _onTap = onTap,
        _isPrefix = isPrefix,
        _hintText = hintText,
        _focusNode = focusNode,
        _errorText = errorText,
        _prefixIcon = prefixIcon,
        _suffixIcon = suffixIcon,
        _readOnly = readOnly,
        _maximumLines = maximumLines,
        _inputFormatter = formatters,
        _keyboardType = keyboardType,
        _onSuffixClick = onSuffixClick,
        _editingController = controller,
        _isObscureText = isObscureText,
        _onValueChanged = onValueChanged,
        _onFieldSubmitted = onFieldSubmitting;

  final TextEditingController _editingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: _onTap,
      autocorrect: false,
      readOnly: _readOnly,
      focusNode: _focusNode,
      maxLines: _maximumLines,
      textAlign: TextAlign.left,
      onChanged: _onValueChanged,
      obscureText: _isObscureText,
      keyboardType: _keyboardType,
      controller: _editingController,
      inputFormatters: _inputFormatter,
      onFieldSubmitted: _onFieldSubmitted,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: _hintText,
        errorText: _errorText,
        prefixIcon: _isPrefix ? Icon(_prefixIcon) : null,
        suffixIcon: _isSuffix
            ? IconButton(
          onPressed: _onSuffixClick,
          icon: Icon(_suffixIcon),
          style: IconButton.styleFrom(
            fixedSize: Size(30.w, 25.h),
            backgroundColor: AppColors.transparent,
          ),
        ) : null,
        filled: true,
        isDense: false,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),

        // Icons
        prefixIconColor: AppColors.textSecondaryLight,
        suffixIconColor: AppColors.textSecondaryLight,

        hintStyle: TextStyle(
          color: AppColors.textHintLight,
          fontWeight: FontWeight.normal,
        ),

        // Borders
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.borderLight, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.borderLight, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.velvet, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.errorLight, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.errorLight, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColors.borderLight.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}