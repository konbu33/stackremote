import '../domain/channel_repository.dart';
import '../domain/channels.dart';

class ChannelFetchAllUseCase {
  // Constructor
  const ChannelFetchAllUseCase({
    required this.channelRepository,
  });

  // Repository
  final ChannelRepository channelRepository;

  // UseCase Execute
  Stream<Channels> execute() {
    // Construct Dimain Model Object

    // Repository Execute
    final data = channelRepository.fetchAll();

    // return channels;
    return data;
  }
}
