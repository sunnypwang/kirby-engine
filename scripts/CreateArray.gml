///CreateArray(*args)

var _arr = array_create(argument_count)
for (var _i=0; _i<argument_count; _i+=1)
{
    _arr[_i] = argument[_i]
}

return _arr
