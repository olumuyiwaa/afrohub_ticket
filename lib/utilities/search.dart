import 'package:flutter/material.dart';

import 'const.dart';

class Search extends StatelessWidget {
  final Function(String)? onSubmitted;
  final String hintText;
  final TextEditingController? searchController;

  const Search({
    super.key,
    this.onSubmitted,
    required this.hintText,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      cursorColor: accentColor,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 2,
            color: accentColor,
          ),
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 24,
        ),
        hintText: hintText,
      ),
    );
  }
}
