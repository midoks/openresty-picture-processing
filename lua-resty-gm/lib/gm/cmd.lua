-- Copyright (C) by Midoks(midoks@163.com)
-- http://www.graphicsmagick.org/download.html


local time_helper = require "resty.gm.time_helper"

local setmetatable = setmetatable
local _M = { _VERSION = '0.01' }
local mt = { __index = _M }
local debug_sort = 0

function _M.new(self)
    local p = setmetatable({
    	gm_path = 'gm',
    	gm_cmd  = '',
    	gm_bg_color = 'white',
    	start_time = time_helper.current_time_millis(),
    	debug   = false
    }, mt)
    return p
end

--[[
	clear cmd value
]]
function _M:clear(self)
	self.gm_cmd = ""
end

--[[
	format conversion
	@param o_img	string:original picture
	@param n_img	string:now pictures
	@param q	int :quality
]]
function _M.gm_format(self,o_img, n_img, q)
	local cmd = ''
	if q > 0 then
		cmd = "convert -quality " .. q .. " "..o_img.." +profile \"*\" "..n_img
	else
		cmd = "convert "..o_img.." +profile \"*\" "..n_img
	end
	self.gm_cmd = cmd
end

--[[
	quality
	@param o_img	:original picture
	@param n_img	:now pictures
	@param quality	:quality
]]
function _M.gm_quality(self,o_img, n_img, q)
	local cmd = "convert -quality ".. q.. " "..o_img.." +profile \"*\" "..n_img
	self.gm_cmd = cmd
end

--[[
	thumbnail

	@param o_img	:original picture
	@param n_img	:now pictures
	@param w		:width
	@param h 		:height
	@crop_type 		: 

	""-> 填充后保证等比缩图 	1
    _ -> 等比缩图				2
    ! -> 非等比缩图，按给定的参数缩图（缺点：长宽比会变化）   	3
    ^ -> 裁剪后保证等比缩图 （缺点：裁剪了图片的一部分）  		4
    > -> 只缩小不放大      	5
    $ -> 限制宽度，只缩小不放大(比如网页版图片用于手机版时) 	6
]]
function _M.gm_thumbnail(self, o_img, n_img, w, h, crop_type, q)
	local cmd = ''
	
	if q > 0 then
		cmd = 'convert ' .. o_img .. " -quality "..q
	else
		cmd = 'convert ' .. o_img
	end
	
	if (crop_type == '') then
		cmd = cmd..' -thumbnail '.. w..'x'..h .. ' -background ' .. self.gm_bg_color .. ' -gravity center -extent ' .. w..'x'..h
	elseif (crop_type == '_') then
		cmd = cmd..' -thumbnail '.. w..'x'..h
	elseif (crop_type == '!') then
		cmd = cmd..' -thumbnail "'.. w..'x'..h .. '!" -extent ' .. w..'x'..h
	elseif (crop_type == '^') then
		cmd = cmd..' -thumbnail "'.. w..'x'..h .. '^" -extent ' .. w..'x'..h
	elseif (crop_type == '>' or crop_type == '$') then
		cmd = cmd..' -resize "'.. w..'x'..h .. '>"'
	else
		self:log('crop_type error:'..crop_type)
		ngx.exit(404)
	end
	cmd = cmd .." +profile \"*\" " .. ' '..n_img
	self.gm_cmd = cmd
end

--[[
	download
	@param path	: path
	@param url	: url
]]
function _M.download( self, path, url )
	local time_start = time_helper.current_time_millis()
	local file, err = io.open(path)
	
	if err then
		os.execute('curl -o '..path..' '..url)
	else
		file:close()
	end
	
	if self.debug then
		local time_end = time_helper.current_time_millis()
		self:log("*----*download consuming:".. (time_end - time_start)*1000 .."ms*----*")
	end
end


--[[
	debug false or true
	@param bool b
	
	ngx.header["gm-debug-s"] = " ---- debug start 	---- "
	ngx.header["gm-debug-e"] = " ---- debug end 	---- "
]]
function _M.D(self, d)
	if d then
		self.debug = d
		self:log("*----*debug start*----*")
	end
end

--[[
	log
]]
function _M.log(self, msg)
	if self.debug then
		ngx.header["gm-debug-"..debug_sort] = msg
		debug_sort = debug_sort + 1
	end
end

function _M.run(self)
	local gm_cmd = self.gm_path .. " " .. self.gm_cmd
	self:log(gm_cmd)
	os.execute(gm_cmd)
	self:log("*----*debug end* ----*")

	if self.debug then
		local time_end = time_helper.current_time_millis()
		self:log("*----*time consuming:".. (time_end - self.start_time)*1000 .."ms* ----*")
	end
	debug_sort = 0
end

function _M.i(self)
    local list = {
        0x47,0x49,0x46,0x38,0x39,0x61,
        0x01,0x00,0x01,0x00,0x80,0xff,
        0x00,0xff,0xff,0xff,0x00,0x00,
        0x00,0x2c,0x00,0x00,0x00,0x00,
        0x01,0x00,0x01,0x00,0x00,0x02,
        0x02,0x44,0x01,0x00,0x3b
    }

    ngx.header.content_type = "image/jpeg"
    local s = ""
    for i=1,table.getn(list) do
        s = s..string.format("%c", list[i])
    end
    ngx.say(s)
    return true
end


-- test
function _M.t( self )
	ngx.header.content_type ="text/plain";
    ngx.say('t')
end

return _M