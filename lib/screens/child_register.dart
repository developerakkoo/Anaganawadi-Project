import 'package:flutter/material.dart';

class RegisterChildScreen extends StatefulWidget {
  const RegisterChildScreen({super.key});

  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  int _currentPage = 0;

  // Controllers
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

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      if (_currentPage < 3) {
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
                      _buildDropdownField("Gender", ["Male", "Female"], (val) => gender = val),
                      _buildTextField(dobController, "DOB", Icons.cake, "Enter your Date of Birth"),
                      _buildDropdownField("Birth Certificate", ["Yes", "No"], (val) => birthCertificate = val),
                    ]),
                    _buildSlide([
                      _buildTextField(heightController, "Height (Feet)", Icons.height, "Enter height"),
                      _buildTextField(weightController, "Weight (Kg)", Icons.scale, "Enter weight"),
                      _buildDropdownField("Immunization Status", ["Yes", "No"], (val) => immunizationStatus = val),
                      _buildDropdownField("Disabilities", ["Yes", "No"], (val) => disabilities = val),
                    ]),
                    _buildSlide([
                      _buildTextField(healthConditionsController, "Health Conditions", Icons.local_hospital, "Enter health conditions"),
                      _buildTextField(attendanceController, "Attendance", Icons.calendar_today, "Required"),
                      _buildDropdownField("Participates in Activities", ["True", "False"], (val) => participatesInActivities = val),
                      _buildDropdownField("Receives Midday Meals", ["Yes", "No"], (val) => middayMeals = val),
                    ]),
                    _buildSlide([
                      _buildDropdownField("Child Role in Family", ["Son", "Daughter"], (val) => childRole = val),
                      _buildTextField(assessmentsController, "Development Assessments", Icons.assessment, "Enter assessment details"),
                      _buildDropdownField("Physical Activity", ["Active", "Not Active"], (val) => physicalActivity = val),
                      _buildTextField(learningMilestonesController, "Learning Milestones", Icons.school, "Enter milestones"),
                    ]),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage > 0
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                          onPressed: _previousPage,
                          child: Text("Back", style: TextStyle(color: Colors.white)),
                        )
                      : SizedBox(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
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

  Widget _buildSlide(List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: fields.map((field) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: field,
        )).toList(),
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
