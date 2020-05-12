///CreateDS(type)
//This script is used to create any new data structure
//which will be tracked by global.MASTER_DS for deallocating purpose

type = argument[0]
ds_index = -1

switch (type)
{
    case 'list': 
        ds_index = ds_list_create(); 
        ds_list_add(global.MASTER_DS, ds_index); 
        ds_list_mark_as_list(global.MASTER_DS, ds_list_size(global.MASTER_DS)-1)
        break;
    case 'map' :
        ds_index = ds_map_create(); 
        ds_list_add(global.MASTER_DS, ds_index); 
        ds_list_mark_as_map(global.MASTER_DS, ds_list_size(global.MASTER_DS)-1)
        break;
}


//show_debug_message(ds_list_size(global.MASTER_DS))
return ds_index

