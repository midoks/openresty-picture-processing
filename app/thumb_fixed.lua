
local gcmd = require "resty.gm.cmd"
local cjson = require "cjson"

os.execute('mkdir -p '..string.match(ngx.var.thumbnail_filepath, "^.*/"))

local g = gcmd:new()
g:D(true)
g:log("thumbnail_fixed")

local crop_type = '0'

local cfg = {'50x50^','100x100>','140x140$','250x250!','300x300_','350x350'}

local now_size = ngx.var.width..'x'..ngx.var.height

for _, t_size in pairs(cfg) do

	if ( now_size == t_size ) then
		crop_type = ''
	elseif ( now_size..'_' == t_size ) then
		crop_type = '_'
	elseif ( now_size..'!' == t_size ) then
		crop_type = '!'
	elseif ( now_size..'^' == t_size ) then
		crop_type = '^'
	elseif ( now_size..'>' == t_size ) then
		crop_type = '>'
	elseif ( now_size..'$' == t_size ) then
		crop_type = '$'
	end
	
end

if crop_type == '0' then
	ngx.exit(404)
end

local quality = tonumber(ngx.var.quality)
if quality > 100 then
	quality = 90
end

g:gm_thumbnail(ngx.var.request_filepath , ngx.var.thumbnail_filepath, ngx.var.width, ngx.var.height, crop_type, quality)
g:run()
ngx.req.set_uri('/thumbnail'..ngx.var.uri, true);

-- ngx.header.content_type ="text/plain";
-- ngx.say("hello world! ".."\r\n")
-- ngx.say(ngx.var.request_filepath.."\r\n")
-- ngx.say(ngx.var.thumbnail_filepath.."\r\n")