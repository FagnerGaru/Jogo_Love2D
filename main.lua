-- Variáveis para armazenar a largura e altura da tela
larguraTela = love.graphics.getWidth()
alturaTela = love.graphics.getHeight()

nivel_atual = 1

-- Carrega recursos e define variáveis iniciais
function love.load()

    definir_valores_do_nivel(nivel_atual)--criar nivel

    imgnave = love.graphics.newImage("imagens/nave.png")--cria nave
   
    nave = {
        posx = larguraTela / 2,  
        posy = alturaTela / 2,  
        velocidade = 200
    } 
    
    -- Variáveis relacionadas aos tiros
    tiros = {}
    atira = true
    delay_tiro = 0.5
    tempo_Ate_Atirar = delay_tiro
    imgtiro = love.graphics.newImage("imagens/projetil.png")

    -- Variáveis relacionadas aos inimigos
    inimigos = {}
    delay_inimigo = 0.4
    tempo_criar_inimigo = delay_inimigo
    img_inimigo = love.graphics.newImage("imagens/inimigo.png")

    --vidas e pontuação
    esta_vivo = true
    pontos = 0
    Vidas = 3
    Game_Over = false
    Transparencia = 0
    ImgGame_Over = love.graphics.newImage("imagens/Game_over.png")

    --background
    fundo = love.graphics.newImage ("imagens/background.png")
    fundo_dois = love.graphics.newImage ("imagens/background.png")

    plano_de_fundo = {
        x = 0,
        y = 0,
        y2 = 0 - fundo:getHeight (),
        vel = 30
    }
--fonte texto
    fonte_nivel = love.graphics.newFont(15) -- Ajuste o tamanho da fonte conforme necessário
    fonte = love.graphics.newFont(15)
    fontedois = love.graphics.newFont(15)
    --sons do jogo 
    som_do_Tiro = love.audio.newSource("sons/Tiro.wav","static")
    explode_nave = love.audio.newSource("sons/explodenave.wav","static")
    explode_inimigo = love.audio.newSource ("sons/explodeinimigo.wav","static")
    musica = love.audio.newSource("sons/musica.wav", "stream")
    som_Game_Over = love.audio.newSource("sons/Game_Over.ogg","stream")
    musica:play()
   musica:setLooping(true)

   --efeito da tela inicial 
    Abre_Tela = false
    Tela_Titulo = love.graphics.newImage("imagens/ImagemTitulo.png")
    Inoutx = 0
    Inouty = 0

    --pause
    Pause = false
 --fonte
 fontedois = love.graphics.newFont("fontexemplo.ttf",50 )
end

-- Atualizações
function love.update(dt)
    if not gamePaused then
    movimentos(dt)
    atirar(dt)
    criar_Inimigo(dt)
    colisoes()
    reset ()
    plano_de_fundo_scrolling(dt)
    Inicia_jogo (dt)
   end
   if Game_Over then
    Fim_de_Jogo(dt)   
   end
    -- Verifique se o jogador atingiu uma pontuação específica para aumentar o nível
    if pontos >= 50 and nivel_atual == 1 then
        nivel_atual = 2
        definir_valores_do_nivel(nivel_atual)
        -- Você pode adicionar mais verificações para outros níveis aqui
    end
end


function atirar(dt)
    tempo_Ate_Atirar = tempo_Ate_Atirar - (1 * dt)
    if tempo_Ate_Atirar < 0 then
        atira = true
    end
    if esta_vivo then
        if love.keyboard.isDown("space") and atira then
           novo_tiro = {x = nave.posx, y = nave.posy, img = imgtiro}
           table.insert(tiros, novo_tiro)
           som_do_Tiro:stop()
           som_do_Tiro:play()
           atira = false
           tempo_Ate_Atirar = delay_tiro    
    end
        end

    for i, tiro in ipairs(tiros) do 
        tiro.y = tiro.y - (500 * dt)
        if tiro.y < 0 then
           table.remove(tiros, i)
        end
    end
end
function criar_Inimigo(dt)
    tempo_criar_inimigo = tempo_criar_inimigo - (1 * dt)
    if tempo_criar_inimigo < 0 then
        tempo_criar_inimigo = delay_inimigo
        numero_aleatorio = math.random(10, larguraTela - ((img_inimigo:getWidth() / 2) + 10))
        novo_inimigo = {x = numero_aleatorio, y = -img_inimigo:getHeight(), img = img_inimigo}
        table.insert(inimigos, novo_inimigo)
    end
        
    for i, inimigo in ipairs(inimigos) do
        inimigo.y = inimigo.y + (200 * dt)
        if inimigo.y > alturaTela then
            table.remove(inimigos, i)
        end
    end
end
    
function colisoes ()
    for i, inimigo in ipairs(inimigos) do
        for j, tiro in ipairs(tiros) do
          if checa_colisao (inimigo.x,inimigo.y, img_inimigo:getWidth(),img_inimigo:getHeight(), tiro.x,tiro.y,imgtiro:getWidth(),imgtiro:getHeight())  then
           table.remove(tiros, j)
           table.remove(inimigos, i)
           explode_inimigo:stop()
           explode_inimigo:play ()
           pontos = pontos + 1          
        end  
    end 

        if checa_colisao (inimigo.x, inimigo.y, img_inimigo:getWidth(),img_inimigo:getHeight(),nave.posx - (imgnave:getWidth()/2),nave.posy,imgnave:getWidth(), imgnave:getHeight()) and esta_vivo then
           table.remove(inimigos,i)
           explode_nave:play()
           esta_vivo = false
           Abre_Tela = false
           Vidas = Vidas - 1
           if Vidas < 0 then
               Game_Over = true
               som_Game_Over: play()
               som_Game_Over:setLooping (false)
            
            end
        end     
    end
end

function checa_colisao (x1,y1,w1,h1,x2,y2,w2,h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
    
end

function movimentos(dt)
    if love.keyboard.isDown("right") then
        if nave.posx < larguraTela - imgnave:getWidth() / 2 then
            nave.posx = nave.posx + nave.velocidade * dt
        end
    end   

    if love.keyboard.isDown("left") then
        if nave.posx > 0 + imgnave:getWidth() / 2 then
            nave.posx = nave.posx - nave.velocidade * dt
        end
    end

    if love.keyboard.isDown("up") then
        if nave.posy > 0 + imgnave:getHeight() / 2 then
            nave.posy = nave.posy - nave.velocidade * dt  
        end
    end  

    if love.keyboard.isDown("down") then
        if nave.posy < alturaTela - imgnave:getHeight() / 2 then
            nave.posy = nave.posy + nave.velocidade * dt 
        end
    end
end

-- Desenha na tela
function love.draw()
    if not gamePaused then
        -- Existing drawing logic...
    else
        -- Display a pause screen or message
        love.graphics.print("Paused", larguraTela / 2 - 30, alturaTela / 2)
    end
    if not Game_Over then
--background
       love.graphics.draw (fundo, plano_de_fundo.x,plano_de_fundo.y)
       love.graphics.draw ( fundo_dois,plano_de_fundo.x,plano_de_fundo.y2)
       love.graphics.draw (imgnave, nave.posx, nave.posy, 0, 1, 1, imgnave:getWidth() / 2 , imgnave:getHeight() / 2)

    -- Desenha tiros
        for i, tiro in ipairs (tiros) do
            love.graphics.draw (tiro.img, tiro.x, tiro.y, 0, 1, 1, imgtiro:getWidth() / 2, imgtiro:getHeight())
            if pontos > 20 then
                love.graphics.draw (tiro.img, tiro.x - 10, tiro.y + 15, 0, 1, 1, imgtiro:getWidth() / 2, imgtiro:getHeight())
                love.graphics.draw (tiro.img, tiro.x +10, tiro.y +15, 0, 1, 1, imgtiro:getWidth() / 2, imgtiro:getHeight())
                delay_tiro = 0.4
                if pontos >50 then
                    love.graphics.draw (tiro.img, tiro.x -20, tiro.y + 30, 0, 1, 1, imgtiro:getWidth() / 2, imgtiro:getHeight())
                    love.graphics.draw (tiro.img, tiro.x +20, tiro.y + 30, 0, 1, 1, imgtiro:getWidth() / 2, imgtiro:getHeight())
                    delay_tiro = 0.3
                    if pontos > 100 then
                        delay_tiro = 0.2
                end
            end
        end
    end      

    -- Desenha inimigos
        for i, inimigo in ipairs (inimigos) do
           love.graphics.draw (inimigo.img, inimigo.x, inimigo.y)
         end
 
--pontos na tela
       love.graphics.setFont(fonte)
       love.graphics.print("pontuacao: " .. pontos, 10, 10)
       love.graphics.print("Vidas: " .. Vidas,400,15)
    end


    --GAMER OVER e reset
    if  esta_vivo then
        love.graphics.draw(imgnave, nave.posx, nave.posy, 0, 1, 1, imgnave:getWidth() / 2 , imgnave:getHeight() / 2)
    elseif Game_Over then
        love.graphics.setColor(255, 255, 255, Transparencia)
         love.graphics.draw(ImgGame_Over, 0, 0)
         love.graphics.setFont(fontedois)
         love.graphics.print("pontuação final: " .. pontos, larguraTela/4,50)
    else
        love.graphics.draw(Tela_Titulo, Inoutx, Inouty)
    end
    love.graphics.setFont(fonte_nivel)
    love.graphics.print("Nível: " .. nivel_atual, 20, 30)
end

function reset ()
    if not esta_vivo and Inouty == 0 and love.keyboard.isDown ('return') then
        tiros = {}
        inimigos = {}
        atira = tempo_Ate_Atirar
        tempo_criar_inimigo = delay_inimigo
        nave.posx = larguraTela /2
        nave.posy = alturaTela /2
        
        Abre_Tela = true  
    end
end

function plano_de_fundo_scrolling (dt)
    plano_de_fundo.y = plano_de_fundo.y + plano_de_fundo.vel * dt
    plano_de_fundo.y2 = plano_de_fundo.y2 + plano_de_fundo.vel * dt
    
    if plano_de_fundo.y > alturaTela then
        plano_de_fundo.y = plano_de_fundo.y2 - fundo_dois:getHeight()
     end

     if plano_de_fundo.y2 > alturaTela then
        plano_de_fundo.y2 =plano_de_fundo.y - fundo:getHeight()  
     end
end

function Inicia_jogo(dt)
    if Abre_Tela and not esta_vivo then
        Inoutx = Inoutx + 600 * dt
        if Inoutx > 481 then
            Inouty = -701
            Inoutx = 0
            esta_vivo =true
        end
          elseif not Abre_Tela then
            esta_vivo = false
            Inouty = Inouty + 600 * dt
            if Inouty > 0  then
                Inouty = 0  
            end     
    end  
end

function love.keyreleased(key)
    if key == "p" and Abre_Tela then
        gamePaused = not gamePaused
        if gamePaused then
            love.audio.pause(musica)
        else
            love.audio.stop(musica)
            love.audio.play(musica)
        end
    end
end

function  Fim_de_Jogo(dt)
    Pause = true
    musica:stop()
    Transparencia = Transparencia + 100 * dt
    if love.keyboard.isDown("escape") then
       love.event.quit() 

       -- Desenha a pontuação final na tela
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Game Over", larguraTela / 2 - 50, alturaTela / 2 - 20)
    love.graphics.print("Pontuação Final: " .. pontos, larguraTela / 2 - 70, alturaTela / 2 + 10)

    if love.keyboard.isDown("escape") then
        love.event.quit() 
    end   
end
end

function definir_valores_do_nivel(nivel) --nivel
    -- Adicione mais níveis conforme necessário
    if nivel == 1 then
        delay_inimigo = 0.4
        velocidade_inimigo = 200
        pontos_necessarios = 20
    elseif nivel == 2 then
        delay_inimigo = 0.3
        velocidade_inimigo = 250
        pontos_necessarios = 50
    elseif nivel == 3 then
        delay_inimigo = 0.25
        velocidade_inimigo = 300
        pontos_necessarios = 100
    elseif nivel == 4 then
        delay_inimigo = 0.2
        velocidade_inimigo = 350
        pontos_necessarios = 150
    elseif nivel == 5 then
        delay_inimigo = 0.15
        velocidade_inimigo = 400
        pontos_necessarios = 200
    end
end
   
