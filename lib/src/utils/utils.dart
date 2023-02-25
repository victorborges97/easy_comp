import 'package:cloud_firestore/cloud_firestore.dart';

Future<QuerySnapshot<T>> getTimeout<T>(Query<T> query, {int seconds = 10}) => query.get().timeout(Duration(seconds: seconds));

getMap<T>({
  required String key,
  required Map<String, dynamic> map,
  required T retur,
  bool parseInt = false,
  bool parseDouble = false,
  T Function(dynamic)? parseFromJson,
}) {
  if (parseFromJson != null) {
    return map.containsKey(key) && map[key] != null ? parseFromJson(map[key]) : retur;
  }
  if (parseInt) {
    return map.containsKey(key) && map[key] != null ? int.parse(map[key].toString()) : retur;
  }
  if (parseDouble) {
    return map.containsKey(key) && map[key] != null ? double.parse(map[key].toString()) : retur;
  }
  return map.containsKey(key) && map[key] != null ? map[key] : retur;
}
