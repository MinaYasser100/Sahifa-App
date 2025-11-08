// lib/features/reels/data/datasources/reels_data_source.dart
import 'package:sahifa/core/model/reel_model/reel_model.dart';

class ReelsRepo {
  // للفيديوهات Local
  static List<ReelModel> getLocalReels() {
    return [
      ReelModel(
        id: '1',
        videoUrl: 'assets/videos/reel.mp4',
        userName: 'Ahmed Mohamed',
        userAvatar: 'assets/images/user1.jpg',
        caption: 'Amazing sunset view! 🌅 #nature #beautiful',
        likes: 1234,
        comments: 45,
        shares: 12,
      ),
      ReelModel(
        id: '2',
        videoUrl: 'assets/videos/reel.mp4',
        userName: 'Sara Ali',
        userAvatar: 'assets/images/user2.jpg',
        caption: 'Cooking the best pasta 🍝 #cooking #food',
        likes: 5678,
        comments: 89,
        shares: 34,
      ),
      ReelModel(
        id: '3',
        videoUrl: 'assets/videos/reel.mp4',
        userName: 'Mohamed Hassan',
        userAvatar: 'assets/images/user3.jpg',
        caption: 'Gym motivation 💪 #fitness #workout',
        likes: 3456,
        comments: 67,
        shares: 23,
      ),
      ReelModel(
        id: '4',
        videoUrl: 'assets/videos/reel.mp4',
        userName: 'Fatima Ibrahim',
        userAvatar: 'assets/images/user4.jpg',
        caption: 'Travel vlog - Dubai 🏙️ #travel #dubai',
        likes: 7890,
        comments: 123,
        shares: 56,
      ),
      ReelModel(
        id: '5',
        videoUrl: 'assets/videos/reel5.mp4',
        userName: 'Omar Khaled',
        userAvatar: 'assets/images/user5.jpg',
        caption: 'Tech review - Latest smartphone 📱 #tech',
        likes: 2345,
        comments: 78,
        shares: 29,
      ),
      ReelModel(
        id: '6',
        videoUrl: 'assets/videos/reel.mp4',
        userName: 'Layla Ahmed',
        userAvatar: 'assets/images/user6.jpg',
        caption: 'Fashion tips for winter ❄️ #fashion #style',
        likes: 4567,
        comments: 92,
        shares: 41,
      ),
    ];
  }

  // // للفيديوهات من Backend
  // static Future<List<ReelModel>> fetchReelsFromBackend() async {
  //   try {
  //     // استبدل بالـ API الخاص بك
  //     final response = await http.get(
  //       Uri.parse('https://your-api.com/api/reels'),
  //     );

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body)['data'];
  //       return data.map((json) => ReelModel.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to load reels');
  //     }
  //   } catch (e) {
  //     throw Exception('Error: $e');
  //   }
  // }
}
