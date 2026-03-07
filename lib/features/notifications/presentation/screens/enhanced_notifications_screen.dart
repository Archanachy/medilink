import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/notifications/presentation/providers/notification_providers.dart';
import 'package:medilink/features/notifications/presentation/state/notification_state.dart';

class EnhancedNotificationsScreen extends ConsumerStatefulWidget {
  const EnhancedNotificationsScreen({super.key});

  @override
  ConsumerState<EnhancedNotificationsScreen> createState() =>
      _EnhancedNotificationsScreenState();
}

class _EnhancedNotificationsScreenState
    extends ConsumerState<EnhancedNotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedType;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationViewmodelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Unread'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all),
                    SizedBox(width: 8),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete all'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'mark_all_read') {
                ref.read(notificationViewmodelProvider.notifier).markAllAsRead();
              } else if (value == 'delete_all') {
                _showDeleteAllDialog();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedType != null || _dateRange != null) _buildActiveFilters(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsList(notificationsState, showAll: true),
                _buildNotificationsList(notificationsState, showAll: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.withValues(alpha: 0.1),
      child: Row(
        children: [
          const Text('Active Filters: '),
          if (_selectedType != null) ...[
            Chip(
              label: Text(_selectedType!),
              onDeleted: () {
                setState(() {
                  _selectedType = null;
                });
              },
            ),
            const SizedBox(width: 8),
          ],
          if (_dateRange != null) ...[
            Chip(
              label: Text(
                  '${_dateRange!.start.day}/${_dateRange!.start.month} - ${_dateRange!.end.day}/${_dateRange!.end.month}'),
              onDeleted: () {
                setState(() {
                  _dateRange = null;
                });
              },
            ),
          ],
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedType = null;
                _dateRange = null;
              });
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
      NotificationState notificationsState, {required bool showAll}) {
    if (notificationsState.status == NotificationStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    var notifications = showAll
        ? notificationsState.notifications
        : notificationsState.notifications
            .where((n) => !n.isRead)
            .toList();

    // Apply filters
    if (_selectedType != null) {
      notifications = notifications
          .where((n) => n.type.toLowerCase() == _selectedType!.toLowerCase())
          .toList();
    }

    if (_dateRange != null) {
      notifications = notifications
          .where((n) =>
              n.createdAt.isAfter(_dateRange!.start) &&
              n.createdAt.isBefore(_dateRange!.end))
          .toList();
    }

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off,
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              showAll ? 'No notifications' : 'No unread notifications',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(notificationViewmodelProvider.notifier).loadNotifications();
      },
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Dismissible(
            key: Key(notification.id),
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: const Icon(Icons.done, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                ref
                    .read(notificationViewmodelProvider.notifier)
                    .markAsRead(notification.id);
                return false;
              } else {
                return await _showDeleteDialog();
              }
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                ref
                    .read(notificationViewmodelProvider.notifier)
                    .deleteNotification(notification.id);
              }
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: notification.isRead
                  ? null
                  : Theme.of(context).primaryColor.withValues(alpha: 0.05),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getNotificationColor(notification.type)
                      .withValues(alpha: 0.2),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight:
                        notification.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(notification.body),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(notification.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                trailing: !notification.isRead
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : null,
                onTap: () {
                  if (!notification.isRead) {
                    ref
                        .read(notificationViewmodelProvider.notifier)
                        .markAsRead(notification.id);
                  }
                  // Navigate to relevant screen based on notification data
                },
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'appointment':
        return Icons.event;
      case 'prescription':
        return Icons.medication;
      case 'payment':
        return Icons.payment;
      case 'reminder':
        return Icons.notifications;
      default:
        return Icons.info;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'appointment':
        return Colors.blue;
      case 'prescription':
        return Colors.green;
      case 'payment':
        return Colors.orange;
      case 'reminder':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['All', 'Appointment', 'Prescription', 'Payment', 'Reminder']
                  .map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _selectedType == type || (type == 'All' && _selectedType == null),
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = type == 'All' ? null : type;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                );
                if (range != null) {
                  setState(() {
                    _dateRange = range;
                  });
                  if (context.mounted) Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(_dateRange == null ? 'Select' : 'Change Date Range'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Notification'),
            content: const Text('Are you sure you want to delete this notification?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Notifications'),
        content: const Text('Are you sure you want to delete all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Delete all notifications
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
