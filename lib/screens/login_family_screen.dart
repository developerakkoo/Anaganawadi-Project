import 'package:flutter/material.dart';
import 'package:mindlabryinth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

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
    authProvider.login(emailController.text, passwordController.text); // Pass email & password

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
                child: Center(
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildSlide("Personal Details", [
                        _buildTextField(userNameController, "Username", Icons.person, "Username is required"),
                        _buildTextField(passwordController, "Password", Icons.lock, "Enter a valid password", obscureText: true),
                        _buildTextField(nameController, "Full Name", Icons.person, "Name is required"),
                        _buildTextField(emailController, "Email", Icons.email, "Enter a valid email", keyboardType: TextInputType.emailAddress),
                      ]),
                      _buildSlide("Contact Details", [
                        _buildTextField(phoneController, "Phone Number", Icons.phone, "Enter a valid phone number", keyboardType: TextInputType.phone),
                        _buildTextField(alternatePhoneController, "Alternate Phone", Icons.phone, "Enter a valid phone number", keyboardType: TextInputType.phone),
                        _buildDropdown(["Male", "Female"], "Gender", gender, (val) => setState(() => gender = val)),
                        _buildTextField(dobController, "Date of Birth", Icons.cake, "DOB is required"),
                      ]),
                      _buildSlide("Location Details", [
                        _buildDropdown(["India", "USA"], "Country", country, (val) => setState(() => country = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["State1", "State2"], "State", state, (val) => setState(() => state = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["Pune", "Konkan"], "Division", division, (val) => setState(() => division = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["Sangli", "Satara"], "District", district, (val) => setState(() => district = val)),

                      ]),
                      _buildSlide("Location Details", [
                        _buildDropdown(["Miraj", "Karad"], "Taluka/Tehsil", talukaTehsil, (val) => setState(() => talukaTehsil = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["Pune Loksabha", "Sangli Loksabha"], "Loksabha Constituency", loksabhaConstituency, (val) => setState(() => loksabhaConstituency = val)),
                         SizedBox(height: 18.0),
                        _buildDropdown(["Bus Stand", "Railway Station"], "Sector", sector, (val) => setState(() => sector = val)),
                         SizedBox(height: 18.0),
                      _buildDropdown(["Bhore", "Narhe"], "Gram Panchayat", gramPanchayat, (val) => setState(() => gramPanchayat = val)),
                      ]),

                      _buildSlide("Additional Details", [
                      _buildDropdown(["Admin", "User"], "Role", role, (val) => setState(() => role = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Mother", "Father"], "Relation to Child", relationToChild, (val) => setState(() => relationToChild = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Business", "Service"], "Parent Occupation", parentOccupation, (val) => setState(() => parentOccupation = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Higher Education", "Secondary"], "Highest Education", parentHighestEducation, (val) => setState(() => parentHighestEducation = val)),
                      ]),

                      _buildSlide("Additional Details", [
                      _buildDropdown(["Home", "Rented"], "Residence Type", residenceType,(val) => setState(() => residenceType = val)),
                      SizedBox(height: 18.0),
                      _buildTextField(numberOfChildrenController, "Number of Children",Icons.child_care, "Enter number of children", keyboardType: TextInputType.number),
                      SizedBox(height: 18.0),
                      _buildDropdown(["No Needs", "Special Care"], "Special Needs", specialNeeds, (val) => setState(() => specialNeeds = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["100000-300000", "300000-500000"], "Income Range", incomeRange, (val) => setState(() => incomeRange = val)),
                      ]),

                     _buildSlide("Additional Details", [
                        _buildDropdown(["Hindu", "Muslim", "Christian"], "Religion",religion, (String? val) => setState(() => religion = val)),
                      SizedBox(height: 18.0),
                     _buildDropdown(["Open", "OBC"], "Category",category, (String? val) => setState(() => category = val)),
                      SizedBox(height: 18.0),
                     _buildDropdown(["Aware", "Not Aware"], "Awareness about Anganwadi", isAwareWithAnganwadi, (String? val) => setState(() => isAwareWithAnganwadi = val)),                     
                      SizedBox(height: 18.0),
                     _buildDropdown(["Some Goals", "Other Goals"], "Parenting Goal", parentingGoal, (String? val) => setState(() => parentingGoal = val)),
                     SizedBox(height: 18.0),
                     _buildSwitch("BPL Card Holder", isBPLCardHolder, (bool? val) => setState(() => isBPLCardHolder = val!)),     
                     ]),
                      
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      onPressed: _previousPage,
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      label: Text("Back", style: TextStyle(color: Colors.white)),
                    ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    onPressed:() {
                      if (_currentPage == 4) {
                      Navigator.pushNamed(context, '/dashboard');
                       print("Form Submitted! Navigate to the next page.");
                    } else {
                  _nextPage();
                 }
               },
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    label: Text(_currentPage == 7 ? "Submit" : "Next", style: TextStyle(color: Colors.white)),
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

Widget _buildSlide(String title, List<Widget> children) {
  return Center(
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
     crossAxisAlignment: CrossAxisAlignment.center, // Centers content horizontally
     children: [
      Text(
        title,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
      ),
      SizedBox(height: 20),
      ...children,
    ],
    ),
  );
}

Widget _buildDropdown(List<String> items, String label, String? value, Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    value: value,
    items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
    onChanged: onChanged,
  );
}

Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TextStyle(fontSize: 16)),
      Switch(
        value: value,
        onChanged: onChanged,
      ),
    ],
  );
}

Widget _buildTextField(TextEditingController controller, String label, IconData icon, String validationMsg,
    {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (value) => value!.isEmpty ? validationMsg : null,
    ),
  );
}
