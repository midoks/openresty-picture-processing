-- Copyright (C) by Midoks(midoks@163.com)
-- http://opencv.org/
-- http://www.bo56.com/tclip%E4%BA%BA%E8%84%B8%E8%AF%86%E5%88%AB%E5%9B%BE%E7%89%87%E8%A3%81%E5%89%AA/

local time_helper = require "resty.gm.time_helper"

local setmetatable = setmetatable
local _M = { _VERSION = '0.01' }
local mt = { __index = _M }
local debug_sort = 0

function _M.new(self)
    local p = setmetatable({
    	path = 'tclip',
    	cmd  = '',
    	start_time = time_helper.current_time_millis(),
    	debug   = false
    }, mt)
    return p
end

function _M.setBin( self, path )
	self.path = path
end

--[[
	clear cmd value
]]
function _M:clear(self)
	self.cmd = ""
end

--[[
	format conversion
	@param o_img	:original picture
	@param n_img	:now pictures
]]
function _M.convert(self,o_img, n_img, w, h)
	local cmd = " -s "..o_img.." -d "..n_img .. " -w "..w.." -h ".. h
	self.cmd = cmd
end

--[[
	debug false or true
	@param bool b
	
	ngx.header["gm-debug-s"] = " ---- tclip debug start ---- "
	ngx.header["gm-debug-e"] = " ---- tclip  debug end 	---- "
]]
function _M.D(self, d)
	if d then
		self.debug = d
		self:log("*----*tclip debug start*----*")
	end
end

--[[
	log
]]
function _M.log(self, msg)
	if self.debug then
		ngx.header["tc-debug-"..debug_sort] = msg
		debug_sort = debug_sort + 1
	end
end

--[[
	run
]]
function _M.run(self)
	local cmd = self.path .. " " .. self.cmd
	self:log(cmd)
	os.execute(cmd)
	self:log("*----*tclip debug end* ----*")

	if self.debug then
		local time_end = time_helper.current_time_millis()
		self:log("*----*time consuming:".. (time_end - self.start_time)*1000 .."ms* ----*")
	end
	debug_sort = 0
end

-- test
function _M.t( self )
	ngx.header.content_type ="text/plain";
    ngx.say('t')
end

return _M