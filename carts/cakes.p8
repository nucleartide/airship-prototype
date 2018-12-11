pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
cartdata("kzgpckv1")daynumber="10"::_::
if (btnp()>0)goto donewithintro
cls()f=4-abs(t()-4)for z=-3,3 do
for x=-1,1 do
for y=-1,1 do
b=mid(f-rnd(.5),0,1)b=3*b*b-2*b*b*b
a=atan2(x,y)-.25
c=8+(a*8)%8
if (x==0 and y==0)c=7
u=64.5+(x*13)+z
v=64.5+(y*13)+z
w=8.5*b-abs(x)*5
h=8.5*b-abs(y)*5
if (w>.5)rectfill(u-w,v-h,u+w,v+h,c)rect(u-w,v-h,u+w,v+h,c-1)
end
end
end
if rnd()<f-.5 then
?daynumber,69-#daynumber*2,65,2
end
if f>=1 then
for j=0,1 do
for i=1,f*50-50 do
x=cos(i/50)y=sin(i/25)-abs(x)*(.5+sin(t()))circfill(65+x*8,48+y*3-j,1,2+j*6)end
end
for i=1,20 do
?sub("pico-8 advent calendar",i),17+i*4,90,mid(-1-i/20+f,0,1)*7
end
end
if (t()==8)goto donewithintro
flip()goto _
::donewithintro::
function index_add(idx,prop,elem)idx[prop]=idx[prop]or {}
add(idx[prop],elem)end
function event(e,evt,...)local fn=e and e[evt]
if type(fn)=="function" then
return fn(e,...)end
return fn
end
function set(o,props)for k,v in pairs(props or {})do
o[k]=v
end
return o
end
function clone(o)
return set({},o)end
function merge(t1,t2)
return set(clone(t1),t2)end
function printa(t,x,y,c,a)printt(printa_pat,t,x,y,{c},a)end
function printsh(t,x,y,c,a)printt(printsh_pat,t,x,y,{c,0},a)end
function printdsh(t,x,y,c1,c2,a)printt(printdsh_pat,t,x,y,{c1,c2,0},a)end
function printt(pat,t,x,y,cs,a)
if (a)x-=a*4*#tostr(t)
for d in all(pat)do
print(t,x+d.x,y+d.y,cs[d.c])end
end
function lerp(a,b,t)
return a+(b-a)*t
end
function rndf(l,h)
return l+rnd(h-l)end
function rndi(l,h)
return flr(rndf(l,h+1))end
function round(x)
return flr(x+0.5)end
function cutebox(x1,y1,x2,y2,cbg,chl,cbr)shadow(x1,y2+2,x2,y2+2,2)shadow(x2+1,y2+1,x2+1,y2+1,2)set_palette()rect(x1,y1-1,x2,y2+1,cbr)rect(x1-1,y1,x2+1,y2)rectfill(x1,y1,x2,y2,cbg)rectfill(x1,y1,x2,y1+(y2-y1)/3,chl)end
function filter(seq,pred)local f={}
for e in all(seq)do
if (pred(e))add(f,e)
end
return f
end
function index_of(seq,target)for i,e in pairs(seq or {})do
if (e==target)return i
end
end
function concat(a,b)local t={}
local append=function(e)add(t,e)end
foreach(a,append)foreach(b,append)
return t
end
function min_by(seq,key)local mk,me=32767
for e in all(seq)do
local k=key(e)
if (k<mk)mk,me=k,e
end
return me,mk
end
function sort_by(seq,key)for limit=#seq-1,1,-1 do
for i=1,limit do
local a,b=seq[i],seq[i+1]
if key(b)<key(a)then
seq[i],seq[i+1]=b,a
end
end
end
return seq
end
function call(fn,a)
return fn
and fn(a[1],a[2],a[3],a[4],a[5])or a
end
function ob(str,props)local result,s,n,inpar=
{},1,1,0
each_char(str,function(c,i)local sc,nxt=sub(str,s,s),i+1
if c=="(" then
inpar+=1
elseif c==")" then
inpar-=1
elseif inpar==0 then
if c=="=" then
n,s=sub(str,s,i-1),nxt
elseif c=="," and s<i then
result[n]=sc=='"'and sub(str,s+1,i-2)or sub(str,s+1,s+1)=="("and call(obfn[sc],ob(sub(str,s+2,i-2)..","))or sc!="f"and band(sub(str,s,i-1)+0,0xffff.fffe)s=nxt
if (type(n)=="number")n+=1
elseif sc!='"'and c==" " or c=="\n" then
s=nxt
end
end
end)
return set(result,props)end
function each_char(str,fn)local rs={}
for i=1,#str do
add(rs,fn(sub(str,i,i),i))end
return rs
end
object={}
function object:extend(kob)kob=ob(kob or "")kob.extends,kob.meta,object[kob.classname or ""]=
self,{__index=kob},kob
return setmetatable(kob,{__index=self,__call=function(self,ob)ob=setmetatable(clone(ob),kob.meta)local ko,init_fn=kob
while ko do
if ko.init and ko.init~=init_fn then
init_fn=ko.init
init_fn(ob)end
ko=ko.extends
end
return ob
end
})end
vector={}
vector.__index=vector
function vector:__add(b)
return v(self.x+b.x,self.y+b.y)end
function vector:__sub(b)
return v(self.x-b.x,self.y-b.y)end
function vector:__mul(m)
return v(self.x*m,self.y*m)end
function vector:__div(d)
return v(self.x/d,self.y/d)end
function vector:__unm()
return v(-self.x,-self.y)end
function vector:dot(v2)
return self.x*v2.x+self.y*v2.y
end
function vector:norm()
return self/self:len()end
function vector:rotr()
return v(-self.y,self.x)end
function vector:__len()
return self:dot(self)end
function vector:len()
return sqrt(#self)end
function vector:str()
return self.x..","..self.y
end
function v(x,y)
return setmetatable({x=x,y=y
},vector)end
function mav(magnitude,angle)
return v(cos(angle),sin(angle))*magnitude
end
obfn={v=v,ln=line,rf=rectfill}
dirs=ob[[
v(-1,0),v(1,0),v(0,-1),v(0,1),
]]
inverse=ob[[2,1,4,3,]]
randomizer=object:extend[[
ctr=0,looseness=0.25,
no_repeats=f,
forced=o(),
]]
function randomizer:init()if self.range then
self.es={}
for i=self.range[1],self.range[2]do
add(self.es,i)end
end
self.last={}
for i,p in pairs(self.es)do
self.last[i]=-1
end
end
function randomizer:next(exclude)if #self.forced>0 then
local v=self.forced[1]
del(self.forced,v)
return v
end
while true do
local i=rndi(1,#self.es)local prob=self.ctr-self.last[i]
if rnd()<prob then
local e=self.es[i]
if e~=exclude then
self.last[i]=self.ctr-(self.no_repeats and self.looseness or 0)
self.ctr+=self.looseness
return e
end
end
end
end
function randomizer:force(values)self.forced=values
end
function force(obj,random_map)for k,f in pairs(random_map)do
obj[k.."rnd"]:force(f)end
end
function init_palettes()local a=0x5000
for p=0,31 do
for c=0,15 do
poke(a,bor(sget(p,c),c==13 and 0x80))
a+=1
end
end
end
function set_palette(no)memcpy(0x5f00,0x5000+shl(flr(no),4),16)end
printa_pat=ob[[
o(x=0,y=0,c=1),
]]
printsh_pat=ob([[
o(x=-1,y=-1,c=2),
o(x=0,y=-1,c=2),
o(x=1,y=-1,c=2),
o(x=-1,y=0,c=2),
o(x=1,y=0,c=2),
o(x=-1,y=1,c=2),
o(x=0,y=1,c=2),
o(x=1,y=1,c=2),
o(x=0,y=0,c=1),
]])printdsh_pat=ob([[
o(x=0,y=2,c=3),
o(x=-1,y=2,c=3),
o(x=-1,y=1,c=3),
o(x=-1,y=0,c=3),
o(x=-1,y=-1,c=3),
o(x=0,y=-1,c=3),
o(x=1,y=-1,c=3),
o(x=1,y=0,c=3),
o(x=1,y=1,c=3),
o(x=1,y=2,c=3),
o(x=0,y=1,c=2),
o(x=0,y=0,c=1),
]])function e_reset()entities,entities_with,entities_tagged={},{},{}
end
function e_add(e)add(entities,e)for p in all(indexed_properties)do
if (e[p])index_add(entities_with,p,e)
end
for t in all(e.tags)do
index_add(entities_tagged,t,e)end
return e
end
function e_remove(e)if e.children then
foreach(e.children,e_remove)end
if e.parent then
del(e.parent.children,e)end
del(entities,e)for p in all(indexed_properties)do
if (e[p])del(entities_with[p],e)
end
for t in all(e.tags)do
del(entities_tagged[t],e)end
end
indexed_properties=ob([[
"r1","r2","r3","r4","r5","r6","r7","r8","r9",
"layout",
]])function e_update_all()for _,ent in pairs(entities)do
local fn=ent[ent.state]
if fn then
fn(ent,ent.t)end
if ent.done then
e_remove(ent)end
ent.t+=1
end
end
entity=object:extend([[
state="idle",t=0,
draw_order=5,
llerp=0.15,
]])entity.init=e_add
function entity:become(state)self.state,self.t=state,0
end
function entity:is_a(tag)
return index_of(self.tags,tag)end
function r_render_all()for z=1,9 do
local prop="r"..z
local ord,mn,mx={},127,0
for _,ent in pairs(entities_with[prop]or {})do
local order=ent.pos and flr(ent.pos.y)or 0
index_add(ord,order,ent)
if (order<mn)mn=order
if (order>mx)mx=order
end
for o=mx,mn,-1 do
for ent in all(ord[o])do
ent[prop](ent,ent.pos)set_palette()end
end
end
end
function l_do_layouts()for e in all(entities_with.layout)do
for i,c in pairs(e.children or {})do
e:layout(c,i)end
end
end
function l_apply(e)local lpos=e.lpos or e.pos
e.pos=#(e.pos-lpos)<0.25 and lpos+v(0,0)or lerp(e.pos,lpos,e.llerp)end
function draw_from_template(tpl,trans)for e in all(tpl)do
call(obfn[e.fn],e)end
end
function shadow(x1,y1,x2,y2,plt)if x2-x1>63 then
shadow(x1,y1,x1+63,y2,plt)shadow(x1+64,y1,x2,y2,plt)
return
end
x1,x2,y1,y2=
round(x1),round(x2),round(y1),round(y2)local al,ar=0,0
if x1%2==1 then
x1-=1
al=1
end
if x2%2==0 then
x2+=1
ar=1
end
local memw=(x2-x1+1)/2
local saddr=0x6000+shl(y1,6)+x1/2
local daddr=0x1800
for y=y1,y2 do
memcpy(daddr,saddr,memw)
saddr+=64
daddr+=64
end
set_palette(plt)palt(13,false)local w,h=x2-x1+1-al-ar,y2-y1+1
sspr(al,96,w,h,x1+al,y1)set_palette()end
obfn.sh=shadow
function move(child,parent)local prev=child.parent
if (prev)del(prev.children,child)
if (parent)index_add(parent,"children",child)
child.parent=parent
child.moved_on=g_move_ctr
g_move_ctr+=0x0.001
end
function is_empty(parent)
return #(parent.children or {})==0
end
bg=entity:extend()function bg:r1()palt(13,false)map(0,0,-4,-5,17,17)for y=0,8 do
set_palette((y+8)/4)palt(13,false)sspr(0,88+y*2%8,104,1,12+y,99+y,104-y*2,1)end
rectfill(21,108,106,108,0)set_palette()spr(100,28,109,2,1)spr(116,82,109,2,1)end
pointer=entity:extend[[
pos=v(64,64),
script=o(),
delay=15,
]]
function pointer:idle()if self.options then
if #self.script>0 then
if self.prompt then
self.delay=60
if btnp(4)then
self.prompt:dismiss()self.prompt=nil
end
end
if self.delay>0 then
self.delay-=1
else
self:s_op(self:s_pop())
return
end
end
if #self.script==0 then
for d=1,4 do
if btnp(d-1)then
self:move(d)sfx(2)end
end
if btnp(5)and self.cancellable then
self:pick()
return
elseif btnp(4)then
self:confirm()
return
end
end
self.lpos=self.tgt.pos+self.tgt.sz*0.5
l_apply(self)end
end
function pointer:confirm()self:pick(self.tgt)end
function pointer:pick(choice)self.runner:unblock(choice)self.options=nil
self:select()end
function pointer:choose(r,os,cancellable)self.runner,self.options,self.cancellable=r,os,cancellable
local tgt=min_by(os,function(o)
return #(self.pos*0.01-o.pos*0.01)end)self:select(tgt)end
function pointer:move(d)d=dirs[d]
local tgt,mc=min_by(self.options,function(o)
if (o==self.tgt)return 32767
return move_cost(self.tgt.pos,o.pos,d)end)
if (tgt and mc<32767)self:select(tgt)
end
function pointer:select(option)if self.tgt then
self.tgt.selected=false
event(option,"on_deselect")end
self.tgt=option
if option then
option.selected=true
event(option,"on_select")end
end
function pointer:r9(p)if self.options then
spr(4,p.x,p.y)end
end
function move_cost(from,to,d)local delta=to-from
while abs(d.x)~=0 and sgn(delta.x)~=sgn(d.x)do
delta.x+=sgn(d.x)*128
end
while abs(d.y)~=0 and sgn(delta.y)~=sgn(d.y)do
delta.y+=sgn(d.y)*128
end
delta*=0.1
local dot=delta:norm():dot(d)
if (dot<=0.5)return 32767
local mul=1+(1-dot)*10
return #delta*mul
end
function pointer:s_pop()local v=self.script[1]
del(self.script,v)
return v
end
function pointer:s_op(op)if op=="move" then
self:move(self:s_pop())self.delay=25
elseif op=="prompt" then
local n=self:s_pop()local a=clone(anims["prompt"..n])for n=1,n do
local txt=""each_char(self:s_pop(),function(c)txt=txt..(c=="/" and "," or c)end)a[n+2].t=txt
end
self.prompt=animation({dur=30,elems=a,locked=true})elseif op=="wait" then
self.delay=60
elseif op=="reset" then
g_tutorial=false
g_game.score=0
g_game.best_cake=0
e_remove(g_reqs)e_remove(g_recipe)g_reqs=reqs()g_reqs:generate()g_reqs:co_next()else
self[op](self)self.delay=60
end
end
particle=object:extend([[
drag=1,l=1,d=0.016666,
grav=0,
]])particles=entity:extend([[
]])function particles:init()self.ps={}
end
function particles:idle()for k,p in pairs(self.ps)do
p.p+=p.v
p.v*=p.drag
p.v.y+=p.grav
p.l-=p.d
if (p.l<=0)self.ps[k]=nil
end
end
function particles:spawn(props)self.ps[rnd()]=particle(props)end
function particles:r8()for _,p in pairs(self.ps)do
local pos=p.p
if p.radius then
circfill(pos.x,pos.y,p.radius*p.l,p.clr)end
if p.sradius then
local s=1-abs(p.l-0.5)*2
circfill(pos.x,pos.y,p.sradius*s,p.clr)end
end
end
floater=entity:extend[[
]]
function floater:idle()
self.vel+=v(0,0.15)
self.vel*=0.98
self.pos+=self.vel
self.done=self.pos.y>128
end
function floater:r9(p)local w=#self.text*4
printdsh(self.text,p.x,p.y,self.clr,4,0.5)end
announce_clrs=ob[[6,7,9,10,12,]]
function announce(text,clr,cards,ps)
ps=ps or 1
local t=v(0,0)
for c in all(cards)do
t+=c.pos+v(12,12)
end
t/=#cards
local d=0.05*(64-t.x)/64
floater({
text=text,clr=clr,pos=t,
vel=mav(2,rndf(0.2,0.3)+d)
})
for i=1,ps*g_combo.count*10 do
local v=mav(rndf(0.7,1.2),rndf(0,0.5))
g_particles:spawn({
p=t+v*2,v=v,
radius=rndf(1,3),
clr=announce_clrs[rndi(1,#announce_clrs)],
grav=0.02,drag=0.99,
d=0.02,l=rndf(1,1.3),
})
end
end
fingers=entity:extend[[
pos=v(52,84),
]]
function fingers:layout(c)c.lpos=self.pos+mav(4,self.t/100)end
gravity={}
function gravity:falling()
self.vel+=v(0,0.2)
self.pos+=self.vel
self.done=self.pos.y>150
end
function gravity:fall()local d=(64-self.pos.x)/64*0.4
self.vel=v(rndf(-0.4,0.4)+d,-2)self:become("falling")end
reqs=entity:extend[[
next_value=1,
]]
function reqs:init()self.krnd=randomizer({range={0,5},looseness=0.33,no_repeats=true
})self.ttrnd=randomizer({range={1,#tray_types},looseness=1,no_repeats=true,})end
function reqs:generate()local kind=self.krnd:next()local trayt=tray_types[self.ttrnd:next()]
local u=upcoming({trayt=trayt,value=self.next_value,kind=kind
})move(u,self)
self.next_value+=1
end
function reqs:co_next()g_recipe=recipe(self.children[1])set(g_recipe,recipe)e_remove(self.children[1])self:generate()end
function reqs:layout(c,i)c.lpos=v(18+i*8,0)end
function reqs:r7()cutebox(0,3,34,4,1,5,0)printdsh("next:",3,1,13,1)end
upcoming=entity:extend[[
pos=v(44,-10),
]]
function upcoming:idle()l_apply(self)end
function upcoming:r8(p)set_palette(24+self.kind)spr(174,p.x,p.y)end
recipe=entity:extend[[
pos=v(0,-40),
lpos=v(1,-2),
glow=0,
]]
set(recipe,gravity)function recipe:idle()l_apply(self)end
function recipe:r9(p)camera(-p.x,-p.y)if self.glow>0 then
set_palette(mid(16+self.glow,16,21))
self.glow-=0.5
end
spr(189,-1,0,3,4)if not self.fulfilled then
printa(self:text(),12,19,4,0.5)else
spr(255,7,18)end
set_palette(6)palt(13,false)palt(3,true)spr(64+self.kind*2,4,3,2,2)camera()end
function recipe:recheck()local total=0
for slot in all(g_tray.children)do
local c=slot:card()if c and c.kind==self.kind then
total+=c.score
end
end
local fulfilled=total>=self.value
if fulfilled and not self.fulfilled then
self.glow=12
self:fall()animation({elems=anims.recipe_clear,dur=45,})end
self.fulfilled=fulfilled
end
function recipe:text()
return self.value.."+"end
animation=entity:extend[[
dur=60,at=0,
]]
function animation:idle()
self.at+=1
if self.locked and self.at>self.dur then
self.at=self.dur
end
self.done=self.at>self.dur*2.5
end
function animation:dismiss()self.locked=false
end
function animation:r8()local t=1-self.at/self.dur
t=t^5
for e in all(self.elems)do
local dt=t*128
if (e.sym)dt=abs(dt)
animation[e.fn](e.d*dt,e)end
end
function animation.sh(d,o)local p=o.p+d
local c=p+o.s
p.x=max(round(p.x),0)p.y=max(round(p.y),0)c.x=min(round(c.x),127)c.y=min(round(c.y),127)if p.x~=c.x and p.y~=c.y then
shadow(p.x,p.y,c.x,c.y,o.plt)end
end
function animation.dspr(d,o)
if (o.blink and g_t%(o.blink*2)<o.blink)return
spr(o.sp,o.p.x+d.x,o.p.y+d.y,o.s.x,o.s.y)end
function animation.pdsh(d,o)printdsh(o.t,o.p.x+d.x,o.p.y+d.y,o.c1,o.c2,o.a)end
function animation.bar(d,o)local p=o.p+d
local c=p+o.s
rectfill(p.x,p.y,c.x,c.y,o.c)end
anims={}
anims.recipe_clear=ob[[
o(fn="sh",d=v(-2,0),p=v(0,49),s=v(127,2),plt=3),
o(fn="pdsh",p=v(64,48),d=v(1,0),t="recipe cleared!",c1=7,c2=5,a=0.5),
]]
anims.prompt2=ob[[
o(fn="bar",d=v(2,0),p=v(0,27),s=v(127,22),c=0),
o(fn="bar",d=v(2,0),p=v(0,28),s=v(127,0),c=13),
o(fn="pdsh",p=v(64,31),d=v(-1,0),t="",c1=7,c2=13,a=0.5),
o(fn="pdsh",p=v(64,40),d=v(1,0),t="",c1=7,c2=13,a=0.5),
o(fn="dspr",p=v(118,45),d=v(1,0),s=v(1,1),sp=25,blink=45),
]]
anims.prompt3=ob[[
o(fn="bar",d=v(2,0),p=v(0,23),s=v(127,31),c=0),
o(fn="bar",d=v(2,0),p=v(0,24),s=v(127,0),c=13),
o(fn="pdsh",p=v(64,27),d=v(-1,0),t="",c1=7,c2=13,a=0.5),
o(fn="pdsh",p=v(64,36),d=v(1,0),t="",c1=7,c2=13,a=0.5),
o(fn="pdsh",p=v(64,45),d=v(-1,0),t="",c1=7,c2=13,a=0.5),
]]
anims.made_cake=ob[[
o(fn="bar",d=v(-2,0),p=v(0,40),s=v(127,0),c=0),
o(fn="bar",d=v(-2,0),p=v(0,71),s=v(127,0),c=0),
o(fn="sh",d=v(2,0),p=v(0,40),s=v(127,1),plt=2),
o(fn="sh",d=v(2,0),p=v(0,42),s=v(127,29),plt=3),
o(fn="dspr",p=v(48,32),d=v(0,-1),sym=1,sp=134,s=v(4,3)),
o(fn="pdsh",p=v(64,52),d=v(1,0),t="fabulous cake!",c1=7,c2=13,a=0.5),
o(fn="pdsh",p=v(64,61),d=v(-1,0),t="24 points!",c1=10,c2=4,a=0.5),
]]
anims.failed_cake=ob[[
o(fn="bar",d=v(-2,0),p=v(0,46),s=v(127,0),c=0),
o(fn="bar",d=v(-2,0),p=v(0,68),s=v(127,0),c=0),
o(fn="sh",d=v(2,0),p=v(0,46),s=v(127,1),plt=2),
o(fn="sh",d=v(2,0),p=v(0,48),s=v(127,20),plt=4),
o(fn="pdsh",p=v(78,46),d=v(1,0),t="not enough chocolate!",c1=14,c2=2,a=0.5),
o(fn="pdsh",p=v(42,56),d=v(-1,0),t="final score:",c1=10,c2=4,a=0),
o(fn="pdsh",p=v(42,64),d=v(1,0),t="best cake:",c1=10,c2=4,a=0),
o(fn="pdsh",p=v(114,56),d=v(-1,0),t="12345",c1=7,c2=5,a=1),
o(fn="pdsh",p=v(114,64),d=v(1,0),t="123",c1=7,c2=5,a=1),
]]
cake_qualities=ob[[
o(5,"nice"),
o(15,"tasty"),
o(25,"yummy"),
o(40,"delicious"),
o(60,"luscious"),
o(80,"scrumptious"),
o(160,"heavenly"),
o(320,"divine"),
o(640,"unbelievable"),
]]
combo=entity:extend[[
pos=v(64,83),
lpos=v(64,83),
ctr=v(32,51),
count=0,
llerp=0.3,
glow=0,
]]
function combo:idle()l_apply(self)end
function combo:bump(by)
self.count+=by
self.pos-=v(0,10)
end
function combo:reset()self.count=0
self.pos=combo.pos
self.lpos=combo.pos
end
function combo:co_apply()local bonus=self.count-1
self.glow=12
local cs=card.played_in_move_order()for frm=0,30 do
local t=frm/30
local ang=lerp(0,0.6,t)
self.lpos+=mav(lerp(3,12,t),ang)
local crd=cs[frm/5]
if crd then
crd:point_out()
crd.score+=bonus
co_update_state()announce("+"..bonus,10,{crd},0.3)sfx(3)end
g_rnr:delay(1)yield()end
end
function combo:r8(p)local cnt=self.count
set_palette(mid(16,21,self.glow))if cnt>=2 then
spr(128,p.x-19,p.y,5,2)printdsh(cnt,p.x+19,p.y+4,10,4,0.5)end
end
tray_types=ob[[
o(
mx=36,my=0,
grid=o(
v(0,0),v(1,0),
v(0,1),v(1,1),v(2,1),
),
rpos=v(84,21),
),
o(
mx=48,my=0,
grid=o(
v(1,0),v(2,0),
v(0,1),v(1,1),v(2,1),
),
rpos=v(18,18),
),
o(
mx=60,my=0,
grid=o(
v(0,0),v(2,0),
v(0,1),v(1,1),v(2,1),
),
rpos=v(53,13),
),
]]
tray=entity:extend[[
tags=o("tray"),
score=0,
shake=0,
]]
set(tray,gravity)function tray:init()set(self,self.trayt)self.slots={}
for c in all(self.grid)do
local s=
slot({tray=self,coords=c
})self.slots[c:str()]=s
move(s,self)end
end
function tray:idle(t)l_apply(self)if self.shake>0 then
self.pos+=v(sin(t/15)*self.shake,0)
self.shake-=0.15
end
end
function tray:anim_shake()self.shake=5
end
function tray:update_score()local total=0
for s in all(self.children)do
local sc=s:card()
if (sc)total+=sc.score
end
self.score=total
end
function tray:co_complete()local rec=g_recipe
if not rec.fulfilled then
self:co_fail()
return false
end
for s in all(self.children)do
s:card():point_out()end
music(0)g_rnr:delay(15)yield()self:fall()local score=self.score
g_game:score_cake(score)local quality=min_by(cake_qualities,
function(q)return abs(q[1]-score)end)[2]
anims.made_cake[6].t=quality.." cake!"anims.made_cake[7].t=score.." points!"animation({elems=anims.made_cake})g_rnr:delay(90)yield()
return true
end
function tray:co_fail()if g_game.score>dget(0)then
dset(0,g_game.score)end
self:anim_shake()music(1)g_recipe.lpos=v(8,44)e_remove(g_reqs)e_remove(g_game)local f=anims.failed_cake
f[5].t="not enough "..kinds[g_recipe.kind+1].."!"f[8].t=tostr(g_game.score)f[9].t=tostr(g_game.best_cake)local anim=animation({elems=f,locked=1
})g_rnr:waitforbtn()yield()anim:dismiss()g_recipe:fall()self:fall()end
function tray:is_complete()
return #filter(self.children,is_empty)==0
end
function tray:anim_nudge()
self.pos.y+=4
end
function tray:r2(p)palt(3,true)palt(13,false)map(self.mx,self.my,p.x-8,p.y-8,11,9)end
slot=entity:extend[[
tags=o("slot"),
sz=v(24,24),
]]
function slot:idle()self.pos=self.tray.pos+self.coords*24
end
function slot:layout(child,i)child.lpos=self.pos
end
function slot:on_select()self:evaluate_drop()end
function slot:evaluate_drop()local fc=g_fingers.children and g_fingers.children[1]
local effects={}
for d=1,4 do
local ns=self:neighbour(d)local nc=ns and ns:card()if nc then
if nc.kind==fc.kind then
add(effects,{d=d,c=12})end
local fl=fc.links[d]
if fl and fl.kind==nc.kind then
add(effects,{d=d,c=9})end
local id=inverse[d]
local nl=nc.links[id]
if nl and nl.kind==fc.kind then
add(effects,{d=d,c=9,inv=true})end
end
end
self.effects=effects
end
function slot:neighbour(direction)local dc=self.coords+dirs[direction]
local slot=self.tray.slots[dc:str()]
return slot
end
function slot:neighbours()local ns={}
for d=1,4 do
add(ns,self:neighbour(d))end
return ns
end
function slot:card()
return self.children and self.children[1]
end
function slot:r3(p)if self.selected then
local d=flr(self.t%30/15)camera(-p.x,-p.y)spr(9,1+d,1+d)spr(9,15-d,1+d,1,1,true)spr(9,15-d,15-d,1,1,true,true)spr(9,1+d,15-d,1,1,false,true)camera()end
end
function slot:r9(p)if self.selected then
camera(-p.x,-p.y)for e in all(self.effects)do
if self.t%10==e.d then
local p=self.pos+v(12+rndf(-1,1),12+rndf(-1,1))local v=dirs[e.d]
if e.inv then
p+=v*24
v*=-1
end
g_particles:spawn({p=p,v=v,d=0.05,radius=2.5,clr=e.c,})end
if self.t%45==0 then
self:neighbour(e.d):card():point_out(6)end
end
camera()end
end
kinds=ob[[
"chocolate","jam",
"raisins","honey",
"dough","nuts",
]]
card=entity:extend[[
tags=o("card"),
t_bg=o(o(1,1,22,22,13,fn="rf")),
t_sides=o(
o(o(0,1,0,22,1,fn="rf"),
o(1,1,1,22,7,fn="rf")),
o(o(23,1,23,22,0,fn="rf"),
o(22,1,22,22,5,fn="rf")),
o(o(1,0,22,0,1,fn="rf"),
o(1,1,22,1,7,fn="rf")),
o(o(1,23,22,23,0,fn="rf"),
o(1,22,22,22,5,fn="rf")),
),
sz=v(24,24),
glow=0,
]]
cardbg=ob[[
o(0,0,23,23,13,fn="rf"),
]]
function card:init()self.icn=64+self.kind*2
end
function card:idle()l_apply(self)end
function card:point_out(n)self.glow=n or 9
end
function card.played_in_move_order()local played=filter(entities_tagged.card,function(c)
return c.parent and c.parent:is_a("slot")end)
return sort_by(played,function(c)
return -c.moved_on
end)end
function card:find_pulls()local ps={}
for d=1,4 do
local l=self.links[d]
if l then
local nc=self:neighbour(d)if nc and nc.kind==l.kind then
add(ps,make_pull(self,l))end
end
end
return ps
end
function card:neighbour(d)local slt=self.parent
if (not slt)return
local ns=slt:neighbour(d)
return ns and ns:card()end
function card:find_fused()local fs={}
for d=1,4 do
local nc=self:neighbour(d)if nc and nc.kind==self.kind then
add(fs,nc)end
end
return fs
end
function card:co_place(slot)self.llerp=0.5
move(self,slot)slot.tray:anim_nudge()g_rnr:delay(8)yield()end
function card:co_fuse_with(cs)self:point_out()for c in all(cs)do
c:point_out()
self.score+=c.score
self.links=merge(c.links,self.links)end
sfx(min(5+g_combo.count,8))announce("fuse!",10,{self,other})g_rnr:delay(15)yield()for c in all(cs)do
c.llerp=0.15
move(c,self.parent)end
g_rnr:delay(12)yield()foreach(cs,e_remove)end
function card:r7(p)if not self.parent:is_a("slot")then
for dy=0,2 do
shadow(p.x+dy,p.y+23+dy,p.x+24-dy,p.y+23+dy,2)end
shadow(p.x+24,p.y+2,p.x+24,p.y+22,2)end
set_palette(16+mid(self.glow,0,5))
if (self.glow>0)self.glow-=0.5
camera(-p.x,-p.y)draw_from_template(card.t_bg)for s=1,4 do
draw_from_template(card.t_sides[s])end
for d,l in pairs(self.links)do
local lp=v(8,8)+dirs[d]*12
set_palette(24+l.kind)spr(169+d,lp.x,lp.y)end
set_palette(16+mid(self.glow,0,5))palt(3,true)palt(13,false)spr(self.icn,4,4,2,2)set_palette(self.kind+8)local ln=#tostr(self.score)spr(136+ln*2,5+ln*2,18,2,2)print(self.score,20-2*ln,20,8)camera()end
pull=object:extend[[
]]
function pull:conflicts_with(other)
return #filter(self.cards,function(c)
return index_of(other.cards,c)end
)>0
end
function pull:merge_with(with)local crds=clone(self.cards)for c in all(with.cards)do
if not index_of(crds,c)then
add(crds,c)end
end
local lnks=concat(self.links,with.links
)
return pull({cards=crds,links=lnks
})end
function pull:score()local _,bonus=min_by(self.cards,
function(c)return c.score end
)for c in all(self.cards)do
c:point_out()
c.score+=bonus*(#self.links)
end
for l in all(self.links)do
announce("link +"..bonus.."!",10,{l.crd,l.other})end
end
function pull:swap()for l in all(self.links)do
l.crd.links[l.d]=nil
end
if #self.cards==2 then
local a,b=self.cards[1],self.cards[2]
a.llerp,b.llerp=0.2,0.2
local ap,bp=a.parent,b.parent
move(a,bp)move(b,ap)end
end
function make_pull(card,link)local d=link.direction
local other=card:neighbour(d)
return pull({links={{crd=card,other=other,d=d}},cards={card,other}
})end
function co_execute_pulls(ps)sfx(min(5+g_combo.count,8))foreach(ps,pull.score)g_rnr:delay(12)yield()foreach(ps,pull.swap)g_rnr:delay(12)yield()end
function merge_pulls(ps)local nothing_merged
repeat
nothing_merged=true
for i=1,#ps do
for j=i+1,#ps do
local a,b=ps[i],ps[j]
if a:conflicts_with(b)then
local n=a:merge_with(b)del(ps,a)del(ps,b)add(ps,n)nothing_merged=false
goto retry
end
end
end
::retry::
until nothing_merged
return ps
end
hand=entity:extend[[
rnds=o(
k=o(range=o(0,5)),
ld=o(range=o(1,4),looseness=0.5),
lk=o(range=o(0,5)),
v=o(es=o(1,2,2,3)),
),
]]
function hand:init()self.children={}
for k,v in pairs(self.rnds)do
self[k.."rnd"]=
randomizer(v)end
end
function hand:co_deal_new(force_recipe)local ch=self.children
if (#ch>=5)return
local k
local forced=
force_recipe and
#ch==4 and
#filter(ch,function(c)
return c.kind==g_recipe.kind
end)==0
if forced then
k=g_recipe.kind
end
if not k then
k=self.krnd:next()end
local c=card({pos=v(144,140),lpos=v(144,140),kind=k,score=self.vrnd:next(),links={}
})local link_count=1
for l=1,link_count do
local link_k,link_d
repeat
link_k=
self.lkrnd:next(k)link_d=
self.ldrnd:next()until not c.links[link_d]
c.links[link_d]={direction=link_d,kind=link_k}
end
move(c,self)sfx(1)g_rnr:delay(8)yield()end
function hand:layout(child,i)local n=#self.children
local x=64+(i-1-n/2)*25
child.lpos=v(x,101-(child.selected and 4 or 0))end
anims.logo=ob[[
o(fn="sh",d=v(0,-1),p=v(0,18),s=v(127,2),plt=2),
o(fn="sh",d=v(0,-1),p=v(0,20),s=v(127,22),plt=3),
o(fn="bar",d=v(0,-1),p=v(0,18),s=v(127,0),c=0),
o(fn="bar",d=v(0,-1),p=v(0,43),s=v(127,0),c=0),
o(fn="dspr",d=v(0,1),p=v(44,17),s=v(5,4),sp=10),
]]
function logo()
return animation({dur=45,elems=anims.logo,locked=true
})end
blinker=entity:extend[[
]]
function blinker:r8(p)
if (self.t<60)return
local t=(self.t-60)%90
if t<=45 then
printdsh(self.text,p.x,p.y,10,4,0.5)end
if (t==0)sfx(2)
end
menu_text=entity:extend[[]]
function menu_text:r8()
if dget(0)>0 then
printdsh("best score: "..dget(0),64,111,7,13,0.5)
printdsh("best cake: "..dget(1),64,119,7,13,0.5)
else
printdsh("controls:",64,99,7,13,0.5)
printdsh("arrows - select things",64,109,6,1,0.5)
printdsh("[z]- confirm  [x]- cancel",64,117,6,1,0.5)
end
end
menu_op=entity:extend[[
sz=v(122,10),
]]
function menu_op:r8(p)local sh=self.selected and 3 or 2
shadow(p.x,p.y-1,p.x+71,p.y+8,sh)printdsh(self.text,p.x+36,p.y+1,10,4,0.5)end
function main_menu(rnr)while true do
local s,htp=
menu_op({text="start game",pos=v(28,61)}),menu_op({text="how to play",pos=v(28,74)})local menu_entities={logo(),menu_text(),s,htp
}
g_chooser.pos=v(64,40)g_rnr:choose({s,htp})local choice=yield()g_tutorial=choice==htp
foreach(menu_entities,e_remove)co_init_game()if g_tutorial then
co_init_tutorial()end
game_logic(rnr)co_end_game()g_rnr:delay(75)yield()end
end
game=entity:extend[[
score=0,best_cake=0,
]]
function game:score_cake(pts)self.best_cake=max(pts,self.best_cake)if pts>dget(1)and not g_tutorial then
dset(1,pts)end
self.score+=pts
end
function game:r8()local w=#tostr(self.score)*4
cutebox(99-w,0,127,7,1,5,0)printdsh(self.score,126,1,7,5,1)printdsh("score:",126-w,1,13,1,1)end
tray_def=ob[[
pos=v(-40,24),
lpos=v(27,28),
]]
function co_update_state()g_tray:update_score()g_recipe:recheck()end
function game_logic(rnr)g_reqs:generate()g_reqs:co_next()while true do
g_combo:reset()if not g_tray then
g_tray=tray(set(tray_def,{trayt=g_recipe.trayt
}))while #g_hand.children<5 do
g_hand:co_deal_new(true)end
end
if is_empty(g_hand)then
return
end
rnr:choose(g_hand.children)local card=yield()move(card,g_fingers)sfx(1)rnr:choose(filter(entities_tagged.slot,is_empty
),true)local spot=yield()if not spot then
move(card,g_hand)sfx(1)goto cancelled
end
card:co_place(spot)co_update_state()sfx(0)local triggered
local pulls
repeat
triggered=false
for card in all(card.played_in_move_order())do
local fused=card:find_fused()if #fused>0 then
g_combo:bump(1)card:co_fuse_with(fused)for i=1,#fused do
g_hand:co_deal_new()end
triggered=true
goto reevaluate
end
end
pulls={}
for c in all(card.played_in_move_order())do
pulls=concat(pulls,c:find_pulls())end
pulls=merge_pulls(pulls)if #pulls>0 then
g_combo:bump(#pulls)co_execute_pulls(pulls)if not g_tray:is_complete()then
g_hand:co_deal_new()end
triggered=true
goto reevaluate
end
::reevaluate::
co_update_state()until not triggered
if g_combo.count>=2 then
g_combo:co_apply()end
if g_tray:is_complete()then
local valid=g_tray:co_complete()if not valid then
return
end
g_tray=nil
g_reqs:co_next()end
::cancelled::
end
end
runner=object:extend[[
blocked=f,
]]
function runner:start(logic)self.value=self
self.co=cocreate(logic)end
function runner:process()if not self.blocked then
if (costatus(self.co)=="dead")return
g_rnr=self
assert(coresume(self.co,self.value))g_rnr=nil
self.value=true
end
end
function runner:unblock(value)self.value,self.blocked=value
end
function runner:delay(dur)self.blocked=true
delay({runner=self,dur=dur})end
function runner:waitforbtn()self.blocked=true
waitforbtn({runner=self})end
function runner:choose(options,cancellable)self.blocked=true
g_chooser:choose(self,options,cancellable)end
delay=entity:extend()function delay:idle()self.done=self.t>=self.dur
if self.done then
self.runner:unblock()end
end
waitforbtn=entity:extend()function waitforbtn:idle()for b=4,5 do
if btnp(b)then
self.done=true
self.runner:unblock()end
end
end
tutorial=ob[[
cards=o(
k=o(0,0,1,3,4,5),
ld=o(1,2,3,4,1,3),
lk=o(1,3,3,2,2,0),
),
recipes=o(
k=o(0),
tt=o(1),
),
script=o(
"prompt",2,
"you're baking cakes",
"for the holidays!",
"prompt",2,
"you do this by putting",
"ingredients into the tray.",
"move",2,
"move",2,
"confirm",
"move",1,
"move",1,
"move",3,
"move",2,
"move",4,
"move",2,
"confirm",
"prompt",2,
"you have to match the recipe",
"in the top-left corner.",
"prompt",3,
"this one means that the total",
"score on chocolate tiles used",
"in your cake must be 1 or more.",
"move",1,
"move",1,
"move",1,
"confirm",
"confirm",
"prompt",2,
"the recipe will fall away",
"when it's finished.",
"prompt",3,
"if you place two identical",
"tiles next to each other/",
"they will fuse.",
"move",1,
"confirm",
"move",3,
"move",1,
"move",2,
"move",4,
"confirm",
"prompt",2,
"tiles with different symbols",
"interact through links.",
"prompt",2,
"see these colored knobs",
"on the sides of your tiles?",
"prompt",3,
"a red knob on the left means",
"you can link to a red tile",
"through that side.",
"move",1,
"confirm",
"wait",
"confirm",
"prompt",2,
"this swaps the tiles and",
"adds bonus points to both.",
"prompt",2,
"forming longer combos adds",
"points to all your tiles.",
"confirm",
"move",2,
"wait",
"confirm",
"prompt",3,
"once the tray fills up/",
"the cake is scored",
"and a new recipe appears.",
"move",1,
"move",1,
"confirm",
"confirm",
"prompt",2,
"you're on your own now!",
"good luck!",
"reset",
),
]]
function grab()set_palette()palt(13,false)for k=0,5 do
sspr(k*16,32,16,16,0,0,8,8)for x=0,7 do
for y=0,7 do
sset(64+k*8+x,120+y,pget(x,y))end
end
end
cstore()end
function _init()init_palettes()e_reset()bg()g_particles=particles()g_chooser=pointer()g_runner=runner()g_runner:start(main_menu)end
function co_init_game()g_move_ctr=0
g_game=game()g_hand=hand()g_combo=combo()g_reqs=reqs()g_fingers=fingers()g_tray=nil
end
function co_end_game()local retiring={g_game,g_hand,g_combo,g_reqs,g_fingers
}
foreach(retiring,e_remove)end
function co_init_tutorial()force(g_hand,tutorial.cards)force(g_reqs,tutorial.recipes)g_chooser.pos=v(64,64)g_chooser.script=clone(tutorial.script)end
g_t=0
function _update60()
g_t+=1
l_do_layouts()e_update_all()g_runner:process()end
function _draw()cls()r_render_all()end
__gfx__
00000010000000000115550000000000000ddddd3333333333333333333333333333333300000dddddddd77772d7277772d777277772d7772ddddddd7777cccc
11100021010111001155dd0011111100077000dd3333333333333333333333333333333307760dddddddd7222727272222722227222272222ddddddd7777cccc
22110021222222002249f70002d49500d076760d3333333333333333333333333333333307000dddddddd72dd727272ddd72ddd72ddd72dddddddddd7777cccc
333110413333330033bb7700333333000707776033333333333333333333333333333333060dddddddddd77772d727772d72ddd7772dd772dddddddd7777cccc
42211041444444004499f70018c4f300d077766033333333333333333333333333333333000dddddddddd7222dd727222d72ddd7222dddd72dddddddccccdddd
55111041151555005dd6670055555500dd07668233333335111111111111111113333333dddddddddddddf2ddddf2f2dddf2dddf2ddddddf2dddddddccccdddd
66d510f5666666006677770066666600ddd0002033333357777766666666666660333333dddddddddddddf2ddddf2ffff22fff2ffff2fff22dddddddccccdddd
776d107d2e7a7b007777770077777700dddddd0d33333571000000000000000005033333ddddddddddddd22dddd2222222d2222222222222ddddddddccccdddd
882210419111410088ee77008888880000101010333331700000000000000000050d3333ddddddddddddddddddddddddddddddddddddddddddddddddcccc7777
9422109118c9f30099aa770018c9f30000101010333331700000000000000000050d333300d00ddddddddddddddddddd772d7772ddddddddddddddddcccc7777
a94210f5aaaaaa00a7777700aaaaaa0000101010333331700000000000000000050d33330a00a0ddddddddddd777fddf22f2f222dffffdddddddddddcccc7777
bb3310f5bbbbbb00bb777700bbbbbb0010101010333331600010101010101010050d33330a90a90ddddddddddd2222df2df2ff2d2222ddddddddddddcccc7777
ccd510f1cccccc00cc667700cccccc0010101010333331600010101010101010050d33330990990ddddddddddddfffdf2df2f22dfffdddddddddddddddddcccc
d5511091dddddd00ddd66700dddddd0010101010333331600010101010101010050d3333090090dddddddddddddd22d2ff22f2dd22dddddd41ddddddddddcccc
ee821095eeeeee00eeff7700eeeeee0010101010333331600010101010101010050d333300d00ddddddddddddddddddd222d22dddddddddd21ddddddddddcccc
f9421075086a7300fff777002e7a7b0010101010333331600010101010101010050d3333ddddddddddd42dddddd2ddddddddddddddddddddddd2ddddddddcccc
333331f0050d3333000000000000000000000000333331600010101010101010050d333300000000ddd2dd0000dddd0000dd00000000000000ddd21dddddcccc
33333160050d3333555555555555555555555555333331600010101010101010050d333300000000ddddd022220dd0222200222222222222220dd1ddddddcccc
33333160050d3333111111111111111111111111333331600010101010101010050d333300000000d2dd0299992002999020999099909999990dddddddddcccc
33333160050d3333ddd55ddddddddddddddd55dd333331600010101010101010050d333300000000ddd02944444029444402944094409444440dddddddddcccc
333331d0050d3333550650555555555555506505333331600010101010101010050d333300000000ddd09440044094404440444044404440000d2dddcccc7777
111111d005111111000650000000000000006500333331600010101010101010050d333300000000ddd0444010004440444044404440444011ddddddcccc7777
6666ddd005777766550650ddddddddddddd06505333331600010101010101010050d33330000000042d0444011104444424044244401424440ddddddcccc7777
0000000000000000dd506500000000000006505d333331600010101010101010050d33330000000022d0442011104242222042222011422240dd21ddcccc7777
000000000000000033d0566666666666666505d3333331610000000000000000050d333300000000ddd0422010004220422042204201422000dd11ddccccdddd
5555555005555555333d05555555555555505d33333331155555555555555555510d333300000000ddd0422001104220422042204220422000ddddddccccdddd
11111160050111113333d000000000000005d333333331511111111111111111150d333300000000ddd04220144042204220422042204220111dddddccccdddd
555551600505555533333d5555555555555d333333333305dddddddddddddddd50dd333300000000dddd0224422042204220422042204224440dddddccccdddd
0000016005000000333333ddddddddddddd33333333333d0555555555555555505d3333300000000ddddd022220042204220422042204222220dd1dd7777cccc
5555516005055555333333333333333333333333333333d500000000000000005d33333300000000dd2ddd0000d000000000000000000000000ddddd7777cccc
ddddd160050ddddd3333333333333333333333333333333d5555555555555555d333333300000000dddddddddddddddddddddddddddddddddddddddd7777cccc
333331600503333333333333333333333333333333333333dddddddddddddddd3333333300000000dddddddddddddddddddddddddddddddddddddddd7777cccc
3333333333333333333333333333333333332233333333333333333333333333333333ffff333333333333332222133312222221111112222222222200000000
3333333333333333337777766cd51333333272233333333333333333333555533ff3ff9999ff3ff3333333322ff9213311222111111112222222222200000000
3423331113333333377cc77cc66d5133332e2121333333333334444445576dd3f99f99999999f99f33333322ffff921311222212111111222222211200000000
321331992113333334c77cc77dd5523332722411333333333359999944ddd113f99999999999999f33333322fff9921311111222111111222211112200000000
3333194442111333374444422222211332e2e1113322233335997aa9942513333f999ffffff999f3333333292999211311111111111111122111122200000000
33312244210991137c77ccc76cc6dd5132221213327e22333549aa99442133333f9ffffffffff9f3333333249222421300000000111111111112222200000000
33110222109444213c57c5576556d55133111133312242133164999442133333f9ffffffffffff9f333222111444421300000000111111111122222200000000
312940010224442131855ee552855013333113333312111333164944213333339ffffffffffffff9332444222124211322224444111111112222222200000000
1294442001224221318ee7e82882203333333333333111333331494213333333f999ffffffff999f3249422ff212113311111111111111111111111111111110
1224422101122210318e77e882221033333222222133333333333942333333334f779ff99ff97ff4249742fff911133317776666666677777777666677776660
012222100011110331887e8828221033332e7e2e42133333333339233333333334ff7997799fff43249942fff91133331766ccccdddd66666666dddd6666dd50
30111100330000333188ee8228812033331222222113333333333923333333333544ffffffff44132444229f99133333176cddddddddccccccccddddccccdd50
3300110333333333312888828211103333312e4111333333333339233333333335d4444444444d1332422229921333331777cccccccc77777777cccc7777ccd0
3333003334233333331222222221033333331111133333333333342333333333335d677766ddd13333222222213333331777cccccccc77777777cccc7777ccd0
3333333331133333333111111000333333333333333333333333333333333333333511111111133333311111133333331777cccccccc77777777cccc7777ccd0
3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333331777cccccccc77777777cccc7777ccd0
ddddddddddddddddd2422211110ddddd01111100dddddddd122222211111222111222221111111111111111111222221176cdddd1777cccc7777ccd07777ccd0
ddddddd999dddddd241111111110ddddd02221100ddddddd112221111122211111111111111111111111111111111111176cdddd1777cccc7777ccd07777ccd0
dddddd977f4ddddd2122222222210ddddd02221100dddddd222222122221111211111111111111112111111122211112176cdddd1777cccc7777ccd07777ccd0
ddddd977f94ddddd1242424121210dddddd02221100ddddd221112222111122212221111111111112111111111122221176cdddd1777cccc7777ccd07777ccd0
dddd9777f94ddddd2424242212120ddddddd0222100ddddd1111111111111111111111111111111111111111111111111777cccc176cddddccccdd50ccccdd50
dddd97777f94dddd2444424121111dddddddd022100ddddd0000000000000000000000000000000000000000000000001777cccc176cddddccccdd50ccccdd50
dddd9777f994dddd24242411112210dddddddd0000dddddd0000000000000000000000000000000000000000000000001777cccc176cddddccccdd50ccccdd50
ddd9777f99494ddd244411242121010ddddddddddddddddd4444444444444444444444442222222244422222444444441777cccc16d5555555555550ccccdd50
dd97777777f994dd2441444242121110dddddddd011111002222222222222222222222221111111122221111222222221777cccccccc77777777ccccccccdd50
dd9f7777fff944ddd114242424211100ddddddd02221100d2222222222222222222222221111111122221111222222221777cccccccc77777777ccccccccdd50
d9777ff99944994ddd1442424211000ddddddd02221100dd2222222222222222222222221111111122222111222222221777cccccccc77777777ccccccccdd50
d97777777ff9942ddd211111110000ddddddd02221100ddd2222222222222222221222221111111122222111222222221777cccccccc77777777ccccccccdd50
d977777fff99442dddd222222200ddddddddd0221100dddd222222222222222222211222111111112222221122222222176cddddddddccccccccdddd7777ccd0
dd99ffff994442dddddd111111ddddddddddd011100ddddd222222222222211122221111111111111221111121112221176cddddddddccccccccdddd7777ccd0
ddd4444444422ddddddddddddddddddddddddd0000dddddd222222221112221111222111111111111122111111111111176cddddddddccccccccdddd7777ccd0
dddddddddddddddddddddddddddddddddddddddddddddddd222222222111222222222222111111112112211122111112176cdddd55555555555555557777ccd0
dd0000ddddddddddd000dddddddddddddddddddd00000000ddddddddddfffffff9999dddddddddddddddddddddd555ddddddddd5555555ddddd55555555555dd
d0aaaa0dddddddddd0a0dddddddddddddddddddd00000000dddddddf999944994422ff9ddddddddddddddddddd57775ddddddd577777775ddd5777777777775d
0aa4440dddddddddd0a0dddddddddddddddddddd00000000ddddddf944444149928824999dddddddddddddddd57ffff5ddddd57ffffffff5d57ffffffffffff5
0a90000d00ddd000d0a00ddd00dddddddddddddd00000000dddddf9f88229914499249419ff9ddddddddddddd57f9995ddddd57ff9999995d57ff99999999995
0a90ddd0aa0d0a0a00aaa0d0aa0dd00000dddddd00000000dddf9ff2882994111449941224299dddddddddddd5799995ddddd57f99999995d57f999999999995
0a90dd0a44a0a4a4a0a44a0a44a0d0a0a0dddddd00000000ddff92ff2244412281144992288299ddddddddddd1799991ddddd17999999991d179999999999991
0a90dd0a00a0a4a4a0a00a0a00a0d00a00dddddd00000000dff1111fffff222822f114499222199dddddddddd1799991ddddd17999999991d179999999999991
09900009009090909090090a00a0d09090dddddd00000000df1881144999ff422f99411449949491dddddddddd19991ddddddd199999991ddd1999999999991d
0499990499409040909994049940d04040dddddd00000000df28822114449994ff941221444994f1ddddddddddd111ddddddddd1111111ddddd11111111111dd
d04444004400400040444000440dd00000dddddd00000000dfff22f92121444ff9412288119941f1dddddddddddddddddddddddddddddddddddddddddddddddd
dd000000000000000000000000dddddddddddddd00000000ff99fff9128214ff9412228229442191dddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddd00000000ff11ff914f2222f94149922229421f91dddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddd00000000ff2ff914ffff4ff41144499921111f91dddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddd00000000df9f911144f9f4911811444494421911dddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddd00000000d199212211499f41822211144222f911dddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddd00000000d129f2228811999912882941122f9911dddddddddddddddddddddddddddddddddddddddddddddddd
000000000000000000000000000000000000000000000000dd122992222211499122942119999111dddd16dddd50dddddddddddddddddddddd000ddddddddddd
000000000000000000000000000000000000000000000000dd142fff99922214441229ff9922221ddddd106dd500ddddddddddddd500005dd0ff90dddd000ddd
000000000000000000000000000000000000000000000000ddd142fff929ffff99999229924221ddddd1920dd0920ddddddddddd509ff9050fff940d50ff905d
000000000000000000000000000000000000000000000000dddd1422224222999222244224221dddddd1f40dd0f40ddddd1111dd002442000ff9940dd0f940dd
000000000000000000000000000000000000000000000000ddddd11444444422244442222211ddddddd1f40dd0f40ddd119ff911dd0000dd0999440dd09440dd
000000000000000000000000000000000000000000000000ddddddd1122222222222222211ddddddddd1920dd0920ddd71244217ddddddddd04440dddd000ddd
000000000000000000000000000000000000000000000000ddddddddd111111111111111dddddddddddd106dd500ddddd600006ddddddddddd000ddddddddddd
000000000000000000000000000000000000000000000000dddddddddddddddddddddddddddddddddddd16dddd50dddddddddddddddddddddddddddddddddddd
176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50dd4444444444444ddddddddd
176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50dd477777777777f444444441
176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50dd4777fffffffffffffff991
176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50dd277fffffffffffffffff91
1777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777ccd0dd27ffffffffffffffffff91
1777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777ccd0dd27fffffffffffffffff991
1777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777ccd0dd27ffffffffffffffffff91
1777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777ccd0dd27ffffffffffffffffff91
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2222222e00000000000000000000000000000000dd27fffffffffffffffff991
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dd27ffffffffffffffffff91
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dd27ffffffffffffffffff91
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dd27ffffffffffffffff9f91
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dd27ffffffffffffffffff91
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dd277ffffffffffffffff991
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dd2777fffffffffffffff941
e22222222222222222222222222222222222222222222222222222222222222eeeeeeeee00000000000000000000000000000000dd277fffffffffffff99f941
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dd27fffffffffffffffff941
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dd27ffffffffffffffff991d
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dd27fffffffffffffff9941d
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000d277fffffffffffffff9941d
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000d27ffffffffffffffff9991d
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000d27ffffffffffffff99f941d
e22222222222222222222222222222222222222222222222222222222222222e2222222e000000000000000000000000000000002f9999ffffffffff99f991dd
e22222222222222222222222222222222222222222222222222222222222222eeeeeeeee0000000000000000000000000000000022229999fff9999f999941dd
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000d2f7299999999999999441dd
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dd2f24444499999999441ddd
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000ddd111011144444444441ddd
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dddddddddd1111111111dddd
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dddddddddddddddddddddddd
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dddddddddddddddddddddddd
e22222222222222222222222222222222222222222222222222222222222222e2222222e00000000000000000000000000000000dddddddddddddddddddddddd
e22222222222222222222222222222222222222222222222222222222222222eeeeeeeee00000000000000000000000000000000dddddddddddddddddddddddd
e22222222222222222222222222222222222222222222222222222222222222e2222222edddd1dddd576c51dd221dddddddddd55dddddddddddd221ddddddddd
e22222222222222222222222222222222222222222222222222222222222222e2222222eddd140ddd444222d2e11ddddd444d576d999999dddd24f91dddddd4d
e22222222222222222222222222222222222222222222222222222222222222e2222222edd04220dc7c75611221d92194aa9465594444449ddd24441ddddd94d
e22222222222222222222222222222222222222222222222222222222222222e2222222ed1402020d1ee820dd29d1e21599941dd9ffffff9d2211221d4ddd49d
e22222222222222222222222222222222222222222222222222222222222222e2222222e14220401d17e820ddddd9119d5941ddd9ff777f9294f911dd44d44dd
e22222222222222222222222222222222222222222222222222222222222222e2222222e1020101dd188820dd2e21ddddd9dddddd955559d244f91dddd444ddd
e22222222222222222222222222222222222222222222222222222222222222e2222222ed101d1ddd122220dd1211ddddd9dddddd1776d1d222421ddddd4dddd
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedd1ddddddd0000dddddddddddd4ddddddd1111ddd1111ddddddddddd
__label__
21000000000000000002222222220002222222222222222222222222222222222222222222222222222222222205550000000000000000000055500000000055
220dd00ddd0d0d0ddd0000222220bb30222222222222222222222222222222222222222222222222222222222205500dd00dd00dd0ddd0ddd000007770777055
000d1d0d110d0d01d100d000000bbb3300022222222222222222222222222222222222222222222222222222220550d110d110d1d0d1d0d1100d005570755055
550d0d0dd001d100d0001055550bb33305501111111111111111111111111111111111111111111111111111110110ddd0d000d0d0dd10dd0001007770777011
110d0d0d100d1d00d010d011110333330110666677777777666666667777777766666666777777776666666677011011d0d000d0d0d1d0d1000d007550557011
000d0d0ddd0d0d00d0001000000033300005dddd66666666dddddddd66666666dddddddd66666666dddddddd660110dd101dd0dd10d0d0ddd001007770777011
110101011101010010500055dddd000d555dddddccccccccddddddddccccccccddddddddccccccccddddddddcc01101100011011001010111000005550555011
110000000000000000cccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc7701100001000000000000000011100000000011
0000000000001777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc7770000000000000000000000000000000000000
0000000000001777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77766666dddddddd66666666dd50000000000000
4444444444441777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777ccd0222244444444
2222222222221777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777ccd0111112222222
2222222222221777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777ccd0111112222222
2222222222221777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777ccd0111111222222
2222221222221777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777ccd0111111222222
222222211222176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50111111122222
222122221111176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50111111112222
111111222111176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50111111111112
111222222222176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50111111112111
222111222221176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50111111111222
211111111111176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50111111111122
221211111111176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50111111111122
122212221111176cddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccddddddddccccccccdd50111111111111
1111111111111777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777ccd0111111111111
0000000000001777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777cccccccc77777777ccd0000000000000
0000000000001777cccccccc77511111111111111111111111111111111111111111111111117777cccccccc77777777cccccccc77777777ccd0000000000000
4444444444441777cccccccc75777776666666666666666666666666666666666666666666660777cccccccc77777777cccccccc77777777ccd0222222222222
2222222222221777cccccccc57100000000000000000000000000000000000000000000000005077cccccccc77777777cccccccc77777777ccd0111111111111
2222222222221777cccccccc170011111111111111111111110011111111111111111111110050d7cccccccc77777777cccccccc77777777ccd0111111111111
2222222222221777cccccccc170177777777777777777777770177777777777777777777770050d7cccccccc77777777cccccccc77777777ccd0111111111111
2222222222221777cccccccc17017dddddddddddddddddddd5017dddddddddddddddddddd50050d7cccccccc77777777cccccccc77777777ccd0111111111111
122222222222176cdddddddd16017dddddddddddddddddddd5017dddddddddddddddddddd50050dcddddddddccccccccddddddddccccccccdd50111111111111
111121112221176cdddddddd16017dddddd22dddddddddddd5017dddddddddddddddddddd50050dcddddddddccccccccddddddddccccccccdd50111111111111
211111111111176cdddddddd16017ddddd2722ddddddddddd5017ddddddddddddd5555ddd50050dcddddddddccccccccddddddddccccccccdd50111111111111
222222111112176cdddddddd16017dddd2e2121dddddddddd5017ddddd4444445576ddddd50050dcddddddddccccccccddddddddccccccccdd50111111111111
222111222221176cdddddddd16017ddd2722411dddddddddd5017dddd59999944ddd11ddd50050dcddddddddccccccccddddddddccccccccdd50111111111111
111111111111176cdddddddd16017ddd2e2e111dd222ddddd5016ddd5997aa994251ddddd50050dcddddddddccccccccddddddddccccccccdd50111111111111
111122211112176cdddddddd16017ddd222121dd27e22dddd50106dd549aa994421dddddd50050dcddddddddccccccccddddddddccccccccdd50111111111111
111111122221176cdddddddd16017dddd1111ddd122421ddd50f90dd1649994421ddddddd50050dcddddddddccccccccddddddddccccccccdd50111111111111
1111111111111777cccccccc16017ddddd11ddddd12111ddd507f0ddd16494421dddddddd50050d7cccccccc77777777cccccccc77777777ccd0111111111111
0000000000001777cccccccc16017ddddddddddddd111dddd507f0dddd149421ddddddddd50050d7cccccccc77777777cccccccc77777777ccd0000000000000
0000000000001777cccccccc16017ddddd2222221dddddddd50f90dddddd942dddddddddd50050d7cccccccc77777777cccccccc77777777ccd0000000000000
4444444444441777cccccccc16017dddd2e7e2e421ddddddd50106dddddd92ddddddddddd50050d7cccccccc77777777cccccccc77777777ccd0222222222222
2222222222221777cccccccc16017dddd122222211ddddddd5016ddddddd92ddddddddddd50050d7cccccccc77777777cccccccc77777777ccd0111111111111
2222222222221777cccccccc16017ddddd12e4111dddddddd5017ddddddd92ddddddddddd50050d7cccccccc77777777cccccccc77777777ccd0111111111111
2222222222221777cccccccc16017dddddd11111ddddddddd5017ddddddd42ddddddddddd50050d7cccccccc77777777cccccccc77777777ccd0111111111111
2222221222221777cccccccc16017dddddddddddddddd111d5017dddddddddddddddd555d50050d7cccccccc77777777cccccccc77777777ccd0111111111111
222222211222176cdddddddd16017ddddddddddddddd177715017ddddddddddddddd5aaa550050dcddddddddccccccccddddddddccccccccdd50111111111111
211122221111176cdddddddd16017dddddddddddddd1711161017dddddddddddddd5a111a50050dcddddddddccccccccddddddddccccccccdd50111111111111
221111222111176cdddddddd16017dddddddddddddd176c1c1017dddddddddddddd5aa919500511111111111111111111111ddddccccccccdd50111111111111
222222222222176cdddddddd160155555555555555517111c1015555555555555555a91195005777766666666666666666660dddccccccccdd50111111111111
222112222221176cdddddddd1600000000000000000071ccc0010000000000000001a991910000000000000000000000000050ddccccccccdd50111111111111
211111222111176cdddddddd160011111111111111107111c0011111111111111111a111910000000000000000000000000050ddccccccccdd50111111111111
111222222212176cdddddddd160177777777777777770ccc070177777777777777771999170000000000000000000000000050ddccccccccdd50111111111111
122222111222176cdddddddd16017dddddddddddddddd000d5017dddddddddddddddd111d50007760000000000000067700050ddccccccccdd50111111111111
1111111111111777cccccccc16017dddddddddddddddddddd5017dddddddddddddddddddd50107000101010101010000700050dc77777777ccd0111111111111
0000000000001777cccccccc16017dddddddddd22221ddddd5017dddddddddddddddddddd50106010101010101010100600050dc77777777ccd0000000000000
0000000000001777cccccccc16017ddddddddd22ff921dddd5017dddd7777766cd51ddddd50100010101010101010100000050dc77777777ccd0000000000000
4444444444441777cccccccc16017dddddddd22ffff921ddd5017ddd77cc77cc66d51dddd50101010101010101010101010050dc77777777ccd0222222222222
2222222222221777cccccccc16017dddddddd22fff9921ddd5017ddd4c77cc77dd552dddd50101010101010101010101010050dc77777777ccd0111111111111
2222222222221777cccccccc16017dddddddd292999211ddd5017ddd74444422222211ddd50101010101010101010101010050dc77777777ccd0111111111111
2222222222221777cccccccc16017dddddddd249222421dd50017dd7c77ccc76cc6dd51d500101010101010101010101010050dc77777777ccd0111111111111
2222222222221777cccccccc16017ddddd222111444421dd01017dddc57c5576556d951d010001010101010101010101010050dc77777777ccd0111111111111
122222222222176cdddddddd16017dddd2444222124211dd02117ddd1855ee55285999dd021001010101010101010101010050ddccccccccdd50111111111111
111121112221176cdddddddd16017ddd249422ff21211ddd02117ddd18ee7e8288229ddd021009010101010000010101010050ddccccccccdd50111111111111
211111111111176cdddddddd16017dd249742fff9111dddd01017ddd18e77e8822210ddd010001010101010077000101010050ddccccccccdd50111111111111
222222111112176cdddddddd16017dd249942fff911ddddd50017ddd1887e88282210ddd500101010101010107676001010050ddccccccccdd50111111111111
222111112221176cdddddddd16017dd2444229f991ddddddd5017ddd188ee82288120dddd50101010101010070777601010050ddccccccccdd50111111111111
211111222111176cdddddddd16017ddd2422229921ddddddd5017ddd1288882821110dddd50101010101010107776601010050ddccccccccdd50111111111111
221222211112176cdddddddd16017dddd22222221dddddddd5017dddd12222222210ddddd50101010101010100766821010050ddccccccccdd50111111111111
122221111222176cdddddddd16017ddddd111111ddddd555d5017ddddd111111000dd555d50100010101010101000200000050ddccccccccdd50111111111111
1111111111111777cccccccc16017ddddddddddddddd5bbb55017ddddddddddddddd5eee550106010101010101010000600050dc77777777ccd0111111111111
0000000000001777cccccccc16017dddddddddddddd5b11135017dddddddddddddd5e111850107000101010101010000700050dc77777777ccd0000000000000
0000000000001777cccccccc16017dddddddddddddd5b33135017dddddddddddddd5e881850107760101010101010067700050dc77777777ccd0000000000000
4444444444441777cccccccc16015555555555555555b11135015555555555555555e111850100000101010101010000000050dc77777777ccd0222222222222
2222222222221777cccccccc16000000000000000001b13331010000000000000001e188810101010101010101010101010050dc77777777ccd0111111111111
2222222222221777cccccccc16100000000000000001b11131000000000000000001e111810000000000000000000000000050dc77777777ccd0111111111111
2222222222221777cccccccc115555555555555555551333155555555555555555551888155555555555555555555555555510dc77777777ccd0111111111111
2222222222221777cccccccc151111111111111111111111111111111111111111111111111111111111111111111111111150dc77777777ccd0111111111111
222222222222176cddddddddc05ddddddddddddddddddddddddddd55ddddddddddddddd55dddddddddddddddddddddddddd50dddccccccccdd50111111111111
222122222111176cddddddddcd055555555555555555555555555065055555555555550650555555555555555555555555505dddccccccccdd50111111111111
111111122211176cddddddddcd50000000000000000000000000006500000000000000065000000000000000000000000005ddddccccccccdd50111111111111
111221112222176cddddddddccd555555555555555555555555550650ddddddddddddd06505555555555555555555555555dddddccccccccdd50111111111111
222111222221176cddddddddcccdddddddddddddddddddddddddd506500000000000006505ddddddddddddddddddddddddddddddccccccccdd50111111111111
111111111111176cddddddddccccccccddddddddccccccccdddddd0566611116666666505dccccccddddddddccccccccddddddddccccccccdd50111111111111
111211111111176cddddddddccccccccddddddddccccccccdd111111111c77c111111111dcccccccddddddddccccccccddddddddccccccccdd50111111111111
222112221111176cddddddddccccccccddddddddccccccccd1777777771dccd1777777770cccccccddddddddccccccccddddddddccccccccdd50111111111111
1111111111111777cccccccc77777777cccccccc77777777c17ddddddd600006ddddddd507777777cccccccc77777777cccccccc77777777ccd0111111111111
0000000000001777cccccccc77777777cccccccc77777777c17dddddddddddddddddddd507777777cccccccc77777777cccccccc77777777ccd0000000000000
0000000000001777cccccccc77777777cccccccc77777777c17dddddddddddddddddddd507777777cccccccc77777777cccccccc77777777ccd0000000000000
4444444444441777cccccccc77777777cccccccc77777777c17dddddddddddddddddddd507777777cccccccc77777777cccccccc77777777ccd0222222222222
2222222222221777cccccccc77777777cccccccc77777777c17ddd42ddd111ddddddddd507777777cccccccc77777777cccccccc77777777ccd0111111111111
2222222222221777cccccccc77777777cccccccc77777777c17ddd21dd199211ddddddd507777777cccccccc77777777cccccccc77777777ccd0111111111111
2222222222221777cccccccc77777777cccccccc77777777c17dddddd194442111ddddd507777777cccccccc77777777cccccccc77777777ccd0111111111111
2222221222221777cccccccc77777777cccccccc77777777c17ddddd122442109911ddd507777777cccccccc77777777cccccccc77777777ccd0111111111111
222222211222176cddddddddccccccccddddddddccccccccd17dddd11022210944421dd50cccccccddddddddccccccccddddddddccccccccdd50111111111111
222122221111176cddddddddccccccccddddddddccccccccd17ddd129400102244421dd50cccccccddddddddccccccccddddddddccccccccdd50111111111111
111111222111176cddddddddccccccccddddddddccccccccd17dd1294442001224221dd50cccccccddddddddccccccccddddddddccccccccdd50111111111111
11122222222216d555555555555555555555555555555555517dd1224422101122210dd505555555555555555555555555555555555555555550111111111111
22211222222116dd55555555dddddddd55555555dddddddd517dd012222100011110ddd50ddddddd55555555dddddddd55555555dddddddd5510111111111111
211111222111116dd55555555dddddddd5555555dddddddd517ddd0111100dd0000dddd50ddddddd55555555ddddddd55555555dddddddd55101111111111111
111222222212211666dddddddd6666666dddddddd6666666617dddd00110ddddddddddd50116666dddddddd66666666ddddddd66666666dd5011111111111111
1222221112222111666ddddddd66666666ddddddd6666666617dddddd00ddd42ddddddd50770666dddddddd6666666dddddddd6666666dd50111111111111111
11111111111111110d551111111555555511111111555555517ddddddddddd11ddd111d50d501551111111555555551111111555555511101111111111111111
000000000000000000d55111111155555551111111555555517ddddddddddddddd1222150d501511111111555555511111115555555111000000000000000000
0000000000000000000ddd5555555ddddddd5555555dddddd17dddddddddddddd12999010d505d5555555ddddddd5555555ddddddd5510000000000000000000
44444444444444422220dd5555555ddddddd5555555dddddd17dddddddddddddd12019110d505d5555555ddddddd5555555ddddddd5102222222222222222222
2222222222222222111101111111111111111111111111111155555555555555512999110d501111111111111111111111111111111011111111111111111111
2222222222222222111110000000000000000000000000000000000000000000002911105d500000000000000000000000000000000111111111111111111111
222222222112222221111111111101111100111111111111111116555555551210299910dd501111111111111101111100111111111111111111111111111111
22222211112222222111111111111022211001111111111111111655555555122101110ddd501111111111111022211001111111111111111111111111111111
222221111222222222111111111111022211001111111111111117ddddd222111440001ddd501111111111110222110011111111111111111111111111111111
222111122222122111111111111111102221100111111111111117dddd2444222124211ddd501111111111102221100111111111111111111111111111111111
111111222222112211111111111111110222100111111111111117ddd249422ff21211dddd501111111111102211001111111111111111111111111111111111
111222222222211221111111111111111022100111111111111117dd249742fff9111ddddd501111111111101110011111111111111111111111111111111111
222111222221111122211111111111111100001111111111111117dd249942fff911dddddd501111111111110000111111111111111111111111111111111111
111111111111112221111111111111111111111111111111111117dd2444229f991ddddddd501111111111111111111111111111111111111111111111111111
111122211112222111122111111111111111111111111111111117ddd2422229921ddddddd501111111111111111111111111111111111111111111111111111
111111122221211112222111111111111111111111111111111117dddd22222221dddddddd501111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111117ddddd111111ddddd555d501111111111111111111111111111111111111111111111111111
000000000000000000000000000000000000000000000000000017ddddddddddddddd5bbb5500000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000017dddddddddddddd5b1133500000000000000000000000000000000000000000000000000000
444444444444444444444442222222222222222222222222222217ddddddd500005d5b3133501222222222222222222222222222222222222222222222222222
22222222222222222222222211111111111111111111111111111555555550c77c055b3133501111111111111111111111111111111111111111111111111111
22222222222222222222222211111111111111111111111111111000000000dccd001b3133111111111111111111111111111111111111111111111111111111
211222222222222221122222211111111111111111111111111111111111110000111b1113111111111111111111111111111111111111111111111111111111
11222212222222111122222221111111111111111111111111111111111111111111113331111111111111111111111111111111111111111111111111111111
12222221122221111222222222111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

__map__
77767676767676767676767676767676777b0000000000000506070707070708000000000506070707070708000000000000000506070707070708000507070708000507070708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66675c5d5e5d5e5d5e5d5e5d5e5d5f4c676b0000000000001516171717171718000000001516171717171718000000000000001516171717171718001516171728002516171718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7b787c1f0f1f0f1f0f1f0f1f0f1f6f4d777b0000000000002526272727272718000000002526272727272718000000000000002526272727272718002526272728002526272718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66686c2f3f2f3f2f3f2f3f2f3f2f7f694c6b0000000000002526272727272718000000002526272727272721070708000507072026272727272718002526272721072026272718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
787b7c1f0f1f0f1f0f1f0f1f0f1f6f794d7b0000000000002526272727272718000000002526272727272717171718001516171714272727272718001526272717171714272718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
686b6c2f3f2f3f2f3f2f3f2f3f2f7f69694c0000000000002526272727272718000000002526272727272727272718002526272727272727272718002526272727272727272718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77787c1f0f1f0f1f0f1f0f1f0f1f6f79794d0000000000002526272727272718000000002526272727272727272718002526272727272727272718002526272727272727272718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
67666c2f3f2f3f2f3f2f3f2f3f2f7f6969690000000000003537372223373738000000003537373622232436363738003537373622232436363738003537373622232436363738000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
787b7c1f0f1f0f1f0f1f0f1f0f1f6f7979790000000000000000003233000000000000000000000032333400000000000000000032333400000000000000000032333400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66676c2f3f2f3f2f3f2f3f2f3f2f7f6969690000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7b777c1f0f1f0f1f0f1f0f1f0f1f6f7979790000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6b686c2f3f2f3f2f3f2f3f2f3f2f7f6969690000000000000000000000000000000000000000050607070800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7b786d7d7e7d7e7d7e7d7e7d7e7d6e7979790000000000000000000000000000000000000000151617171800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
67666a6969696969696969696969696969690000000000000000000000000000000000000000252627271800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7b4e7a7979797979797979797979797979790000000000000000000000000000000000050607032627271800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
686b676a69696969696969696969696969690000000000000000000000000000000000151617172427271800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4e784e7a79797979797979797979797979790000000000000000000000000000000000252627272727271800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000152627272727271800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000252627272727272800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000252627272727271800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000252627272727271800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000003537372b2c37373800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000003b3c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010200000f6540c0500c0330002100013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400000c61424641306150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100001075310735047150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010700003975039722397123971500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00002875500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00002475528750287252871500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c0000267552b7502b7252b71500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c0000287552d7502d7252d71500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00002975530750307253071500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001375513725107550c700137550c0001875500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001f055000001c0350000018055000000c05500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001375513725107550c700137550c0001875500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c00001375513725107550c700137550c0001875500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c00002805528025240550000028055000002d05500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c00000c7550c7250c7000c7000c7540c7001175411730117151171500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
04 3f3e3d44
04 3c3b3a44

