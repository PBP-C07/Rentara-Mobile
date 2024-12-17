import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomPriceDrawer extends StatelessWidget {
  final String price;
  final String phoneNumber;
  final bool isRent;

  const BottomPriceDrawer({
    Key? key,
    required this.price,
    required this.phoneNumber,
    required this.isRent,
  }) : super(key: key);

  String _formatPrice() {
    String numericPrice = price.replaceAll(RegExp(r'[^0-9]'), '');
    int priceValue = int.tryParse(numericPrice) ?? 0;
    final formatter = NumberFormat('#,###', 'id_ID');
    return 'Rp ${formatter.format(priceValue).replaceAll(',', '.')}${isRent ? '/day' : ''}';
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    final noTelp = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final url = 'https://wa.me/$noTelp';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Couldn't launch WhatsApp"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error opening WhatsApp"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRent ? 'Rental Price' : 'Sell Price',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatPrice(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isRent
                            ? const Color.fromARGB(255, 71, 132, 111)
                            : const Color.fromARGB(255, 166, 48, 48),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _launchWhatsApp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRent
                        ? const Color.fromARGB(255, 71, 132, 111)
                        : const Color.fromARGB(255, 166, 48, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
          ),
        ],
      ),
    );
  }
}
