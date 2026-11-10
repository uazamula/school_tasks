enum ContentTag {
  animal,
  domesticAnimal,
  wildAnimal,
  person,
  food,
  object,
  nature,
  sound,
}

/// Батьківські теги: тег «вужчий» і має входити в «ширший».
const Map<ContentTag, ContentTag> _contentTagParents = {
  ContentTag.domesticAnimal: ContentTag.animal,
  ContentTag.wildAnimal: ContentTag.animal,
};

extension ContentTagHierarchy on ContentTag {
  /// Батьківський тег або null.
  ContentTag? get parent => _contentTagParents[this];

  /// Сам тег і всі його предки.
  Set<ContentTag> get withAncestors {
    final result = <ContentTag>{this};
    var current = parent;

    while (current != null) {
      result.add(current);
      current = current.parent;
    }

    return result;
  }
}

extension ContentTagSetHierarchy on Set<ContentTag> {
  /// Набір тегів, доповнений усіма батьківськими.
  Set<ContentTag> get withAncestors => {
    for (final tag in this) ...tag.withAncestors,
  };
}
