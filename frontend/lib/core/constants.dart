import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiBaseUrl = dotenv.env['API_URL'] ?? 'http://localhost:9000';

// Dropdown
const labelColor = Color(0xFFFFFFFF);
const dropdownBGColor = Color(0xFFFFFFFF);
const readOnlyDropdownBGColor = Color(0xFFE3E3E3);
const symbolColor = Color(0x89000000);
