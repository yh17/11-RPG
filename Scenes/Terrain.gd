extends Spatial

var Tile = preload("res://Scenes/Tile0.tscn")
var tile_size = 2
var ground_size = 30
var map = []
var count = 0
var initial_value = {}

func initialize_map(width,height,value):
	var to_return = []
	for y in range(height):
		to_return.append([])
		to_return[y].resize(width)
		for x in range(width):
			to_return[y][x] = value
	return to_return

func create_tile(u,v,width,height,count):
	var t = Tile.instance()
	var x = (u - int(ceil(width/2)))*tile_size
	var z = (v - int(ceil(height/2)))*tile_size
	t.translate_object_local(Vector3(x,0,z))
	t.name = "Tile_" + str(count)
	return t

func append_row(map):
	return map

func prepend_row(map,value):
	map.push_front([])
	map[0].resize(map[1].size())
	for v in range (map[0].size()):
		map[0][v] = value
	return map
	
func append_column(map):
	return map

func prepend_column(map,value):
	for u in range(map.size()):
		map[u].push_front(value)
	return map


func _ready():
	var width = int(ceil(ground_size / tile_size))
	var height = int(ceil(ground_size / tile_size))
	map = initialize_map(width,height,initial_value)
	for v in range(map.size()):
		for u in range(map[v].size()):
			var t = create_tile(u,v,map[v].size(),map.size(),count)
			count += 1
			map[v][u]["name"]= t.name
			add_child(t)

func _physics_process(delta):
	var t = get_node(map[0][0]["name"])
	var t_x = t.get_global_transform().origin.x
	var t_z = t.get_global_transform().origin.z
	if t_x < 0:
		map = prepend_column(map,initial_value)
		for u in range(map.size()):
			var t1 = create_tile(u,0,0,map.size(),count)
			create_tile(u,0,0,map.size(),count)
			count += 1
			map[0][u]["name"] = t1.name
			add_child(t1)
	if t_z < 0:
		map = prepend_row(map, initial_value)
		for v in range(map[0].size()):
			var t1 = create_tile(0,v,map[0].size(),0,count)
			count += 1 
			map[v][0]["name"] = t1.name
			add_child(t1)
