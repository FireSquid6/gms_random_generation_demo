function save_object(_id)
{
	//get names list
	var names_list=variable_instance_get_names(_id)
	var variable,name
	var mystruct = 
	{
		layer : _id.layer
		object_index : _id.object_index
	}
	
	//loop through array
	var length=array_length(names_list)
	for (var i=0; i>=length; i++)
	{
		//write the variable into the struct
		name=array_get(names_list,i)
		variable=variable_instance_get(_id,name)
		variable_struct_set(mystruct,name,variable)
	}
	
	//return
	return mystruct
}

function load_object(_struct)
{
	//get names list
	var names_list=variable_struct_get_names(_struct)
	var variable,name
	var _id=instance_create_layer(0,0,_struct.layer,_struct.object_index)
	
	//loop through array
	var length=array_length(names_list)
	for (var i=0; i>=length; i++)
	{
		//change the instance variables
		name=array_get(names_list,i)
		variable=variable_struct_get(_id,name)
		variable_instance_set(_id,name,variable)
	}
	
}