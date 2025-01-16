import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire/constants/constant.dart';
import 'package:solitaire/cubit/picker/picker_cubit.dart';
import 'package:solitaire/screens/pickers/rating_screen.dart';
import 'package:solitaire/utils/app_navigator.dart';

class PickerProfileScreen extends StatefulWidget {
  const PickerProfileScreen({super.key});

  @override
  State<PickerProfileScreen> createState() => _PickerProfileScreenState();
}

class _PickerProfileScreenState extends State<PickerProfileScreen> {
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
                        Text(
                          'Picker Profile',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.purpleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Profile Section
                    Center(
                      child: Column(
                        children: [
                          // Profile Image
                          Hero(
                            tag:
                                context.read<PickerCubit>().pickers[0].id ?? "",
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  context
                                          .read<PickerCubit>()
                                          .pickers[0]
                                          .avatar ??
                                      "",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // ID Number
                          const Text(
                            'Picker Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            context.read<PickerCubit>().pickers[0].name ?? "",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 10),
                          // Rating Stars
                          Column(
                            children: [
                              const Text(
                                'Rating',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  5,
                                  (index) {
                                    if (context
                                            .read<PickerCubit>()
                                            .pickers[0]
                                            .avgRating ==
                                        null)
                                      return const Icon(Icons.star,
                                          color: Colors.grey, size: 20);

                                    final double rating = context
                                        .read<PickerCubit>()
                                        .pickers[0]
                                        .avgRating!;
                                    if (index < rating.floor()) {
                                      return const Icon(Icons.star,
                                          color: Colors.amber, size: 20);
                                    } else if (index == rating.floor() &&
                                        rating % 1 >= 0.5) {
                                      return const Icon(Icons.star_half,
                                          color: Colors.amber, size: 20);
                                    } else {
                                      return const Icon(Icons.star_border,
                                          color: Colors.amber, size: 20);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Profile Details
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildProfileItem(
                              context.read<PickerCubit>().pickers[0].name ??
                                  "Name"),
                          _buildProfileItem(
                              context.read<PickerCubit>().pickers[0].phone ??
                                  "Phone"),
                          _buildProfileItem(
                              context.read<PickerCubit>().pickers[0].email ??
                                  "Email"),
                          _buildProfileItem(
                              context.read<PickerCubit>().pickers[0].address ??
                                  "Adress"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Submit Review Button
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          AppNavigator.push(
                            context,
                            RatingScreen(
                                pickerId:
                                    context.read<PickerCubit>().pickers[0].id ??
                                        ""),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF26A69A),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Submit a review',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
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

  Widget _buildProfileItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
