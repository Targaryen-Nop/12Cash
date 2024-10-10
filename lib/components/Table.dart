import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Dropdown Search')),
        body: Center(
          child: SearchBar(),
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _showDropdown = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 300,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'ค้นหา',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _showDropdown = value.isNotEmpty;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add search functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  'ค้นหา',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        if (_showDropdown) _buildDropdown()
      ],
    );
  }

  Widget _buildDropdown() {
    // Example data, replace with actual search results
    final searchResults = [
      {
        'name': 'ร้าน เจริญพรค้าขาย',
        'code': '10334587',
        'route': '19',
        'address': '999/99 มหาราช ต.สุริยะ อ.พระจันทร์ จ.ป่าดงพงไพร 99999',
      },
    ];

    return Container(
      width: 300,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: searchResults.map((result) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result['name']!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'รหัสร้าน: ${result['code']}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'เส้นทาง: ${result['route']}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'ที่อยู่: ${result['address']}',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
            ],
          );
        }).toList(),
      ),
    );
  }
}
