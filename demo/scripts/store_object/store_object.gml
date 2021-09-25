function save_object(_id)
{
	//get names list
	var names_list=variable_instance_get_names(_id)
	
	//set default vars
	var mystruct = 
	{
		layer : _id.layer,
		object_index : _id.object_index,
		x : _id.x,
		y : _id.y,
		image_xscale : _id.image_xscale,
		image_yscale : _id.image_yscale,
		image_blend : _id.image_blend,
		image_alpha : _id.image_alpha,
		sprite_index : _id.sprite_index,
		image_index : _id.image_index
	}
	
	//set other vars
	var size = array_length(names_list)
	var str,val
	for (var i = 0; i <= size; i++)
	{
		str = names_list[i]
		val = variable_instance_get(_id,str)
		
		variable_struct_set(mystruct,str,val)
	}
	
	//return
	return mystruct
}

function load_object(_struct, _layer)
{
	//get names list
	var names_list=variable_struct_get_names(_struct)
	var val,str
	var _id = instance_create_layer(0,0,_layer,_struct.object_index)
	
	//set default vars
	with _id
	{
		x = _struct.x
		y = _struct.y
		image_xscale = _struct.image_xscale
		image_yscale = _struct.image_yscale
		image_blend = _struct.image_blend
		image_alpha = _struct.image_alpha
		sprite_index = _struct.sprite_index
		image_index = _struct.image_index
	}
	
	//set other vars
	var size = array_length(names_list)
	for (var i = 0; i <= size; i++)
	{
		str = names_list[i]
		val = variable_struct_get(_struct,str)
		
		variable_instance_set(_id,str,val)
	}
	
	//return
	return _id
}