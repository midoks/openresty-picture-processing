
local gcmd = require "resty.gm.cmd"
local gtclip = require "resty.gm.tclip"


os.execute('mkdir -p '..string.match(ngx.var.thumbnail_filepath, "^.*/"))

local gt = gtclip:new()
local gc = gcmd:new()

gt:D(true)
gc:D(true)

if ngx.var.dest_ext == "webp" then

	local tmp = ngx.var.document_root.."/thumbnail"..ngx.var.req_image.."_t"..ngx.var.width.."x"..ngx.var.height.."."..ngx.var.source_ext
	gt:convert(ngx.var.request_filepath , tmp, ngx.var.width, ngx.var.height)
	gt:run()

	local quality = tonumber(ngx.var.quality)

	gc:gm_format(tmp, ngx.var.thumbnail_filepath, quality)
	
	gc:run()
else
	gt:convert(ngx.var.request_filepath , ngx.var.thumbnail_filepath, ngx.var.width, ngx.var.height)
	gt:run()
end
ngx.req.set_uri('/thumbnail'..ngx.var.uri, true);

-- test

-- ngx.header.content_type ="text/plain";
-- ngx.say("hello world! tclip".."\r\n")
-- ngx.say(ngx.var.request_filepath.."\r\n")
-- ngx.say(ngx.var.document_root.."/thumbnail"..ngx.var.req_image.."_t"..ngx.var.width.."x"..ngx.var.height.."."..ngx.var.source_ext.."\r\n")
-- ngx.say(ngx.var.thumbnail_filepath.."\r\n")
-- ngx.say(ngx.var.d_ext.."\r\n")