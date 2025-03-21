# Документация по системе мини-игр

## Обзор системы

Система мини-игр состоит из трех основных компонентов:

1. **MiniGameManager** - глобальный менеджер для запуска и закрытия мини-игр
2. **SimpleInteractable** - интерактивный объект для запуска мини-игры
3. **SimpleGameController** - контроллер для управления состоянием игрока

## Подробное объяснение работы MiniGameManager

MiniGameManager **не является** машиной состояний в классическом понимании. Это менеджер, который отвечает за:

1. **Хранение информации о мини-играх** - содержит словарь `minigames` с путями к сценам мини-игр
2. **Запуск мини-игр** - загружает и отображает мини-игру поверх основной игры
3. **Обработку сигналов от мини-игр** - получает сигналы о завершении или отмене мини-игры
4. **Уведомление других компонентов** - отправляет сигналы о запуске, завершении или отмене мини-игры

### Принцип работы

1. **Запуск мини-игры** (функция `start_minigame`):
   - Проверяет, не активна ли уже другая мини-игра
   - Загружает сцену мини-игры из словаря `minigames`
   - Создает новый CanvasLayer для отображения мини-игры поверх основной игры
   - Подключает сигналы от мини-игры (`game_completed` и `game_cancelled`)
   - Устанавливает флаг `minigame_active` в true
   - Отправляет сигнал `minigame_started_signal`

2. **Закрытие мини-игры** (функция `close_minigame`):
   - Удаляет экземпляр мини-игры и CanvasLayer
   - Сбрасывает все переменные, связанные с текущей мини-игрой
   - Устанавливает флаг `minigame_active` в false

3. **Обработка сигналов от мини-игры**:
   - Функция `_on_minigame_completed` вызывается, когда мини-игра успешно завершена
   - Функция `_on_minigame_cancelled` вызывается, когда мини-игра отменена
   - Обе функции отправляют соответствующие сигналы и закрывают мини-игру

4. **Проверка активности мини-игры** (функция `is_minigame_active`):
   - Возвращает значение флага `minigame_active`
   - Используется для предотвращения запуска нескольких мини-игр одновременно

### Отличие от машины состояний

В отличие от машины состояний:

1. MiniGameManager не хранит набор предопределенных состояний
2. Не имеет логики перехода между состояниями
3. Не содержит функций для обработки каждого состояния
4. Не отслеживает текущее состояние системы (кроме флага активности)

MiniGameManager - это скорее **сервис** или **фасад**, который предоставляет интерфейс для работы с мини-играми, а не машина состояний.

### Как работает система

1. Игрок подходит к интерактивному объекту
2. При нажатии клавиши E, объект вызывает метод `start_minigame()` у MiniGameManager
3. MiniGameManager загружает сцену мини-игры и отображает её
4. MiniGameManager отправляет сигнал `minigame_started_signal`
5. SimpleGameController получает этот сигнал и отключает управление игроком
6. Когда мини-игра завершается, она отправляет сигнал `game_completed` или `game_cancelled`
7. MiniGameManager получает эти сигналы, закрывает мини-игру и отправляет соответствующие сигналы
8. SimpleGameController получает эти сигналы и включает управление игроком

### Предотвращение множественного запуска мини-игр

1. MiniGameManager содержит флаг `minigame_active`, который устанавливается при запуске мини-игры
2. Перед запуском новой мини-игры проверяется этот флаг
3. SimpleInteractable также проверяет активность мини-игры перед вызовом `start_minigame()`

## Как добавить новую мини-игру

### 1. Создание сцены мини-игры

1. Создайте новую сцену с корневым узлом (Control, Node2D, CanvasLayer или Node)
2. Добавьте необходимые элементы интерфейса или игровые объекты
3. Добавьте скрипт к корневому узлу со следующей структурой:

```gdscript
extends Control  # Или другой тип узла

signal game_completed  # Сигнал успешного завершения
signal game_cancelled  # Сигнал отмены/неудачи

func _ready():
    # Инициализация мини-игры
    pass

# Ваша логика мини-игры

# Когда мини-игра успешно завершена:
func success_handler():
    emit_signal("game_completed")

# Когда мини-игра отменена или проиграна:
func fail_handler():
    emit_signal("game_cancelled")
```

4. Сохраните сцену в папке `scenes/mini-games/`

### 2. Регистрация мини-игры в MiniGameManager

1. Откройте скрипт `global/MiniGameManager.gd`
2. Добавьте путь к вашей мини-игре в словарь `minigames`:

```gdscript
var minigames = {
    "test_game": "res://scenes/mini-games/test-game.tscn",
    "my_new_game": "res://scenes/mini-games/my_new_game.tscn"  # Добавьте эту строку
}
```

### 3. Создание интерактивного объекта для новой мини-игры

1. Создайте новый экземпляр сцены `scenes/activates/simple_interactable.tscn`
2. Установите свойство `minigame_name` в имя вашей мини-игры
3. Установите свойство `prompt_text` с подходящим текстом подсказки
4. Разместите этот объект на игровой сцене 