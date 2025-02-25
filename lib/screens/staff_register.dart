import 'package:flutter/material.dart';

class RegisterStaffScreen extends StatefulWidget {
  const RegisterStaffScreen({super.key});

  @override
  State<RegisterStaffScreen> createState() => _RegisterStaffScreenState();
}

class _RegisterStaffScreenState extends State<RegisterStaffScreen> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  int _currentPage = 0;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  String? country, state, division, district, talukaTehsil, block, loksabhaConstituency,
      vidhansabhaConstituency, sector, gramPanchayat, gram, anganwadi, gender, role, roleType;

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      if (_currentPage < 4) {
        _pageController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.ease);
        setState(() {
          _currentPage++;
        });
      } else {
        _submitForm();
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
      setState(() {
        _currentPage--;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Form Submitted Successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildSlide([
                      _buildTextField(nameController, "Full Name", Icons.person, "Name is required"),
                      SizedBox(height: 18.0),
                      _buildTextField(emailController, "Email", Icons.email, "Enter a valid email", keyboardType: TextInputType.emailAddress),
                      SizedBox(height: 18.0),
                      _buildTextField(phoneController, "Phone Number", Icons.phone, "Enter a valid phone number", keyboardType: TextInputType.phone),
                      SizedBox(height: 18.0),
                     _buildDropdown(["Male", "Female"], "Gender", gender, (String? val) => setState(() => gender = val)),
                      SizedBox(height: 18.0),

                    ]),
                    _buildSlide([
                      _buildDropdown(["USA", "India", "UK"], "Country", country, (String? val) => setState(() => country = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Maharastra", "Delhi"], "State", state, (String? val) => setState(() => state = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Pune", "Konkan"], "Division", division, (String? val) => setState(() => division = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Sangli", "Kolhapur"], "District", district, (String? val) => setState(() => district = val)),
                      SizedBox(height: 18.0),
                    ]),
                    _buildSlide([
                     _buildDropdown(["Miraj", "Shirala"], "Taluka/Tehsil", talukaTehsil, (String? val) => setState(() => talukaTehsil = val)),
                     SizedBox(height: 18.0),
                     _buildDropdown(["Bus Stand", "railway Station"], "Block", block, (String? val) => setState(() => block = val)),
                     SizedBox(height: 18.0),
                     _buildDropdown(["Pune Loksabha", "Sangli Loksabha"], "Loksabha Constituency", loksabhaConstituency, (String? val) => setState(() => loksabhaConstituency = val)),
                     SizedBox(height: 18.0),
                     _buildDropdown(["Pune Vidhansabha", "Sangli Vidhansabha"], "Vidhansabha Constituency", vidhansabhaConstituency, (String? val) => setState(() => vidhansabhaConstituency = val)),
                     SizedBox(height: 18.0),
                    ]),
                    _buildSlide([
                     _buildDropdown(["Sector1", "Sector2"], "Sector", sector, (String? val) => setState(() => sector = val)),
                     SizedBox(height: 18.0),
                     _buildDropdown(["Ambegaon", "Baramati"], "Gram Panchayat", gramPanchayat, (String? val) => setState(() => gramPanchayat = val)),
                     SizedBox(height: 18.0),
                     _buildDropdown(["Bhor", "Daund"], "Gram", gram, (String? val) => setState(() => gram = val)),
                     SizedBox(height: 18.0),
                     _buildDropdown(["Mahila Bal Vikas", "PASHAN ANGANWADI"], "Anganwadi", anganwadi, (String? val) => setState(() => anganwadi = val)),
                     SizedBox(height: 18.0),
                    ]),
                    _buildSlide([
                      _buildTextField(pincodeController, "Pincode", Icons.pin_drop, "Enter valid pincode", keyboardType: TextInputType.number),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Admin", "User"], "Role", role, (String? val) => setState(() => role = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Worker", "Teacher"], "Role Type", roleType, (String? val) => setState(() => roleType = val)),
                      SizedBox(height: 18.0),
                    ]),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage > 0
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                          onPressed: _previousPage,
                          child: Text("Back", style: TextStyle(color: Colors.white)),
                        )
                      : SizedBox(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                    onPressed: _nextPage,
                    child: Text(_currentPage == 4 ? "Submit" : "Next", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDropdown(List<String> items, String label, String? selectedValue, ValueChanged<String?> onChanged) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    value: selectedValue,
    items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    onChanged: onChanged,
    validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
  );
}

Widget _buildTextField(TextEditingController controller, String label, IconData icon, String errorMsg, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    decoration: InputDecoration(labelText: label, border: OutlineInputBorder(), prefixIcon: Icon(icon)),
    validator: (value) => (value == null || value.isEmpty) ? errorMsg : null,
  );
}

Widget _buildSlide(List<Widget> children) {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: children);
}

