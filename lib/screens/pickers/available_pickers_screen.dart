import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire/constants/constant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:solitaire/cubit/picker/picker_cubit.dart';
import 'package:solitaire/cubit/picker/picker_state.dart';
import 'package:solitaire/screens/pickers/picker_profile_screen.dart';
import 'package:solitaire/screens/pickers/rating_screen.dart';
import 'package:solitaire/utils/app_navigator.dart';

class AvailablePickersScreen extends StatefulWidget {
  const AvailablePickersScreen({super.key});

  @override
  State<AvailablePickersScreen> createState() => _AvailablePickersScreenState();
}

class _AvailablePickersScreenState extends State<AvailablePickersScreen> {
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  int limit = 10;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<PickerCubit>().getPickers(page, limit);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      page++;
      context.read<PickerCubit>().getPickers(page, limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                controller: _scrollController,
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
                              'Available Pickers',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.purpleColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Picker Cards
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: context
                              .read<PickerCubit>()
                              .pickers
                              .length, // Number of pickers
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        context
                                                .read<PickerCubit>()
                                                .pickers[index]
                                                .avatar ??
                                            '',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(),
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
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context
                                                  .read<PickerCubit>()
                                                  .pickers[index]
                                                  .name ??
                                              '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          context
                                                  .read<PickerCubit>()
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
                                                color: Colors.grey,
                                              ),
                                            ),
                                            RatingBar.builder(
                                              initialRating: context
                                                      .read<PickerCubit>()
                                                      .pickers[index]
                                                      .avgRating ??
                                                  0,
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 10,
                                              ignoreGestures: true,
                                              itemBuilder: (context, index) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              unratedColor:
                                                  Colors.amber.withOpacity(0.3),
                                              onRatingUpdate: (rating) {},
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
                                              PickerProfileScreen(),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.purpleColor,
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
                                                          .read<PickerCubit>()
                                                          .pickers[index]
                                                          .id ??
                                                      ''),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Rate',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(Icons.star,
                                                  size: 10,
                                                  color: Colors.white),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // Add loading indicator at the bottom
                        if (isLoading)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: CircularProgressIndicator(),
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
}
