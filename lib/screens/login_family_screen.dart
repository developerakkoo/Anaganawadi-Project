import 'package:flutter/material.dart';

class LoginFamilyScreen extends StatefulWidget {
  const LoginFamilyScreen({super.key});

  @override
  State<LoginFamilyScreen> createState() => _LoginFamilyScreenState();
}

class _LoginFamilyScreenState extends State<LoginFamilyScreen> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  int _currentPage = 0;

  // Controllers
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alternatePhoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController numberOfChildrenController = TextEditingController();

  String? gender, country, state, division, district, talukaTehsil, loksabhaConstituency, 
      vidhansabhaConstituency, sector, gramPanchayat, gram, anganwadi, role, relationToChild,
      parentOccupation, parentHighestEducation, residenceType, specialNeeds, incomeRange,
      religion, category, familyHealthConcerns, isAwareWithAnganwadi, parentingGoal;
  
  bool needSupport = false;
  int? numberOfChildren;
  bool isBPLCardHolder = false;

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      if (_currentPage < 8) {
        _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
        setState(() => _currentPage++);
      } else {
        _submitForm();
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
      setState(() => _currentPage--);
    }
  }

  void _submitForm() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      authProvider.login()
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
                      _buildTextField(userNameController, "Username", Icons.person, "Username is required"),
                      _buildTextField(passwordController, "Password", Icons.lock, "Enter a valid password", obscureText: true),
                      _buildTextField(nameController, "Full Name", Icons.person, "Name is required"),
                      _buildTextField(emailController, "Email", Icons.email, "Enter a valid email", keyboardType: TextInputType.emailAddress),
                    ]),
                    _buildSlide([
                      _buildTextField(phoneController, "Phone Number", Icons.phone, "Enter a valid phone number", keyboardType: TextInputType.phone),
                      _buildTextField(alternatePhoneController, "Alternate Phone", Icons.phone, "Enter a valid phone number", keyboardType: TextInputType.phone),
                      _buildDropdown(["Male", "Female"], "Gender", gender, (val) => setState(() => gender = val)),
                      _buildTextField(dobController, "Date of Birth", Icons.cake, "DOB is required"),
                    ]),
                    _buildSlide([
                      _buildDropdown(["India", "USA"], "Country", country, (val) => setState(() => country = val)),
                      _buildDropdown(["State1", "State2"], "State", state, (val) => setState(() => state = val)),
                      _buildDropdown(["Pune", "Konkan"], "Division", division, (val) => setState(() => division = val)),
                      _buildDropdown(["Sangli", "Satara"], "District", district, (val) => setState(() => district = val)),
                    ]),
                    _buildSlide([
                      _buildDropdown(["Miraj", "Karad"], "Taluka/Tehsil", talukaTehsil, (val) => setState(() => talukaTehsil = val)),
                      _buildDropdown(["Pune Loksabha", "Sangli Loksabha"], "Loksabha Constituency", loksabhaConstituency, (val) => setState(() => loksabhaConstituency = val)),
                      _buildDropdown(["Bus Stand", "Railway Station"], "Sector", sector, (val) => setState(() => sector = val)),
                      _buildDropdown(["Bhore", "Narhe"], "Gram Panchayat", gramPanchayat, (val) => setState(() => gramPanchayat = val)),
                    ]),
                    _buildSlide([
                      _buildDropdown(["Admin", "User"], "Role", role, (val) => setState(() => role = val)),
                      _buildDropdown(["Mother", "Father"], "Relation to Child", relationToChild, (val) => setState(() => relationToChild = val)),
                      _buildDropdown(["Business", "Service"], "Parent Occupation", parentOccupation, (val) => setState(() => parentOccupation = val)),
                      _buildDropdown(["Higher Education", "Secondary"], "Highest Education", parentHighestEducation, (val) => setState(() => parentHighestEducation = val)),
                    ]),
                    _buildSlide([
                      _buildDropdown(["Home", "Rented"], "Residence Type", residenceType, (val) => setState(() => residenceType = val)),
                      _buildTextField(numberOfChildrenController, "Number of Children", Icons.child_care, "Enter number of children", keyboardType: TextInputType.number),
                      _buildDropdown(["No Needs", "Special Care"], "Special Needs", specialNeeds, (val) => setState(() => specialNeeds = val)),
                      _buildDropdown(["100000-300000", "300000-500000"], "Income Range", incomeRange, (val) => setState(() => incomeRange = val)),
                    ]),
                    _buildSlide([
                      _buildDropdown(["100000-300000", "300000-500000"], "Income Range", incomeRange, (String? val) => setState(() => incomeRange = val)),
                      _buildDropdown(["Hindu", "Muslim", "Christian"], "Religion",religion, (String? val) => setState(() => religion = val)),
                      _buildDropdown(["Open", "OBC"], "Category",category, (String? val) => setState(() => category = val)),
                      _buildDropdown(["Aware", "Not Aware"], "Awareness about Anganwadi", isAwareWithAnganwadi, (String? val) => setState(() => isAwareWithAnganwadi = val)),
                    ]),
                    _buildSlide([
                      _buildDropdown(["Some Goals", "Other Goals"], "Parenting Goal", parentingGoal, (String? val) => setState(() => parentingGoal = val)),
                      SizedBox(height: 12),
                      _buildSwitch("BPL Card Holder", isBPLCardHolder, (bool? val) => setState(() => isBPLCardHolder = val!)),
                    ])
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
                    child: Text(_currentPage == 3 ? "Submit" : "Next", style: TextStyle(color: Colors.white)),
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
  return Column(
    children: [
      DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        value: selectedValue,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
      ),
      SizedBox(height: 18.0),
    ],
  );
}

Widget _buildTextField(TextEditingController controller, String label, IconData icon, String errorMsg, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
  return Column(
    children: [
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(), prefixIcon: Icon(icon)),
        validator: (value) => (value == null || value.isEmpty) ? errorMsg : null,
      ),
      SizedBox(height: 18.0),
    ],
  );
}

Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Text(label), Switch(value: value, onChanged: onChanged)],
  );
}

Widget _buildSlide(List<Widget> children) {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: children);
}
