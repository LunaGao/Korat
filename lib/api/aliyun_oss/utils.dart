import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String httpDateNow() {
  final dt = new DateTime.now();
  initializeDateFormatting();
  final formatter = new DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_ISO');
  final dts = formatter.format(dt.toUtc());
  return "$dts GMT";
}

String getAuthorization(
  String keyId,
  String keySecret,
  String httpMethod,
  String date, {
  String path = '',
  String contentType = '',
}) {
  path = "/korat-data/" + path;
  String signature =
      "$httpMethod\n\n$contentType\n$date\nx-oss-date:$date\n$path";
  var hmac = new Hmac(sha1, utf8.encode(keySecret));
  var digest = hmac.convert(utf8.encode(signature));
  var returnSignature = base64Encode(digest.bytes);
  return "OSS " + keyId + ":" + returnSignature;
}
