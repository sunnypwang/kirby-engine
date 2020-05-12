///GetSprites(ability,state)

ability = argument[0]
state = argument[1]

sprites = CreateDS('map')
for (j=0; j<array_length_1d(state); j+=1)
{
    ds_map_add(sprites, state[j], asset_get_index('spr_' + ability + '_' + state[j]))
}

return sprites
