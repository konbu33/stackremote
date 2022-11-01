import '../domain/channel.dart';
import '../domain/channel_repository.dart';
import '../domain/channel_id.dart';

class ChannelUpdateUseCase {
  // Constructor
  const ChannelUpdateUseCase({
    required this.channelRepository,
  });

  // Repository
  final ChannelRepository channelRepository;

  // UseCase Execute
  void execute(
    ChannelId channelId,
  ) {
    // Construct Dimain Model Object
    final Channel channel = Channel.create();

    // Repository Execute
    channelRepository.update(channel);
  }
}
