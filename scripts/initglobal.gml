#define Initglobal
///InitializeGlobal()

InitGameSetting()

InitPlatforming()

InitRendering()

InitControlButton()

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
global.player_depth = -2
global.enemy_depth = -1