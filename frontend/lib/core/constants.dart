import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiBaseUrl = dotenv.env['API_URL'] ?? 'http://localhost:9000';

// // Colors
// const primaryColor = Color(0xFF82B1FF);

// // Menu
// const menuHeaderColor = Color(0xFF121B2A);
// const menuColor = Color(0xFF3D5B8B);

// Dropdown
const labelColor = Color(0xFFFFFFFF);
const dropdownBGColor = Color(0xFFFFFFFF);
const readOnlyDropdownBGColor = Color(0xFFE3E3E3);
const readOnlyDropdownBorderColor = Color(0xFF7C7E81);
const selectCurrencyColor = Color(0xFF969696);

const textColor = Color(0xFF090303);
const symbolColor = Color(0x89000000);



// 
// const errorText = Color(0xFFF44336);