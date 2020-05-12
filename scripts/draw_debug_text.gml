var _text = ""
for (var _i=0; _i<argument_count; _i+=1)
{
    _text += string(argument[_i]) + "#"
};

draw_text_transformed(view_xview[0],view_yview[0],_text,2,2,0);
