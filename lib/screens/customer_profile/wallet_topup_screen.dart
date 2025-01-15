import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solitaire/constants/constant.dart';
import 'package:solitaire/cubit/customer_profile/profile_cubit.dart';
import 'package:solitaire/widgets/success_dialog.dart';

class WalletTopupScreen extends StatefulWidget {
  const WalletTopupScreen({
    super.key,
  });

  @override
  State<WalletTopupScreen> createState() => _WalletTopupScreenState();
}

class _WalletTopupScreenState extends State<WalletTopupScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<double> quickTopupAmounts = [50, 100, 200, 500, 1000];
  String selectedPaymentMethod = '';
  String? selectedAmount;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    SuccessDialog.show(
      context,
      title: 'Topup Successfully',
      buttonText: 'Back to Profile',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.8),
              ),
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
                        'Wallet Topup',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.purpleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Current Balance Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Current balance',
                          style: TextStyle(
                            color: AppColors.cyanBlueColor,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context
                                  .read<ProfileCubit>()
                                  .currentBalance
                                  .toString(),
                              style: const TextStyle(
                                color: AppColors.purpleColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'SAR',
                              style: TextStyle(
                                color: AppColors.purpleColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Amount Input Field
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    height: 40,
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.cyanBlueColor.withOpacity(0.1),
                        hintText: 'Enter Amount (eg. SAR 25.00)',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Quick Topup Selection
                  const Text(
                    'Quick Topup selection',
                    style: TextStyle(
                      color: AppColors.purpleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: quickTopupAmounts.map((amount) {
                        final isSelected = selectedAmount == amount.toString();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? const Color.fromRGBO(206, 235, 15, 1)
                                  : AppColors.secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedAmount = amount.toString();
                                _amountController.text = amount.toString();
                              });
                            },
                            child: Text(
                              amount.toStringAsFixed(0),
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Payment Methods
                  const Text(
                    'Choose Payment Method',
                    style: TextStyle(
                      color: AppColors.purpleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildPaymentMethod(
                            'Credit/Debit Card', FontAwesomeIcons.creditCard),
                        _buildPaymentMethod(
                            'Amazon Pay', FontAwesomeIcons.amazonPay),
                        _buildPaymentMethod(
                            'Apple Pay', FontAwesomeIcons.applePay),
                        _buildPaymentMethod('PayPal', FontAwesomeIcons.paypal),
                        _buildPaymentMethod(
                            'Google Pay', FontAwesomeIcons.googlePay),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Topup Summary',
                    style: TextStyle(
                      color: AppColors.purpleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Topup Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
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
                        _buildSummaryRow('Topup Amount', '100.00 SAR'),
                        _buildSummaryRow('Transaction Fee', '0.00 SAR'),
                        const Divider(),
                        _buildSummaryRow('Total Amount', '100.00 SAR',
                            isBold: true),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              _showSuccessDialog();
                            },
                            child: const Text(
                              'Confirm payment',
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

                  const SizedBox(height: 20),

                  // Recent History
                  const Text(
                    'Recent History',
                    style: TextStyle(
                      color: AppColors.purpleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildHistoryItem(
                          'Paid by Credit/Debit Card',
                          'Jan 5,2005',
                          '100.00 SAR',
                          'Master card',
                        ),
                        _buildHistoryItem(
                          'Paid by Credit/Debit Card',
                          'Dec 28,2004',
                          '200.00 SAR',
                          'Visa Card',
                        ),
                        _buildHistoryItem(
                          'Paid by Amazon Pay',
                          'Dec 01,2004',
                          '100.00 SAR',
                          'Amazon pay',
                        ),
                        _buildHistoryItem(
                          'Paid by PayPal',
                          'Nov 08,2004',
                          '50.00 SAR',
                          'Paypal',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String title, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 30),
      title: Text(
        "     $title",
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.purpleColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Radio<String>(
        value: title,
        groupValue: selectedPaymentMethod,
        onChanged: (String? value) {
          setState(() {
            selectedPaymentMethod = value!;
          });
        },
        activeColor: AppColors.secondaryColor,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.purpleColor,
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
      String title, String date, String amount, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.purpleColor,
                  fontSize: 12,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: AppColors.purpleColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: AppColors.purpleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.cyanBlueColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
