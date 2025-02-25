import 'package:flutter/material.dart';

class HelperWidgets {
  // Build Card

// Helper function to build input fields
  static Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, String errorMsg,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMsg;
        }
        if (label == "Email" &&
            !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                .hasMatch(value)) {
          return "Enter a valid email";
        }
        if (label == "Phone Number" && value.length < 10) {
          return "Enter a valid phone number";
        }
        if (label == "Password" && value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
    );
  }

// Helper function to build slides
  static Widget _buildSlide(List<Widget> children) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  static Widget _buildCard(String title, List<Widget> children) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

// Build Dropdown
  static Widget _buildDropdown(
      List<String> items, String label, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField(
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

// Build Checkbox
  static Widget _buildCheckbox(
      String label, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
        title: Text(label), value: value, onChanged: onChanged);
  }

// Build Date Picker
  static Widget _buildDatePicker(
      TextEditingController controller, String label) {
    return _buildTextField(controller, label, Icons.calendar_today, "Required");
  }
}
