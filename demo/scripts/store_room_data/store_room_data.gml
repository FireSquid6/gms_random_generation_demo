function store_room_data(_room)
{
	room_goto(_room)
	var roomdata,meta,tiles,tilemap,objs_list,othercorner,doors_list,buff,str,filename,index
	
	index=0
	othercorner=noone
	
	//for every left corner, create a thing
	with obj_tl_corner
	{
		//get the other corner
		with obj_br_corner
		{
			if channel=other.channel
			{
				othercorner=id
				break
			}
		}
		
		//save the metadata
		meta = 
		{
			width : point_distance(x,0,othercorner.x,0)
			length : point_distance(0,y,0,othercorner.y)
			size : size
			type : type
		}
		
		//save the door positions
		
		//save the object positions
		
		//save the tilemap
		
		//package the structs
		roomdata = 
		{
			metadata : meta
			tilegrid : tiles
			objs : objs_list
			doors : doors_lists
		}
		
		//save the structs
		str = json_stringify(roomdata)
		buff = buffer_create(1,buffer_grow,1)
		buffer_write(buff,buffer_string,str)
		
		filename = "ROOM_DATA_"+string(index)+".json"
		buffer_save(buff,filename)
		
		//reset
		othercorner=noone
		index++
	}
}