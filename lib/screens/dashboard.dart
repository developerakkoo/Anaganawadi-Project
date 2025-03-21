import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:mindlabryinth/screens/api_service.dart';
import 'child_register.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({super.key});

  @override
  State<DashScreen> createState() => _MyAppState();
}

class _MyAppState extends State<DashScreen> {
  bool _isDarkMode = false;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.grey[900])
          : ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.grey[100]),
      home: DashboardScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const DashboardScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  File? _imageFile;
  final picker = ImagePicker();

  void _updateProfileImage(File? image) {
    setState(() {
      _imageFile = image;
    });
  }

    // Create an instance of ApiService
  final ApiService apiService = ApiService();
  
 // After user logs in and receives a token
 final String token = 'eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJ0ZXN0X3dvcmtlcl8xIiwiZXhwIjoxNzQzMDAxMzQ5LCJpYXQiOjE3NDIzOTY1NDksImF1dGhvcml0aWVzIjpbIkFOR0FOV0FESV9XT1JLRVIiLCJBVCIsIk1DIiwiUERBIiwiVFYiLCJVQSIsIlVWIiwiVkMiLCJWVCIsIlZXIl19.LxMZQFcO33zFhMJqKV6AAyYOD0TOC3c6HPT0TySs0_7CaQIIsQ9pFRgLJqxvvvqMkXCOUyFvXPH7pq1PR03DOuo7fT9boTTiU_QZyMchv9bEoAj_Y5UY-x1QEnTnocl4OQi0oQGkd652Irava6PpKMr55OrH_C0V2DTlav4nt13_l0o16TfBSUHTXnq_fHrHLKgKjuARcIDyxOlUZfxueIQt__5tORwB1YW12ej17IlZH_9X4xePJzvoBAiTshZAmqjd8HlfQWhwg2mgmgAW2f1GnJABC7Gu_LEjgADodpuJRAepU2LdKuNgeyAFnpjgvLADu5ZZVDuqGMkl1DFTFcLU68lkVlOao9PQolAXFBbtC95tpsx673cq_Xc0fxDqjb7QnLn0iK26HaDDWo1Sdt2txHTi6eUHTUkr1A7SQF3XPNZCnWj2ghNmzBVN_934JRRrXUcjEDw1cc0D01r7zKOrZHOOpUNa6QWExsiFdVn4VIcqB1slOsvrpG6lJGWjAHATyNTSPFVzn-nNTzdaSyouMqbG1frO8abzSmd5S4dMcyP16ULcExC7xYS4QL0e4NN2S29I1j5MCcqWSQW8duIIgCc64uQF0m3BWlsPA5oTzf_cB7q-QnyVbuZrYYV-y712-1UWzxxA_1BpwhBFJWt4Pd8KW4mwSX-B6eQMxLM';

  @override
  void initState() {
    super.initState();
    print("Setting token: $token");
    // Set the token after the user logs in
    apiService.setToken(token);
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) _updateProfileImage(File(pickedFile.path));
  }

@override
Widget build(BuildContext context) {
  final pages = [
    _buildDashboardPage(),
    ProfileSection(imageFile: _imageFile, onImagePicked: _updateProfileImage, pickImageFunction: _pickImage),
    VaccinationSection(),
    ActivitySection(apiService: apiService), // Pass the ApiService instance here
    RegisterChildScreen(apiService: apiService,),
    SettingsSection(isDarkMode: widget.isDarkMode, toggleTheme: widget.toggleTheme),
  ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : AssetImage('assets/profilenew.png') as ImageProvider,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : AssetImage('assets/profilenew.png') as ImageProvider,
                  ),
                  SizedBox(height: 8),
                  Text('Welcome, Varun', style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard'), onTap: () => setState(() => _selectedIndex = 0)),
            ListTile(leading: Icon(Icons.person), title: Text('Profile'), onTap: () => setState(() => _selectedIndex = 1)),
            ListTile(leading: Icon(Icons.vaccines), title: Text('Vaccination'), onTap: () => setState(() => _selectedIndex = 2)),
            ListTile(leading: Icon(Icons.local_activity), title: Text('Activity'), onTap: () => setState(() => _selectedIndex = 3)),
            ListTile(leading: Icon(Icons.child_care), title: Text('Child'), onTap: () => setState(() => _selectedIndex = 4)),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings'), onTap: () => setState(() => _selectedIndex = 5)),
          ],
        ),
      ),
      body: pages[_selectedIndex],
    );
  }

  Widget _buildDashboardPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Welcome Back!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              CircleAvatar(
                radius: 30,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : AssetImage('assets/profilenew.png') as ImageProvider,
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Here is an overview of your dashboard.', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard('Total Students', '12,543', '80% Increase than before', Icons.people, Colors.blue),
              _buildStatCard('Total Income', '\$10,123', '80% Increase in 20 Days', Icons.attach_money, Colors.green),
              _buildStatCard('Working Hours', '32h 42m', '80% Increase than before', Icons.access_time, Colors.orange),
              _buildStatCard('Active Projects', '24', '12% Increase this month', Icons.assignment, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildStatCard(String title, String value, String description, IconData icon, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(backgroundColor: iconColor.withOpacity(0.1), child: Icon(icon, color: iconColor)),
              Icon(Icons.more_vert, color: Colors.grey[700]),
            ],
          ),
          SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}

class VaccinationSection extends StatefulWidget {
  const VaccinationSection({super.key});

  @override
  State<VaccinationSection> createState() => _VaccinationSectionState();
}

class _VaccinationSectionState extends State<VaccinationSection> {
  final List<TextEditingController> _vaccineControllers = [];
  final List<DateTime?> _selectedDates = [];
  final List<TimeOfDay?> _selectedTimes = [];

  void _addSchedule() {
    setState(() {
      _vaccineControllers.add(TextEditingController());
      _selectedDates.add(null);
      _selectedTimes.add(null);
    });
  }

  void _removeSchedule(int index) {
    setState(() {
      _vaccineControllers[index].dispose();
      _vaccineControllers.removeAt(index);
      _selectedDates.removeAt(index);
      _selectedTimes.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDates[index] = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTimes[index] = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vaccination Schedule',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addSchedule,
            child: const Text('Add Vaccination Schedule'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _vaccineControllers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _vaccineControllers[index],
                          decoration: const InputDecoration(
                            labelText: 'Vaccine Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _selectDate(context, index),
                                child: Text(
                                  _selectedDates[index] == null
                                      ? 'Select Date'
                                      : 'Date: ${_selectedDates[index]!.toLocal()}'.split(' ')[0],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _selectTime(context, index),
                                child: Text(
                                  _selectedTimes[index] == null
                                      ? 'Select Time'
                                      : 'Time: ${_selectedTimes[index]!.format(context)}',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () => _removeSchedule(index),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Remove'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Vaccination Scheduled')),
                                );
                              },
                              child: const Text('Confirm Schedule'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) toggleTheme;

  const SettingsSection({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ListTile(title: Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        SwitchListTile(
          title: Text('Dark Mode'),
          value: isDarkMode,
          onChanged: toggleTheme,
        ),
        Divider(),
        ListTile(title: Text('Account Settings'), subtitle: Text('Change password, email, etc.'), trailing: Icon(Icons.arrow_forward_ios), onTap: () {}),
        ListTile(title: Text('Notification Settings'), subtitle: Text('Manage notification preferences'), trailing: Icon(Icons.arrow_forward_ios), onTap: () {}),
        ListTile(title: Text('Privacy Settings'), subtitle: Text('Manage privacy and security'), trailing: Icon(Icons.arrow_forward_ios), onTap: () {}),
        ListTile(title: Text('Language'), subtitle: Text('Select app language'), trailing: Icon(Icons.arrow_forward_ios), onTap: () {}),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.logout),
          label: Text('Logout'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: EdgeInsets.symmetric(vertical: 16)),
        ),
      ],
    );
  }
}

class ProfileSection extends StatefulWidget {
  final File? imageFile;
  final Function(File?) onImagePicked;
  final Future<void> Function() pickImageFunction;

  const ProfileSection({super.key, required this.imageFile, required this.onImagePicked, required this.pickImageFunction});

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  bool _isEditing = false;
  String _name = 'Varun';
  String _role = 'Staff';
  String _mob = '1234567890';
  String _email = 'user@gmail.com';
  String _pass = '123456';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.grey[700]),
              onPressed: () => setState(() => _isEditing = !_isEditing),
            ),
          ]),
          GestureDetector(
            onTap: _isEditing ? widget.pickImageFunction : null,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: widget.imageFile != null
                  ? FileImage(widget.imageFile!)
                  : AssetImage('assets/profilenew.png') as ImageProvider,
            ),
          ),
          SizedBox(height: 16),
          _isEditing
              ? TextField(decoration: InputDecoration(labelText: 'Name'), onChanged: (value) => _name = value)
              : Text(_name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _isEditing
              ? TextField(decoration: InputDecoration(labelText: 'Role'), onChanged: (value) => _role = value)
              : Text(_role, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 8),
          _isEditing
              ? TextField(decoration: InputDecoration(labelText: 'Mobile No'), onChanged: (value) => _mob = value)
              : Text(_mob, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          _isEditing
              ? TextField(decoration: InputDecoration(labelText: 'Email'), onChanged: (value) => _email = value)
              : Text(_email, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 8),
          _isEditing
              ? TextField(decoration: InputDecoration(labelText: 'Password'), onChanged: (value) => _pass = value)
              : Text(_pass, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDashboardItem('163', 'Follow'),
                      _buildDashboardItem('316', 'Download'),
                      _buildDashboardItem('039', 'Completed'),
                      _buildDashboardItem('090', 'Comment'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

// Activity Section --
class ActivitySection extends StatefulWidget {
  final ApiService apiService;

  const ActivitySection({super.key, required this.apiService});

  @override
  _ActivitySectionState createState() => _ActivitySectionState();
}

class _ActivitySectionState extends State<ActivitySection> {
  final List<ActivityForm> _activityForms = [];

  @override
  void initState() {
    super.initState();
    _addActivityForm(); // Initialize with one form
  }

void _addActivityForm() {
  setState(() => _activityForms.add(ActivityForm(
        key: UniqueKey(),
        onRemove: () => _removeActivityForm(_activityForms.length - 1),
        apiService: widget.apiService, // Pass the ApiService instance
      )));
}
  void _removeActivityForm(int index) {
    setState(() => _activityForms.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _addActivityForm,
            icon: Icon(Icons.add),
            label: Text('Add Activity'),
          ),
          ..._activityForms,
        ],
      ),
    );
  }
}
class ActivityForm extends StatefulWidget {
  final VoidCallback? onRemove;
  final ApiService apiService;

  const ActivityForm({super.key, this.onRemove, required this.apiService});

  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController(text: 'Color Identification Practice');
  final TextEditingController _descriptionController = TextEditingController(text: 'Identify Black Color Objects');
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedAnganwadiId = '2';
  final List<TextEditingController> _stepControllers = [
    TextEditingController(text: 'Look at the surroundings'),
    TextEditingController(text: 'Spot the objects with Black in Color'),
    TextEditingController(text: 'Note Down the names'),
  ];

  void _addStep() => setState(() => _stepControllers.add(TextEditingController()));

  void _removeStep(int index) => setState(() => _stepControllers.removeAt(index));

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _submitActivity() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Check if the token is set
        if (widget.apiService.token == null || widget.apiService.token!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Authentication required. Please log in again.")),
          );
          return;
        }

        // Format the time in 24-hour format (HH:mm:ss)
        final formattedTime = _selectedTime!.format(context); // e.g., "3:37 PM"
        final timeParts = formattedTime.split(":"); // Split into ["3", "37 PM"]
        final hourPart = timeParts[0].trim(); // Extract hour part and remove spaces
        final minuteAndPeriod = timeParts[1].trim().split(" "); // Split into ["37", "PM"]

        // Extract minute and period
        final minute = minuteAndPeriod[0]; // "37"
        final period = minuteAndPeriod[1]; // "PM"

        // Parse hour and minute as integers
        final hour = int.parse(hourPart);
        final minuteInt = int.parse(minute);

        // Convert to 24-hour format
        int hour24 = hour;
        if (period == "PM" && hour != 12) {
          hour24 += 12;
        } else if (period == "AM" && hour == 12) {
          hour24 = 0;
        }

        // Format as HH:mm:ss
        final formatted24HourTime = "${hour24.toString().padLeft(2, '0')}:${minuteInt.toString().padLeft(2, '0')}:00";

        // Debug log to verify the formatted time
        print("Formatted 24-hour time: $formatted24HourTime");

        // Prepare the data to be sent to the API
        final Map<String, dynamic> activityData = {
          "activityTitle": _titleController.text,
          "description": _descriptionController.text,
          "activityScheduledDate": _selectedDate!.toIso8601String().split('T')[0], // Format: YYYY-MM-DD
          "activityScheduledTime": formatted24HourTime, // Format: HH:mm:ss
          "isCompleted": false,
          "anganwadiId": int.parse(_selectedAnganwadiId),
          "steps": _stepControllers.map((controller) => controller.text).toList(),
        };

        // Call the API to submit the activity
        await widget.apiService.activitySection(activityData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Activity Scheduled Successfully!")),
        );

        // Open the _showSubmitForm after successful submission
        _showSubmitForm();
      } catch (e) {
        // Show error message if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  void _showSubmitForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9, // Almost full screen
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            final formKey = GlobalKey<FormState>();
            final TextEditingController titleController = TextEditingController(text: 'Guide for the activity to perform the Alphabets Puzzle');
            final TextEditingController descriptionController = TextEditingController(text: 'To perform Alphabets Puzzle activity');
            final TextEditingController ageGroupController = TextEditingController(text: '10-12');

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Guide Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: "Guide Title"),
                        validator: (value) => value!.isEmpty ? "Title is required" : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: "Guide Description"),
                        validator: (value) => value!.isEmpty ? "Description is required" : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: ageGroupController,
                        decoration: InputDecoration(labelText: "Age Group"),
                        validator: (value) => value!.isEmpty ? "Age Group is required" : null,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              // Prepare the data to be sent to the API
                              final Map<String, dynamic> guideData = {
                                "ageGroup": ageGroupController.text,
                                "description": descriptionController.text,
                                "title": titleController.text,
                              };

                              // Call the API to submit the guide
                              await widget.apiService.activityGuide(guideData);

                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Guide Submitted Successfully!")),
                              );

                              // Close the bottom sheet
                              Navigator.pop(context);
                            } catch (e) {
                              // Show error message if something goes wrong
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: ${e.toString()}")),
                              );
                            }
                          }
                        },
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Activity Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (widget.onRemove != null)
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: widget.onRemove,
                    ),
                ],
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Activity Title'),
                validator: (value) => value!.isEmpty ? 'Title cannot be empty' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text(_selectedDate == null
                          ? 'Select Date'
                          : _selectedDate!.toLocal().toString().split(' ')[0]),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectTime(context),
                      child: Text(_selectedTime == null ? 'Select Time' : _selectedTime!.format(context)),
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _selectedAnganwadiId,
                items: ['1', '2', '3']
                    .map((id) => DropdownMenuItem(value: id, child: Text('Anganwadi $id')))
                    .toList(),
                onChanged: (value) => setState(() => _selectedAnganwadiId = value!),
                decoration: InputDecoration(labelText: 'Anganwadi ID'),
              ),
              SizedBox(height: 16),
              Text('Steps', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ..._stepControllers.asMap().entries.map((entry) => Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: entry.value,
                          decoration: InputDecoration(labelText: 'Step ${entry.key + 1}'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeStep(entry.key),
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _addStep,
                    icon: Icon(Icons.add),
                    label: Text('Add Step'),
                  ),
                  ElevatedButton(
                    onPressed: _submitActivity,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
