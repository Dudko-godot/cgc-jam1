extends TileMapLayer

@onready var obstacles: TileMapLayer = $"../Obstacles"

func _use_tile_data_runtime_update(coords):
	# Этот метод Godot может вызывать при обновлении данных тайла (runtime).
	# Возвращаем true, если на координатах есть "дерево" (или нужный тайл).
	if coords in obstacles.get_used_cells_by_id(0):
		return true
	return false

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData):
	# Если на этих координатах есть дерево, убираем навигационный полигон,
	# чтобы по этому тайлу нельзя было ходить (он становится непроходимым).
	if coords in obstacles.get_used_cells_by_id(0):
		tile_data.set_navigation_polygon(0, null)
