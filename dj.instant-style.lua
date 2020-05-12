script_name = "Instant Style"
script_description = "Choose Style and set with Hotkey"
script_author = "Django.Durano"
script_version = "1.1.0"

function style(subs,sel,act,styles)

	if marker~=1 then

	ADP=aegisub.decode_path
	ADO=aegisub.dialog.open
	ADD=aegisub.dialog.display
	ADS=aegisub.dialog.save
	ak=aegisub.cancel
	userpath=ADP("?user").."\\"
	stylpath=userpath.."catalog\\"
	styles={}

	aegisub.progress.title("Choose Style")

	local delim = {","}
	local d = "[^"..table.concat(delim).."]+"

	for i=1,#subs do
    if subs[i].class=="style" then
	table.insert(styles,subs[i].name)
	_G[subs[i].name]={}
	l=subs[i].raw:gsub("Style: ","")
	for w in l:gmatch(d) do
		table.insert(_G[subs[i].name],w)
	end
    end
    if subs[i].class=="dialogue" then break end
	end

	guiy=0
	guix=0

	stylgui={
	{x=guix,y=guiy,width=1,height=1,class="label",label="Save Location:"},
	{x=guix+2,y=guiy,width=1,height=1,class="label",label="Styles ~>"},
	{x=guix,y=guiy+2,width=1,height=1,class="label",label="Current Script:"},
	{x=guix+2,y=guiy+2,width=1,height=1,class="dropdown",name="styl",items=styles},
	{x=guix,y=guiy+4,width=1,height=1,class="label",label="Storage:"},
	}
	repeat

	DIR()

	P,rez=ADD(stylgui,{"Cancel","Save"},{close='Cancel',ok='Save'})

	until P=="Save" or P=="Cancel"

	check=1

	if P=="Save" then
	for k,v in ipairs(stylgui) do
	if v.class=="checkbox" then if rez[v.name]==true then marker=1 end end
	if v.class=="dropdown" and rez[v.name]~="" then
	if v.name=="styl" then
	instyln=_G[rez[v.name]] instyl=rez[v.name]
	else
	instyln=_G[v.name.."_"..rez[v.name]] instyl=rez[v.name] end
	end end
	ins(subs, sel)
	end
	if marker==1 then check=nil end
	if P=="Cancel" then ak() end
	else
	ins(subs, sel)
	end
end


function ins(subs, sel)

if instyln~=nil then
	if check==1 then
	for i=1,#subs do
		if subs[i].class=="style" then
		style=subs[i]
		style.class="style"
		style.section="[V4+ Styles]"
		style.name=instyln[1]:gsub("﻿","")
		style.fontname=instyln[2]
		style.fontsize=instyln[3]
		style.color1=instyln[4]
		style.color2=instyln[5]
		style.color3=instyln[6]
		style.color4=instyln[7]
		if instyln[8]==0 then style.bold=true else style.bold=false end
		if instyln[9]==0 then style.italic=false else style.italic=true end
		if instyln[10]==0 then style.underline=true else style.underline=false end
		if instyln[11]==0 then style.strikeout=true else style.strikeout=false end
		style.scale_x=instyln[12]
		style.scale_y=instyln[13]
		style.spacing=instyln[14]
		style.angle=instyln[15]
		style.borderstyle=instyln[16]
		style.outline=instyln[17]
		style.shadow=instyln[18]
		style.align=instyln[19]
		style.margin_l=instyln[20]
		style.margin_r=instyln[21]
		style.margin_v=instyln[22]
		style.encoding=instyln[23]
		subs[i-1]=style
		
	break end
    end end

	for i=#sel,1,-1 do
		if check==1 then q=1 else q=0 end
		line=subs[sel[i]+q]
		line.style=instyl
		subs[sel[i]+q]=line
	end

    aegisub.set_undo_point(script_name)
	q=nil
    return sel,subs
	else marker=nil
	end
end


function DIR()

styl={}
q=2
p=4
local delim = {","}
local d = "[^"..table.concat(delim).."]+"

for dir in io.popen('dir '..quo(stylpath)..'*.sty /b'):lines() do

	local t = {}
	local y = dir:gsub(".sty","")

	for line in io.lines (stylpath..dir) do
		table.insert(t,line:match("Style: (%a+)"))
		x=y.."_"..line:match("Style: (%a+)")
		l=line:gsub("Style: ","")
		_G[x]={}
		for w in l:gmatch(d) do
			table.insert(_G[x],w)
		end
	end

	table.insert(stylgui,{x=q,y=p,class="label",label=y})
	table.insert(stylgui,{x=q,y=p+1,class="dropdown",name=y,items=t})

	q=q+1
	if q==6 then q=2 p=p+2 end

	end

	table.insert(stylgui,{x=0,y=p+3,width=1,height=1,class="label",label="Save Style"})
	table.insert(stylgui,{x=2,y=p+3,width=1,height=1,class="checkbox",name="sav"})
	table.insert(stylgui,{x=0,y=p+5,width=1,height=1,class="label",label="Instant Style Version: "..script_version})
	table.insert(stylgui,{x=0,y=p+6,width=1,height=1,class="label",label=""})

end


function t_error(message,level)

	err=ADD({{class="label",label=message}},{"ok"},{ok='ok'})
	end


function quo(x) x="\""..x.."\"" return x end		--set "" to string--

function reset()

marker=nil

end

aegisub.register_macro("Instant Style/Set", script_description, style)
aegisub.register_macro("Instant Style/Reset", script_description, reset)