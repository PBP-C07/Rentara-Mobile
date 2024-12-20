import 'package:flutter/material.dart';

class VehicleFormComponents {
  static final mainColor = const Color(0xFF2B6777);
  static final secondaryColor = const Color(0xFF52AB98);
  static final backgroundColor = const Color(0xFFF2F2F2);
  static final cardColor = Colors.white;

  static Widget buildFormField(String label, {Widget? child, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: mainColor.withOpacity(0.8),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child ?? const SizedBox(),
      ],
    );
  }

  static InputDecoration buildInputDecoration({IconData? icon}) {
    return InputDecoration(
      prefixIcon: icon != null
          ? Icon(icon, color: mainColor.withOpacity(0.7), size: 22)
          : null,
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: mainColor.withOpacity(0.15), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: mainColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      hintStyle: TextStyle(
        color: mainColor.withOpacity(0.5),
        fontSize: 14,
      ),
      helperStyle: TextStyle(
        color: mainColor.withOpacity(0.6),
        fontSize: 12,
      ),
    );
  }

  // Style untuk dropdown
  static Widget buildDropdownDecoration(String label, Widget child,
      {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: mainColor.withOpacity(0.8),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: mainColor.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: mainColor.withOpacity(0.7), size: 22),
                const SizedBox(width: 12),
              ],
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }

  // Preview gambar
  static Widget buildImagePreview(String photoLink) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: mainColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: photoLink.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera,
                      size: 48, color: mainColor.withOpacity(0.3)),
                  const SizedBox(height: 8),
                  Text(
                    'No image preview',
                    style: TextStyle(color: mainColor.withOpacity(0.5)),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                photoLink,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image,
                          size: 48, color: mainColor.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      Text(
                        'Invalid image URL. Use another link.',
                        style: TextStyle(color: mainColor.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
    );
  }

  static String? validateRequired(String? value) {
    return value?.isEmpty ?? true ? "Required" : null;
  }

  static String? validatePhone(String? value) {
    if (value?.isEmpty ?? true) return "Required";
    if (!RegExp(r'^\d{10,13}$').hasMatch(value!)) return "Invalid format";
    return null;
  }

  static String? validateUrl(String? value) {
    if (value?.isEmpty ?? true) return "Required";
    if (!Uri.parse(value!).isAbsolute) return "Invalid URL";
    return null;
  }

  static String? validatePrice(String? value) {
    if (value?.isEmpty ?? true) return "Required";
    if (int.tryParse(value!) == null) return "Must be a number";
    if (int.parse(value) < 1) return "Must be positive";
    return null;
  }

  static ButtonStyle buildSubmitButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      shadowColor: secondaryColor.withOpacity(0.3),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: mainColor,
          ),
        );
      },
    );
  }
}
