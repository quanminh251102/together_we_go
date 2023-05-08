String handleLongString(String str) {
  if (str.length < 20) return str;
  return str.substring(0, 19) + '...';
}

String handeDateString_getTime(String str) {
  DateTime dt = DateTime.parse(str).toLocal();
  return dt.hour.toString() + ":" + dt.minute.toString();
}
