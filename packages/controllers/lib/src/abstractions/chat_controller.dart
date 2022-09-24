// ignore: one_member_abstracts
abstract class ChatController {
  Future<DateTime> sendMessage({required String to, required String content});
}
