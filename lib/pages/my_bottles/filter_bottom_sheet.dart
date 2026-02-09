import 'package:flutter/material.dart';

typedef OnSortApply = void Function(String selectedSort);

class FilterBottomSheet extends StatefulWidget {
  final OnSortApply? onApply;           // ← callback to parent
  final String initialSort;             // optional: pass current sort from parent

  const FilterBottomSheet({
    super.key,
    this.onApply,
    this.initialSort = 'name_asc',      // default
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSort;
  }

  void _reset() {
    setState(() {
      _selectedSort = 'name_asc';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filter & Sort",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xfffe8003),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Sort by",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // All options now use local state
            _FilterOptionTile(
              title: "Name: A to Z",
              value: "name_asc",
              isSelected: _selectedSort == "name_asc",
              onTap: () => setState(() => _selectedSort = "name_asc"),
            ),
            _FilterOptionTile(
              title: "Name: Z to A",
              value: "name_desc",
              isSelected: _selectedSort == "name_desc",
              onTap: () => setState(() => _selectedSort = "name_desc"),
            ),
            _FilterOptionTile(
              title: "Time: Newest First",
              value: "time_desc",
              isSelected: _selectedSort == "time_desc",
              onTap: () => setState(() => _selectedSort = "time_desc"),
            ),
            _FilterOptionTile(
              title: "Time: Oldest First",
              value: "time_asc",
              isSelected: _selectedSort == "time_asc",
              onTap: () => setState(() => _selectedSort = "time_asc"),
            ),
            _FilterOptionTile(
              title: "Price: High to Low",
              value: "price_desc",
              isSelected: _selectedSort == "price_desc",
              onTap: () => setState(() => _selectedSort = "price_desc"),
            ),
            _FilterOptionTile(
              title: "Price: Low to High",
              value: "price_asc",
              isSelected: _selectedSort == "price_asc",
              onTap: () => setState(() => _selectedSort = "price_asc"),
            ),
            _FilterOptionTile(
              title: "Fullest",
              value: "fullest",
              isSelected: _selectedSort == "fullest",
              onTap: () => setState(() => _selectedSort = "fullest"),
            ),
            _FilterOptionTile(
              title: "Emptiest",
              value: "emptiest",
              isSelected: _selectedSort == "emptiest",
              onTap: () => setState(() => _selectedSort = "emptiest"),
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _reset();
                      // You can also pop() here if you want reset → close
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Reset",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply?.call(_selectedSort);  // ← send value back!
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfffe8003),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterOptionTile extends StatelessWidget {
  final String title;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOptionTile({
    required this.title,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xfffe8003).withOpacity(0.15) : null,
          border: Border.all(
            color: isSelected ? const Color(0xfffe8003) : Colors.grey[700]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xfffe8003) : Colors.white,
                fontSize: 16,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xfffe8003),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}