-- This script is based on the uninstall script for GTNH-CropAutomation from here:
-- https://github.com/DylanTaylor1/GTNH-CropAutomation/blob/main/uninstall.lua
-- Since the original uses the MIT License, I included a copy here.
--
-- MIT License
-- 
-- Copyright (c) 2023 DylanTaylor1
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.


local shell = require('shell')
local scripts = {
    'main.lua',
    'settings.conf',
    'uninstall.lua',
    'lib/Alveary.lua',
    'lib/Apiary.lua',
    'lib/BasicManager.lua',
    'lib/Bee.lua',
    'lib/BeeContainer.lua',
    'lib/BeeTraits.lua',
    'lib/BreederBlock.lua',
    'lib/Chest.lua',
    'lib/Config.lua',
    'lib/Evaluator.lua',
    'lib/FromNative.lua',
    'lib/Inventory.lua',
    'lib/Location.lua',
    'lib/Log.lua',
    'lib/PriorityQueue.lua',
    'lib/Transposer.lua',
    'lib/util.lua'
}

-- UNINSTALL
for i=1, #scripts do
    shell.execute(string.format('rm %s', scripts[i]))
    print(string.format('Uninstalled %s', scripts[i]))
end

shell.execute('rm -r lib')
print(string.format('Removed lib folder'))
