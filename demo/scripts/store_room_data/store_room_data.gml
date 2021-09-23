enum LAYER_TYPES
{
	INSTANCE,
	TILE,
	ASSET
}

function get_area_data(_room)
{
	room_goto(_room)
	var meta,areadata,list = [],layername,layertype,layerdata,layerstring
	
	var layers = layer_get_all()
	
	//for every area marker create a struct
	with obj_area_marker
	{	
		//save the metadata
		meta = 
		{
			area_width : point_distance(bbox_left,bbox_top,bbox_right,bbox_top),
			area_height : point_distance(bbox_left,bbox_top,bbox_left,bbox_bottom),
			areaname : areaname
		}
		
		areadata = 
		{
			metadata : meta
			layerlist : []
		}
		
		//save all the layers
		var size = array_length(layers)
		var layer_is_saved = true
		for (var i = 0; i < size; i++)
		{
			//get the layer type
			layername = layer_get_name(layers[i])
			layerstring = string_char_at(layername, 0) + string_char_at(layername, 1) + string_char_at(layername, 2)
			
			layerdata = 
			{
				metadata : 
				{
					layer_name : layername
				}
			}
			
			//do stuff based on each layer
			switch layerstring
			{
				case "lay":
					//metadata & setup
					layertype = LAYER_TYPES.INSTANCE
					layerdata.metadata.layer_type = layertype
					layerdata.instance_list = []
					
					//save each object in instance list
					//why isn't there a built in function to get all instances in a layer
					//this is stupid
					var layid = layer_get_id(layername)
					var mydepth = layer_get_depth(layid)
					with all
					{
						//check if in the layer and in bounds
						if depth == mydepth && place_meeting(x, y, other)
						{
							//save the object to the list
							array_push(layerdata.instance_list, save_object(id))
						}
					}
					
					break
				case "tls":
					//setup metadata
					layertype = LAYER_TYPES.TILE
					layerdata.metadata.layer_type = layertype
					layerdata.metadata.tilemap_id = layer_tilemap_get_id(layername)
					layerdata.metadata.tileset = tilemap_get_tileset(layerdata.metadata.tilemap_id)
					
					//iterate through a grid
					var grid = ds_grid_create(width, height)
					
					var column = 0
					var row = 0
					var tile, xx, yy
					
					while row < height
					{
						if column > width
						{
							column = 0
							row ++
						}
						
						xx = column * CELL_WIDTH
						yy = row * CELL_HEIGHT
						tile = tilemap_get_at_pixel(layerdata.metadata.tilemap_id, xx, yy)
						
						column ++
					}
					
					//add grid to layerdata
					layerdata.grid = grid
					break
				case "ass":
					//I'm not making asset layer saving yet
					layertype = LAYER_TYPES.ASSET
					layerdata.metadata.layer_type = layertype
					
					break
				default:
					layer_is_saved = false
					break
			}
			
			//add struct to areadata
			if array_is_saved array_push(areadata.layerlist, layerdata)
		}
		
		//add the area data to the area list
		array_push(list,areadata)
	}
	
	//return the completed list of areas
	return list
}

function place_area_data(area, _x, _y)
{
	var list = area.layerlist
	var size = array_length(list)
	var currentlayer
	
	for (var i = 0; i < size; i++)
	{
		currentlayer = list[i]
		switch currentlayer.metadata.layer_type
		{
			case LAYER_TYPES.INSTANCE:
				
				break
			case LAYER_TYPES.TILE:
				
				break
			case LAYER_TYPES.ASSET:
				break
		}
	}
}

#macro AREA_FILE_DIRECTORY "areas/"

function save_area_data(area_data_list)
{
	var data, name, str, buff
	for (var i = 0; i < array_length(area_data_list); i++)
	{
		data = area_data_list[i]
		name = data.metadata.areaname
		name = AREA_FILE_DIRECTORY + name + ".json"
		
		str = json_stringify(str)
		buff = buffer_create(1, buffer_grow, 1)
		buffer_write(buff, buffer_string, str)
		
		buffer_save(buff, name)
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