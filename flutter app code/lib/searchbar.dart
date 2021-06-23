import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _controller = TextEditingController();
  String s = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.07,
            color: Color(0xffFEA652),
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 4, 3, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: TextField(
                cursorColor: Color(0xffFEA652),
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Enter Text',
                  fillColor: Colors.white,
                ),
                onSubmitted: (String value) {
                  print(s);
                  setState(() {
                     print(s.length);
                    s.length == 1 ? s = value.toUpperCase() : s = value;
                  });
                  print(s);
                },
              ),
            ),
          ),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: s != ''
                ? Image.asset(
                    'assets/images/$s\_test.jpg',
                    fit: BoxFit.contain,
                  )
                : Container(color: Color(0xffFEA652).withOpacity(0.5)),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
