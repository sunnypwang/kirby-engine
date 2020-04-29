#define EnemyCreate
///EnemyCreate(hsp,vsp,grav,vsp_max,hp)


hsp = argument[0]
vsp = argument[1]
GRAV = argument[2]
VSP_MAX = argument[3]
hp = argument[4]

FEET_OFFSET = bbox_bottom - bbox_top

#define EnemyStep
///StepEnemy


//slope vertical collision
if(vsp!= 0 and position_meeting(x,bbox_bottom+vsp,obj_slope)){      //if moving and colliding with slope in direction moving
     while(!position_meeting(x,bbox_bottom+sign(vsp),obj_slope)){   //move in 1 pixel until contact
         y += sign(vsp);
     }
     vsp = 0
}

//walking on slope collision
//First, check if player is going up slope or not
//This is done by checking that next position horizontally is still on slope, if yes it means player is going up on the slope
slope_up_inst = instance_position(floor(x+hsp),bbox_bottom,obj_slope);  //check if next position is still on slope
if (slope_up_inst != noone){    //if yes it will be that slope object id
    
    if(slope_up_inst.SLOPE_RATIO == 0){     //if it's "obj_slope_end" then it will always push player up to its top
        rel_x = sprite_get_height(slope_up_inst.sprite_index);         
    } else {
        //calculate relative x position of player from the slope x (very left)
        rel_x = floor(x+hsp) - slope_up_inst.x;     
        if(slope_up_inst.SLOPE_RATIO < 0){  //if opposite slope direction invert the relative value
            rel_x = sprite_get_width(slope_up_inst.sprite_index) - 1 - rel_x;
        }
    }
    //show_debug_message(string(slope_up_inst)+" "+string(rel_x));
    //set player at position relative to that slope y position using rel_x as a offset
    player_y_above_offset =  abs(FEET_OFFSET - sprite_get_height(slope_up_inst.sprite_index));
    newy = slope_up_inst.y - player_y_above_offset - rel_x;
    
    y = floor(newy);
    
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
            player_y_above_offset =  abs(FEET_OFFSET - sprite_get_height(slope_down_inst.sprite_index));
            newy = slope_down_inst.y - player_y_above_offset - rel_x;
            y = floor(newy);
        }
    }
    
}

//If player is falling and about to collide with solidtop (but not solid)
if(vsp >= 0){
    var solidtop = collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+vsp,obj_solidtop,0,0)
    //if (solidtop or position_meeting(x,y+FEET_OFFSET+1,obj_slope)) //if standing on ground
    //{
        
        //check if it is solidtop but not solid
        if(solidtop and solidtop.object_index != obj_solid){ 
            // set player on top of solidtop and set vertical speed to zero
            y = solidtop.y - sprite_get_height(solidtop.sprite_index) 
            vsp = 0
        }
        //if(solidtop) show_debug_message(solidtop.object_index)
    //}
}

//vertical collision with solid
if(vsp != 0 and place_meeting(x,floor(y+vsp),obj_solid)){

    //snap to wall when falling/rising very near to vertical walls
    //this make it easier to jump through small gap
    for(i=SMALL_GAP_OFFSET; i>0; i-=1){
        if(vsp < 0 and !place_meeting(x+i,floor(y+vsp),obj_solid)){        
            x += i
            break
        } else if(vsp < 0 and !place_meeting(x-i,floor(y+vsp),obj_solid)){
            x -= i
            break
        }
    }
    
    if (place_meeting(x,floor(y+vsp),obj_solid)){
        //handle normally
        while(!place_meeting(x,y+sign(vsp),obj_solid)){
            y += sign(vsp) //pixel-perfect snap
        }
        
        event_user(1)
        
        vsp = 0
    }  
}
y = floor(y+vsp)

//horizontal collision with solid
if(hsp != 0 and place_meeting(floor(x+hsp),y,obj_solid)){
    while(not place_meeting(x+sign(hsp),y,obj_solid)){
        x = x+sign(hsp) //pixel-perfect snap
    }
    hsp = 0
}
x = floor(x+hsp)

























/*

next_x = round(x+hsp)
next_y = round(y+vsp)

if(place_meeting(next_x,next_y,obj_solid)){    //If pos (next_x,next_y) overlap with solid

    if(not place_meeting(x,next_y,obj_solid)){
        //y = next_y
        
        while(not place_meeting(round(x+sign(hsp)),next_y,obj_solid)){
            x = round(x+sign(hsp))
        }
        hsp = 0  
         
    } else if(not place_meeting(next_x,y,obj_solid)){
        //x = next_x
         
        while(not place_meeting(next_x,round(y+sign(vsp)),obj_solid)){
            y = round(y+sign(vsp))
        }
        vsp = 0    
    } else {
        while(not place_meeting(round(x+sign(hsp)),round(y+sign(vsp)),obj_solid)){  
            x = round(x+sign(hsp))
            y = round(y+sign(vsp))   
        }
        hsp = 0
        vsp = 0
    }
}
*/




/*
if(vsp < 0 and place_meeting(x,round(y+vsp),obj_solid)){
    while(!place_meeting(x,round(y+sign(vsp)),obj_solid)){
        y = round(y+sign(vsp))
        show_debug_message('up')
    }
    vsp = 0
}

if(hsp > 0 and place_meeting(round(x+hsp),y,obj_solid)){
    while(!place_meeting(round(x+sign(hsp)),y,obj_solid)){
        x = round(x+sign(hsp))
        show_debug_message('right')
    }
    hsp = 0
}

if(hsp < 0 and place_meeting(round(x+hsp),y,obj_solid)){
    while(!place_meeting(round(x+sign(hsp)),y,obj_solid)){
        x = round(x+sign(hsp))
        show_debug_message('left')
    }
    hsp = 0
}
*/

/*
//Horizontal collision
if (hsp!=0){
    if (place_meeting(x+hsp,y,obj_solid)){      //if slope
        y_offset = 0;
        while(y_offset <= abs(hsp) and place_meeting(x+hsp,y-y_offset,obj_solid)){
            y_offset++;
        }
        if(place_meeting(x+hsp,y-y_offset,obj_solid)){
            while(!place_meeting(x+sign(hsp),y,obj_solid)){
                x += sign(hsp);
            } 
            image_xscale = sign(hsp); //special case, kirby is in a 1x1 hole
            hsp = 0;
            dashing = 0;
            
        } else {
            y -= y_offset;
        }   
    }
    else {      //normal floor
        y_offset = 0;
        while(!place_meeting(x+hsp,y+1+y_offset,obj_solid) and y_offset <= abs(hsp)){
            y_offset++;
        }
        if(!place_meeting(x+hsp,y+y_offset,obj_solid)){
            y += y_offset;
        }  
    }
}

//Vertical collision
if (vsp!=0 and place_meeting(x,y+vsp,obj_solid))        //if moving 
{
    if(vsp < 0 and !place_meeting(x+2,y+vsp,obj_solid)){        //snap to wall when falling/rising very near to vertical walls
        x += 2;
    } else if(vsp < 0 and !place_meeting(x-2,y+vsp,obj_solid)){
        x -= 2;
    } else {        //falling/rising normally
        while(!place_meeting(x,y+sign(vsp),obj_solid))
        {
        y += sign(vsp);
        }
        vsp = 0;
    } 
    
}

//diagonal collision
/*
if(hsp != 0 and vsp != 0 and place_meeting(x+hsp, y+vsp, obj_solid))
{
    while(!place_meeting(x+sign(hsp), y + sign(vsp), obj_solid))        //if not hitting a wall
    {
        x+= sign(hsp);
        y+= sign(vsp);
    }
    while(place_meeting(x, y + sign(vsp), obj_solid))       //snap to wall when moving diagonally when falling/rising very near to vertical walls
    {
        x -= sign(hsp);
    }
    hsp = 0;
}
*/

//slope horizontal collision
/*slope = instance_place(x,y+1,obj_slope);
if(hsp != 0 and slope != noone)
{
    //Slope collision handler
    y -= (hsp/slope.ratio);
}
*/