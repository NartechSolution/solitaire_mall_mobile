// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solitaire/constants/constant.dart';
import 'package:solitaire/cubit/auth/auth_cubit.dart';
import 'package:solitaire/cubit/auth/auth_state.dart';
import 'package:solitaire/screens/customer_profile/customer_profile_screen.dart';
import 'package:solitaire/utils/app_loading.dart';
import 'package:solitaire/utils/app_navigator.dart';
import 'package:solitaire/widgets/error_dialog.dart';
import 'login_screen.dart';
import 'package:solitaire/widgets/success_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _agreedToTerms = false;

  // Add controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Add focus nodes
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    // Dispose focus nodes
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    SuccessDialog.show(
      context,
      title: 'Signing Up Successfully',
      buttonText: 'OK',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          print(state);
          if (state is RegisterSuccess) {
            AppNavigator.pushReplacement(
                context, const CustomerProfileScreen());
            _showSuccessDialog();
          }
          if (state is RegisterError) {
            ErrorDialog.show(
              context,
              title: state.message.replaceAll("Exception:", ""),
              buttonText: 'OK',
            );
          }
        },
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'SOLITAIRE',
                        style: TextStyle(
                          fontSize: 28,
                          color: AppColors.primaryColor,
                          letterSpacing: 10,
                        ),
                      ),
                      Opacity(
                        opacity: 0.8,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.purpleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: TextField(
                                  controller: _nameController,
                                  focusNode: _nameFocus,
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_phoneFocus);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter Full Name',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    isDense: true,
                                    constraints: const BoxConstraints(
                                      maxHeight: 40,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: IntlPhoneField(
                                  disableLengthCheck: true,
                                  controller: _phoneController,
                                  focusNode: _phoneFocus,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Mobile No.',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                  ),
                                  initialCountryCode: 'SA',
                                  onSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_emailFocus);
                                  },
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.emailAddress,
                                  onSubmitted: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter Email Address',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    isDense: true,
                                    constraints: const BoxConstraints(
                                      maxHeight: 40,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: Colors.orange,
                                    value: _agreedToTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _agreedToTerms = value ?? false;
                                      });
                                    },
                                  ),
                                  const Text(
                                    'I agree to the processing of ',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const Text(
                                    'Personal Data',
                                    style: TextStyle(
                                      color: AppColors.purpleColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.secondaryColor,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthCubit>().registerUser(
                                          _nameController.text.trim(),
                                          _phoneController.text.trim(),
                                          _emailController.text.trim(),
                                        );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondaryColor,
                                    minimumSize:
                                        const Size(double.infinity, 45),
                                  ),
                                  child: state is RegisterLoading
                                      ? const AppLoading(
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : const Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ),
                              const Divider(color: AppColors.purpleColor),
                              const Center(child: Text('or Sign up with')),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _socialButton(FontAwesomeIcons.facebook,
                                      AppColors.purpleColor),
                                  _socialButton(
                                      FontAwesomeIcons.twitter, Colors.black),
                                  _socialButton(
                                      FontAwesomeIcons.google, Colors.red),
                                  _socialButton(
                                      FontAwesomeIcons.apple, Colors.black),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: RichText(
                                  text: const TextSpan(
                                    text: 'Tap ',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Login',
                                        style: TextStyle(
                                          color: AppColors.purpleColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' button if already have account',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Opacity(
                            opacity: 0.9,
                            child: SizedBox(
                              width: 150,
                              height: 40,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black38,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  AppNavigator.push(
                                      context, const LoginScreen());
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
        child: FaIcon(icon, color: color, size: 20),
      ),
    );
  }
}
