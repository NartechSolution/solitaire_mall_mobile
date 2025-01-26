// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:solitaire/constants/constant.dart';
import 'package:solitaire/cubit/picker/picker_cubit.dart';
import 'package:solitaire/cubit/picker_request/picker_request_cubit.dart';
import 'package:solitaire/cubit/picker_request/picker_request_state.dart';
import 'package:solitaire/screens/pickers/rating_screen.dart';
import 'package:solitaire/utils/app_loading.dart';
import 'package:solitaire/utils/app_navigator.dart';
import 'package:solitaire/widgets/error_dialog.dart';
import 'package:solitaire/widgets/success_dialog.dart';
import 'package:geolocator/geolocator.dart';

class PickerProfileScreen extends StatefulWidget {
  const PickerProfileScreen({super.key, required this.index});

  final int index;

  @override
  State<PickerProfileScreen> createState() => _PickerProfileScreenState();
}

class _PickerProfileScreenState extends State<PickerProfileScreen> {
  final PickerRequestCubit _pickerRequestCubit = PickerRequestCubit();

  void _showSuccessDialog(String title) {
    SuccessDialog.show(
      context,
      title: title,
      buttonText: 'OK',
    );
  }

  void _showWarningMessage(String message) {
    ErrorDialog.show(
      context,
      title: message,
      buttonText: 'OK',
    );
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showWarningMessage(
          'Location services are disabled. Please enable them.');
      return null;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showWarningMessage('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showWarningMessage('Location permissions are permanently denied');
      return null;
    }

    // Get current position
    return await Geolocator.getCurrentPosition();
  }

  Future<String> _getAddressFromLatLong(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
      return 'Address not found';
    } catch (e) {
      return 'Error retrieving address';
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<PickerRequestCubit>().getRequestStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<PickerRequestCubit, PickerRequestState>(
          bloc: _pickerRequestCubit,
          listener: (context, state) {
            print(state.toString());
            if (state is PickerRequestSuccess) {
              _showSuccessDialog(state.message);
            } else if (state is PickerRequestError) {
              _showWarningMessage(state.message);
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
                                tag: context
                                        .read<PickerCubit>()
                                        .pickers[widget.index]
                                        .id ??
                                    "",
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
                                              .pickers[widget.index]
                                              .avatar ??
                                          "",
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          size: 100,
                                        );
                                      },
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
                                context
                                        .read<PickerCubit>()
                                        .pickers[widget.index]
                                        .name ??
                                    "",
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
                                                .pickers[widget.index]
                                                .avgRating ==
                                            null)
                                          return const Icon(Icons.star,
                                              color: Colors.grey, size: 20);

                                        final double rating = context
                                            .read<PickerCubit>()
                                            .pickers[widget.index]
                                            .avgRating!
                                            .toDouble();
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
                              _buildProfileItem(context
                                      .read<PickerCubit>()
                                      .pickers[widget.index]
                                      .name ??
                                  "Name"),
                              _buildProfileItem(context
                                      .read<PickerCubit>()
                                      .pickers[widget.index]
                                      .phone ??
                                  "Phone"),
                              _buildProfileItem(context
                                      .read<PickerCubit>()
                                      .pickers[widget.index]
                                      .email ??
                                  "Email"),
                              _buildProfileItem(context
                                      .read<PickerCubit>()
                                      .pickers[widget.index]
                                      .address ??
                                  "Address"),
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
                                    pickerId: context
                                            .read<PickerCubit>()
                                            .pickers[widget.index]
                                            .id ??
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
                        const SizedBox(height: 10),
                        // Add this before the Request Button
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(12),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your Location',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _pickerRequestCubit.currentAddress.isEmpty
                                    ? 'No location selected'
                                    : _pickerRequestCubit.currentAddress,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Pick Location',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                  onPressed: () async {
                                    final position =
                                        await _getCurrentLocation();
                                    if (position != null) {
                                      final address =
                                          await _getAddressFromLatLong(
                                              position);
                                      _pickerRequestCubit.updateLocation(
                                        address,
                                        position.latitude,
                                        position.longitude,
                                      );
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Request Button
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
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (_pickerRequestCubit.currentAddress.isEmpty) {
                                _showWarningMessage(
                                    'Please select your location first');
                                return;
                              }
                              _pickerRequestCubit.submitRequest(
                                context
                                        .read<PickerCubit>()
                                        .pickers[widget.index]
                                        .id ??
                                    "",
                                _pickerRequestCubit.currentAddress,
                                _pickerRequestCubit.currentLatitude!,
                                _pickerRequestCubit.currentLongitude!,
                              );
                            },
                            child: state is PickerRequestLoading
                                ? AppLoading(
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : const Text(
                                    'Request to Pick',
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
            );
          },
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
