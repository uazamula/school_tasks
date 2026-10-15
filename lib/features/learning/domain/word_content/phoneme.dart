class Phoneme {
  const Phoneme({
    required this.id,
    required this.profileId,
    required this.symbol,
    this.audio,
  });

  final String id;
  final String profileId;
  final String symbol;
  final String? audio;
}
