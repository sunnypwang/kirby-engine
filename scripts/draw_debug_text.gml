text = ""
for (i=0; i<argument_count; i+=1)
{
    text += string(argument[i]) + "#"
};

draw_text_transformed(view_xview[0],view_yview[0],text,2,2,0);
