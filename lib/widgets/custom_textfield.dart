import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({super.key, required this.controller, required this.label, this.hintText, this.isObscureText = false, this.needObscureToggle = true, this.isEnabled = true, this.textInputType});
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final bool isObscureText;
  final bool needObscureToggle;
  final bool isEnabled;
  final TextInputType? textInputType;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = false;
  @override
  void initState() {
    super.initState();
    isObscure = widget.isObscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9)),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: widget.controller,
                obscureText: isObscure,
                enabled: widget.isEnabled,
                keyboardType: widget.textInputType,
                style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: widget.hintText ?? "",
                  border: InputBorder.none,
                  suffixIcon: widget.isObscureText && widget.needObscureToggle
                      ? IconButton(
                          icon: Icon(
                            isObscure == true ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        )
                      : null,
                ),
              ),
            ],
          ),
        ));
  }
}
