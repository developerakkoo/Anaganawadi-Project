import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      ActivitySection(),
      GuideSection(),
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
                  : AssetImage('assets/profile.png') as ImageProvider,
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
                        : AssetImage('assets/profile.png') as ImageProvider,
                  ),
                  SizedBox(height: 8),
                  Text('Welcome, User', style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard'), onTap: () => setState(() => _selectedIndex = 0)),
            ListTile(leading: Icon(Icons.person), title: Text('Profile'), onTap: () => setState(() => _selectedIndex = 1)),
            ListTile(leading: Icon(Icons.vaccines), title: Text('Vaccination'), onTap: () => setState(() => _selectedIndex = 2)),
            ListTile(leading: Icon(Icons.local_activity), title: Text('Activity'), onTap: () => setState(() => _selectedIndex = 3)),
            ListTile(leading: Icon(Icons.menu_book), title: Text('Guide'), onTap: () => setState(() => _selectedIndex = 4)),
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
                    : AssetImage('assets/profile.png') as ImageProvider,
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

class VaccinationSection extends StatelessWidget {
  const VaccinationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Vaccination Section', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}

// class ActivitySection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Activity Section', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//     );
//   }
// }

class GuideSection extends StatelessWidget {
  const GuideSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Guide Section', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
  String _name = 'Johan Due';
  String _role = 'Staff';
  String _mob = '1234567890';
  String _email = 'user.email@example.com';
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
                  : AssetImage('assets/profile.png') as ImageProvider,
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
// Updated Activity section with dynamic form functionality and improved error handling
class ActivitySection extends StatefulWidget {
  const ActivitySection({super.key});

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

  const ActivityForm({super.key, this.onRemove});

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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _addStep,
                  icon: Icon(Icons.add),
                  label: Text('Add Step'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
