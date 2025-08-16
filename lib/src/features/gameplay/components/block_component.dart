// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:menara_balok/src/features/gameplay/game/menara_balok_game.dart';

enum BlockMovement {
  left,
  right,
}

class BlockComponent extends RectangleComponent
    with HasGameRef<MenaraBalokGame>, CollisionCallbacks {
  final bool isPerfect;
  BlockComponent(
    Vector2 position,
    Vector2 size, {
    this.isPerfect = false,
  }) : super(
          position: position,
          size: size,
        );

  @override
  Future<void>? onLoad() {
    paint = Paint()..color = isPerfect ? Colors.redAccent : Colors.blueAccent;
    add(RectangleHitbox());
    return super.onLoad();
  }
}
