import '../domain/channel.dart';
import '../domain/channel_repository.dart';

class ChannelFetchByIdUseCase {
  // Constructor
  const ChannelFetchByIdUseCase({
    required this.channelRepository,
  });

  // Repository
  final ChannelRepository channelRepository;

  // UseCase Execute
  Future<Channel> execute(String channelId) {
    // Construct Dimain Model Object

    // Repository Execute
    final data = channelRepository.fetchById(channelId);

    // return channels;
    return data;
  }
}
