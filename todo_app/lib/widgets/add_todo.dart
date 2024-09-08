import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  final Function(String) onTaskSubmitted;
  final bool isDarkMode;

  AddTodo({
    required this.onTaskSubmitted,
    required this.isDarkMode,
  });

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  bool _isClicked = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _onClick() {
    setState(() {
      _isClicked = true;
    });
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClick,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isClicked
              ? (widget.isDarkMode ? Colors.grey[700] : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isClicked
                ? (widget.isDarkMode ? Colors.blueGrey : Colors.blue)
                : Colors.grey,
            width: _isClicked ? 1.5 : 1,
          ),
        ),
        child: _isClicked
            ? TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Enter a task',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.grey,
                  ),
                ),
                onSubmitted: (value) {
                  widget.onTaskSubmitted(value);
                  setState(() {
                    _controller.clear();
                    _isClicked = false;
                  });
                },
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              )
            : Center(
                child: Text(
                  'Add Todo',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
      ),
    );
  }
}
