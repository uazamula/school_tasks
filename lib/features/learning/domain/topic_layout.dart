import 'package:school_tasks/features/learning/domain/interaction_layout.dart';
import 'package:school_tasks/features/learning/domain/prompt_layout.dart';

class TopicLayout {
  const TopicLayout({
    this.promptFlex = 1,
    this.interactionFlex = 2,
    this.interaction = const InteractionLayout(),
    this.prompt = const PromptLayout(),
  });

  /// Відносний розмір області умови.
  final int promptFlex;

  /// Відносний розмір області взаємодії.
  final int interactionFlex;

  final InteractionLayout interaction;
  final PromptLayout prompt;

  /// Співвідношення 1/3 : 2/3.
  const TopicLayout.standard({
    this.interaction = const InteractionLayout(),
    this.prompt = const PromptLayout(),
  }) : promptFlex = 1,
       interactionFlex = 2;

  /// Співвідношення 3/5 : 2/5.
  ///
  /// Для тем, де умова займає більше місця.
  const TopicLayout.largePrompt({
    this.interaction = const InteractionLayout(),
    this.prompt = const PromptLayout(),
  }) : promptFlex = 3,
       interactionFlex = 2;

  /// Співвідношення 1/5 : 4/5.
  ///
  /// Наприклад, для тем, що складаються переважно з matching.
  const TopicLayout.minimalPrompt({
    this.interaction = const InteractionLayout(),
    this.prompt = const PromptLayout(),
  }) : promptFlex = 1,
       interactionFlex = 4;

  int get totalFlex => promptFlex + interactionFlex;

  double get promptRatio => promptFlex / totalFlex;

  double get interactionRatio => interactionFlex / totalFlex;
}
