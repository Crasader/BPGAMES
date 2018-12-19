
--------------------------------------------------------------------------------
-- 音效相关辅助函数
--------------------------------------------------------------------------------
audio_engine = audio_engine or {}

--------------------------------------------------------------------------------
-- 常量
--------------------------------------------------------------------------------
audio_engine.audioengine = nil
--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------

-- 播放背景音乐
function audio_engine.playBackground(param_str)
    if audio_engine.audioengine == nil then
        audio_engine.audioengine = cc.SimpleAudioEngine:getInstance()
    end
    audio_engine.audioengine:playMusic(param_str, true)
end

-- 停止播放背景音乐
function audio_engine.endBackground()
    if audio_engine.audioengine == nil then
        audio_engine.audioengine = cc.SimpleAudioEngine:getInstance()
    end
   -- audio_engine.audioengine:stopBackgroundMusic()
end

function audio_engine.stopEffect(id)

end

function audio_engine.stopAllEffects()

end

function audio_engine.playEffect(param_sound,param_loop)

end
