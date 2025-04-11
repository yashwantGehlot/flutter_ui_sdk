import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final Future<void> Function() onTap;

  const LoadingButton({
    super.key,
    required this.icon,
    required this.text,
    this.color = Colors.black,
    required this.onTap,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          setState(() {
            _isLoading = true;
          });

          try {
            await widget.onTap();
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 24,
                color: widget.color,
              ),
              const SizedBox(width: 14),
              Flexible(
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (_isLoading) ...[
                const Spacer(),
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
