local caps_mode = hs.hotkey.modal.new()
local inputEnglish = "com.apple.keylayout.ABC"

local on_caps_mode = function()
    caps_mode:enter()
end

local off_caps_mode = function()
    caps_mode:exit()
    hs.keycodes.currentSourceID(inputEnglish)
    hs.eventtap.keyStroke({}, 'escape')
end

hs.hotkey.bind({}, 'f13', on_caps_mode, off_caps_mode)