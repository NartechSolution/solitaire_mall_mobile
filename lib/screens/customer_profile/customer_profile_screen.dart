import 'package:flutter/material.dart';
import 'package:solitaire/constants/constant.dart';
import 'package:solitaire/screens/customer_profile/select_services_screen.dart';
import 'package:solitaire/screens/customer_profile/wallet_topup_screen.dart';
import 'package:solitaire/utils/app_navigator.dart';

class ProfileData {
  String name;
  String phone;
  String email;
  String address;

  ProfileData({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });
}

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  late ProfileData _profileData;
  Map<String, bool> _switchStates = {
    'NFC': false,
    'Fingerprint': false,
  };

  @override
  void initState() {
    super.initState();
    _profileData = ProfileData(
      name: 'Hasnain Ahmad',
      phone: '+966 52 762 1329',
      email: 'Hasnain@gmail.com',
      address: 'Sulaimaniya st, Olaya Riyadh City KSA',
    );

    // Initialize switch states
    _switchStates = {
      'NFC': false,
      'Fingerprint': false,
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
              size: 20,
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

  void _showFullScreenImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Full screen image
              InteractiveViewer(
                child: Image.asset(
                  'assets/background.png',
                  fit: BoxFit.contain,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
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
                        GestureDetector(
                          onTap: _showFullScreenImage,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.purpleColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                image: AssetImage('assets/background.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
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
                        _profileData.name,
                        (value) => setState(() => _profileData.name = value),
                      ),
                    ),
                    _buildProfileItem(
                      _profileData.phone,
                      Icons.edit,
                      onEdit: () => _showEditDialog(
                        'Phone',
                        _profileData.phone,
                        (value) => setState(() => _profileData.phone = value),
                      ),
                    ),
                    _buildProfileItem(
                      _profileData.email,
                      Icons.edit,
                      onEdit: () => _showEditDialog(
                        'Email',
                        _profileData.email,
                        (value) => setState(() => _profileData.email = value),
                      ),
                    ),
                    _buildProfileItem(
                      _profileData.address,
                      Icons.edit,
                      onEdit: () => _showEditDialog(
                        'Address',
                        _profileData.address,
                        (value) => setState(() => _profileData.address = value),
                      ),
                    ),

                    // Update Profile Button
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cyanBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    // Request Services Button
                    const SizedBox(height: 12),
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

                    // Fingerprint and NFC Section
                    const SizedBox(height: 40),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Your Fingerprint or NFC Device/Card',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
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
                          true,
                        ),
                        const SizedBox(height: 12),
                        _buildStatusButton(
                          'Fingerprint Registered',
                          _switchStates['Fingerprint']!
                              ? AppColors.secondaryColor
                              : Colors.grey,
                          true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(String text, Color color, bool isRegistered) {
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
            scale: 0.7, // This will make the switch 80% of its original size
            child: Switch(
              value: _switchStates[key]!,
              onChanged: (bool value) {
                setState(() {
                  _switchStates[key] = value;
                });
              },
              activeColor: Colors.green,
              inactiveTrackColor: Colors.grey.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
