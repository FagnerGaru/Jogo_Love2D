-- Configurações do jogo
function love.conf(t)
    t.identity = nil
    t.version = "11.4"
    t.console = true

    t.window.title = "jogo de nave"
    t.window.icon = nil
    t.window.width = 480
    t.window.height = 700
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 1
    t.window.minheight = 1
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = true
    t.window.msaa = 0
    t.window.display = 1
    t.window.x = nil
    t.window.y = nil

    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true 
    t.modules.system = true
    t.modules.timer = true
    t.modules.touch = true
    t.modules.video = true
    t.modules.window = true
    t.modules.thread = true
end















