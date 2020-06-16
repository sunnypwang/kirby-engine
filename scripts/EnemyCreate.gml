#define EnemyCreate
///EnemyCreate(spd,hp,ability)

WALK_SPD = argument[0]
MAX_HP = argument[1]

hurt_sprite_index = asset_get_index(sprite_get_name(sprite_index) + '_hurt')
if(hurt_sprite_index == -1) hurt_sprite_index = sprite_index

if(argument_count > 2) ability = argument[2]
else ability = ABILITY_NONE

vsp = 0
dir = image_xscale
hsp = dir * WALK_SPD
grav = global.grav
VSP_MAX = global.vsp_max
hp = MAX_HP
inhalable = true
depth = global.enemy_depth

FEET_OFFSET = bbox_bottom - bbox_top + 1

#define EnemyVerticalCollision
///EnemyGravity()

vsp = min(vsp + grav,VSP_MAX)
hsp = dir * WALK_SPD

//slope vertical collision
if(vsp != 0 and position_meeting(x,floor(bbox_bottom+vsp),obj_slope)){      //if moving and colliding with slope in direction moving
     while(!position_meeting(x,bbox_bottom+sign(vsp),obj_slope)){   //move in 1 pixel until contact
         y += sign(vsp);
     }
     vsp = 0
}

//walking on slope collision
//First, check if player is going up slope or not
//This is done by checking that next position horizontally is still on slope, if yes it means player is going up on the slope
slope_y_offset = 0
slope_up_inst = instance_position(floor(x+hsp),bbox_bottom,obj_slope);  //check if next position is still on slope
if (slope_up_inst != noone){    //if yes it will be that slope object id
    
    if(slope_up_inst.SLOPE_RATIO == 0){     //if it's "obj_slope_end" then it will always push player up to its top
        rel_x = sprite_get_height(slope_up_inst.sprite_index);         
    } else {
        //calculate relative x position of player from the slope x (very left)
        rel_x = floor(x+hsp) - slope_up_inst.x     
        if(slope_up_inst.SLOPE_RATIO < 0){  //if opposite slope direction invert the relative value
            rel_x = sprite_get_width(slope_up_inst.sprite_index) - 1 - rel_x;
        }
    }
    //show_debug_message(string(slope_up_inst)+" "+string(rel_x));
    //set player at position relative to that slope y position using rel_x as a offset
    player_y_above_offset =  FEET_OFFSET - sprite_get_height(slope_up_inst.sprite_index)
    newy = slope_up_inst.y - player_y_above_offset - rel_x;
    //y = floor(newy)
    slope_y_offset = newy - y
    
    
} else {
    //If not going up, check if he is going down on slope or not
    //Check first if player is standing on slope, then check if next position player would be if he is going down on slope is still on slope
    standing_slope = instance_position(x,bbox_bottom+1,obj_slope);  //check if standing on slope
    if(standing_slope != noone){
        slope_down_inst = instance_position(floor(x+hsp),floor(bbox_bottom+abs(hsp)+1),obj_slope);  //check if still on slope at position he would be if he goes down on slope
        if(slope_down_inst != noone){       //if yes it will be that slope object id
            
            if(slope_down_inst.SLOPE_RATIO == 0){  //if it's "obj_slope_end" then it will always push player up to its top
                rel_x = sprite_get_height(slope_down_inst.sprite_index);           
            } else {
                //calculate relative x position of player from the slope x (very left)
                rel_x = floor(x+hsp) - slope_down_inst.x;
                if(slope_down_inst.SLOPE_RATIO < 0){
                    rel_x = sprite_get_width(slope_down_inst.sprite_index) - 1 - rel_x;   //if opposite slope direction invert the relative value
                }
            }
            
            //show_debug_message(string(slope_down_inst)+" "+string(rel_x));
            //set player at position relative to that slope y position using rel_x as a offset
            player_y_above_offset =  FEET_OFFSET - sprite_get_height(slope_down_inst.sprite_index)
            newy = slope_down_inst.y - player_y_above_offset - rel_x;
            //y = floor(newy)
            slope_y_offset = newy - y
        }
    }
    
}

//If player is falling and about to collide with solidtop (but not solid)
if(vsp >= 0){
    var solidtop = collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+vsp,obj_solidtop,0,1)
        //check if it is solidtop but not solid
        if(solidtop and solidtop.object_index != obj_solid){ 
            // set player on top of solidtop and set vertical speed to zero
            y = solidtop.y - sprite_get_height(solidtop.sprite_index) 
            vsp = 0
        }
}

//vertical collision with solid
if(vsp != 0 and place_meeting(x,floor(y+vsp),obj_solid)){
    while(!place_meeting(x,y+sign(vsp),obj_solid)){
        y += sign(vsp) //pixel-perfect snap
    }
    vsp = 0 
}

y += slope_y_offset
y = floor(y+vsp)

#define EnemyHorizontalCollision
//EnemyHorizontalCollision()

//turnwall = argument[0]
//turnenemy = argument[1]

//turn wall
if(hsp != 0 and place_meeting(floor(x+hsp),y,obj_solid)){
    while(not place_meeting(x+sign(hsp),y,obj_solid)){
        x = x+sign(hsp) //pixel-perfect snap
    }
    
    hsp = 0
    dir = -dir
    
}


//turn enemy
if(hsp != 0 and place_meeting(floor(x+hsp),y,obj_enemyparent)){
    while(not place_meeting(x+sign(hsp),y,obj_enemyparent)){
        x = x+sign(hsp) //pixel-perfect snap
    }
    
    hsp = 0
    dir = -dir
    
}

x = floor(x+hsp)

//enemy = collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,obj_enemyparent,0,1)
/*
enemy = instance_place(x,y,obj_enemyparent)
if(enemy != noone){
    hsp = -hsp
    dir = -dir
    if(dir == 1){
        x = enemy.bbox_right + abs(sprite_xoffset)
    } else {
        x = enemy.bbox_left - abs(sprite_width - sprite_xoffset)
    }
    
}
*/