//this code is not commented well, but there's nothing I'm gonna do about it
function place_area_data(area, _x, _y)
{
	var list = variable_struct_get(area,"layerlist")
	var size = array_length(list)
	var currentlayer, mylayer
	
	for (var i = 0; i < size; i++)
	{
		currentlayer = list[i]
		mylayer = layer_create(-1)
		switch currentlayer.metadata.layer_type
		{
			case LAYER_TYPES.INSTANCE:
				
				var instance_list = currentlayer.instance_list
				var array_size = array_length(instance_list)
				var struct
				
				for (var i = 0; i < array_size; i++)
				{
					struct = instance_list[i]
					load_object(struct, mylayer)
				}
				
				break
			case LAYER_TYPES.TILE:
				//create the tilemap
				var tilemap = layer_tilemap_create(mylayer, _x, _y, currentlayer.metadata.tileset, currentlayer.metadata.tilemap_width, currentlayer.metadata.tilemap_height)
				
				//set the tiles
				var width = currentlayer.metadata.tilemap_width
				var height = currentlayer.metadata.tilemap_height
				var grid = currentlayer.grid
				
				var column = 0
				var row = 0
				var xx, yy, tile
				
				while row < height
				{
					if column > width
					{
						column = 0
						row ++
					}
					
					xx = _x + (column * CELL_WIDTH)
					yy = _y + (row * CELL_HEIGHT)
					tile = ds_grid_get(grid, column, row)
					tilemap_set_at_pixel(tilemap, tile, xx, yy)
					
					column ++
				}
				
				break
			case LAYER_TYPES.ASSET:
				break
		}
	}
}

function load_area_data(name)
{
	var fname = AREA_FILE_DIRECTORY + name + ".json"
	var buff = buffer_load(fname)
	var str = buffer_read(buff, buffer_string)
	var struct = json_parse(str)
	
	return struct
}