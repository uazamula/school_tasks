class MemoryAnswer {
  const MemoryAnswer({required this.hiddenPairId, required this.facePairId});

  /// Пара, якій належить обрана картка B.
  final String hiddenPairId;

  /// Пара, якій належить обрана картка A.
  final String facePairId;
}
