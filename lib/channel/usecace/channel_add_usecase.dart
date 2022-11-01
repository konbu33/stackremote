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
  Future<Channel> execute(String channelName) async {
    // Construct Dimain Model Object
    final Channel channel = Channel.create();

    // Repository Execute
    await channelRepository.add(channel);

    return channel;
  }
}
