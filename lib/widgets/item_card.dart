import 'package:atta/entities/dish.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/extensions/double_ext.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
    this.withBackground = false,
    super.key,
  });

  final String imageUrl;
  final String name;
  final String description;
  final double price;
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AttaSpacing.m,
            vertical: AttaSpacing.s,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                height: 68,
                width: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AttaRadius.small),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: AttaSpacing.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AttaTextStyle.subHeader),
                    const SizedBox(height: AttaSpacing.xs),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AttaSpacing.m),
              Text(price.toEuro),
            ],
          ),
        ),
      ),
    );
  }
}

class DishItemCard extends StatelessWidget {
  const DishItemCard(
    this.dish, {
    super.key,
  });

  final AttaDish dish;

  @override
  Widget build(BuildContext context) {
    return _ItemCard(
      key: key,
      imageUrl: dish.imageUrl,
      name: dish.name,
      description: dish.description,
      price: dish.price,
    );
  }
}

class MenuItemCard extends StatelessWidget {
  const MenuItemCard(
    this.menu, {
    super.key,
  });

  final AttaMenu menu;

  @override
  Widget build(BuildContext context) {
    return _ItemCard(
      key: key,
      imageUrl: menu.imageUrl,
      name: menu.name,
      description: menu.description,
      price: menu.price,
      withBackground: true,
    );
  }
}
