
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final storage = FlutterSecureStorage();

final emulip = '192.168.0.104:3000';
final simulip = '127.0.0.1:3000';

final ip = Platform.isAndroid ? emulip : simulip;