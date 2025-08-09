import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/filter_provider.dart';
import '../models/channel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAccountSection(),
            const SizedBox(height: 16),
            _buildChannelManagementSection(),
            const SizedBox(height: 16),
            _buildKidsModeSection(),
            const SizedBox(height: 16),
            _buildEducationalChannelsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                if (user != null) ...[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.photoUrl != null 
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null 
                          ? Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U')
                          : null,
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showSignOutConfirmation(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Sign Out'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleSignOut(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSignOut(BuildContext context) async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).signOut();
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Widget _buildChannelManagementSection() {
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Allowed Channels',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddChannelDialog,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (filterProvider.settings.allowedChannels.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.playlist_add,
                          size: 48,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No channels added yet',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add some channels to filter your content.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ...filterProvider.settings.allowedChannels.map(
                    (channel) => _buildChannelItem(channel, filterProvider),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChannelItem(Channel channel, FilterProvider filterProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFFF6B6B),
          child: Icon(Icons.play_arrow, color: Colors.white),
        ),
        title: Text(channel.name),
        subtitle: Text(
          channel.url,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => _confirmRemoveChannel(channel, filterProvider),
        ),
      ),
    );
  }

  Widget _buildKidsModeSection() {
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kids Mode',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable Kids Mode'),
                  subtitle: const Text('Restrict content to educational channels only'),
                  value: filterProvider.settings.isKidsMode,
                  onChanged: (value) => _handleToggleKidsMode(filterProvider),
                  secondary: const Icon(Icons.child_care),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Parental PIN'),
                  subtitle: Text(
                    filterProvider.settings.parentalPin != null 
                        ? 'PIN is set' 
                        : 'No PIN set',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showPinDialog(filterProvider),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Hide YouTube Shorts'),
                  subtitle: const Text('Remove short-form videos from feed'),
                  value: filterProvider.settings.hideShorts,
                  onChanged: (_) => filterProvider.toggleHideShorts(),
                  secondary: const Icon(Icons.videocam_off),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Hide Trending Section'),
                  subtitle: const Text('Remove trending videos from feed'),
                  value: filterProvider.settings.hideTrending,
                  onChanged: (_) => filterProvider.toggleHideTrending(),
                  secondary: const Icon(Icons.trending_down),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEducationalChannelsSection() {
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, _) {
        final educationalChannels = filterProvider.getEducationalChannels();
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended Educational Channels',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'These channels are pre-approved for kids mode',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 16),
                ...educationalChannels.map(
                  (channel) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF4ECDC4),
                        child: Icon(Icons.school, color: Colors.white),
                      ),
                      title: Text(channel.name),
                      subtitle: Text(
                        channel.url,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        Icons.verified,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddChannelDialog() async {
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Channel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Channel Name',
                hintText: 'Enter channel name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Channel URL',
                hintText: 'https://www.youtube.com/c/ChannelName',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    
    if (result == true && 
        nameController.text.trim().isNotEmpty && 
        urlController.text.trim().isNotEmpty) {
      final channel = Channel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        url: urlController.text.trim(),
      );
      
      await context.read<FilterProvider>().addChannel(channel);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Channel added successfully!')),
        );
      }
    }
  }

  Future<void> _confirmRemoveChannel(Channel channel, FilterProvider filterProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Channel'),
        content: Text('Are you sure you want to remove "${channel.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await filterProvider.removeChannel(channel.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Channel removed successfully!')),
        );
      }
    }
  }

  Future<void> _handleToggleKidsMode(FilterProvider filterProvider) async {
    if (!filterProvider.settings.isKidsMode && 
        filterProvider.settings.parentalPin != null) {
      final pin = await _showPinInputDialog('Enter PIN to enable Kids Mode:');
      if (pin == filterProvider.settings.parentalPin) {
        await filterProvider.toggleKidsMode();
      } else if (pin != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect PIN')),
          );
        }
      }
    } else {
      await filterProvider.toggleKidsMode();
    }
  }

  Future<void> _showPinDialog(FilterProvider filterProvider) async {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Parental PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (filterProvider.settings.parentalPin != null)
              TextField(
                controller: currentPinController,
                decoration: const InputDecoration(
                  labelText: 'Current PIN',
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
              ),
            const SizedBox(height: 16),
            TextField(
              controller: newPinController,
              decoration: const InputDecoration(
                labelText: 'New PIN',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPinController,
              decoration: const InputDecoration(
                labelText: 'Confirm New PIN',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Update'),
          ),
        ],
      ),
    );
    
    if (result == true) {
      final currentPin = currentPinController.text;
      final newPin = newPinController.text;
      final confirmPin = confirmPinController.text;
      
      if (filterProvider.settings.parentalPin != null && 
          currentPin != filterProvider.settings.parentalPin) {
        _showErrorSnackBar('Current PIN is incorrect');
        return;
      }
      
      if (newPin != confirmPin) {
        _showErrorSnackBar('New PINs do not match');
        return;
      }
      
      if (newPin.length < 4) {
        _showErrorSnackBar('PIN must be 4 digits');
        return;
      }
      
      await filterProvider.setParentalPin(newPin);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN updated successfully!')),
        );
      }
    }
  }

  Future<String?> _showPinInputDialog(String message) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Parental Control'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'PIN',
              hintText: message,
            ),
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Enter'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

