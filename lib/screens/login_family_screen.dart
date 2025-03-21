import 'package:flutter/material.dart';
import 'package:mindlabryinth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Register Provider
      ],
      child: LoginFamilyScreen(),
    ),
  );
}
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

  String? gender, country, state, division, district, talukaTehsil, block,
      loksabhaConstituency, vidhansabhaConstituency, sector, gramPanchayat, gram,
      anganwadi, role, relationToChild, parentOccupation, parentHighestEducation,
      residenceType, specialNeeds, incomeRange, religion, category,
      familyHealthConcerns, isAwareWithAnganwadi, parentingGoal;

  bool needSupport = false;
  bool isBPLCardHolder = false;

   // ✅ Changed: Added Anganwadi options with actual values
  List<Map<String, String>> anganwadiOptions = [
    {"name": "14", "value": "14_[2752107022]"},
    {"name": "Ravbachivasti", "value": "Ravbachivasti_[2752107022]"},
  ];

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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepare the data to be sent to the backend
      Map<String, dynamic> familyData = {
        "userName": userNameController.text,
        "password": passwordController.text,
        "name": nameController.text,
        "email": emailController.text,
        "phoneNumber": phoneController.text,
        "gender": gender,
        "dob": dobController.text,
        "country": country,
        "state": state,
        "division": division,
        "district": district,
        "talukaTehsil": talukaTehsil,
        "block": block,
        "loksabhaConstituency": loksabhaConstituency,
        "vidhansabhaConstituency": vidhansabhaConstituency,
        "sector": sector,
        "gramPanchayat": gramPanchayat,
        "gram": gram,
        "anganwadi": anganwadi ?? "Ravbachivasti_[2752107022]", 
        "role": role,
        "roleType": "ANGANWADI_PARENTS", // Hardcoded as per JSON example
        "relationToChild": relationToChild,
        "alternatePhoneNumber": alternatePhoneController.text,
        "parentOccupation": parentOccupation,
        "parentHighestEducation": parentHighestEducation,
        "residenceType": residenceType,
        "numberOfChildren": numberOfChildrenController.text,
        "needSupport": needSupport,
        "specialNeeds": specialNeeds,
        "incomeRange": incomeRange,
        "isBPLCardHolder": isBPLCardHolder,
        "religion": religion,
        "category": category,
        "familyHealthConcerns": familyHealthConcerns,
        "isAwareWithAnganwadi": isAwareWithAnganwadi,
        "parentingGoal": parentingGoal,
      };

      // Log the request payload
      print("Request Payload: $familyData");

      // Call the API
      ApiService apiService = ApiService();
      apiService.setToken("eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJ0ZXN0X3BhcmVudF8xMiIsImV4cCI6MTc0MzE4MzYyNCwiaWF0IjoxNzQyNTc4ODI0LCJhdXRob3JpdGllcyI6W119.KunBQU40KC9-6qJXTyIYULAPinn7nBPMHCloSwyWKJP46hIbaTIIZXtWMjeaEelGyLpbfyFgheqIi-CPwgc4e4UzU0UniTsrJ38eUZfRn3LvsEZHXdj4AFabCIV0AsyaZTOKh8MtPpXYxyyTcrg5ZctIkQl0l3fBfZefXJNbd2wVXFdZYfBEPa3snJJJXOq5ObnsM9Y3B6vD-0dBYiRDokX-rVvUj9BFu_7pq0Je-p6GfLzRXwo74BWDRsaFZnt-GlAA1CyBLbSvhOP0bkaT7z0YHCVmEEvh_-F-WlzIjyycV_shmSvSaKSRH5yjseIp6szWsn7-jJa9QGWK2WPncu7j7wn6HK-eX9qGLW5sAHentKd07M9RqOntNJwN5EOyGEyLz4wsASpR4-yEwe1nB0f3461havKKgt7IkqAZ_NNxE7ErE2_W0grfebSVkTC8HrxsOLzL7g50ZXDuWjx5iIGje6MAoK69B6jRirtPwf_l8xVgl1-fItnhEd9xFntCByneKDVq7ZiiqNUSfum_-PnQNFX2TxU8wuTHbWkzCHE2VEXER-xpzBhSZtSRNYe6x568dCRX76qkzDH8a0qycb34-dzjoSXIpxY_Qh1mnpiux0IRaHERKq4sy9Nel_E4XPfX1GS5qKUjZo9IM-d5vRR_7MNVWIibnt3y_IdMiLE");
      await apiService.registerFamily(familyData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Form Submitted Successfully!")),
      );

      // Navigate to the next screen
      Navigator.pushNamed(context, '/dashboard');
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
                        _buildDropdown(["MALE", "FEMALE"], "Gender", gender, (val) => setState(() => gender = val)),
                        _buildTextField(dobController, "Date of Birth", Icons.cake, "DOB is required"),
                      ]),
                      _buildSlide("Location Details", [
                        _buildDropdown(["India"], "Country", country, (val) => setState(() => country = val)),
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
                        SizedBox(height: 18.0),
                        _buildDropdown(
      anganwadiOptions.map((e) => e['name']!).toList(),
      "Select Anganwadi",
      anganwadiOptions.firstWhere((e) => e['value'] == anganwadi, orElse: () => anganwadiOptions.first)['name'],
      (String? val) {
        final selectedOption = anganwadiOptions.firstWhere((e) => e['name'] == val);
        setState(() => anganwadi = selectedOption['value']);
      },
    ),
                      ]),
                      _buildSlide("Additional Details", [
                        _buildDropdown(["ANGANWADI_PARENTS"], "Role", role, (val) => setState(() => role = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["MOTHER", "FATHER"], "Relation to Child", relationToChild, (val) => setState(() => relationToChild = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["Business", "Service"], "Parent Occupation", parentOccupation, (val) => setState(() => parentOccupation = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["Higher Education", "10th"], "Highest Education", parentHighestEducation, (val) => setState(() => parentHighestEducation = val)),
                      ]),
                      _buildSlide("Additional Details", [
                        _buildDropdown(["Home", "Rented"], "Residence Type", residenceType, (val) => setState(() => residenceType = val)),
                        SizedBox(height: 18.0),
                        _buildTextField(numberOfChildrenController, "Number of Children", Icons.child_care, "Enter number of children", keyboardType: TextInputType.number),
                        SizedBox(height: 18.0),
                        _buildDropdown(["No Needs", "Special Care"], "Special Needs", specialNeeds, (val) => setState(() => specialNeeds = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["NutritionalNA", "Under NutritionalNA"], "family Health Concerns", familyHealthConcerns, (val) => setState(() => familyHealthConcerns = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["100000-300000", "300000-500000"], "Income Range", incomeRange, (val) => setState(() => incomeRange = val)),

                      ]),
                      _buildSlide("Additional Details", [
                        _buildDropdown(["Hindu", "Muslim", "Christian"], "Religion", religion, (val) => setState(() => religion = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["Open", "OBC"], "Category", category, (val) => setState(() => category = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["Aware", "Not Aware"], "Awareness about Anganwadi", isAwareWithAnganwadi, (val) => setState(() => isAwareWithAnganwadi = val)),
                        SizedBox(height: 18.0),
                        _buildDropdown(["Some Goals", "Other Goals"], "Parenting Goal", parentingGoal, (val) => setState(() => parentingGoal = val)),
                        SizedBox(height: 18.0),
                        _buildSwitch("BPL Card Holder", isBPLCardHolder, (val) => setState(() => isBPLCardHolder = val)),
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
                      if (_currentPage == 7) {
                      Navigator.pushNamed(context, '/dashboard');
                      _submitForm();
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
