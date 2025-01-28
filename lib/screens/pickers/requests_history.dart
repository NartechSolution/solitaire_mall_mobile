import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire/cubit/picker_request/picker_request_cubit.dart';
import 'package:solitaire/cubit/picker_request/picker_request_state.dart';
import 'package:solitaire/utils/app_loading.dart';

class RequestHistory extends StatefulWidget {
  const RequestHistory({super.key});

  @override
  State<RequestHistory> createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request History'),
        actions: [
          BlocBuilder<PickerRequestCubit, PickerRequestState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: state is PickerRequestStatusLoading
                    ? null // Disable button while loading
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
            return ListView.builder(
              shrinkWrap: true,
              itemCount:
                  context.read<PickerRequestCubit>().requestStatus.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final request =
                    context.read<PickerRequestCubit>().requestStatus[index];
                final picker = request.pickerDetails;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text('Picker Details'),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: picker?.avatar != null
                                        ? NetworkImage(picker?.avatar ?? '')
                                        : null,
                                    child: picker?.avatar == null
                                        ? Text(picker?.name?[0].toUpperCase() ??
                                            '')
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildDetailRow(
                                      'Name', picker?.name ?? 'N/A'),
                                  _buildDetailRow(
                                      'Phone', picker?.phone ?? 'N/A'),
                                  _buildDetailRow('Status',
                                      request.request?.status ?? 'N/A'),
                                  _buildDetailRow('Location',
                                      request.request?.location ?? 'N/A'),
                                ],
                              ),
                            ),
                            actions: [
                              if (request.request?.status == 'PENDING')
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context
                                        .read<PickerRequestCubit>()
                                        .cancelRequest(
                                            request.request?.id ?? '');

                                    context
                                        .read<PickerRequestCubit>()
                                        .getRequestStatus();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Cancel Request'),
                                ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: request.request?.status == 'PENDING'
                                    ? Colors.blue.shade100
                                    : request.request?.status == 'ACCEPTED'
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                request.request?.status ?? '',
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: picker?.avatar != null
                                      ? NetworkImage(picker?.avatar ?? '')
                                      : null,
                                  child: picker?.avatar == null
                                      ? Text(
                                          picker?.name?[0].toUpperCase() ?? '')
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      picker?.name ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      picker?.phone ?? '',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              request.request?.location ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
