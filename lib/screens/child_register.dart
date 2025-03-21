import 'package:flutter/material.dart';
import 'package:mindlabryinth/providers/auth_provider.dart';
import 'package:mindlabryinth/screens/api_service.dart';
import 'package:mindlabryinth/screens/dashboard.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Register Provider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashScreen(),
      routes: {
        '/dashboard': (context) => DashScreen(), // Define the route for the dashboard
      },
    );
  }
}

class RegisterChildScreen extends StatefulWidget {
  const RegisterChildScreen({super.key, required ApiService apiService});

  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  int _currentPage = 0;

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController healthConditionsController = TextEditingController();
  final TextEditingController attendanceController = TextEditingController();
  final TextEditingController assessmentsController = TextEditingController();
  final TextEditingController learningMilestonesController = TextEditingController();

  String? gender;
  String? birthCertificate;
  String? disabilities;
  String? middayMeals;
  String? childRole;
  String? physicalActivity;
  String? participatesInActivities;
  String? immunizationStatus;

  final ApiService _apiService = ApiService(); 

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      if (_currentPage < 4) {
        _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
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
      _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
      setState(() {
        _currentPage--;
      });
    }
  }

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    // Prepare the JSON data
    final Map<String, dynamic> childData = {
      "name": nameController.text,
      "gender": gender,
      "dob": dobController.text,
      "birthCertificateNumber": birthCertificate,
      "height": double.tryParse(heightController.text) ?? 0.0,
      "weight": double.tryParse(weightController.text) ?? 0.0,
      "immunizationStatus": immunizationStatus,
      "disabilities": disabilities,
      "healthConditions": healthConditionsController.text,
      "attendance": attendanceController.text,
      "participatesInActivities": participatesInActivities == "True",
      "receivesMiddayMeals": middayMeals == "Yes",
      "childRoleInFamily": childRole,
      "developmentAssessments": assessmentsController.text,
      "physicalActivity": physicalActivity,
      "learningMilestones": learningMilestonesController.text,
      "parentFeedback": "Improving", // You can add a field for this if needed
      "anganwadiWorkerFeedback": "Good Progress", // You can add a field for this if needed
    };

    try {
      // Call the API to register the child
      await _apiService.registerChild(childData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Child registered successfully!")),
      );

      // Navigate to the dashboard
      Navigator.pushNamed(context, '/dashboard');
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to register child: $e")),
      );
    }
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
                      _buildTextField(nameController, "Full Name", Icons.person, "Name is required"),
                      _buildDropdownField("Gender", ["Male", "Female"], (val) => gender = val),
                      _buildTextField(dobController, "DOB", Icons.cake, "Enter your Date of Birth"),
                      _buildDropdownField("Birth Certificate", ["Yes", "No"], (val) => birthCertificate = val),
                    ]),
                    _buildSlide("Personal Details", [
                      _buildTextField(heightController, "Height (Feet)", Icons.height, "Enter height"),
                      _buildTextField(weightController, "Weight (Kg)", Icons.scale, "Enter weight"),
                      _buildDropdownField("Immunization Status", ["Yes", "No"], (val) => immunizationStatus = val),
                      _buildDropdownField("Disabilities", ["Yes", "No"], (val) => disabilities = val),
                    ]),
                    _buildSlide("Location Details", [
                      _buildTextField(healthConditionsController, "Health Conditions", Icons.local_hospital, "Enter health conditions"),
                      _buildTextField(attendanceController, "Attendance", Icons.calendar_today, "Required"),
                      _buildDropdownField("Participates in Activities", ["True", "False"], (val) => participatesInActivities = val),
                      _buildDropdownField("Receives Midday Meals", ["Yes", "No"], (val) => middayMeals = val),
                    ]),
                    _buildSlide("Other Details", [
                      _buildDropdownField("Child Role in Family", ["Son", "Daughter"], (val) => childRole = val),
                      _buildTextField(assessmentsController, "Development Assessments", Icons.assessment, "Enter assessment details"),
                      _buildDropdownField("Physical Activity", ["Active", "Not Active"], (val) => physicalActivity = val),
                      _buildTextField(learningMilestonesController, "Learning Milestones", Icons.school, "Enter milestones"),
                    ]),
                    _buildSlide("Additional Details", [
                      _buildTextField(TextEditingController(), "Other Information", Icons.info, "Enter additional info"),
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
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          onPressed: _previousPage,
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          label: Text("Back", style: TextStyle(color: Colors.white, fontSize: 18)),
                        )
                      : SizedBox(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                    label: Text(_currentPage == 5 ? "Submit" : "Next", style: TextStyle(color: Colors.white, fontSize: 18)),
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

  Widget _buildSlide(String title, List<Widget> fields) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ...fields.map((field) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: field,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String errorMsg) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (value) => value == null || value.isEmpty ? errorMsg : null,
    );
  }

  Widget _buildDropdownField(String label, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? "Please select $label" : null,
    );
  }
}
