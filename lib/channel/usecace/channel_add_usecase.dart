import '../domain/channel.dart';
import '../domain/channel_repository.dart';
import '../domain/channel_id.dart';

class ChannelAddUseCase {
  // Constructor
  const ChannelAddUseCase({
    required this.channelRepository,
  });

  // Repository
  final ChannelRepository channelRepository;

  // UseCase Execute
  Future<ChannelId> execute(String channelName) async {
    // Construct Dimain Model Object
    final Channel channel = Channel.create(channelName: channelName);

    // Repository Execute
    await channelRepository.add(channel);

    return channel.channelId;
  }
}
