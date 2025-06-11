import 'package:flutter/material.dart';

class BuddhaBowlScreen extends StatelessWidget {
  const BuddhaBowlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Healthy Recipes')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRecipeImage(),
              const SizedBox(height: 20),
              _buildRecipeTitle(),
              const SizedBox(height: 8),
              _buildRecipeTags(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=600',
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRecipeTitle() {
    return const Text(
      'Quinoa Buddha Bowl',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildRecipeTags() {
    return const Row(
      children: [
        Icon(Icons.restaurant, size: 16, color: Colors.green),
        SizedBox(width: 4),
        Text(
          'Fresh Vegetarian • High Protein',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
