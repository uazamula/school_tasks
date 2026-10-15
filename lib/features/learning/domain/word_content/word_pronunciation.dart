class WordPronunciation {
  WordPronunciation({
    required this.profileId,
    required List<String> phonemeIds,
    this.audio,
  }) : phonemeIds = List.unmodifiable(phonemeIds);

  final String profileId;
  final List<String> phonemeIds;
  final String? audio;
}
