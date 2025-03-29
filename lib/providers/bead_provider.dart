import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/get_puzzle_type.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/request/user_request.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BeadProvider with ChangeNotifier {
  late Box _beadBox;

  Set<String> _beadIds = {};
  Map<String, int> _colorCount = {};
  List<Color> _beadColor = [Colors.white, Colors.white];
  bool _isLoading = false;

  List<Color> get beadColor => _beadColor;
  bool get isLoading => _isLoading;

  void updateLoading({required bool setLoading}) {
    _isLoading = setLoading;
    notifyListeners();
  }

  Future<void> initialize() async {
    await _loadStoredData();

    while (true) {
      final currentSession = Supabase.instance.client.auth.currentSession;
      if (currentSession == null) await Utils.waitForSession();

      try {
        final responseData = await apiRequest('/api/bead/user', ApiType.get);
        if (responseData['code'] == 200) {
          final puzzleList =
              List<Map<String, dynamic>>.from(responseData['result']);
          await _updateBeadIds(puzzleList);
          await _updateBeadColors(puzzleList);
        }
        break;
      } catch (error) {
        if (error.toString().contains('Invalid or expired JWT')) {
          await Utils.waitForSession();
        } else {
          throw Exception('Error initializing bead: $error');
        }
      }
    }
  }

  Future<void> _loadStoredData() async {
    _beadBox = await Hive.openBox('beadBox');

    _beadIds = _beadBox.get('beadIds', defaultValue: <String>{});
    _beadColor =
        List<Color>.from(_beadBox.get('beadColor', defaultValue: <Color>[]));
    if (_beadColor.isEmpty) {
      _beadColor = [Colors.white, Colors.white];
    }
    _colorCount = Map<String, int>.from(
      _beadBox.get('colorCount', defaultValue: <String, int>{}),
    );
    notifyListeners();
  }

  Future<void> _updateBeadIds(List<Map<String, dynamic>> puzzleList) async {
    final validIds = puzzleList.map((p) => p['id'] as String).toSet();
    final bool hasChanges =
        !(_beadIds.containsAll(validIds) && validIds.containsAll(_beadIds));

    if (hasChanges) {
      _beadIds = validIds;
      notifyListeners();
      await _beadBox.put('beadIds', _beadIds);
    }
  }

  Future<void> _updateBeadColors(List<Map<String, dynamic>> puzzleList) async {
    if (puzzleList.isEmpty) {
      _setBeadColor([Colors.white, Colors.white]);
      return;
    }
    final Map<String, int> colorCount = {};

    for (var element in puzzleList) {
      final color = element['color'] as String?;
      if (color != null && color.isNotEmpty) {
        colorCount[color] = (colorCount[color] ?? 0) + 1;
      }
    }

    if (!mapEquals(_colorCount, colorCount)) {
      _colorCount = Map.from(colorCount);
      notifyListeners();
      await _beadBox.put('colorCount', _colorCount);
    }
    final List<Color> colors = _getTopColors();
    _setBeadColor(colors);
  }

  List<Color> _getTopColors() {
    String? topColor1, topColor2, topColor3;
    int count1 = 0, count2 = 0, count3 = 0;
    final List<String> colors = [];

    Color colorMatch(String str) => ColorUtils.colorMatch(stringColor: str);

    for (var entry in _colorCount.entries) {
      final color = entry.key;
      final count = entry.value;

      if (count > count1) {
        count3 = count2;
        topColor3 = topColor2;
        count2 = count1;
        topColor2 = topColor1;
        count1 = count;
        topColor1 = color;
      } else if (count > count2) {
        count3 = count2;
        topColor3 = topColor2;
        count2 = count;
        topColor2 = color;
      } else if (count > count3) {
        count3 = count;
        topColor3 = color;
      }
    }

    if (topColor1 != null) colors.add(topColor1);
    if (topColor2 != null) colors.add(topColor2);
    if (topColor3 != null) colors.add(topColor3);

    switch (colors.length) {
      case 0:
        return [Colors.white, Colors.white];
      case 1:
        final Color color = colorMatch(colors[0]);
        return [color, color];
      case 2:
        return colors.map(colorMatch).toList();
      default:
        return [
          colorMatch(colors[1]),
          colorMatch(colors[0]),
          colorMatch(colors[2]),
        ];
    }
  }

  void _setBeadColor(List<Color> colors) async {
    if (_beadColor != colors) {
      _beadColor = colors;
      notifyListeners();
      await _beadBox.put('beadColor', _beadColor);
    }
  }

  void addPuzzleToBead(
    Map<String, dynamic> puzzleData,
    PuzzleType puzzleType,
  ) async {
    final String puzzleId = puzzleData['id'];

    if (_beadIds.add(puzzleId)) {
      notifyListeners();

      final String puzzleColor = ColorUtils.colorToString(puzzleData['color']);
      updateColorForBead(puzzleColor);

      await _beadBox.put('beadIds', _beadIds);

      final String userId = await UserRequest.getUserId();
      final Map<String, String> bodies = {
        'id': puzzleId,
        'user_id': userId,
        'title': puzzleData['title'],
        'color': puzzleColor,
        'author_id': puzzleType == PuzzleType.personal
            ? puzzleData['sender_id']
            : puzzleData['author_id'],
        'post_type': GetPuzzleType.typeToString(puzzleType),
      };
      final Map<String, String> headers = {'Content-Type': 'application/json'};

      await apiRequest(
        '/api/bead/user',
        ApiType.post,
        headers: headers,
        bodies: bodies,
      );
    }
  }

  void updateColorForBead(String addedColor, {bool isAdding = true}) async {
    _colorCount[addedColor] =
        (_colorCount[addedColor] ?? 0) + (isAdding ? 1 : -1);
    notifyListeners();

    await _beadBox.put('colorCount', _colorCount);
    final List<Color> colors = _getTopColors();
    _setBeadColor(colors);
  }

  void removePuzzleFromBead(String puzzleId) async {
    _beadIds.remove(puzzleId);
    notifyListeners();
    await _beadBox.put('beadIds', _beadIds);
  }

  bool isExist(String puzzleId) => _beadIds.contains(puzzleId);
}
