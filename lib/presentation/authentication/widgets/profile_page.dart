import 'package:articly/presentation/authentication/view_models/profile_view_model.dart';
import 'package:articly/presentation/authentication/widgets/auth_button.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return Scaffold(
          // backgroundColor: Color(0xFFEFEFEF),
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text('Profile'),
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 15,
                  children: [
                    // // --- Profile Picture ---
                    // CircleAvatar(
                    //   radius: 60,
                    //   backgroundImage: AuthService().user!.photoURL != null
                    //       ? NetworkImage(AuthService().user!.photoURL ?? '')
                    //       : AssetImage('assets/profile_picture.png'),
                    // ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Account info',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Username',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.viewModel.getUsername() ?? 'User',
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: _showEditUsernameDialog,
                                icon: Icon(Icons.edit),
                              ),
                            ],
                          ),
                          Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.viewModel.getUserEmail() ??
                                        'Unspecified',
                                  ),
                                  const SizedBox(height: 3),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // --- Sign Out Button ---
                    AuthButton(
                      color: Colors.red,
                      onPressed: displayLogoutDialog,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8,
                        children: [
                          Icon(Icons.logout),
                          Text(
                            'Log Out',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> displayLogoutDialog() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text(
          'Are you sure you want to log out of your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    if (shouldSignOut == true) {
      await widget.viewModel.logOut();
      // Remove the navigation stack

      if (widget.viewModel.errorMessageLogout == null && mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  _showEditUsernameDialog() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempName = widget.viewModel.getUsername() ?? '';
        return AlertDialog(
          title: Text('Edit Username'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(labelText: 'New username'),
            controller: TextEditingController(text: tempName),
            onChanged: (value) {
              tempName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(tempName),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
    if (newName != null && newName.trim().isNotEmpty) {
      await widget.viewModel.editUsername(newName.trim());
      // FirestoreService().updateUser({'username': newName.trim()});
    }
  }
}
