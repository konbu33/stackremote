import '../domain/channel_repository.dart';

class ChannelDeleteUseCase {
  // Constructor
  const ChannelDeleteUseCase({
    required this.channelRepository,
  });

  // Repository
  final ChannelRepository channelRepository;

  // UseCase Execute
  Future<String> execute(
    String channelId,
  ) async {
    // Construct Dimain Model Object

    // Repository Execute
    final data = await channelRepository.delete(channelId);

    return data;
  }
}
