import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/reviews/presentation/providers/review_providers.dart';
import 'package:medilink/features/reviews/presentation/widgets/rating_stars_widget.dart';

class SubmitReviewScreen extends ConsumerStatefulWidget {
  final String reviewableId;
  final String reviewableType;
  final String reviewableName;

  const SubmitReviewScreen({
    super.key,
    required this.reviewableId,
    required this.reviewableType,
    required this.reviewableName,
  });

  @override
  ConsumerState<SubmitReviewScreen> createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends ConsumerState<SubmitReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  double _rating = 0;
  final List<String> _selectedTags = [];

  final List<String> _availableTags = [
    'Professional',
    'Friendly',
    'On Time',
    'Clean Facility',
    'Good Communication',
    'Thorough Examination',
    'Affordable',
    'Highly Recommended',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewViewmodelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Review'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Review for ${widget.reviewableName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Rating',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: InteractiveRatingStars(
                initialRating: _rating,
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
                size: 48,
              ),
            ),
            if (_rating > 0) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _getRatingText(_rating),
                  style: TextStyle(
                    fontSize: 16,
                    color: _getRatingColor(_rating),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
            const Text(
              'Your Review',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _commentController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Share your experience...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your review';
                }
                if (value.trim().length < 10) {
                  return 'Review must be at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Add Tags (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : _submitReview,
                child: state.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    final success = await ref.read(reviewViewmodelProvider.notifier).submitReview(
          reviewableId: widget.reviewableId,
          reviewableType: widget.reviewableType,
          rating: _rating,
          comment: _commentController.text.trim(),
          tags: _selectedTags,
        );

    if (success && mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
    } else if (mounted) {
      final state = ref.read(reviewViewmodelProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error ?? 'Failed to submit review')),
      );
    }
  }

  String _getRatingText(double rating) {
    if (rating >= 4.5) return 'Excellent!';
    if (rating >= 3.5) return 'Good';
    if (rating >= 2.5) return 'Average';
    if (rating >= 1.5) return 'Poor';
    return 'Very Poor';
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 3.5) return Colors.lightGreen;
    if (rating >= 2.5) return Colors.orange;
    if (rating >= 1.5) return Colors.deepOrange;
    return Colors.red;
  }
}
