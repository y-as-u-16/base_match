import '../core/constants/app_constants.dart';
import 'generated/app_localizations.dart';

extension AppLocalizationsHelpers on AppLocalizations {
  String resultTypeLabel(String type) {
    return switch (type) {
      AppConstants.resultHit => resultHit,
      AppConstants.resultOut => resultOut,
      AppConstants.resultWalk => resultWalk,
      AppConstants.resultError => resultError,
      _ => type,
    };
  }

  String resultDetailLabel(String detail) {
    return switch (detail) {
      AppConstants.detailSingle => detailSingle,
      AppConstants.detailDouble => detailDouble,
      AppConstants.detailTriple => detailTriple,
      AppConstants.detailHr => detailHomeRun,
      AppConstants.detailK => detailStrikeout,
      AppConstants.detailGround => detailGround,
      AppConstants.detailFly => detailFly,
      AppConstants.detailLine => detailLine,
      AppConstants.detailDp => detailDoublePlay,
      AppConstants.detailSacBunt => detailSacBunt,
      AppConstants.detailSacFly => detailSacFly,
      AppConstants.detailOther => detailOther,
      AppConstants.detailBb => detailWalk,
      AppConstants.detailHbp => detailHitByPitch,
      AppConstants.detailE => detailError,
      _ => detail,
    };
  }

  String inningsFromOuts(int outs) {
    final innings = outs ~/ 3;
    final rest = outs % 3;
    return rest == 0
        ? inningsOnlyLabel(innings)
        : inningsWithRestLabel(innings, rest);
  }
}
