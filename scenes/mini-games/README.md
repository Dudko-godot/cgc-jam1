# Руководство по созданию мини-игр

## Правильная настройка сцен мини-игр для центрирования

Для корректного отображения мини-игр в центре экрана, необходимо правильно настроить корневой узел сцены. Вот основные принципы:

### 1. Настройка корневого узла Control

Корневой узел мини-игры должен быть настроен следующим образом:

- **Тип узла**: Control
- **Layout Mode**: 3 (anchors & margins)
- **Anchors Preset**: 8 (центр)
  - anchor_left = 0.5
  - anchor_top = 0.5
  - anchor_right = 0.5
  - anchor_bottom = 0.5
- **Размер через отступы (offsets)**:
  - offset_left = -[половина ширины]
  - offset_top = -[половина высоты]
  - offset_right = [половина ширины]
  - offset_bottom = [половина высоты]
- **Grow Direction**:
  - grow_horizontal = 2
  - grow_vertical = 2

### 2. Примеры настройки для разных мини-игр

#### Тестовая мини-игра (4 кнопки)
```
[node name="Test-game" type="Control"]
layout_mode = 3
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
grow_horizontal = 2
grow_vertical = 2
```

Контейнер с кнопками также центрирован:
```
[node name="ButtonsContainer" type="GridContainer" parent="."]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -202.0
offset_top = -202.0
offset_right = 202.0
offset_bottom = 202.0
grow_horizontal = 2
grow_vertical = 2
```

#### Мини-игра "Мытье посуды"
```
[node name="Sink" type="Control"]
layout_mode = 3
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -400.0
offset_top = -300.0
offset_right = 400.0
offset_bottom = 300.0
grow_horizontal = 2
grow_vertical = 2
```

#### Мини-игра "Домашнее задание"
```
[node name="Homework" type="Control"]
layout_mode = 3
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -500.0
offset_top = -300.0
offset_right = 500.0
offset_bottom = 300.0
grow_horizontal = 2
grow_vertical = 2
```

### 3. Преимущества этого подхода

1. **Простота**: Мини-игры автоматически центрируются без дополнительного кода в менеджере.
2. **Предсказуемость**: Поведение одинаково для всех мини-игр.
3. **Тестируемость**: Мини-игры можно тестировать отдельно, и они будут выглядеть так же, как при запуске через менеджер.
4. **Масштабируемость**: Легко добавлять новые мини-игры, следуя тем же принципам.

### 4. Внутренние элементы мини-игры

Внутренние элементы мини-игры могут использовать любые настройки anchors и margins относительно корневого узла. Это позволяет гибко настраивать расположение элементов внутри мини-игры.

### 5. Добавление новой мини-игры

1. Создайте новую сцену с корневым узлом Control.
2. Настройте корневой узел согласно указанным выше принципам.
3. Добавьте внутренние элементы мини-игры.
4. Создайте скрипт с сигналами `game_completed` и `game_cancelled`.
5. Добавьте путь к сцене в словарь `minigames` в `MiniGameManager.gd`. 