import 'package:flutter/material.dart';
import '../widgets/deal_card.dart';
import '../widgets/header.dart';
import '../widgets/navbar.dart';
import '../widgets/car_card.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: const Text(
            'View All',
            style: TextStyle(
              color: Color(0xFF2B6777),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CarCard(
            brand: 'Mercedes Benz',
            carName: 'CLS',
            rating: 4.5,
            pricePerDay: 125000,
            fuelType: 'Gasoline',
            imageUrl: 'https://res.cloudinary.com/mufautoshow/image/upload/f_auto,w_auto/v1678416045/mos/type/1678416044_0_cls-350.png',
            onTap: () {},
          ),
          CarCard(
            brand: 'Honda',
            carName: 'City HS',
            rating: 4.5,
            pricePerDay: 125000,
            fuelType: 'Gasoline',
            imageUrl: 'https://api.cvtindonesia.co.id/upload/file-1621512885591.jpg',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderSection(),
                    const SizedBox(height: 24),
                    const DealCard(),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            'Most Searched Car',
                            () {
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildCarSection(),
                          const SizedBox(height: 32),
                          _buildSectionHeader(
                            'Recommended For You',
                            () {
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildCarSection(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 150), 
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: NavBarBottom(),
            ),
          ],
        ),
      ),
    );
  }
}