import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchResultsWidget extends StatelessWidget {
  final String query;
  final String? selectedFilter;

  const SearchResultsWidget({
    super.key,
    required this.query,
    this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final doctors = _getMockDoctors(query, selectedFilter);
    final hospitals = _getMockHospitals(query, selectedFilter);
    final articles = _getMockArticles(query, selectedFilter);
    final appointments = _getMockAppointments(query, selectedFilter);

    final hasResults = doctors.isNotEmpty ||
        hospitals.isNotEmpty ||
        articles.isNotEmpty ||
        appointments.isNotEmpty;

    if (!hasResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No results found for "$query"',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        if (doctors.isNotEmpty) ...[
          _buildSectionHeader(context, 'Doctors', doctors.length),
          ...doctors.map((doctor) => _buildDoctorCard(context, doctor)),
        ],
        if (hospitals.isNotEmpty) ...[
          _buildSectionHeader(context, 'Hospitals', hospitals.length),
          ...hospitals.map((hospital) => _buildHospitalCard(context, hospital)),
        ],
        if (articles.isNotEmpty) ...[
          _buildSectionHeader(context, 'Articles', articles.length),
          ...articles.map((article) => _buildArticleCard(context, article)),
        ],
        if (appointments.isNotEmpty) ...[
          _buildSectionHeader(context, 'Appointments', appointments.length),
          ...appointments
              .map((appointment) => _buildAppointmentCard(context, appointment)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Map<String, dynamic> doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(doctor['image']),
        ),
        title: Text(
          doctor['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doctor['specialty']),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${doctor['rating']}'),
                const SizedBox(width: 8),
                Text('${doctor['experience']} years exp'),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.push('/doctors/${doctor['id']}');
        },
      ),
    );
  }

  Widget _buildHospitalCard(
      BuildContext context, Map<String, dynamic> hospital) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.local_hospital, color: Colors.blue[700]),
        ),
        title: Text(
          hospital['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    hospital['location'],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${hospital['rating']}'),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.push('/hospitals/${hospital['id']}');
        },
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, Map<String, dynamic> article) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.article, color: Colors.green[700]),
        ),
        title: Text(
          article['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(
                    article['category'],
                    style: const TextStyle(fontSize: 12),
                  ),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const Spacer(),
                Text(
                  '${article['readTime']} min read',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.push('/articles/${article['id']}');
        },
      ),
    );
  }

  Widget _buildAppointmentCard(
      BuildContext context, Map<String, dynamic> appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.event, color: Colors.purple[700]),
        ),
        title: Text(
          'Dr. ${appointment['doctorName']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appointment['specialty']),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  appointment['date'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  appointment['time'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            appointment['status'],
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: _getStatusColor(appointment['status']),
          padding: EdgeInsets.zero,
        ),
        onTap: () {
          context.push('/appointments/${appointment['id']}');
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green[100]!;
      case 'pending':
        return Colors.orange[100]!;
      case 'cancelled':
        return Colors.red[100]!;
      case 'completed':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  // Mock data methods
  List<Map<String, dynamic>> _getMockDoctors(String query, String? filter) {
    if (filter != null && filter != 'all' && filter != 'doctors') return [];

    return [
      {
        'id': '1',
        'name': 'Dr. John Smith',
        'specialty': 'Cardiologist',
        'rating': 4.8,
        'experience': 15,
        'image': 'https://via.placeholder.com/150',
      },
      {
        'id': '2',
        'name': 'Dr. Sarah Johnson',
        'specialty': 'Dermatologist',
        'rating': 4.9,
        'experience': 12,
        'image': 'https://via.placeholder.com/150',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockHospitals(String query, String? filter) {
    if (filter != null && filter != 'all' && filter != 'hospitals') return [];

    return [
      {
        'id': '1',
        'name': 'City General Hospital',
        'location': '123 Main St, Springfield',
        'rating': 4.5,
      },
      {
        'id': '2',
        'name': 'St. Mary\'s Medical Center',
        'location': '456 Oak Ave, Springfield',
        'rating': 4.7,
      },
    ];
  }

  List<Map<String, dynamic>> _getMockArticles(String query, String? filter) {
    if (filter != null && filter != 'all' && filter != 'articles') return [];

    return [
      {
        'id': '1',
        'title': '10 Tips for a Healthy Heart',
        'category': 'Cardiology',
        'readTime': 5,
      },
      {
        'id': '2',
        'title': 'Understanding Diabetes Management',
        'category': 'Endocrinology',
        'readTime': 8,
      },
    ];
  }

  List<Map<String, dynamic>> _getMockAppointments(String query, String? filter) {
    if (filter != null && filter != 'all' && filter != 'appointments') return [];

    return [
      {
        'id': '1',
        'doctorName': 'John Smith',
        'specialty': 'Cardiologist',
        'date': 'Dec 25, 2023',
        'time': '10:00 AM',
        'status': 'Confirmed',
      },
      {
        'id': '2',
        'doctorName': 'Sarah Johnson',
        'specialty': 'Dermatologist',
        'date': 'Dec 28, 2023',
        'time': '2:00 PM',
        'status': 'Pending',
      },
    ];
  }
}
