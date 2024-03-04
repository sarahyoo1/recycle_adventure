import 'dart:math';

import 'package:flame/components.dart';
import 'package:recycle_adventure/components/item.dart';

class ItemSpawnManager extends Component {
  late Timer _timer;
  late Vector2 position;
  late Vector2 size;
  ItemSpawnManager({
    required this.position,
    required this.size,
  }) : super() {
    _timer = Timer(1, onTick: _spawnItems, repeat: true);
  }

  final List<String> itemsList = [
    'Heart',
    'glass-green soda bottle',
    'glass-jar',
    'metal-red soda can',
    'metal-tuna can',
    'other-mug',
    'other-pizza box',
    'other-polystyrene foam cup',
    'paper-cardboard box',
    'paper-newspaper',
    'Plastic Bag',
    'Plastic Bottle',
    'plastic-laundry soap bottle',
    'plastic-milk jug',
    'plastic-water bottle',
  ];

  late String itemName;
  late Item? item;
  late List<Item> itemsContainer = [];

  @override
  void onMount() {
    super.onMount();
    _chooseRandomItem();
    _timer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
    _moveItems(dt);
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  void _spawnItems() {
    _chooseRandomItem();
    itemsContainer.add(item!);
    add(item!);
  }

  void _moveItems(dt) {
    for (Item item in itemsContainer) {
      if (item.item == 'Heart') {
        //heart item movement
        if (item.position.x < 300) {
          item.position.x += 80 * dt;
          item.position.y = 176;
        } else {
          if (item.position.y < 272) {
            item.position.x = 300;
            item.position.y += 150 * dt;
          } else {
            item.position.y = 272;
          }
        }
      } else {
        //other items movements
        if (item.position.x < 592) {
          item.position.x += 80 * dt;
          item.position.y = 176;
        } else {
          item.position.x = 592;
          item.position.y += 200 * dt;
        }
      }
    }
  }

  void _chooseRandomItem() {
    int rd = Random().nextInt(itemsList.length);
    itemName = itemsList[rd];

    item = Item(
      item: itemName,
      size: size,
    );
  }
}
