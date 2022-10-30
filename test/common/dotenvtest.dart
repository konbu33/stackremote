import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void dotEnvTestLoad() {
  WidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad(fileInput: File('.env').readAsStringSync());
}
