
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

const emulip = '192.168.45.241:3000';
const simulip = '127.0.0.1:3000';

final ip = Platform.isAndroid ? emulip : simulip;