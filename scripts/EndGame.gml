///EndGame()

size = ds_list_size(global.MASTER_DS)
show_debug_message(size)
/*
for (i=0; i<size; i+=1)
{
    
    ds_list_destroy(global.MASTER_DS[| i])
    show_debug_message(global.MASTER_DS[| i])
};
*/
ds_list_destroy(global.MASTER_DS)
