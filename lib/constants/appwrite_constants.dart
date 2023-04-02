class AppwriteConstants {
static const String endPoint = "http://192.168.0.104:80/v1";
  static const String projectId = "64292c4154438fa53a15";
  static const String databaseId = "64292f041d225c29ff1b";
  static const String usersCollection = "64292f1440e2b6667c5b";
  static const String postsCollection = "64292f23d5dfc3e893f1";
  static const String notificationsCollection = "64292f3e761dba064a9a";
  static const String imagesBucket = "64292f5a9df4107dfb30";

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
