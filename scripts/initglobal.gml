#define Initglobal
///InitializeGlobal()

InitGameSetting()

InitPlatforming()

InitRendering()

InitControlButton()

InitDataStruct()

InitSprites()

#define InitGameSetting
global.game_speed = 30

global.game_screen_width = 864
global.game_screen_height = 480

global.window_width = 1920
global.window_height = 1080

global.tile_size = 32

#define InitPlatforming
global.grav = 1
global.vsp_max = 8

#define InitRendering
global.effect_depth = -3
global.player_depth = -2
global.enemy_depth = -1
#define InitDataStruct
///InitDataStruct

global.MASTER_DS = ds_list_create()

#define InitSprites
///InitSprites()
global.kirby_state = CreateArray('still','walk','run','jump','fall','fall2','bounce','skid','float','puff','duck','slide','slide2','inhale','inhale2','exhaust','stuffing','dead','big_still','big_walk','big_jump','big_fall','big_duck','big_skid','spit','spit2','swallow')
global.ability_state = CreateArray('still','walk','run','jump','fall','fall2','bounce','skid','float','puff','duck','slide','slide2','attack')
global.abilities = CreateArray('kirby','beam')

global.DS_SPRITES_KIRBY = GetSprites('kirby',global.kirby_state)
global.DS_SPRITES_BEAM = GetSprites('beam',global.ability_state)
