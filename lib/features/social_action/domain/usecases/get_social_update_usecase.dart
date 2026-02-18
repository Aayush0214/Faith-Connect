import '../repository/social_repository.dart';

class GetSocialUpdatesUseCase {
  final SocialActionRepository _socialRepository;
  GetSocialUpdatesUseCase({required SocialActionRepository socialRepository}) : _socialRepository = socialRepository;

  Stream<Map<String, dynamic>> call() {
    return _socialRepository.socialUpdates;
  }
}