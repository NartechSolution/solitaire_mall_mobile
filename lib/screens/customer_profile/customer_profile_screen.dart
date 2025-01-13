import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire/constants/constant.dart';
import 'package:solitaire/cubit/customer_profile/profile_cubit.dart';
import 'package:solitaire/cubit/customer_profile/profile_state.dart';
import 'package:solitaire/model/user_model.dart';
import 'package:solitaire/screens/auth/start_screen.dart';
import 'package:solitaire/screens/customer_profile/select_services_screen.dart';
import 'package:solitaire/screens/customer_profile/wallet_topup_screen.dart';
import 'package:solitaire/utils/app_loading.dart';
import 'package:solitaire/utils/app_navigator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solitaire/utils/app_preferences.dart';
import 'dart:io';

import 'package:solitaire/widgets/success_dialog.dart';
import 'package:solitaire/widgets/nfc_enable_dialog.dart';

class ProfileData {
  String name;
  String phone;
  String email;
  String address;
  String image;

  ProfileData({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.image,
  });
}

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  late ProfileData _profileData = ProfileData(
    name: '',
    phone: '',
    email: '',
    address: '',
    image: 'assets/background.png',
  );
  Map<String, bool> _switchStates = {
    'NFC': false,
    'Fingerprint': false,
  };

  ProfileCubit profileCubit = ProfileCubit();
  AppPreferences appPreferences = AppPreferences();

  bool? hasNfc;
  bool? hasFingerprint;
  bool? isDisabled;

  @override
  void initState() {
    super.initState();
    profileCubit.getCustomerProfile();

    hasNfc = AppPreferences.getHasNfc();
    hasFingerprint = AppPreferences.getHasFingerprint();

    // Initialize switch states
    _switchStates = {
      'NFC': hasNfc ?? false,
      'Fingerprint': hasFingerprint ?? false,
    };
  }

  Future<void> _showEditDialog(
      String title, String currentValue, Function(String) onSave) async {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Edit $title',
            style: const TextStyle(
              color: AppColors.purpleColor,
              fontSize: 12,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter $title',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.purpleColor,
                  fontSize: 12,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColors.purpleColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResetPasswordDialog() async {
    bool obscurePassword = true;
    bool obscureConfirmPassword = true;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Reset Password',
                style: TextStyle(
                  color: AppColors.purpleColor,
                  fontSize: 12,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: profileCubit.passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter new password',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: profileCubit.confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm new password',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.purpleColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (profileCubit.passwordController.text.isEmpty ||
                        profileCubit.confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in both fields')),
                      );
                      return;
                    }

                    if (profileCubit.passwordController.text !=
                        profileCubit.confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                      return;
                    }

                    setState(() {
                      profileCubit.oldPasswordController.text =
                          profileCubit.passwordController.text;
                    });
                    profileCubit.updateCustomerProfile(
                      UserModel(
                        password: profileCubit.passwordController.text,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.purpleColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildProfileItem(String text, IconData icon,
      {required Function() onEdit}) {
    return Container(
      width: double.infinity,
      height: 40,
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
          ),
          IconButton(
            icon: Icon(
              icon,
              size: 16,
              color: AppColors.purpleColor,
            ),
            onPressed: onEdit,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Full screen image with error handling
              InteractiveViewer(
                child: Image(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/default_profile.png',
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
              // Close button
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  File? _imageFile;
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress image quality to 80%
      );

      if (image != null) {
        // Show loading indicator
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Uploading image...')),
          );
        }

        // Update local state
        setState(() {
          _profileData.image = image.path;
          _imageFile = File(image.path);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image updated successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _showSuccessDialog(String title) {
    SuccessDialog.show(
      context,
      title: title,
      buttonText: 'OK',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          bloc: profileCubit,
          listener: (context, state) {
            if (state is ProfileSuccess) {
              setState(() {
                _profileData = ProfileData(
                  name: profileCubit.nameController.text,
                  phone: profileCubit.phoneController.text,
                  email: profileCubit.emailController.text,
                  address: profileCubit.addressController.text,
                  image: profileCubit.imageUrl,
                );
              });
            }
            if (state is ProfileUpdateSuccess) {
              if (mounted) {
                _showSuccessDialog('Profile updated successfully');
                profileCubit.getCustomerProfile();
              }
            }
            if (state is ProfileUpdateError) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message.replaceAll('Exception:', ''),
                    ),
                  ),
                );
              }
            }
            if (state is FingerprintEnableDisableSuccess) {
              if (mounted) {
                hasFingerprint == false && isDisabled == false
                    ? _showSuccessDialog('Fingerprint enabled successfully')
                    : _showSuccessDialog('Fingerprint disabled successfully');
              }
              profileCubit.getCustomerProfile();
            }
            if (state is NfcEnableDisableSuccess) {
              if (mounted) {
                hasNfc == false
                    ? _showSuccessDialog('NFC enabled successfully')
                    : _showSuccessDialog('NFC disabled successfully');
              }
              profileCubit.getCustomerProfile();
            }
            if (state is NfcEnableDisableError) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message.replaceAll('Exception:', '')),
                  ),
                );
              }
            }
            if (state is FingerprintEnableDisableError) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text(state.message.replaceAll('Exception:', ''))),
                );
                hasFingerprint = false;
                profileCubit.getCustomerProfile();
              }
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
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Button and Title Row
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, size: 20),
                              onPressed: () => Navigator.pop(context),
                              color: AppColors.purpleColor,
                            ),
                            const Text(
                              'Customer Profile',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.purpleColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Profile Section with Image and Wallet
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Profile Image
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => _showFullScreenImage(
                                    _profileData.image,
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.purpleColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _profileData.image
                                              .startsWith('http')
                                          ? Image.network(
                                              _profileData.image,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/background.png',
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                    color:
                                                        AppColors.purpleColor,
                                                  ),
                                                );
                                              },
                                            )
                                          : Image.file(
                                              File(_profileData.image),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/background.png',
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.purpleColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      onPressed: _pickImage,
                                      constraints: const BoxConstraints(
                                        minWidth: 30,
                                        minHeight: 30,
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Wallet Card
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 120,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Wallet',
                                    style: TextStyle(
                                      color: AppColors.purpleColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Text(
                                    'Current balance',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Column(
                                    children: [
                                      // ignore: prefer_const_constructors
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          Text(
                                            '100.00 ',
                                            style: TextStyle(
                                              color: AppColors.purpleColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'SAR',
                                            style: TextStyle(
                                              color: AppColors.purpleColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            AppNavigator.push(
                                              context,
                                              const WalletTopupScreen(),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.secondaryColor,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Topup Wallet',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Profile Information List
                        _buildProfileItem(
                          _profileData.name,
                          Icons.edit,
                          onEdit: () => _showEditDialog(
                            'Name',
                            profileCubit.nameController.text,
                            (value) => setState(
                                () => profileCubit.nameController.text = value),
                          ),
                        ),
                        _buildProfileItem(
                          _profileData.phone,
                          Icons.edit,
                          onEdit: () => _showEditDialog(
                            'Phone',
                            profileCubit.phoneController.text,
                            (value) => setState(() =>
                                profileCubit.phoneController.text = value),
                          ),
                        ),
                        _buildProfileItem(
                          _profileData.email,
                          Icons.edit,
                          onEdit: () => _showEditDialog(
                            'Email',
                            profileCubit.emailController.text,
                            (value) => setState(() =>
                                profileCubit.emailController.text = value),
                          ),
                        ),

                        _buildProfileItem(
                          profileCubit.addressController.text,
                          Icons.edit,
                          onEdit: () => _showEditDialog(
                            'Address',
                            profileCubit.addressController.text,
                            (value) => setState(() =>
                                profileCubit.addressController.text = value),
                          ),
                        ),

                        // Update Profile Button
                        const SizedBox(height: 20),

                        // reset password button
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _showResetPasswordDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Reset Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Update the image through the cubit
                              profileCubit.updateCustomerProfile(
                                UserModel(
                                  name: profileCubit.nameController.text,
                                  phone: profileCubit.phoneController.text,
                                  email: profileCubit.emailController.text,
                                  address: profileCubit.addressController.text,
                                ),
                                imageFile: _imageFile,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cyanBlueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: state is ProfileLoading
                                ? const AppLoading(
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : const Text(
                                    'Update Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        // Request Services Button
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              AppNavigator.push(
                                context,
                                const SelectServicesScreen(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purpleColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Request Services',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),
                        // logout button
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text(
                                      'Confirm Logout',
                                      style: TextStyle(
                                        color: AppColors.purpleColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    content: const Text(
                                      'Are you sure you want to logout?',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 10,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: AppColors.purpleColor,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          AppPreferences.logout();
                                          AppNavigator.pushAndRemoveUntil(
                                            context,
                                            const StartScreen(),
                                          );
                                        },
                                        child: const Text(
                                          'Logout',
                                          style: TextStyle(
                                            color: AppColors.errorColor,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.errorColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                        // Fingerprint and NFC Section
                        const SizedBox(height: 40),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Your Fingerprint or NFC Device/Card\nEnable or disable to use the fingerprint or NFC',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            _buildStatusButton(
                              'NFC Registered',
                              _switchStates['NFC']!
                                  ? AppColors.secondaryColor
                                  : Colors.grey,
                              hasNfc ?? false,
                            ),
                            const SizedBox(height: 12),
                            _buildStatusButton(
                              'Fingerprint Registered',
                              _switchStates['Fingerprint']!
                                  ? AppColors.secondaryColor
                                  : Colors.grey,
                              hasFingerprint ?? false,
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
      ),
    );
  }

  Widget _buildStatusButton(
    String text,
    Color color,
    bool isRegistered,
  ) {
    // Determine which switch we're dealing with
    String key = text.contains('NFC') ? 'NFC' : 'Fingerprint';

    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _switchStates[key]!
            ? Colors.green.withOpacity(0.1)
            : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _switchStates[key]! ? Icons.check_circle : Icons.remove_circle,
                color: _switchStates[key]! ? Colors.green : Colors.grey,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: _switchStates[key]! ? Colors.green : color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: _switchStates[key]!,
              onChanged: (bool value) async {
                // Handle the switch state change
                if (key == 'NFC') {
                  await _handleNfcToggle(value);
                } else {
                  await _handleFingerprintToggle(value);
                }
              },
              activeColor: Colors.green,
              inactiveTrackColor: Colors.grey.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNfcToggle(bool value) async {
    if (value) {
      // Show confirmation dialog before enabling
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Enable NFC',
              style: TextStyle(
                color: AppColors.purpleColor,
                fontSize: 12,
              ),
            ),
            content: const Text(
              'Do you want to enable NFC authentication?',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 10,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.purpleColor,
                    fontSize: 10,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Enable',
                  style: TextStyle(
                    color: AppColors.purpleColor,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        setState(() {
          _switchStates['NFC'] = true;
        });

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return NFCEnableDialog(
                nfcValue: hasNfc ?? false,
                profileCubit: profileCubit,
              );
            },
          );
          await AppPreferences.setHasNfc(true);
          isDisabled = false;
        }
      }
    } else {
      setState(() {
        _switchStates['NFC'] = false;
      });
      if (mounted) {
        profileCubit.enableNfc(false, '');
        await AppPreferences.setHasNfc(false);
        isDisabled = true;
      }
    }
  }

  Future<void> _handleFingerprintToggle(bool value) async {
    if (value) {
      // Show confirmation dialog before enabling
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Enable Fingerprint',
              style: TextStyle(
                color: AppColors.purpleColor,
                fontSize: 12,
              ),
            ),
            content: const Text(
              'Do you want to enable fingerprint authentication?',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 10,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.purpleColor,
                    fontSize: 10,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Enable',
                  style: TextStyle(
                    color: AppColors.purpleColor,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        setState(() {
          _switchStates['Fingerprint'] = true;
        });
        if (mounted) {
          profileCubit.enableFingerprint(true);
          await AppPreferences.setHasFingerprint(true);
        }
      }
    } else {
      setState(() {
        _switchStates['Fingerprint'] = false;
      });
      if (mounted) {
        profileCubit.enableFingerprint(false);
        await AppPreferences.setHasFingerprint(false);
      }
    }
  }
}
