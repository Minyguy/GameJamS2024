extends TileMap
const TYPE = "Ground"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_terrain_set_at_global(_position):
	var map_coords = self.local_to_map(self.to_local(_position))
	var tile = get_cell_tile_data(0, map_coords)
	
	if self.get_cell_tile_data(0, self.local_to_map(self.to_local(_position))) != null:
		return self.get_cell_tile_data(0, self.local_to_map(self.to_local(_position))).get_terrain_set()
	return -1
