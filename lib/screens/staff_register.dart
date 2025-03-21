import 'package:flutter/material.dart';
import 'package:mindlabryinth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider()), // Register Provider
      ],
      child: RegisterStaffScreen(),
    ),
  );
}

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
  final TextEditingController dobController = TextEditingController();


  String? country,
      state,
      division,
      district,
      talukaTehsil, 
      block,
      loksabhaConstituency,
      vidhansabhaConstituency,
      sector,
      gramPanchayat,
      gram,
      anganwadi,
      gender,
      role,
      roleType;

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      if (_currentPage < 6) {
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

    void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    // Prepare the data to be sent to the backend
    Map<String, dynamic> staffData = {
      "userName": nameController.text, 
      "password": passwordController.text,
      "name": nameController.text,
      "email": emailController.text,
      "phoneNumber": phoneController.text,
      "gender": gender?.toUpperCase(), // Ensure gender is in uppercase (e.g., "MALE")
      "dob": dobController.text, 
      "country": country?.toUpperCase(), // Ensure country is in uppercase (e.g., "INDIA")
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
      "anganwadi": anganwadi,
      "pincode": pincodeController.text,
      "role": role?.toUpperCase(), 
      "roleType": roleType?.toUpperCase(),
      "listOfanganwadiIds": [14, 15], // Add a way to capture this in your UI
    };

    // Log the request payload
    print("Request Payload: $staffData");

    // Set the token
    ApiService apiService = ApiService();
    apiService.setToken("eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJ0ZXN0X3N1cGVydmlzb3JfMSIsImV4cCI6MTc0Mjk5OTI3MywiaWF0IjoxNzQyMzk0NDczLCJhdXRob3JpdGllcyI6W119.auwptcJVI2WxA-eDLFL4y5CHMm80gSAOiyklGWF7aNqoW2cvJZM8bDrBPvHA0fnekV1n-4P9qxFM6F78iRoHnALeYWZaKbatLxZFlzfNsMjaGTmUiAcdwEfq2F2b3d9RnYcuT2GevTO7d8uNJIQfpl3q1eAe0edS3RfDbyoSC66wO5dt39nnRxBJcrheWOdip8IwM0xTFKeitk8-W1lnF9IJLqliZhKQl6MTjLW1JTv4sS88kZizAVcwjBIgzTHpveydzko5-DUBcULclMwSUKjGfixtePCx5EHoAON5xD3dKggXvaVFxBzKay2fd5OQVUpi_8kL5_CwLSKqFuWq-ZPYmNSXLmrwbFMQgHvJDx2lIqgCJqUpSbK0psQdDYwWZdviiZlajUukFxq9Fto_xpGYJ68W_6r0WsVE2JVj851c8jlLXrWbzajtCRr6TXELbhI-CG90nhznzoKw6Vd7mO21pSuEUyCwA1Uvu5QXG09OKDbrof1jqxiJ_aZFPive7yYSV7W0ukZUVzQt_1nnbCG3nlqgROby1xwyM6XKGc0DGf4bDN4SuBpAfgRHtKn4OfSgq9wrhmc4DKTi7Id0id5ZBvHegAm7MmDs7fTQUjntr1a8Rr0_6Qqf7JttrA9HVKQFj4cauZkR-QxEpX9iXQ5xLx-IdD837n_dVPQIcSk");

    // Call the API
    await apiService.registerStaff(staffData);

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
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildSlide("Personal Details", [
                      _buildTextField(nameController, "Full Name", Icons.person,
                          "Name is required"),
                      SizedBox(height: 18.0),
                      _buildTextField(emailController, "Email", Icons.email,
                          "Enter a valid email",
                          keyboardType: TextInputType.emailAddress),
                      SizedBox(height: 18.0),
                      _buildTextField(phoneController, "Phone Number",
                          Icons.phone, "Enter a valid phone number",
                          keyboardType: TextInputType.phone),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Male", "Female"], "Gender", gender,
                          (String? val) => setState(() => gender = val)),
                      SizedBox(height: 18.0),
                      _buildTextField(dobController, "Date of Birth", Icons.child_care,
                          "Name is required"),
                    ]),
                    _buildSlide("Location Details", [
                      _buildDropdown(["USA", "India", "UK"], "Country", country,
                          (String? val) => setState(() => country = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Maharastra", "Delhi"], "State", state,
                          (String? val) => setState(() => state = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Pune", "Konkan"], "Division", division,
                          (String? val) => setState(() => division = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(
                          ["Sangli", "Kolhapur"],
                          "District",
                          district,
                          (String? val) => setState(() => district = val)),
                      SizedBox(height: 18.0),
                    ]),
                    _buildSlide("Location Details", [
                      _buildDropdown(
                          ["Miraj", "Shirala"],
                          "Taluka/Tehsil",
                          talukaTehsil,
                          (String? val) => setState(() => talukaTehsil = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Bus Stand", "railway Station"], "Block",
                          block, (String? val) => setState(() => block = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(
                          ["Pune Loksabha", "Sangli Loksabha"],
                          "Loksabha Constituency",
                          loksabhaConstituency,
                          (String? val) =>
                              setState(() => loksabhaConstituency = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(
                          ["Pune Vidhansabha", "Sangli Vidhansabha"],
                          "Vidhansabha Constituency",
                          vidhansabhaConstituency,
                          (String? val) =>
                              setState(() => vidhansabhaConstituency = val)),
                      SizedBox(height: 18.0),
                    ]),
                    _buildSlide("Location Details", [
                      _buildDropdown(["Sector1", "Sector2"], "Sector", sector,
                          (String? val) => setState(() => sector = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(
                          ["Ambegaon", "Baramati"],
                          "Gram Panchayat",
                          gramPanchayat,
                          (String? val) => setState(() => gramPanchayat = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(["Bhor", "Daund"], "Gram", gram,
                          (String? val) => setState(() => gram = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(
                          ["Mahila Bal Vikas", "PASHAN ANGANWADI"],
                          "Anganwadi",
                          anganwadi,
                          (String? val) => setState(() => anganwadi = val)),
                      SizedBox(height: 18.0),
                    ]),
                    _buildSlide("Location Details", [
                      _buildTextField(pincodeController, "Pincode",
                          Icons.pin_drop, "Enter valid pincode",
                          keyboardType: TextInputType.number),
                      SizedBox(height: 18.0),
                      _buildDropdown(["SUPERVISOR", "STAFF"], "Role", role,
                          (String? val) => setState(() => role = val)),
                      SizedBox(height: 18.0),
                      _buildDropdown(
                          ["ANGANWADI_STAFF", "Teacher"],
                          "Role Type",
                          roleType,
                          (String? val) => setState(() => roleType = val)),
                      SizedBox(height: 18.0),
                    ]),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage > 0
                      ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          onPressed: _previousPage,
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          label: Text("Back",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        )
                      : SizedBox(),
                 ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    onPressed:() {
                      if (_currentPage == 5) {
                      Navigator.pushNamed(context, '/dashboard');
                      _submitForm();
                      print("Form Submitted! Navigate to the next page.");
                    } else {
                  _nextPage();
                 }
               },
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    label: Text(_currentPage == 5 ? "Submit" : "Next", style: TextStyle(color: Colors.white)),
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

  Widget _buildDropdown(List<String> items, String label, String? selectedValue,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      value: selectedValue,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null || value.isEmpty ? 'This field is required' : null,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
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
          prefixIcon: Icon(icon)),
      validator: (value) => (value == null || value.isEmpty) ? errorMsg : null,
    );
  }

  Widget _buildSlide(String title, List<Widget> children) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centers content vertically
        crossAxisAlignment:
            CrossAxisAlignment.center, // Centers content horizontally
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
          SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
