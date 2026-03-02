import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../matchups/domain/entities/batter_pitcher_matchup.dart';
import '../../../matchups/domain/entities/team_matchup.dart';

class RivalryCardWidget extends StatelessWidget {
  const RivalryCardWidget({
    super.key,
    this.batterPitcherMatchup,
    this.teamMatchup,
  }) : assert(
          batterPitcherMatchup != null || teamMatchup != null,
          'Either batterPitcherMatchup or teamMatchup must be provided',
        );

  final BatterPitcherMatchup? batterPitcherMatchup;
  final TeamMatchup? teamMatchup;

  bool get isBatterPitcher => batterPitcherMatchup != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      height: 400,
      child: CustomPaint(
        painter: _RivalryCardPainter(
          batterPitcherMatchup: batterPitcherMatchup,
          teamMatchup: teamMatchup,
        ),
      ),
    );
  }
}

class _RivalryCardPainter extends CustomPainter {
  _RivalryCardPainter({
    this.batterPitcherMatchup,
    this.teamMatchup,
  });

  final BatterPitcherMatchup? batterPitcherMatchup;
  final TeamMatchup? teamMatchup;

  bool get isBatterPitcher => batterPitcherMatchup != null;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawFrame(canvas, size);
    _drawDiagonalAccent(canvas, size);
    _drawTitle(canvas, size);
    _drawNames(canvas, size);
    _drawStatBar(canvas, size);
    _drawComment(canvas, size);
    _drawSubComment(canvas, size);
    _drawWatermark(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));
    canvas.clipRRect(rrect);

    // Main gradient
    final List<Color> gradColors = isBatterPitcher
        ? [
            const Color(0xFF0D3B0E),
            const Color(0xFF1B5E20),
            const Color(0xFF2E7D32),
          ]
        : [
            const Color(0xFF0A2647),
            const Color(0xFF0D47A1),
            const Color(0xFF1565C0),
          ];

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: gradColors,
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Subtle radial glow at top
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.6),
        radius: 0.8,
        colors: [
          Colors.white.withValues(alpha: 0.06),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, glowPaint);

    // Diagonal stripe pattern
    final stripePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (var i = -size.height.toInt(); i < size.width.toInt() * 2; i += 28) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble() + size.height, size.height),
        stripePaint,
      );
    }

    // 淡いダイヤモンドパターン
    final diamondPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final cx = size.width / 2;
    final cy = size.height * 0.55;
    final diamondPath = Path()
      ..moveTo(cx, cy - 50)
      ..lineTo(cx + 50, cy)
      ..lineTo(cx, cy + 50)
      ..lineTo(cx - 50, cy)
      ..close();
    canvas.drawPath(diamondPath, diamondPaint);

    // 内側のダイヤモンド
    final innerDiamondPath = Path()
      ..moveTo(cx, cy - 30)
      ..lineTo(cx + 30, cy)
      ..lineTo(cx, cy + 30)
      ..lineTo(cx - 30, cy)
      ..close();
    canvas.drawPath(innerDiamondPath, diamondPaint);
  }

  void _drawFrame(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));

    // Outer border (太く: 3 -> 4)
    final borderPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFFFD54F),
          const Color(0xFFF9A825),
          const Color(0xFFFF8F00),
          const Color(0xFFF9A825),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRRect(rrect, borderPaint);

    // Inner border
    final innerRect = Rect.fromLTWH(8, 8, size.width - 16, size.height - 16);
    final innerRRect =
        RRect.fromRectAndRadius(innerRect, const Radius.circular(14));
    final innerBorderPaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(innerRRect, innerBorderPaint);

    // 外枠と内枠の間の微細な装飾パターン（点線）
    final midRect = Rect.fromLTWH(5, 5, size.width - 10, size.height - 10);
    final midRRect =
        RRect.fromRectAndRadius(midRect, const Radius.circular(16));
    final midPaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRRect(midRRect, midPaint);

    // ホームベース形のコーナー装飾（五角形）
    _drawHomePlateCorner(canvas, 12, 12, false, false);
    _drawHomePlateCorner(canvas, size.width - 12, 12, true, false);
    _drawHomePlateCorner(canvas, 12, size.height - 12, false, true);
    _drawHomePlateCorner(canvas, size.width - 12, size.height - 12, true, true);
  }

  /// ホームベース形の小さな装飾を描画
  void _drawHomePlateCorner(
      Canvas canvas, double cx, double cy, bool flipX, bool flipY) {
    final s = 6.0;
    final dx = flipX ? -1.0 : 1.0;
    final dy = flipY ? -1.0 : 1.0;

    final path = Path()
      ..moveTo(cx, cy)
      ..lineTo(cx + s * dx, cy)
      ..lineTo(cx + s * dx, cy + s * 0.6 * dy)
      ..lineTo(cx + s * 0.5 * dx, cy + s * dy)
      ..lineTo(cx, cy + s * 0.6 * dy)
      ..close();

    final paint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  void _drawDiagonalAccent(Canvas canvas, Size size) {
    // Diagonal red slash behind VS
    final path = Path()
      ..moveTo(size.width * 0.42, 60)
      ..lineTo(size.width * 0.58, 60)
      ..lineTo(size.width * 0.55, 130)
      ..lineTo(size.width * 0.45, 130)
      ..close();

    final accentPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.red.shade800.withValues(alpha: 0.6),
          Colors.red.shade900.withValues(alpha: 0.3),
        ],
      ).createShader(Rect.fromLTWH(0, 60, size.width, 70));
    canvas.drawPath(path, accentPaint);
  }

  void _drawTitle(Canvas canvas, Size size) {
    // Category label
    final categoryLabel =
        isBatterPitcher ? 'BATTER vs PITCHER' : 'TEAM vs TEAM';
    final categoryPainter = TextPainter(
      text: TextSpan(
        text: categoryLabel,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    categoryPainter.paint(
      canvas,
      Offset((size.width - categoryPainter.width) / 2, 20),
    );

    // Main title
    final title = isBatterPitcher ? '宿敵対決' : '因縁の対決';
    final titlePainter = TextPainter(
      text: TextSpan(
        text: title,
        style: const TextStyle(
          color: Color(0xFFFFD54F),
          fontSize: 30,
          fontWeight: FontWeight.w900,
          letterSpacing: 6,
          shadows: [
            Shadow(
              color: Color(0x80000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    titlePainter.paint(
      canvas,
      Offset((size.width - titlePainter.width) / 2, 36),
    );
  }

  void _drawNames(Canvas canvas, Size size) {
    final name1 = isBatterPitcher
        ? batterPitcherMatchup!.batterName
        : teamMatchup!.teamAName;
    final name2 = isBatterPitcher
        ? batterPitcherMatchup!.pitcherName
        : teamMatchup!.teamBName;

    final role1 = isBatterPitcher ? 'BATTER' : '';
    final role2 = isBatterPitcher ? 'PITCHER' : '';

    const nameStyle = TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
      shadows: [
        Shadow(
            color: Color(0x60000000), blurRadius: 4, offset: Offset(0, 2)),
      ],
    );

    final roleStyle = TextStyle(
      color: Colors.white.withValues(alpha: 0.5),
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 2,
    );

    // VS: 28 -> 32 サイズアップ
    final vsStyle = TextStyle(
      color: Colors.red.shade400,
      fontSize: 32,
      fontWeight: FontWeight.w900,
      letterSpacing: 2,
      shadows: const [
        Shadow(
            color: Color(0x80000000), blurRadius: 8, offset: Offset(0, 2)),
      ],
    );

    final centerX = size.width / 2;
    const y = 82.0;

    // VS
    final vsPainter = TextPainter(
      text: TextSpan(text: 'VS', style: vsStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    vsPainter.paint(
      canvas,
      Offset(centerX - vsPainter.width / 2, y + 2),
    );

    // Name 1 (left)
    final name1Painter = TextPainter(
      text: TextSpan(text: name1, style: nameStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '..',
    )..layout(maxWidth: centerX - vsPainter.width / 2 - 40);

    name1Painter.paint(
      canvas,
      Offset(centerX - vsPainter.width / 2 - 20 - name1Painter.width, y),
    );

    // Name 2 (right)
    final name2Painter = TextPainter(
      text: TextSpan(text: name2, style: nameStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '..',
    )..layout(maxWidth: centerX - vsPainter.width / 2 - 40);

    name2Painter.paint(
      canvas,
      Offset(centerX + vsPainter.width / 2 + 20, y),
    );

    // Role labels (for batter/pitcher)
    if (isBatterPitcher) {
      final role1Painter = TextPainter(
        text: TextSpan(text: role1, style: roleStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      role1Painter.paint(
        canvas,
        Offset(
            centerX - vsPainter.width / 2 - 20 - role1Painter.width, y - 14),
      );

      final role2Painter = TextPainter(
        text: TextSpan(text: role2, style: roleStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      role2Painter.paint(
        canvas,
        Offset(centerX + vsPainter.width / 2 + 20, y - 14),
      );
    }
  }

  void _drawStatBar(Canvas canvas, Size size) {
    const labelStyle = TextStyle(
      color: Color(0x99FFFFFF),
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    );
    // 数値サイズアップ: 22 -> 24
    const valueStyle = TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.w800,
    );

    final List<(String label, String value)> stats;
    if (isBatterPitcher) {
      final m = batterPitcherMatchup!;
      stats = [
        ('打率', m.avg.toStringAsFixed(3)),
        ('安打/打数', '${m.hits}/${m.ab}'),
        ('HR', '${m.hr}'),
        ('四死球', '${m.bbHbp}'),
        ('三振', '${m.so}'),
      ];
    } else {
      final m = teamMatchup!;
      stats = [
        ('対戦', '${m.games}試合'),
        ('戦績', '${m.winsA}勝${m.winsB}敗${m.draws}分'),
        ('勝率', m.winRateA.toStringAsFixed(3)),
        ('得点', '${m.runsA}-${m.runsB}'),
      ];
    }

    // Draw separator line with improved decoration
    final lineY = 138.0;
    final linePaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.25)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(24, lineY),
      Offset(size.width - 24, lineY),
      linePaint,
    );

    // ラベルと数値の間の装飾（小さなダイヤモンド）
    final centerX = size.width / 2;
    final decorPaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    final decorPath = Path()
      ..moveTo(centerX, lineY - 3)
      ..lineTo(centerX + 3, lineY)
      ..lineTo(centerX, lineY + 3)
      ..lineTo(centerX - 3, lineY)
      ..close();
    canvas.drawPath(decorPath, decorPaint);

    // Stats
    final startY = 158.0;
    final usableWidth = size.width - 48;
    final colWidth = usableWidth / stats.length;

    for (var i = 0; i < stats.length; i++) {
      final (label, value) = stats[i];
      final x = 24 + colWidth * i + colWidth / 2;

      final labelPainter = TextPainter(
        text: TextSpan(text: label, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      labelPainter.paint(
        canvas,
        Offset(x - labelPainter.width / 2, startY),
      );

      final valuePainter = TextPainter(
        text: TextSpan(text: value, style: valueStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      valuePainter.paint(
        canvas,
        Offset(x - valuePainter.width / 2, startY + 20),
      );

      // Column separator
      if (i < stats.length - 1) {
        final sepX = 24 + colWidth * (i + 1);
        final sepPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.1)
          ..strokeWidth = 1;
        canvas.drawLine(
          Offset(sepX, startY),
          Offset(sepX, startY + 48),
          sepPaint,
        );
      }
    }

    // Bottom separator
    canvas.drawLine(
      Offset(24, startY + 62),
      Offset(size.width - 24, startY + 62),
      linePaint,
    );
    // 下部のダイヤモンド装飾
    final bottomDecorPath = Path()
      ..moveTo(centerX, startY + 62 - 3)
      ..lineTo(centerX + 3, startY + 62)
      ..lineTo(centerX, startY + 62 + 3)
      ..lineTo(centerX - 3, startY + 62)
      ..close();
    canvas.drawPath(bottomDecorPath, decorPaint);
  }

  void _drawComment(Canvas canvas, Size size) {
    final comment = _generateComment();
    final commentIcon = _getCommentIcon();

    // Comment background
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, 272),
        width: math.min(comment.length * 22.0 + 60, size.width - 60),
        height: 40,
      ),
      const Radius.circular(20),
    );
    final bgPaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.15);
    canvas.drawRRect(bgRect, bgPaint);

    // Icon + text
    final iconPainter = TextPainter(
      text: TextSpan(
        text: commentIcon,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final commentPainter = TextPainter(
      text: TextSpan(
        text: comment,
        style: const TextStyle(
          color: Color(0xFFFFD54F),
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
          shadows: [
            Shadow(
              color: Color(0x40000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final totalWidth = iconPainter.width + 6 + commentPainter.width;
    final startX = (size.width - totalWidth) / 2;

    iconPainter.paint(canvas, Offset(startX, 262));
    commentPainter.paint(canvas, Offset(startX + iconPainter.width + 6, 260));
  }

  void _drawSubComment(Canvas canvas, Size size) {
    final subComment = _generateSubComment();

    final subPainter = TextPainter(
      text: TextSpan(
        text: subComment,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    subPainter.paint(
      canvas,
      Offset((size.width - subPainter.width) / 2, 292),
    );
  }

  /// Returns (prefix, main comment) tuple for batter-pitcher matchup.
  (String, String) _generateBatterPitcherComment() {
    final m = batterPitcherMatchup!;

    // Determine prefix based on at-bats
    String prefix = '';
    if (m.ab >= 30) {
      prefix = '宿命のライバル: ';
    } else if (m.ab >= 20) {
      prefix = '因縁深まる: ';
    } else if (m.ab >= 10) {
      prefix = '顔なじみ: ';
    }

    // Special conditions (checked first, override generic avg-based)
    if (m.so >= 5 && m.hits == 0) return (prefix, '完全封鎖');
    if (m.bbHbp >= 5) return (prefix, '勝負を避けられる男');
    if (m.hr >= 5) return (prefix, 'ホームランアーティスト');
    if (m.so >= 10) return (prefix, '三振コレクター');
    if (m.hr >= 1 && m.avg < 0.200) return (prefix, '一発屋');
    if (m.avg >= 0.500 && m.ab >= 10) return (prefix, '完全支配');
    if (m.avg >= 0.400) return (prefix, '天敵認定');
    if (m.avg >= 0.350 && m.hr >= 2) return (prefix, '恐怖の強打者');
    if (m.avg >= 0.300) return (prefix, '相性抜群');
    if (m.avg >= 0.250) return (prefix, '五分の勝負');
    if (m.avg >= 0.200) return (prefix, '苦戦中...');
    if (m.avg >= 0.100) return (prefix, '難攻不落の壁');
    if (m.avg < 0.100 && m.ab >= 10) return (prefix, '天敵は向こうだった');

    return (prefix, '因縁の始まり');
  }

  /// Returns (prefix, main comment) tuple for team matchup.
  (String, String) _generateTeamComment() {
    final m = teamMatchup!;
    final winRate = m.winRateA;

    // Determine prefix based on games played
    String prefix = '';
    if (m.games >= 10) {
      prefix = '長年のライバル: ';
    }

    // Special conditions
    if (m.draws >= 3) return (prefix, '決着つかず');
    if (winRate >= 0.800) return (prefix, 'お得意様');
    if (winRate >= 0.600) return (prefix, 'やや優勢');
    if (winRate >= 0.400) return (prefix, '好敵手');
    if (winRate >= 0.200) return (prefix, '苦手意識');
    if (winRate < 0.200 && m.games >= 3) return (prefix, '天敵チーム');

    return (prefix, '因縁の幕開け');
  }

  String _generateComment() {
    if (isBatterPitcher) {
      final (prefix, comment) = _generateBatterPitcherComment();
      return '$prefix$comment';
    } else {
      final (prefix, comment) = _generateTeamComment();
      return '$prefix$comment';
    }
  }

  /// Sub-comment for batter-pitcher matchup (grassroots baseball banter).
  String _generateBatterPitcherSubComment() {
    final m = batterPitcherMatchup!;

    if (m.so >= 5 && m.hits == 0) return '-- 助っ人コールが必要 --';
    if (m.bbHbp >= 5) return '-- もう敬遠しよう --';
    if (m.hr >= 5) return '-- 打ち上げで自慢できる --';
    if (m.so >= 10) return '-- バットに当てることから始めよう --';
    if (m.hr >= 1 && m.avg < 0.200) return '-- 一振りに賭ける男 --';
    if (m.avg >= 0.500 && m.ab >= 10) return '-- 投げるのが怖い打者 --';
    if (m.avg >= 0.400) return '-- 打ち上げで自慢できる --';
    if (m.avg >= 0.350 && m.hr >= 2) return '-- もう敬遠しよう --';
    if (m.avg >= 0.300) return '-- 飲み会のネタ確定 --';
    if (m.avg >= 0.250) return '-- 次の試合が楽しみだ --';
    if (m.avg >= 0.200) return '-- リベンジ必至 --';
    if (m.avg >= 0.100) return '-- 助っ人コールが必要 --';
    if (m.avg < 0.100 && m.ab >= 10) return '-- 次は絶対打つ --';

    return '-- 因縁はここから始まる --';
  }

  /// Sub-comment for team matchup (grassroots baseball banter).
  String _generateTeamSubComment() {
    final m = teamMatchup!;
    final winRate = m.winRateA;

    if (m.draws >= 3) return '-- 延長戦を希望 --';
    if (winRate >= 0.800) return '-- 飲み会のネタ確定 --';
    if (winRate >= 0.600) return '-- 次の試合が楽しみだ --';
    if (winRate >= 0.400) return '-- 名勝負の予感 --';
    if (winRate >= 0.200) return '-- 助っ人コールが必要 --';
    if (winRate < 0.200 && m.games >= 3) return '-- リベンジ必至 --';

    return '-- 因縁はここから始まる --';
  }

  String _generateSubComment() {
    if (isBatterPitcher) {
      return _generateBatterPitcherSubComment();
    } else {
      return _generateTeamSubComment();
    }
  }

  String _getCommentIcon() {
    if (isBatterPitcher) {
      final m = batterPitcherMatchup!;
      if (m.so >= 5 && m.hits == 0) return '\u{1F6AB}';
      if (m.bbHbp >= 5) return '\u{1F6B6}';
      if (m.hr >= 5) return '\u{1F3C6}';
      if (m.so >= 10) return '\u{1F4A8}';
      if (m.hr >= 1 && m.avg < 0.200) return '\u{1F4A5}';
      if (m.avg >= 0.500 && m.ab >= 10) return '\u{1F451}';
      if (m.avg >= 0.400) return '\u{1F525}';
      if (m.avg >= 0.350 && m.hr >= 2) return '\u{1F4AA}';
      if (m.avg >= 0.300) return '\u{2B50}';
      if (m.avg >= 0.250) return '\u{2694}';
      if (m.avg >= 0.200) return '\u{1F630}';
      if (m.avg >= 0.100) return '\u{1F9F1}';
      if (m.avg < 0.100 && m.ab >= 10) return '\u{1F480}';
      return '\u{26BE}';
    } else {
      final m = teamMatchup!;
      final winRate = m.winRateA;
      if (m.draws >= 3) return '\u{1F91D}';
      if (winRate >= 0.800) return '\u{1F451}';
      if (winRate >= 0.600) return '\u{2B50}';
      if (winRate >= 0.400) return '\u{1F525}';
      if (winRate >= 0.200) return '\u{1F630}';
      if (winRate < 0.200 && m.games >= 3) return '\u{1F480}';
      return '\u{26BE}';
    }
  }

  void _drawWatermark(Canvas canvas, Size size) {
    // 縫い目パターン強化 (alpha: 0.04 -> 0.08)
    final stitchPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 右下の縫い目カーブ
    final stitchPath1 = Path();
    for (var i = 0; i < 10; i++) {
      final x = size.width - 90 + math.cos(i * 0.7) * 25;
      final y = size.height - 65 + math.sin(i * 0.7) * 25;
      if (i == 0) {
        stitchPath1.moveTo(x, y);
      } else {
        stitchPath1.lineTo(x, y);
      }
    }
    canvas.drawPath(stitchPath1, stitchPaint);

    // 左上の縫い目カーブ（対称的）
    final stitchPath2 = Path();
    for (var i = 0; i < 10; i++) {
      final x = 90.0 - math.cos(i * 0.7) * 25;
      final y = 65.0 - math.sin(i * 0.7) * 25;
      if (i == 0) {
        stitchPath2.moveTo(x, y);
      } else {
        stitchPath2.lineTo(x, y);
      }
    }
    canvas.drawPath(stitchPath2, stitchPaint);

    // 縫い目のステッチ（短い横線）
    final stitchDetailPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (var i = 0; i < 8; i++) {
      final x = size.width - 90 + math.cos(i * 0.7) * 25;
      final y = size.height - 65 + math.sin(i * 0.7) * 25;
      final angle = math.atan2(
        math.cos((i + 1) * 0.7) * 25 - math.cos(i * 0.7) * 25,
        math.sin((i + 1) * 0.7) * 25 - math.sin(i * 0.7) * 25,
      );
      canvas.drawLine(
        Offset(x + math.cos(angle + math.pi / 2) * 4,
            y + math.sin(angle + math.pi / 2) * 4),
        Offset(x - math.cos(angle + math.pi / 2) * 4,
            y - math.sin(angle + math.pi / 2) * 4),
        stitchDetailPaint,
      );
    }

    // App name watermark
    final watermarkPainter = TextPainter(
      text: TextSpan(
        text: 'base_match',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.25),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    watermarkPainter.paint(
      canvas,
      Offset(
        size.width - watermarkPainter.width - 20,
        size.height - watermarkPainter.height - 18,
      ),
    );

    // ホームベース形コーナーアクセント（五角形）
    _drawHomePlateAccent(canvas, 14, 20, 1, 1);
    _drawHomePlateAccent(canvas, size.width - 14, 20, -1, 1);
    _drawHomePlateAccent(canvas, 14, size.height - 20, 1, -1);
    _drawHomePlateAccent(canvas, size.width - 14, size.height - 20, -1, -1);

    // Date stamp
    final now = DateTime.now();
    final dateStr =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
    final datePainter = TextPainter(
      text: TextSpan(
        text: dateStr,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.2),
          fontSize: 10,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    datePainter.paint(
      canvas,
      Offset(20, size.height - datePainter.height - 18),
    );
  }

  /// ウォーターマーク用のホームベース形アクセント
  void _drawHomePlateAccent(
      Canvas canvas, double cx, double cy, double dx, double dy) {
    final s = 8.0;
    final path = Path()
      ..moveTo(cx, cy)
      ..lineTo(cx + s * dx, cy)
      ..lineTo(cx + s * dx, cy + s * 0.7 * dy)
      ..lineTo(cx + s * 0.5 * dx, cy + s * dy)
      ..lineTo(cx, cy + s * 0.7 * dy)
      ..close();

    final paint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RivalryCardPainter oldDelegate) =>
      batterPitcherMatchup != oldDelegate.batterPitcherMatchup ||
      teamMatchup != oldDelegate.teamMatchup;
}
