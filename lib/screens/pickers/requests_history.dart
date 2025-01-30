import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire/cubit/picker_request/picker_request_cubit.dart';
import 'package:solitaire/cubit/picker_request/picker_request_state.dart';
import 'package:solitaire/utils/app_loading.dart';
import 'dart:async';

class RequestHistory extends StatefulWidget {
  const RequestHistory({super.key});

  @override
  State<RequestHistory> createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        context.read<PickerRequestCubit>().getRequestStatus();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Request History',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            )),
        actions: [
          BlocBuilder<PickerRequestCubit, PickerRequestState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: state is PickerRequestStatusLoading
                    ? null
                    : () {
                        context.read<PickerRequestCubit>().getRequestStatus();
                      },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<PickerRequestCubit, PickerRequestState>(
        listener: (context, state) {
          if (state is PickerRequestStatusSuccess) {
            print(state.requestStatus);
            if (state.requestStatus.request?.status == 'ACCEPTED') {
              _refreshTimer?.cancel();
            }
          } else if (state is PickerRequestStatusError) {
            print(state.message);
          } else if (state is PickerRequestCancelSuccess) {
            context.read<PickerRequestCubit>().getRequestStatus();
          } else if (state is PickerRequestCancelError) {
            print(state.message);
          }
        },
        builder: (context, state) {
          if (state is PickerRequestStatusLoading) {
            return const Center(
              child: AppLoading(
                color: Colors.blue,
                size: 24,
              ),
            );
          }

          if (state is PickerRequestStatusSuccess) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Hero(
                tag: 'request-card',
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Picker Details',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Center(
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.blue.shade50,
                                      backgroundImage: state.requestStatus
                                                  .pickerDetails?.avatar !=
                                              null
                                          ? NetworkImage(state.requestStatus
                                                  .pickerDetails?.avatar ??
                                              '')
                                          : null,
                                      child: state.requestStatus.pickerDetails
                                                  ?.avatar ==
                                              null
                                          ? Text(
                                              state.requestStatus.pickerDetails
                                                      ?.name?[0]
                                                      .toUpperCase() ??
                                                  '',
                                              style:
                                                  const TextStyle(fontSize: 32),
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _buildDetailRow(
                                      'Name',
                                      state.requestStatus.pickerDetails?.name ??
                                          'N/A'),
                                  _buildDetailRow(
                                      'Phone',
                                      state.requestStatus.pickerDetails
                                              ?.phone ??
                                          'N/A'),
                                  _buildDetailRow(
                                      'Status',
                                      state.requestStatus.request?.status ??
                                          'N/A'),
                                  _buildDetailRow(
                                      'Location',
                                      state.requestStatus.request?.location ??
                                          'N/A'),
                                  const SizedBox(height: 24),
                                  if (state.requestStatus.request?.status ==
                                      'PENDING')
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade50,
                                          foregroundColor: Colors.red,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context
                                              .read<PickerRequestCubit>()
                                              .cancelRequest(state.requestStatus
                                                      .request?.id ??
                                                  '');
                                        },
                                        child: const Text('Cancel Request'),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatusBadge(
                                state.requestStatus.request?.status ?? ''),
                            const SizedBox(height: 16),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blue.shade50,
                                backgroundImage:
                                    state.requestStatus.pickerDetails?.avatar !=
                                            null
                                        ? NetworkImage(state.requestStatus
                                                .pickerDetails?.avatar ??
                                            '')
                                        : null,
                                child:
                                    state.requestStatus.pickerDetails?.avatar ==
                                            null
                                        ? Text(
                                            state.requestStatus.pickerDetails
                                                    ?.name?[0]
                                                    .toUpperCase() ??
                                                '',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        : null,
                              ),
                              title: Text(
                                state.requestStatus.pickerDetails?.name ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.requestStatus.pickerDetails?.phone ??
                                        '',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          state.requestStatus.request
                                                  ?.location ??
                                              '',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.location_on_outlined,
                                          size: 16,
                                          color: Colors.grey.shade600),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  state.requestStatus.request?.status ==
                                          'ACCEPTED'
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blue.shade50,
                                            foregroundColor: Colors.blue,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => Dialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(24),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.blue),
                                                      ),
                                                      const SizedBox(
                                                          height: 24),
                                                      const Text(
                                                        'Waiting for Picker',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      Text(
                                                        'Please stay at ${state.requestStatus.request?.location ?? "your location"}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      const Text(
                                                        'The picker will arrive at your request location shortly',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 24),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          foregroundColor:
                                                              Colors.blue,
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                            'OK, I\'ll Wait Here'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Track Picker',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
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

          return const Center(
            child: AppLoading(
              color: Colors.blue,
              size: 24,
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'PENDING':
        backgroundColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      case 'ACCEPTED':
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      default:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
