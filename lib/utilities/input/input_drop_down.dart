import 'package:flutter/material.dart';

class InputDropDown extends StatefulWidget {
  final List<String> options;
  final void Function(String) onOptionSelected;
  final String inputTitle;

  const InputDropDown({
    super.key,
    required this.options,
    required this.onOptionSelected,
    required this.inputTitle,
  });

  @override
  State<InputDropDown> createState() => _InputDropDownState();
}

class _InputDropDownState extends State<InputDropDown> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.options[0];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE1E7EA),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.inputTitle,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Container(
              alignment: Alignment.center,
              height: 44,
              child: DropdownButton<String>(
                isDense: true,
                value: selectedOption,
                items: widget.options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue!;
                    widget.onOptionSelected(newValue);
                  });
                },
                icon: const Icon(Icons.arrow_drop_down),
                underline: const SizedBox(),
                isExpanded: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
