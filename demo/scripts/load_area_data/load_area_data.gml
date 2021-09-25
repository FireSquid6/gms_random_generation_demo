function place_area_data(area, _x, _y)
{
	var list = area.layerlist
	var size = array_length(list)
	var currentlayer, mylayer
	
	for (var i = 0; i < size; i++)
	{
		currentlayer = list[i]
		switch currentlayer.metadata.layer_type
		{
			case LAYER_TYPES.INSTANCE:
				
				break
			case LAYER_TYPES.TILE:
				//create the tile layer
				mylayer = layer_create(-i)
				mylayer = layer_tile_create()
				
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
	var struct = json_decode(str)
	
	return struct
}