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
			metadata : meta,
			layerlist : []
		}
		
		//save all the layers
		var size = array_length(layers)
		var layer_is_saved = true
		for (var i = 0; i < size; i++)
		{
			//get the layer type
			layername = layer_get_name(layers[i])
			layerstring = string_char_at(layername, 1) + string_char_at(layername, 2) + string_char_at(layername, 3)
			
			if layername != "lay_meta"
			{
				layerdata = 
				{
					metadata : 
					{
						
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
							if depth == mydepth && place_meeting(x, y, other) && self.id != other.id
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
						layerdata.metadata.tilemap_width = (bbox_right - bbox_left) div CELL_WIDTH
						layerdata.metadata.tilemap_height = (bbox_bottom - bbox_top) div CELL_HEIGHT
					
						//iterate through a grid
						var width = layerdata.metadata.tilemap_width
						var height = layerdata.metadata.tilemap_height
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
						
							xx = bbox_left + (column * CELL_WIDTH)
							yy = bbox_top + (row * CELL_HEIGHT)
							tile = tilemap_get_at_pixel(layerdata.metadata.tilemap_id, xx, yy)
							
							ds_grid_add(grid, column, row, tile)
						
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
				if layer_is_saved array_push(areadata.layerlist, layerdata)
			}
		}
		
		//add the area data to the area list
		array_push(list,areadata)
	}
	
	//return the completed list of areas
	return list
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
		
		str = json_stringify(data)
		buff = buffer_create(1, buffer_grow, 1)
		buffer_write(buff, buffer_string, str)
		
		buffer_save(buff, name)
	}
}