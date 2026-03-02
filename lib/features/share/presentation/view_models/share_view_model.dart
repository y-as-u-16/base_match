import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../matchups/domain/entities/batter_pitcher_matchup.dart';
import '../../../matchups/domain/entities/team_matchup.dart';

final cardBoundaryKeyProvider = Provider<GlobalKey>((ref) {
  return GlobalKey();
});

final shareCardProvider =
    StateNotifierProvider<ShareCardNotifier, AsyncValue<void>>((ref) {
  return ShareCardNotifier(ref);
});

class ShareCardNotifier extends StateNotifier<AsyncValue<void>> {
  ShareCardNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> shareCard({
    BatterPitcherMatchup? batterPitcherMatchup,
    TeamMatchup? teamMatchup,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final key = _ref.read(cardBoundaryKeyProvider);
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('カード画像の取得に失敗しました');
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('画像の変換に失敗しました');
      }

      final shareText = _buildShareText(
        batterPitcherMatchup: batterPitcherMatchup,
        teamMatchup: teamMatchup,
      );

      final pngBytes = byteData.buffer.asUint8List();
      await Share.shareXFiles(
        [
          XFile.fromData(
            Uint8List.fromList(pngBytes),
            mimeType: 'image/png',
            name: 'rivalry_card.png',
          ),
        ],
        text: shareText,
      );
    });
  }

  String _buildShareText({
    BatterPitcherMatchup? batterPitcherMatchup,
    TeamMatchup? teamMatchup,
  }) {
    if (batterPitcherMatchup != null) {
      final m = batterPitcherMatchup;
      final comment = _batterPitcherComment(m);
      return '${m.batterName} vs ${m.pitcherName} の因縁が更新!\n'
          '打率${m.avg.toStringAsFixed(3)} $comment\n'
          '#base_match #草野球 #因縁カード';
    } else if (teamMatchup != null) {
      final m = teamMatchup;
      final comment = _teamComment(m);
      return '${m.teamAName} vs ${m.teamBName} の因縁が更新!\n'
          '${m.winsA}勝${m.winsB}敗${m.draws}分 $comment\n'
          '#base_match #草野球 #因縁カード';
    }
    return '#base_match #因縁カード';
  }

  String _batterPitcherComment(BatterPitcherMatchup m) {
    if (m.so >= 5 && m.hits == 0) return '完全封鎖';
    if (m.bbHbp >= 5) return '勝負を避けられる男';
    if (m.hr >= 5) return 'ホームランアーティスト';
    if (m.avg >= 0.500 && m.ab >= 10) return '完全支配';
    if (m.avg >= 0.400) return '天敵認定';
    if (m.avg >= 0.350 && m.hr >= 2) return '恐怖の強打者';
    if (m.avg >= 0.300) return '相性抜群';
    if (m.avg >= 0.250) return '五分の勝負';
    if (m.avg >= 0.200) return '苦戦中...';
    if (m.avg >= 0.100) return '難攻不落の壁';
    if (m.avg < 0.100 && m.ab >= 10) return '天敵は向こうだった';
    return '因縁の始まり';
  }

  String _teamComment(TeamMatchup m) {
    final winRate = m.winRateA;
    if (m.draws >= 3) return '決着つかず';
    if (winRate >= 0.800) return 'お得意様';
    if (winRate >= 0.600) return 'やや優勢';
    if (winRate >= 0.400) return '好敵手';
    if (winRate >= 0.200) return '苦手意識';
    if (winRate < 0.200 && m.games >= 3) return '天敵チーム';
    return '因縁の幕開け';
  }
}
