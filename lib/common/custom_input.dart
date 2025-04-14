import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  CustomInput({
    super.key, 
    required this.label, 
    this.obscureText = false,
    this.maxLine = 1,
    this.controller,    
  });

  String label;
  bool obscureText;
  TextEditingController? controller;
  int? maxLine;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {

  bool _obscure = false;

  @override
  void initState() {  
    _obscure = widget.obscureText;  
    super.initState();
  }

  Widget TogglePasswordIcon()
  {
    return GestureDetector(
      onTap: () {
        setState(() {
          _obscure = !_obscure;
        });
      },
      child: Icon(
        _obscure == true ? Icons.visibility_rounded : Icons.visibility_off_rounded,
        size: 24,
        color: Colors.white,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(      
      decoration: BoxDecoration(      
        border: Border.all(
          width: 1,
          color: const Color(0xFFff8202)
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15))        
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -10,
            left: 15,
            child: Container(
              color: Theme.of(context).colorScheme.background.withOpacity(1),          
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
          TextField(
            controller: widget.controller,    
            maxLines: widget.maxLine,        
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: false,
              isDense: true,
              contentPadding: const EdgeInsets.all(13),
              suffixIcon: widget.obscureText == true ? TogglePasswordIcon() : null
            ),
            obscureText: _obscure,
            style: Theme.of(context).textTheme.bodySmall?.apply(
                
            ),
          )
        ],
      ),
    );
  }
}