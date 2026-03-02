import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../matchups/presentation/view_models/matchup_view_model.dart';
import '../view_models/share_view_model.dart';
import '../widgets/rivalry_card_widget.dart';

class CardPreviewPage extends ConsumerWidget {
  const CardPreviewPage({
    super.key,
    required this.matchupType,
    required this.id1,
    required this.id2,
  });

  final String matchupType;
  final String id1;
  final String id2;

  bool get isBatterPitcher => matchupType == 'batter_pitcher';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boundaryKey = ref.watch(cardBoundaryKeyProvider);
    final shareState = ref.watch(shareCardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('因縁カード')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: _buildBody(context, ref, boundaryKey, shareState),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    GlobalKey boundaryKey,
    AsyncValue<void> shareState,
  ) {
    if (isBatterPitcher) {
      return _buildBatterPitcherCard(context, ref, boundaryKey, shareState);
    } else {
      return _buildTeamCard(context, ref, boundaryKey, shareState);
    }
  }

  Widget _buildBatterPitcherCard(
    BuildContext context,
    WidgetRef ref,
    GlobalKey boundaryKey,
    AsyncValue<void> shareState,
  ) {
    final detail = ref.watch(
      batterPitcherDetailProvider((batterId: id1, pitcherId: id2)),
    );

    return detail.when(
      loading: () => const LoadingWidget(message: 'カードを生成中...'),
      error: (error, _) => AppErrorWidget(
        message: 'データの読み込みに失敗しました',
        onRetry: () => ref.invalidate(
          batterPitcherDetailProvider((batterId: id1, pitcherId: id2)),
        ),
      ),
      data: (matchup) => _CardPreviewBody(
        boundaryKey: boundaryKey,
        shareState: shareState,
        onShare: () => ref.read(shareCardProvider.notifier).shareCard(
              batterPitcherMatchup: matchup,
            ),
        card: RivalryCardWidget(batterPitcherMatchup: matchup),
      ),
    );
  }

  Widget _buildTeamCard(
    BuildContext context,
    WidgetRef ref,
    GlobalKey boundaryKey,
    AsyncValue<void> shareState,
  ) {
    final detail = ref.watch(
      teamMatchupDetailProvider((teamAId: id1, teamBId: id2)),
    );

    return detail.when(
      loading: () => const LoadingWidget(message: 'カードを生成中...'),
      error: (error, _) => AppErrorWidget(
        message: 'データの読み込みに失敗しました',
        onRetry: () => ref.invalidate(
          teamMatchupDetailProvider((teamAId: id1, teamBId: id2)),
        ),
      ),
      data: (matchup) => _CardPreviewBody(
        boundaryKey: boundaryKey,
        shareState: shareState,
        onShare: () => ref.read(shareCardProvider.notifier).shareCard(
              teamMatchup: matchup,
            ),
        card: RivalryCardWidget(teamMatchup: matchup),
      ),
    );
  }
}

class _CardPreviewBody extends StatelessWidget {
  const _CardPreviewBody({
    required this.boundaryKey,
    required this.shareState,
    required this.onShare,
    required this.card,
  });

  final GlobalKey boundaryKey;
  final AsyncValue<void> shareState;
  final VoidCallback onShare;
  final RivalryCardWidget card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Card with shadow
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: RepaintBoundary(
                key: boundaryKey,
                child: card,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Share hint
          Text(
            'SNSで因縁カードを共有しよう',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          if (shareState is AsyncError)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'エラー: ${(shareState as AsyncError).error}',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: shareState is AsyncLoading ? null : onShare,
              icon: shareState is AsyncLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.share),
              label: const Text('カードを共有'),
            ),
          ),
        ],
      ),
    );
  }
}
