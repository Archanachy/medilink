import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/search/presentation/widgets/search_results_widget.dart';

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all';
  List<String> _searchHistory = [];
  List<String> _recentSearches = [];

  final List<Map<String, String>> _filters = [
    {'value': 'all', 'label': 'All'},
    {'value': 'doctors', 'label': 'Doctors'},
    {'value': 'hospitals', 'label': 'Hospitals'},
    {'value': 'articles', 'label': 'Articles'},
    {'value': 'appointments', 'label': 'Appointments'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSearchHistory() {
    // Load from local storage
    setState(() {
      _recentSearches = ['Dr. Smith', 'Cardiology',  'Blood Pressure', 'General Hospital'];
    });
  }

  void _addToHistory(String query) {
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory = _searchHistory.sublist(0, 10);
        }
      });
      // Save to local storage
    }
  }

  void _performSearch(String query) {
    _addToHistory(query);
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search doctors, hospitals, articles...',
            border: InputBorder.none,
          ),
          onSubmitted: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _performSearch(_searchController.text),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          if (_searchQuery.isEmpty) ...[
            _buildRecentSearches(),
            _buildSearchSuggestions(),
          ] else
            Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              selected: isSelected,
              label: Text(filter['label']!),
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter['value']!;
                });
                if (_searchQuery.isNotEmpty) {
                  _performSearch(_searchQuery);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _recentSearches.clear();
                  });
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
        ),
        ..._recentSearches.map(
          (search) => ListTile(
            leading: const Icon(Icons.history),
            title: Text(search),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_outward),
              onPressed: () {
                _searchController.text = search;
                _performSearch(search);
              },
            ),
            onTap: () {
              _searchController.text = search;
              _performSearch(search);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Popular Searches',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Cardiologist',
            'Pediatrician',
            'Dentist',
            'Emergency Care',
            'Lab Tests',
            'Vaccination',
          ].map((suggestion) {
            return InkWell(
              onTap: () {
                _searchController.text = suggestion;
                _performSearch(suggestion);
              },
              child: Chip(
                label: Text(suggestion),
                backgroundColor: Colors.grey[200],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return SearchResultsWidget(
      query: _searchQuery,
      selectedFilter: _selectedFilter,
    );
  }
}
