// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire/constants/constant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:solitaire/cubit/picker/picker_cubit.dart';
import 'package:solitaire/cubit/picker/picker_state.dart';
import 'package:solitaire/screens/pickers/picker_profile_screen.dart';
import 'package:solitaire/screens/pickers/rating_screen.dart';
import 'package:solitaire/screens/pickers/requests_history.dart';
import 'package:solitaire/utils/app_loading.dart';
import 'package:solitaire/utils/app_navigator.dart';

class AvailablePickersScreen extends StatefulWidget {
  const AvailablePickersScreen({super.key});

  @override
  State<AvailablePickersScreen> createState() => _AvailablePickersScreenState();
}

class _AvailablePickersScreenState extends State<AvailablePickersScreen>
    with SingleTickerProviderStateMixin {
  int page = 1;
  int limit = 10;
  bool isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<PickerCubit>().getPickers(page, limit);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Confirmation dialog to exit
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Are you sure you want to exit?',
              style: TextStyle(
                color: AppColors.purpleColor,
                fontSize: 12,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.purpleColor,
                    fontSize: 12,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Exit',
                  style: TextStyle(
                    color: AppColors.purpleColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<PickerCubit, PickerState>(
            listener: (context, state) {
              print('State changed: $state');
              if (state is PickerSuccessState) {
                setState(() {
                  isLoading = false;
                });
              }
              if (state is PickerErrorState) {
                setState(() {
                  isLoading = false;
                  page--;
                });
              }
            },
            builder: (context, state) {
              print('Pickers: ${context.read<PickerCubit>().pickers}');
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
                          // Tab Bar
                          TabBar(
                            controller: _tabController,
                            labelColor: AppColors.purpleColor,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: AppColors.purpleColor,
                            tabs: const [
                              Tab(text: 'Available Pickers'),
                              Tab(text: 'Request History'),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Tab Bar View
                          SizedBox(
                            height: MediaQuery.of(context).size.height -
                                200, // Adjust height as needed
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Available Pickers Tab
                                Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: context
                                          .read<PickerCubit>()
                                          .pickers
                                          .length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            AppNavigator.push(
                                              context,
                                              PickerProfileScreen(index: index),
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 16),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Index number
                                                Text(
                                                  '${context.read<PickerCubit>().pickers.length - index}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),

                                                // Profile Image
                                                Hero(
                                                  tag:
                                                      'picker_image_${context.read<PickerCubit>().pickers[index].id}',
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.network(
                                                      context
                                                              .read<
                                                                  PickerCubit>()
                                                              .pickers[index]
                                                              .avatar ??
                                                          '',
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Icon(
                                                            Icons.error);
                                                      },
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return const Center(
                                                          child: AppLoading(
                                                            color: AppColors
                                                                .purpleColor,
                                                            size: 15,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),

                                                // Info Column
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        context
                                                                .read<
                                                                    PickerCubit>()
                                                                .pickers[index]
                                                                .name ??
                                                            '',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        context
                                                                .read<
                                                                    PickerCubit>()
                                                                .pickers[index]
                                                                .phone ??
                                                            '',
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            'Rating ',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          RatingBar.builder(
                                                            initialRating: context
                                                                    .read<
                                                                        PickerCubit>()
                                                                    .pickers[
                                                                        index]
                                                                    .avgRating
                                                                    ?.toDouble() ??
                                                                0,
                                                            minRating: 0,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                true,
                                                            itemCount: 5,
                                                            itemSize: 10,
                                                            ignoreGestures:
                                                                true,
                                                            itemBuilder:
                                                                (context,
                                                                        index) =>
                                                                    const Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            unratedColor: Colors
                                                                .amber
                                                                .withOpacity(
                                                                    0.3),
                                                            onRatingUpdate:
                                                                (rating) {},
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Action Buttons Column
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          AppNavigator.push(
                                                            context,
                                                            PickerProfileScreen(
                                                                index: index),
                                                          );
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .purpleColor,
                                                        ),
                                                        child: const Text(
                                                          'View',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    SizedBox(
                                                      height: 20,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          AppNavigator.push(
                                                            context,
                                                            RatingScreen(
                                                                pickerId: context
                                                                        .read<
                                                                            PickerCubit>()
                                                                        .pickers[
                                                                            index]
                                                                        .id ??
                                                                    ''),
                                                          );
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                        child: const Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              'Rate',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                            SizedBox(width: 4),
                                                            Icon(Icons.star,
                                                                size: 10,
                                                                color: Colors
                                                                    .white),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    if (context
                                            .read<PickerCubit>()
                                            .pickers
                                            .length >=
                                        limit)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: ElevatedButton(
                                          onPressed: !isLoading
                                              ? () {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  page++;
                                                  context
                                                      .read<PickerCubit>()
                                                      .getPickers(page, limit);
                                                }
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.purpleColor,
                                          ),
                                          child: isLoading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                )
                                              : const Text('Load More'),
                                        ),
                                      ),
                                  ],
                                ),
                                RequestHistory(),
                              ],
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
      ),
    );
  }
}
