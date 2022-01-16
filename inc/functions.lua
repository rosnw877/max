function dl_cb(a,d) end
 
function GetInputFile(file)
local file = file or "" 
if file:match('/') then
infile = {ID= "InputFileLocal", path_  = file}
elseif file:match('^%d+$') then
infile = {ID= "InputFileId", id_ = file}
else
infile = {ID= "InputFilePersistentId", persistent_id_ = file}
end
return infile
end

local clock = os.clock
function sleep(time)  
local untime = clock()
while clock() - untime <= time do end
end

function sendMsg(chat_id,reply_id,text,markup,funcb)
pcall(tdcli_function({
ID="SendMessage",
chat_id_=chat_id,
reply_to_message_id_= reply_id,
disable_notification_=1,
from_background_= 1,
reply_markup_= nil,
input_message_content_={
ID = "InputMessageText",
text_= text,
disable_web_page_preview_= 1,
clear_draft_= 0,
entities_={},
parse_mode_=  {ID = "TextParseModeMarkdown"} ,
}},funcb or dl_cb,nil)
)
end

function sendPhoto(chat_id,reply_id,photo,caption,func)
pcall(tdcli_function({
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessagePhoto",
photo_ = GetInputFile(photo),
added_sticker_file_ids_ = {},
width_ = 0,
height_ = 0,
caption_ = caption or ''
}
},func or dl_cb,nil))
end
	
	 
function sendVoice(chat_id,reply_id,voice,caption,func)
pcall(tdcli_function({
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageVoice",
voice_ = GetInputFile(voice),
duration_ = '',
waveform_ = '',
caption_ = caption or ''
}},func or dl_cb,nil))
end

function sendAnimation(chat_id,reply_id,animation,caption,func)
pcall(tdcli_function({
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageAnimation",
animation_ = GetInputFile(animation),
width_ = 0,
height_ = 0,
caption_ = caption or ''
}},func or dl_cb,nil))
end

function sendAudio(chat_id,reply_id,audio,title,caption,func)
pcall(tdcli_function({
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageAudio",
audio_ = GetInputFile(audio),
duration_ = '',
title_ = title or '',
performer_ = '',
caption_ = caption or ''
}},func or dl_cb,nil))
end

function sendSticker(chat_id,reply_id,sticker,func)
pcall(tdcli_function({
ID='SendMessage',
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageSticker",
sticker_ = GetInputFile(sticker),
width_ = 0,
height_ = 0
}},func or dl_cb,nil))
end

function sendVideo(chat_id,reply_id,video,caption,func)
pcall(tdcli_function({ 
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 0,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageVideo",  
video_ = GetInputFile(video),
added_sticker_file_ids_ = {},
duration_ = 0,
width_ = 0,
height_ = 0,
caption_ = caption or ''
}},func or dl_cb,nil))
end


function sendDocument(chat_id,reply_id,document,caption,func)
pcall(tdcli_function({
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageDocument",
document_ = GetInputFile(document),
caption_ = caption
}},func or dl_cb,nil))
end


function fwdMsg(chat_id,from_chat_id,msg_id,func)
pcall(tdcli_function({
ID="ForwardMessages",
chat_id_ = chat_id,
from_chat_id_ = from_chat_id,
message_ids_ = {[0] = msg_id},
disable_notification_ = 0,
from_background_ = 0
},func or dl_cb,nil))
end


function SendMention(chat_id,user_id,msg_id,Text,offset, length) 
pcall(tdcli_function ({ 
ID = "SendMessage", 
chat_id_ = chat_id, 
reply_to_message_id_ = msg_id, 
disable_notification_ = 0, 
from_background_ = 1, 
reply_markup_ = nil, 
input_message_content_ = { 
ID = "InputMessageText", 
text_ = Text, 
disable_web_page_preview_ = 1, 
clear_draft_ = 0, 
entities_ = {[0]={ 
ID="MessageEntityMentionName", 
offset_ = offset , 
length_ = length , 
user_id_ = user_id },},},
},dl_cb, nil))
end
   
function sendChatAction(chatid,action,func)
pcall(tdcli_function({ID = 'SendChatAction',chat_id_ = chatid,action_ = {ID = "SendMessage"..action.."Action",progress_ = 1},}, func or dl_cb,nil))
end

--================================{{  GetChannelFull  }} ===================================
function download_file(Link,Bath)
local Get_Files, res = https.request(Link)
print(res)
if res == 200 then
print("DONLOADING_FROM_URL: "..Link)
local FileD = io.open(Bath,'w+')
FileD:write(Get_Files)
FileD:close()
end
end
--================================{{  GetChannelFull  }} ===================================

function GetFullChat(GroupID,func)
pcall(tdcli_function({ID="GetChannelFull",channel_id_ = GroupID:gsub('-100','')},func or dl_cb,nil))
end

--================================{{  KickUser  }} ===================================

function kick_user(user_id,chat_id,func)
pcall(tdcli_function({ID="ChangeChatMemberStatus",chat_id_=chat_id,user_id_=user_id,status_={ID="ChatMemberStatusKicked"}},func or dl_cb,nil))
end

--================================{{  UnBlock  }} ===================================

function StatusLeft(chat_id,user_id,func)
pcall(tdcli_function({ID="ChangeChatMemberStatus",chat_id_=chat_id,user_id_=user_id,status_={ID="ChatMemberStatusLeft"}},func or dl_cb,nil))
end
--================================{{  DeleteMsg  }} ===================================

function Del_msg(GroupID,msg_id,func)
pcall(tdcli_function({ID="DeleteMessages",chat_id_=GroupID,message_ids_={[0]=msg_id}},func or dl_cb,nil))
end


function GetPhotoUser(User,func)
pcall(tdcli_function({ID='GetUserProfilePhotos',user_id_=User,offset_=0,limit_=1},func,nil))
end
  
function GetMsgInfo(UID,Msg_id,Cb,Arg)
pcall(tdcli_function({ID="GetMessage",chat_id_ = UID,message_id_ = Msg_id},Cb,Arg))
end

function GetUserName(User,Cb,Arg)
pcall(tdcli_function({ID="SearchPublicChat",username_ = User},Cb,Arg))
end

function GetUserID(User,Cb,Arg)
pcall(tdcli_function({ID="GetUser",user_id_ = User},Cb,Arg))
end


function GroupTitle(GroupID,func)
pcall(tdcli_function({ID="GetChat",chat_id_ = GroupID},func or dl_cb,nil))
end

function GetChannelAdministrators(GroupID,func,limit)
pcall(tdcli_function({ID="GetChannelMembers",channel_id_= GroupID:gsub('-100',''),filter_={ID = "ChannelMembersAdministrators"},offset_=0,limit_=40},func,nil))
end 

function GetChatMember(GroupID,UserID,func)
pcall(tdcli_function({ID='GetChatMember',chat_id_ = GroupID,user_id_ = UserID},func,nil))
end

function GetHistory(GroupID,NumDel,func)
pcall(tdcli_function({ID="GetChatHistory",chat_id_ = GroupID,from_message_id_ = 0,offset_ = 0,limit_ = NumDel},func,nil))
end
-----------------------{ Start Api Token Bot}-----------------------------
function getr(br)
if br then
return "✓"
else
return "✿"
end
end

function GetApi(web)
local info, res = https.request(web)
if res ~= 200 then return false end
local success, res = pcall(JSON.decode, info);
if success then
if not res.ok then return false end
res = res
else
res = false
end
return res
end


--================================{{  ExportChatInviteLink  }} ===================================

function ExportLink(GroupID)
local GetLin,res = https.request(ApiToken..'/exportChatInviteLink?chat_id='..GroupID)
print(res)
if res ~= 200 then return false end
local success, res = pcall(JSON.decode, GetLin)
return (res or "")
end

function Restrict(chat_id,user_id,right)
if right == 1 then
https.request(ApiToken..'/restrictChatMember?chat_id='..chat_id..'&user_id='..user_id..'&can_send_messages=false')
elseif right == 2 then
https.request(ApiToken..'/restrictChatMember?chat_id='..chat_id..'&user_id='..user_id..'&can_send_messages=true&can_send_media_messages=true&can_send_other_messages=true&can_add_web_page_previews=true')
elseif right == 3 then
https.request(ApiToken..'/restrictChatMember?chat_id='..chat_id..'&user_id='..user_id..'&can_send_messages=true&can_send_media_messages=false&can_send_other_messages=false&can_add_web_page_previews=false')
end
end


function send_msg(chat_id,text,msg_id)
local url = ApiToken..'/sendMessage?chat_id='..chat_id..'&text='..URL.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true"
if msg_id then
url = url.."&reply_to_message_id="..msg_id/2097152/0.5
end
return GetApi(url)
end

function EditMsg(chat_id,message_id,text,funcb)
local url = ApiToken..'/editMessageText?chat_id='..chat_id ..'&message_id='..tonumber(message_id/2097152/0.5)..'&text='..URL.escape(text)..'&parse_mode=Markdown&disable_web_page_preview=true'
return GetApi(url)
end

function send_key(chat_id,text,keyboard,inline,msg_id)
local response = {}
response.inline_keyboard = inline
response.keyboard = keyboard
response.resize_keyboard = true
response.one_time_keyboard = false
local Send_api = ApiToken.."/sendMessage?chat_id="..chat_id.."&text="..
URL.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..URL.escape(JSON.encode(response))
if msg_id then 
Send_api = Send_api.."&reply_to_message_id="..msg_id/2097152/0.5
end
return GetApi(Send_api)
end 

function GetFilePath(FileID)
local UrlInfo = https.request(ApiToken..'/getfile?file_id='..FileID)
return ApiToken..'/'..JSON.decode(UrlInfo).result.file_path
end

----------------------{ End Api Token Bot }-----------------------------

----------------------{ Get Name Bot }-----------------------------
Bot_Name = redis:get(mero..":NameBot:")


function GetType(ChatID) 
if tostring(ChatID):match('^-100') then
return 'channel' 
elseif tostring(ChatID):match('-') then
return 'chat' 
else 
return 'pv'
end 
end


function ResolveUser(datax)
if datax.username_ then 
USERNAME = '@'..Flter_Markdown(datax.username_)
else 
USERNAME = FlterName(datax.first_name_..' '..(datax.last_name_ or ""),20) 
USERNAME = "["..USERNAME.."](tg://user?id="..datax.id_..")"
end
return USERNAME
end


function FlterName(Name,Num)
local CharNumber = tonumber(Num or 25)
local Name = tostring(Name):lower()
Name = Name:gsub("https://[%a%d_]+",'') 
Name = Name:gsub("http://[%a%d_]+",'') 
Name = Name:gsub("telegram.dog/[%a%d_]+",'') 
Name = Name:gsub("telegram.me/[%a%d_]+",'') 
Name = Name:gsub("t.me/[%a%d_]+",'') 
Name = Name:gsub("[%a%d_]+.pe[%a%d_]+",'') 
Name = Name:gsub("@[%a%d_]+",'')
Name = Name:gsub("#[%a%d_]+",'')

Name = FlterEmoje(Name)
Name = Flterzhrfa(Name)
Name = utf8.gsub(Name,"'","")
Name = utf8.gsub(Name,'"',"")
Name = utf8.gsub(Name,"✸","")
Name = utf8.gsub(Name,"ﮧ","")
Name = utf8.gsub(Name,"│","")
Name = utf8.gsub(Name,"ٜ","")
Name = utf8.gsub(Name,"༒","")
Name = utf8.gsub(Name,"ᬼ","")
Name = utf8.gsub(Name,"̅","")
Name = utf8.gsub(Name,"❦","")
Name = utf8.gsub(Name,"ᝢ","")
Name = utf8.gsub(Name,"༼","")
Name = utf8.gsub(Name,"๘","")
Name = utf8.gsub(Name,"༽","")
Name = utf8.gsub(Name,"⎨","")
Name = utf8.gsub(Name,"ௌ","")
Name = utf8.gsub(Name,"⎬","")
Name = utf8.gsub(Name,"ۤ","")
Name = utf8.gsub(Name,"꧄","")
Name = utf8.gsub(Name,"░","")
Name = utf8.gsub(Name,"͝","")
Name = utf8.gsub(Name,"¥","")
Name = utf8.gsub(Name,"َ","")
Name = utf8.gsub(Name,"✧","")
Name = utf8.gsub(Name,"ֆ","")
Name = utf8.gsub(Name,"ۖ","")
Name = utf8.gsub(Name,"(])","")
Name = utf8.gsub(Name,"","")
Name = utf8.gsub(Name,"֧","")
Name = utf8.gsub(Name,"*","")
Name = utf8.gsub(Name,"","")
Name = utf8.gsub(Name,"﴿","")
Name = utf8.gsub(Name,"₪","")
Name = utf8.gsub(Name,"ૣ","")
Name = utf8.gsub(Name,"☆","")
Name = utf8.gsub(Name,"͞","")
Name = utf8.gsub(Name,"ٖ","")
Name = utf8.gsub(Name,"֯","")
Name = utf8.gsub(Name,"‘","")
Name = utf8.gsub(Name,"ُ","")
Name = utf8.gsub(Name,"ꪆ","")
Name = utf8.gsub(Name,"↡","")
Name = utf8.gsub(Name,"᭄","")
Name = utf8.gsub(Name,"௵","")
Name = utf8.gsub(Name,"♚","")
Name = utf8.gsub(Name,"ﹻ","")
Name = utf8.gsub(Name,"ۦ","")
Name = utf8.gsub(Name,"͟","")
Name = utf8.gsub(Name,"̶","")
Name = utf8.gsub(Name,"_","")
Name = utf8.gsub(Name,"`","")
Name = utf8.gsub(Name,"‏","")
Name = utf8.gsub(Name,"๘","")
Name = utf8.gsub(Name,"͡","")
Name = utf8.gsub(Name,"⸨","")
Name = utf8.gsub(Name,"▓","")
Name = utf8.gsub(Name,"ـ","")
Name = utf8.gsub(Name,"ஞ","")
Name = utf8.gsub(Name,"❥","")
Name = utf8.gsub(Name,"ꨩ","")
Name = utf8.gsub(Name,"‏","")
Name = utf8.gsub(Name,"ೈ","")
Name = utf8.gsub(Name,"٘","")
Name = utf8.gsub(Name,"ࣧ","")
Name = utf8.gsub(Name,"“","")
Name = utf8.gsub(Name,"•","")
Name = utf8.gsub(Name,']',"")
Name = utf8.gsub(Name,"}","")
Name = utf8.gsub(Name,"ཻ","")
Name = utf8.gsub(Name,"⸩","")
Name = utf8.gsub(Name,"ِ","")
Name = utf8.gsub(Name,"ࣩ","")
Name = utf8.gsub(Name,"ٰ","")
Name = utf8.gsub(Name,"ہ","")
Name = utf8.gsub(Name,"ۙ","")
Name = utf8.gsub(Name,"ৡ","")
Name = utf8.gsub(Name,"҉","")
Name = utf8.gsub(Name,"ٙ","")
Name = utf8.gsub(Name,"ّ","")
Name = utf8.gsub(Name,"ۨ","")
Name = utf8.gsub(Name,"ै","")
Name = utf8.gsub(Name,"ೋ","")
Name = utf8.gsub(Name,"๋","")
Name = utf8.gsub(Name,"͢","")
Name = utf8.gsub(Name,"ﮩ","")
Name = utf8.gsub(Name,"❁","")
Name = utf8.gsub(Name,"⃤","")
Name = utf8.gsub(Name,"ﮮ","")
Name = utf8.gsub(Name,"⸽","")
Name = utf8.gsub(Name,"̝","")
Name = utf8.gsub(Name,"{","")
Name = utf8.gsub(Name,"𖤍","")
Name = utf8.gsub(Name,"|","")
Name = utf8.gsub(Name,"ۧ","")
Name = utf8.gsub(Name,"ۗ","")
Name = utf8.gsub(Name,"ۣ","")
Name = utf8.gsub(Name,"ٍ","")
Name = utf8.gsub(Name,"ؔ","")
Name = utf8.gsub(Name,"ٌ","")
Name = utf8.gsub(Name,"͜","")
Name = utf8.gsub(Name,"ꪸ","")
Name = utf8.gsub(Name,"ۂ","")
Name = utf8.gsub(Name,"»","")
Name = utf8.gsub(Name,"̚","")
Name = utf8.gsub(Name,"𖣁","")
Name = utf8.gsub(Name,"۫","")
Name = utf8.gsub(Name,"ْ","")
Name = utf8.gsub(Name,"ৣ","")
Name = utf8.gsub(Name,"ے","")
Name = utf8.gsub(Name,"♱","")
Name = utf8.gsub(Name,"℘","")
Name = utf8.gsub(Name,"ً","")
Name = utf8.gsub(Name,"۪","")
Name = utf8.gsub(Name,"❰","")
Name = utf8.gsub(Name,"꯭","")
Name = utf8.gsub(Name,"ٚ","")
Name = utf8.gsub(Name,"﷽","")
Name = utf8.gsub(Name,"ۛ","")
Name = utf8.gsub(Name,"〞","")
Name = utf8.gsub(Name,"█","")
Name = utf8.gsub(Name,"✮","")
Name = utf8.gsub(Name,"✿","")
Name = utf8.gsub(Name,"✺","")
Name = utf8.gsub(Name,"̐","")
Name = utf8.gsub(Name,"ྀ","")
Name = utf8.gsub(Name,"←","")
Name = utf8.gsub(Name,"↝","")
Name = utf8.gsub(Name,"ؒ","")
Name = utf8.gsub(Name,"̷","")
Name = utf8.gsub(Name,"⇣","")
Name = utf8.gsub(Name,"«","")
Name = utf8.gsub(Name,"ٛ","")
Name = utf8.gsub(Name,"ॠ","")
Name = utf8.gsub(Name,"̲","")
Name = utf8.gsub(Name,"-","")
Name = utf8.gsub(Name,"͛","")
Name = utf8.gsub(Name,"☬","")
Name = utf8.gsub(Name,"ٓ","")
Name = utf8.gsub(Name,"❱","")
Name = utf8.gsub(Name,"ۓ","")
Name = utf8.gsub(Name,"‏","")
Name = utf8.gsub(Name,"௸","")

if utf8.len(Name) > CharNumber then
Name = utf8.sub(Name,0,CharNumber)..'...' 
end
local CheckName = Name:gsub(' ','')
if not CheckName then 
  Name = 'الاسم سبام •'
end
return utf8.escape(Name)
end

function ResolveName(data)
if type(data) == 'table' then
if data.last_name_ then Name = data.first_name_ .." "..data.last_name_ else Name = data.first_name_ end
TNAME = FlterName(Name,20) 
else
TNAME = FlterName(data,20)
end
print("| Number char : "..utf8.len(TNAME))
ncn = {}
for c in TNAME:gmatch("[^%s]+") do 
table.insert(ncn,c)  
print(c) 
end
return utf8.escape(ncn[1])
end

function ResolveUserName(data)
if data.username_ then 
USERNAME = '@'..data.username_
else 
if data.last_name_ then Name = data.first_name_ .." "..data.last_name_ else Name = data.first_name_ end
USERNAME = FlterName(Name,20) 
end
return USERNAME
end


function Hyper_Link_Name(data)
if data.first_name_ then 
if data.last_name_ then 
Name = data.first_name_ .." "..data.last_name_
else 
Name = data.first_name_ 
end
usernn = data.username_ or "th3bs"
else 
Name = data.title_
usernn = data.type_.user_.username_ or "th3bs"
end
Name = Name:gsub('[[][]]','')
Name = FlterName(Name,10)
Name = "["..Name.."](t.me/"..usernn..")"
print(Name)
return Name
end

function Flter_Markdown(TextMsg) 
local Text = tostring(TextMsg)
Text = Text:gsub('_',[[\_]])
Text = Text:gsub('*','\\*')
Text = Text:gsub('`','\\`')
local Hyperlink = Text:match('[(](.*)[)]')
local Hyperlink1 = Text:match('[[](.*)[]]')
if Hyperlink and Hyperlink1 then
Hyperlink = "("..Hyperlink:gsub([[\_]],'_')..")"
Text = Text:gsub('[(](.*)[)]',Hyperlink ) 
Hyperlink1 = Hyperlink1:gsub([[\_]],'_')
Hyperlink1 = "["..Hyperlink1:gsub('[[][]]','').."]"
Text = Text:gsub('[[](.*)[]]',Hyperlink1 ) 
end
return Text 
end

function KlmatMmno3(text)
resq = false
local listFshars = redis:get("UpdatWordsFshar")
if not listFshars then
local Fshar_Word , res = https.request('https://api.th3boss.com/Words_Fshars.txt')
if res ~= 200 then Fshar_Word = "\n" end
redis:setex("UpdatWordsFshar",3600,Fshar_Word)
print(Fshar_Word)
end


for lines in listFshars:gmatch('[^\r\n]+') do
if text:match('^('..lines..')$') or text:match(lines..' .*') or text:match('.* '..lines) then
print("Word is Fshar")
resq = true
end end
print(resq)
return resq
end


function KlmatMmno3(text)
resq = false
if not Fshar_Word or not redis:get("UpdatWordsFshar") then
Fshar_Word , res = https.request('https://api.th3boss.com/Words_Fshars.txt')
if res ~= 200 then Fshar_Word = "\n" end
redis:setex("UpdatWordsFshar",3600,true)
end
for lines in Fshar_Word:gmatch('[^\r\n]+') do
if text:match('^('..lines..')$') or text:match(lines..' .*') or text:match('.* '..lines) then
print("Word is Fshar")
resq = true
end end
return resq
end

function Get_Ttl(msgs)
local MsgShow = '' 
local NumMsg = tonumber(msgs)
if NumMsg < 80 then 
MsgShow = 'غير متفاعل ✘' 
elseif NumMsg < 300 then
MsgShow = 'ضعيف ' 
elseif NumMsg < 900 then 
MsgShow = 'متوسط ' 
elseif NumMsg < 5000 then 
MsgShow = 'متفاعل ' 
elseif NumMsg < 9000 then 
MsgShow = 'قوي جدا ' 
elseif NumMsg < 10000 then 
MsgShow = 'قمه التفاعل ' 
elseif NumMsg < 100000 then 
MsgShow = 'اقوى تفاعل ' 
elseif NumMsg > 150000 then 
MsgShow = 'ملك التفاعل ' 
end
return MsgShow 
end

function Rank_Checking(UserID,ChatID)
if UserID == our_id then 
var = true
elseif  tonumber(UserID) == tonumber(1099083018) then
var = true
elseif  tonumber(UserID) == tonumber(1965223041) then
var = true
elseif  UserID == SUDO_ID then
var = true
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then
var = true
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then
var = true
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then
var = true
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then
var = true
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then
var = true
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then
var = true
elseif redis:sismember(mero..'whitelist:'..ChatID,UserID) then
var = false
else
var = false
end
return var
end
function Getrtba(UserID,ChatID)
if UserID == our_id then 
var = 'هذا البوت ' 
elseif  tonumber(UserID) == tonumber(1099083018) then
var = 'مبرمج السورس' 
elseif  tonumber(UserID) == tonumber(1965223041) then
var = 'Carbon' 
elseif  UserID == SUDO_ID then
var = 'مطور اساسي ' 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then
var = 'مطور البوت ' 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then
var = 'المالك' 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then
var = 'المنشئ الاساسي' 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then
var = 'المنشــىء' 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then
var = 'المدير' 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then
var = 'الادمن ' 
elseif redis:sismember(mero..'whitelist:'..ChatID,UserID) then
var = 'عضو مميز ' 
else
var = 'فقط عضو' 
end
return var
end


function SaveNumMsg(msg)
if msg.edited then
redis:incr(mero..':edited:'..msg.chat_id_..':'..msg.sender_user_id_)
elseif msg.text and not msg.forward_info then
redis:incr(mero..'msgs:'..msg.sender_user_id_..':'..msg.chat_id_)
elseif msg.adduser then 
redis:incr(mero..':adduser:'..msg.chat_id_..':'..msg.sender_user_id_)
elseif msg.photo then
redis:incr(mero..':photo:'..msg.chat_id_..':'..msg.sender_user_id_)
elseif msg.sticker then
redis:incr(mero..':sticker:'..msg.chat_id_..':'..msg.sender_user_id_)
elseif msg.voice then
redis:incr(mero..':voice:'..msg.chat_id_..':'..msg.sender_user_id_)
elseif msg.audio then
redis:incr(mero..':audio:'..msg.chat_id_..':'..msg.sender_user_id_)
elseif msg.video or msg.video_note then
redis:incr(mero..':video:'..msg.chat_id_..':'..msg.sender_user_id_)
elseif msg.animation then
redis:incr(mero..':animation:'..msg.chat_id_..':'..msg.sender_user_id_)
end
end


--================================{{  We Sudoer  }} ===================================

function we_sudo(msg)
if msg.sender_user_id_ == SUDO_ID then
return true 
else
return false
end 
end


--================================{{  List Sudoer  }} ===================================


function sudolist(msg)
local list = redis:smembers(mero..':SUDO_BOT:')
message = '•*│* قائمه الـمـطـوريـن : \n\n`مطور اساسي`**\n'..SUDO_USER..' » ❪' ..SUDO_ID.. '❫\n*┄─┅══┅─┄ *\n'
if #list==0 then  message = message.."* لا يوجد مطورين حاليا \n• *"
else
for k,v in pairs(list) do
local info = redis:hgetall(mero..'username:'..v)
local count = redis:scard(mero..'mtwr_count'..v)
if info and info.username and info.username:match("@[%a%d_]+") then
message = message ..k.. '~⪼ '..(info.username or '')..' » ❪`' ..v.. '`❫\n'
else
message = message ..k.. '~⪼ '..(info.username or '')..' l » ❪`' ..v.. '`❫\n'
end
end 
end
send_msg(msg.chat_id_,message,msg.id_)
print(message)
return false 
end

--================================{{  List owner  }} ===================================
function monshlist(msg)
  local list = redis:smembers(mero..':MONSHA_BOT:'..msg.chat_id_)
  if #list==0 then  return  "* لا يوجد منشئين حاليا \n• *" end
  message = '•*│* قائمه منشيين : \n\n*┄─┅══┅─┄ *\n'
  
  for k,v in pairs(list) do
tdcli_function ({ID = "GetUser",user_id_ = v},function(arg,data) 
if data.username_ then
message = message..""..k.."- ([@"..data.username_.."])\n"
else
message = message..""..k.."- (`"..v.."`)\n"
end
if #list == k then
return send_msg(msg.chat_id_,message,msg.id_)
end
end,nil)
end
  return false 
  end
--================================{{ List owner  }} ===================================

function ownerlist(msg)
  local list = redis:smembers(mero..'owners:'..msg.chat_id_)
  if #list==0 then  return  "•*│* لا يوجد مدير في هذه المجموعه \n❕" end
  message = '•*│ قائمه المدراء :*\n\n'
  for k,v in pairs(list) do
tdcli_function ({ID = "GetUser",user_id_ = v},function(arg,data) 
if data.username_ then
message = message..""..k.."- ([@"..data.username_.."])\n"
else
message = message..""..k.."- (`"..v.."`)\n"
end
if #list == k then
return send_msg(msg.chat_id_,message,msg.id_)
end
end,nil)
end
  return false
  end
function KARA_BOT(msg)
  local list = redis:smembers(mero..':KARA_BOT:'..msg.chat_id_)
  if #list==0 then  return  "•*│* لا يوجد منشئين اساسيين \n❕" end
  message = '•*│ قائمه الاساسيين :*\n\n'
  for k,v in pairs(list) do
tdcli_function ({ID = "GetUser",user_id_ = v},function(arg,data) 
if data.username_ then
message = message..""..k.."- ([@"..data.username_.."])\n"
else
message = message..""..k.."- (`"..v.."`)\n"
end
if #list == k then
return send_msg(msg.chat_id_,message,msg.id_)
end
end,nil)
end
  end
function MALK_BOT(msg)
  local list = redis:smembers(mero..':MALK_BOT:'..msg.chat_id_)
  if #list==0 then  return  "•*│* لا يوجد مالكين \n❕" end
  message = '•*│ قائمه المالكين :*\n\n'
  for k,v in pairs(list) do
tdcli_function ({ID = "GetUser",user_id_ = v},function(arg,data) 
if data.username_ then
message = message..""..k.."- ([@"..data.username_.."])\n"
else
message = message..""..k.."- (`"..v.."`)\n"
end
if #list == k then
return send_msg(msg.chat_id_,message,msg.id_)
end
end,nil)
end
  return false
  end

--================================{{ List Admins  }} ===================================

function GetListAdmin(msg)
local list = redis:smembers(mero..'admins:'..msg.chat_id_)
if #list==0 then  return  "•*│* لا يوجد ادمن في هذه المجموعه \n❕" end
message = '•*│ قائمه الادمنيه :*\n\n'
for k,v in pairs(list) do
tdcli_function ({ID = "GetUser",user_id_ = v},function(arg,data) 
if data.username_ then
message = message..""..k.."- ([@"..data.username_.."])\n"
else
message = message..""..k.."- (`"..v.."`)\n"
end
if #list == k then
return send_msg(msg.chat_id_,message,msg.id_)
end
end,nil)
end
return false
end

--================================{{  List WhiteList  }} ===================================

function whitelist(msg)
local list = redis:smembers(mero..'whitelist:'..msg.chat_id_)
if #list == 0 then return "*•│لا يوجد مميزين في القائمه *" end
message = '•*│* قائمه الاعضاء المميزين :\n'   
for k,v in pairs(list) do
tdcli_function ({ID = "GetUser",user_id_ = v},function(arg,data) 
if data.username_ then
message = message..""..k.."- ([@"..data.username_.."])\n"
else
message = message..""..k.."- (`"..v.."`)\n"
end
if #list == k then
return send_msg(msg.chat_id_,message,msg.id_)
end
end,nil)
end
return false
end

--================================{{  Mute User And List Mute User   }} ===================================

function MuteUser(Group, User)
if redis:sismember(mero..'is_silent_users:'..Group,User) then 
return true 
else
return false
end 
end


function MuteUser_list(msg)
local list = redis:smembers(mero..'is_silent_users:'..msg.chat_id_)
if #list==0 then return "•*│*لايوجد اعضاء مكتومين " end
message = '•*│*قائمه الاعضاء المكتومين :\n'
for k,v in pairs(list) do
tdcli_function ({ID = "GetUser",user_id_ = v},function(arg,data) 
if data.username_ then
message = message..""..k.."- ([@"..data.username_.."])\n"
else
message = message..""..k.."- (`"..v.."`)\n"
end
if #list == k then
return send_msg(msg.chat_id_,message,msg.id_)
end
end,nil)
end
return false
end


--================================{{  Check Banned And List Banned  }} ===================================


function Check_Banned(Group,User)
if redis:sismember(mero..'banned:'..Group,User) then 
return true 
else
return false
end 
end

function GetListBanned(msg)
local list = redis:smembers(mero..'banned:'..msg.chat_id_)
if #list==0 then return "•*│*لايوجد أعضاء محظورين " end
message = '•*│*قائمه الاعضاء المحظورين :\n'
for k,v in pairs(list) do
tdcli_function ({ID = "GetUser",user_id_ = v},function(arg,data) 
if data.username_ then
message = message..""..k.."- ([@"..data.username_.."])\n"
else
message = message..""..k.."- (`"..v.."`)\n"
end
if #list == k then
return send_msg(msg.chat_id_,message,msg.id_)
end
end,nil)
end
return false
end



--================================{{  Sudoer  }} ===================================

function GeneralBanned(User)
if redis:sismember(mero..'gban_users',User) then 
return true 
else
return false
end 
end

function GetListGeneralBanned(msg)
local list = redis:smembers(mero..'gban_users')
if #list==0 then return  "*•│لايوجد اعضاء محظورين عام*" end
message = '•*│*قائمه المحظورين عام :\n'
for k,v in pairs(list) do
tdcli_function ({ID = "GetUser",user_id_ = v},function(arg,data) 
if data.username_ then
message = message..""..k.."- ([@"..data.username_.."])\n"
else
message = message..""..k.."- (`"..v.."`)\n"
end
if #list == k then
return send_msg(msg.chat_id_,message,msg.id_)
end
end,nil)
end
return false
end

--================================{{  Filter Words  }} ===================================
function FilterXall(msg)
local var = false
local Text = (msg.text or msg.content_.caption_)
local list = redis:smembers(mero..'Filter_Word:all')
if #list ~=0 then
for k,word in pairs(list) do
if Text:match('^('..word..')$') or Text:match(word..' .*') or Text:match('.* '..word) then
Del_msg(msg.chat_id_,msg.id_,function(arg,d)
if d.ID == "Ok" then
GetUserID(msg.sender_user_id_,function(arg,data)
if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data) end
SendMention(msg.chat_id_,data.id_,msg.id_,"✿¦ العضو » "..USERNAME.."\n✿¦ عذرا هذه الكلمات ممنوعه هنا \n✿",11,utf8.len(USERNAME))
end,nil)
end
end)
print("Word is Del")
var = true
else
var = false
end
end
else
var = false
end 
return var
end

function AddFilterall(msg, word)
if redis:sismember(mero..'Filter_Word:all',word) then 
return  "•*│*الكلمه *{"..word.."}* هي بالتأكيد من قائمه المنع✓️" 
else
redis:sadd(mero..'Filter_Word:all',word) 
return  "•*│*الكلمه *{"..word.."}* تمت اضافتها الى قائمه المنع ✓️"
end
end

function RemFilterall(msg, word)
if redis:sismember(mero..'Filter_Word:all',word) then 
redis:srem(mero..'Filter_Word:all',word) 
return  "•*│*الكلمه *{"..word.."}* تم السماح بها ✓️" 
else
return  "•*│*الكلمه *{"..word.."}* هي بالتأكيد مسموح بها✓️" 
end
end
function FilterXListall(msg)
local list = redis:smembers(mero..'Filter_Word:all')
print(#list)
if #list == 0 then return "•*│*قائمه الكلمات الممنوعه فارغه" end
filterlist = '•*│*قائمه الكلمات الممنوعه :\n'    
for k,v in pairs(list) do
filterlist = filterlist..'*'..k..'* -  '..Flter_Markdown(v)..'\n'
end 
return filterlist
end

function FilterX(msg)
local var = false
local Text = (msg.text or msg.content_.caption_)
local list = redis:smembers(mero..':Filter_Word:'..msg.chat_id_)
if #list ~=0 then
for k,word in pairs(list) do
if Text:match('^('..word..')$') or Text:match(word..' .*') or Text:match('.* '..word) then
Del_msg(msg.chat_id_,msg.id_)
print("Word is Del")
var = true
else
var = false
end
end
else
var = false
end 
return var
end


function FilterXList(msg)
local list = redis:smembers(mero..':Filter_Word:'..msg.chat_id_)
if #list == 0 then return "•*│*قائمه الكلمات الممنوعه فارغه" end
filterlist = '•*│*قائمه الكلمات الممنوعه :\n'    
for k,v in pairs(list) do
filterlist = filterlist..'*'..k..'* -  '..Flter_Markdown(v)..'\n'
end 
return filterlist
end

function AddFilter(msg, word)
if redis:sismember(mero..':Filter_Word:'..msg.chat_id_,word) then 
return  "•*│*الكلمه *{"..word.."}* هي بالتأكيد من قائمه المنع✓️" 
else
redis:sadd(mero..':Filter_Word:'..msg.chat_id_,word) 
return  "•*│*الكلمه *{"..word.."}* تمت اضافتها الى قائمه المنع ✓️"
end
end

function RemFilter(msg, word)
if redis:sismember(mero..':Filter_Word:'..msg.chat_id_,word) then 
redis:srem(mero..':Filter_Word:'..msg.chat_id_,word) 
return  "•*│*الكلمه *{"..word.."}* تم السماح بها ✓️" 
else
return  "•*│*الكلمه *{"..word.."}* هي بالتأكيد مسموح بها✓️" 
end
end

------------------------------------------

function CheckFlood(msg)
EnterCmd = true
local NumberFlood = tonumber(redis:get(mero..':Flood_Spam:'..msg.sender_user_id_..':msgs') or 0)
if NumberFlood > 3 then 
redis:setex(mero..':Flood_Spam:'..msg.sender_user_id_..':Stoped',10,true)
EnterCmd = false
elseif redis:get(mero..':Flood_Spam:'..msg.sender_user_id_..':Stoped') then
EnterCmd = false
else
redis:setex(mero..':Flood_Spam:'..msg.sender_user_id_..':msgs',3,NumberFlood+1)
end
return EnterCmd
end


function buck_up_groups(msg)

json_data = '{"BotID": '..mero..',"UserBot": "'..Bot_User..'","Groups" : {'
local All_Groups_ID = redis:smembers(mero..'group:ids')
for key,GroupS in pairs(All_Groups_ID) do
local NameGroup = (redis:get(mero..'group:name'..GroupS) or '')
NameGroup = NameGroup:gsub('"','')
NameGroup = NameGroup:gsub([[\]],'')
if key == 1 then
json_data =  json_data ..'"'..GroupS..'":{"Title":"'..NameGroup..'"'
else
json_data =  json_data..',"'..GroupS..'":{"Title":"'..NameGroup..'"'
end

local admins = redis:smembers(mero..'admins:'..GroupS)
if #admins ~= 0 then
json_data =  json_data..',"Admins" : {'
for key,value in pairs(admins) do
local info = redis:hgetall(mero..'username:'..value)
if info then 
UserName_ = (info.username or "")
UserName_ = UserName_:gsub([[\]],'')
UserName_ = UserName_:gsub('"','')
end 
if key == 1 then
json_data =  json_data..'"'..UserName_..'":'..value
else
json_data =  json_data..',"'..UserName_..'":'..value
end
end
json_data =  json_data..'}'
end

local creators = redis:smembers(mero..':MONSHA_BOT:'..GroupS)
if #creators ~= 0 then
json_data =  json_data..',"Creator" : {'
for key,value in pairs(creators) do
local info = redis:hgetall(mero..'username:'..value)
if info then 
UserName_ = (info.username or "")
UserName_ = UserName_:gsub([[\]],'')
UserName_ = UserName_:gsub('"','')
end 
if key == 1 then
json_data =  json_data..'"'..UserName_..'":'..value
else
json_data =  json_data..',"'..UserName_..'":'..value
end 
end
json_data =  json_data..'}'
end

local malk = redis:smembers(mero..':MALK_BOT:'..GroupS)
if #malk ~= 0 then
json_data =  json_data..',"malk" : {'
for key,value in pairs(malk) do
local info = redis:hgetall(mero..'username:'..value)
if info then 
UserName_ = (info.username or "")
UserName_ = UserName_:gsub([[\]],'')
UserName_ = UserName_:gsub('"','')
end 
if key == 1 then
json_data =  json_data..'"'..UserName_..'":'..value
else
json_data =  json_data..',"'..UserName_..'":'..value
end 
end
json_data =  json_data..'}'
end

local creator = redis:smembers(mero..':KARA_BOT:'..GroupS)
if #creator ~= 0 then
json_data =  json_data..',"Kara" : {'
for key,value in pairs(creator) do
local info = redis:hgetall(mero..'username:'..value)
if info then 
UserName_ = (info.username or "")
UserName_ = UserName_:gsub([[\]],'')
UserName_ = UserName_:gsub('"','')
end 
if key == 1 then
json_data =  json_data..'"'..UserName_..'":'..value
else
json_data =  json_data..',"'..UserName_..'":'..value
end 
end
json_data =  json_data..'}'
end

local owner = redis:smembers(mero..'owners:'..GroupS)
if #owner ~= 0 then
json_data =  json_data..',"Owner" : {'
for key,value in pairs(owner) do
local info = redis:hgetall(mero..'username:'..value)
if info then 
UserName_ = (info.username or "")
UserName_ = UserName_:gsub([[\]],'')
UserName_ = UserName_:gsub('"','')
end 
if key == 1 then
json_data =  json_data..'"'..UserName_..'":'..value
else
json_data =  json_data..',"'..UserName_..'":'..value
end
end
json_data =  json_data..'}'
end

json_data =  json_data.."}"
end

local Save_Data = io.open("./inc/"..Bot_User..".json","w+")
Save_Data:write(json_data..'}}')
Save_Data:close()
sendDocument(msg.chat_id_,msg.id_,"./inc/"..Bot_User..".json","✿| ملف النسخه الاحتياطيه ...\n✿| المجموعات » { "..#All_Groups_ID.." }\n✿| للبوت » "..Bot_User.."\n📆| التاريخ » "..os.date("%Y/%m/%d").."\n",dl_cb,nil)
end

function chat_list(msg)
local list = redis:smembers(mero..'group:ids')
message = '•*│*قائمه المجموعات :\n\n'
for k,v in pairs(list) do 
local info = redis:get(mero..'group:name'..v)
if info then 
if utf8.len(info) > 25 then
info = utf8.escape(utf8.gsub(info,0,25))..'...'
end
message = message..k..'ـ '..Flter_Markdown(info).. ' \nــ •⊱ { `' ..v.. '` } ⊰•\n\n'
else 
message = message..k.. 'ـ '..' ☜ •⊱ { `' ..v.. '` } ⊰• \n'
end 
end
all_groups = '•│قائمه المجموعات :<br><br>'
for k,v in pairs(list) do 
local info = redis:get(mero..'group:name'..v)
if info then
all_groups = all_groups..' '..k..'- <span style="color: #bd2a2a;">'..info.. '</span> <br> ايدي ☜ (<span style="color:#078883;">' ..v.. '</span>)<br>'
else
all_groups = all_groups..' '..k.. '- '..' ☜ (<span style="color:#078883;">' ..v.. '</span>) <br>'
end 
end

if utf8.len(message) > 4096 then
sendMsg(msg.chat_id_,1,'•*|*عذرا لديك الكثير من المجموعات\n•*|*سوف ارسل لك ملف فيها قائمه مجموعات المفعله انتظر لحظه ...')
file = io.open("./inc/All_Groups.html", "w")
file:write([[
<html dir="rtl">
<head>
<title>قائمه المجموعات •</title>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type"/>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://fonts.googleapis.com/css?family=Harmattan" rel="stylesheet">

</head>
<style>*{font-family: 'Harmattan', sans-serif;font-weight: 600;text-shadow: 1px 1px 16px black;}</style>
<body>
<p style="color:#018bb6;font-size: 17px;font-weight: 600;" aligin="center">قائمه المجموعات •</p>
<hr>
]]..all_groups..[[

</body>
</html>
]])
file:close()
return sendDocument(msg.chat_id_,msg.id_,'./inc/All_Groups.html','•│قائمه المجموعات بالكامله ✓ \n•│يحتوي ('..#list..') مجموعه \n•│افتح الملف في عارض HTML او بالمتصفح',dl_cb,nil)
else 
return sendMsg(msg.chat_id_,1,message) 
end 
end



function rem_data_group(id_group)
redis:del(
mero..'group:add'..id_group,
mero..'lock_link'..id_group, 
mero..'lock_id'..id_group,
mero..'lock_spam'..id_group, 
mero..'lock_webpage'..id_group,
mero..'lock_markdown'..id_group,
mero..'lock_flood'..id_group,
mero..'lock_bots'..id_group,
mero..'mute_forward'..id_group,
mero..'mute_contact'..id_group,
mero..'mute_location'..id_group,
mero..'mute_document'..id_group,
mero..'mute_keyboard'..id_group,
mero..'mute_game'..id_group,
mero..'mute_inline'..id_group,
mero..'lock_username'..id_group,
mero..'num_msg_mero'..id_group,
mero..'replay'..id_group
)
redis:srem(mero..'group:ids',id_group)
end



function set_admins(msg) 
GetChannelAdministrators(msg.chat_id_,function(arg,data)
local NumAdmin = 0
for k,v in pairs(data.members_) do
if not data.members_[k].bot_info_ and data.members_[k].status_.ID == "ChatMemberStatusEditor" then
NumAdmin = NumAdmin + 1
GetUserID(v.user_id_,function(arg,data)
redis:hset(mero..'username:'..data.id_,'username',ResolveUser(data))
redis:sadd(mero..'admins:'..msg.chat_id_,data.id_)
end,nil)
end
end
if NumAdmin == 0 then 
return sendMsg(msg.chat_id_,msg.id_,"•│لا يـوجـد ادمنيه لكي يتم رفعهم \n")
else
return sendMsg(msg.chat_id_,msg.id_,"•│تم رفع  { *"..NumAdmin.."* } مـن الادمنيه‌‏ في البوت \n✓️")
end
end,100)
end

function modadd(msg)
if redis:get(mero..'lock_service') then
service = true
Get_Director = 30
else
service = false
Get_Director = 1
end 
if not msg.SudoUser and not service then return '•│أنـت لـسـت الـمـطـور ' end
if msg.is_post_ then return "•│عذرا هذا بوت حمايه المجموعات وليس القنوات  " end
if msg.type ~= "channel" then return '•│لا يمكنك تفعيل البوت في المجوعات العاديه / البوت يدعم فقط المجموعات الخارقه ' end
if redis:get(mero..'group:add'..msg.chat_id_) then  return '•*│*المجموعه بالتأكيد ✓️ تم تفعيلها' end

local UserChaneel = redis:get(mero..":UserNameChaneel")
if UserChaneel and not msg.SudoBase then
local url , res = https.request(ApiToken..'/getchatmember?chat_id='..UserChaneel..'&user_id='..msg.sender_user_id_)
if res == 200 then
print(url) 
local Req = JSON.decode(url)
if Req.ok and Req.result and Req.result.status == "left" or Req.result.status == "kicked" then
return "• اشترك بالقناة أولاً ["..UserChaneel.."] \n•|ثم ارجع ارسـل تفعيل ."
end
else
return "• اشترك بالقناة أولا ["..UserChaneel.."] \n•|ثم ارجع ارسـل تفعيل ."
end
end
 
redis:setex(mero..":ismember:"..msg.sender_user_id_,1500,true)
GetFullChat(msg.chat_id_,function(arg,data) 
local GroupUsers = tonumber(redis:get(mero..':addnumberusers') or 0)
local Groupcount = tonumber(data.member_count_)
if GroupUsers  >= Groupcount and not msg.SudoBase then
return sendMsg(msg.chat_id_,msg.id_,'•*│* لا يمكنني تفعيل البوت في المجموعة‏ يجب ان تكون اكثر مـن *【'..GroupUsers..'】* عضـو ')
else 
GetChatMember(msg.chat_id_,our_id,function(arg,data)
if data.status_.ID == "ChatMemberStatusMember" then
return sendMsg(msg.chat_id_,msg.id_,'•*|*عذرا البوت ليس مشرف في المجموعه ♨️\n•*|*يرجى ترقيته الى مشرف لتتمكن من تفعيل البوت ✓️')
else
local lock_service = redis:get(mero..'lock_service')
if lock_service then 
sendMsg(msg.chat_id_,msg.id_,'*•|تـم تفعيل البوت في القروب ✓️* \n•|تم رفع مشرفين ادمن في البوت‌‌‏ \n✓')
else
sendMsg(msg.chat_id_,msg.id_,'•│تـم تفعيل القروب \n✓️')
end
GetChannelAdministrators(msg.chat_id_,function(arg,data)
for k,v in pairs(data.members_) do
if data.members_[k].status_.ID == "ChatMemberStatusCreator" then
GetUserID(v.user_id_,function(arg,data)
redis:hset(mero..'username:'..data.id_, 'username', ResolveUser(data))
redis:sadd(mero..':MALK_BOT:'..msg.chat_id_,data.id_)
end)
elseif lock_service and not data.members_[k].bot_info_ and data.members_[k].status_.ID == "ChatMemberStatusEditor" then
GetUserID(v.user_id_,function(arg,data)
redis:hset(mero..'username:'..data.id_,'username',ResolveUser(data))
redis:sadd(mero..'admins:'..msg.chat_id_,data.id_)
end,nil)
end
end 

redis:mset(
mero..'group:add'..msg.chat_id_,true,
mero..'lock_link'..msg.chat_id_,true, 
mero..'lock_id'..msg.chat_id_,true,
mero..'lock_spam'..msg.chat_id_,true,
mero..'lock_webpage'..msg.chat_id_,true,
mero..'lock_markdown'..msg.chat_id_,true,
mero..'lock_flood'..msg.chat_id_,true,
mero..'lock_bots'..msg.chat_id_,true,
mero..'mute_forward'..msg.chat_id_,true,
mero..'mute_contact'..msg.chat_id_,true,
mero..'mute_location'..msg.chat_id_,true,
mero..'mute_document'..msg.chat_id_,true,
mero..'mute_keyboard'..msg.chat_id_,true,
mero..'mute_game'..msg.chat_id_,true,
mero..'mute_inline'..msg.chat_id_,true,
mero..'lock_username'..msg.chat_id_,true,
mero..'num_msg_mero'..msg.chat_id_,5, 
mero..'replay'..msg.chat_id_,true
)
redis:del(mero..'lock_geams'..msg.chat_id_) 
redis:del(mero..'mute_inline'..msg.chat_id_) 
redis:set(mero..'lock:kara:'..msg.chat_id_,'off')
redis:del(mero.."Ban:Cheking"..msg.chat_id_)
redis:set(mero..'tagall@all'..msg.chat_id_,'open') 
redis:del(mero.."kadmeat"..msg.chat_id_)
redis:sadd(mero..'group:ids',msg.chat_id_) 
redis:set(mero.."lock_edit_media"..msg.chat_id_,true)
redis:sadd(mero..'mtwr_count'..msg.sender_user_id_,msg.chat_id_)
redis:set(mero.."brj_Bots"..msg.chat_id_,"open")
redis:del(mero..'lock_bots_by_kick'..msg.chat_id_)
redis:del(mero..'lock_bots'..msg.chat_id_)
redis:set(mero..'replayallbot'..msg.chat_id_,true)
GroupTitle(msg.chat_id_,function(arg,data)
local NameGroup = data.title_
redis:set(mero..'group:name'..msg.chat_id_,NameGroup)
local Gp_Link = ExportLink(msg.chat_id_)
if Gp_Link and Gp_Link.result then
Gp_Link = Gp_Link.result
else
Gp_Link = ""
end
redis:set(mero..'linkGroup'..msg.chat_id_,Gp_Link)
if not we_sudo(msg) then
GetUserID(msg.sender_user_id_,function(arg,datai)
if datai.username_ then 
USERNAME_T = '•*│*الـمعرف ❪ @['..datai.username_..'] ❫\n'
else 
USERNAME_T = ''
end
return send_msg(SUDO_ID,'⚜*│* تــــم تــفــعــيــل الـــبـــوت ...\n●ـ▬ـ▬ـ▬ஜ۩۞۩ஜ▬ـ▬ـ▬ـ●\n•╿معلومات المجموعه\n'
..'•│اسم المجموعه ❪ ['..NameGroup..']('..Gp_Link..') ❫\n'
..'•│ايدي المجموعه ❪ '..msg.chat_id_..' ❫\n'
..'•|عدد اعضاء المجموعه ❪ *'..Groupcount..'* ❫ \n●ـ▬ـ▬ـ▬ஜ۩۞۩ஜ▬ـ▬ـ▬ـ●\n•|معلومات الشخص الي ضافني \n'
..'•*│*الاسـم ❪ ['..FlterName(datai.first_name_..' '..(datai.last_name_ or ""),23)..'](tg://user?id='..msg.sender_user_id_..') ❫\n'
..USERNAME_T..'\n📆│تاريخ التفعيل ❪* '..os.date("%Y/%m/%d")
..' *❫\n✿╽الساعه ❪* '..os.date("%I:%M%p")..' *❫')
end,nil)
end
end)
end,Get_Director) 
end
end)
end 
end)
return false
end 

function modrem(msg)
if not msg.SudoUser then return '✿*│* أنـت لـسـت الـمـطـور •'end
if not redis:get(mero..'group:add'..msg.chat_id_) then return '✿*│* المجموعه بالتأكيد ✓️ تم تعطيلها' end  
rem_data_group(msg.chat_id_)
return '•*│* تـم تـعـطـيـل القروب '
end

function modrem(msg)
if not msg.SudoUser then return '•*│*أنـت لـسـت الـمـطـور 'end
if not redis:get(mero..'group:add'..msg.chat_id_) then return '•*│*القروب بالتأكيد ✓️ تم تعطيلو' end  
rem_data_group(msg.chat_id_)
return '•*│*تـم تـعـطـيـل القروب '
end

function action_by_reply(arg,data)  --===  معلومات الرد 
local MsgID = arg.msg.id_
local ChatID = arg.msg.chat_id_
if data.sender_user_id_ then
local cmd = arg.cmd
local UserID = data.sender_user_id_
GetUserID(UserID,function(arg,data)

local Resolv = ResolveUser(data)

if data.username_ then 
USERNAME = '@'..data.username_
else 
USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or ""),20) 
end
USERCAR = utf8.len(USERNAME)


if cmd =="tqeed" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك تقييد البوت\n") 
elseif UserID == tonumber(1099083018) then
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك تقييد مبرمج السورس\n") 
elseif UserID == tonumber(1965223041) then
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك تقييد Carbon\n") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك تقييد المطور الاساسي\n") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك تقييد المطور\n") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك تقييد المـــــــــالك \n") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك تقييد المنشىء الاساسي \n") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك تقييد المنشــئ \n") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك تقييد المـــــدير \n") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك تقييد الادمـــــن \n") 
end
GetChatMember(ChatID,UserID,function(arg,data)
if data.status_.ID == "ChatMemberStatusEditor" then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنني تقييد المشرف\n✿") 
else
Restrict(ChatID,UserID,1)
redis:sadd(mero..'Muted:User:kid'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تقييد العضـو بنجاح \n✓️',12,USERCAR) 
end
end)
end

if cmd =="fktqeed" then
if UserID == our_id then  
return sendMsg(ChatID,MsgID,"•*│*البوت ليس مقييد  \n") 
end
Restrict(ChatID,UserID,2)
redis:srem(mero..'Muted:User:kid'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n•╽تم فك تقييد العضـو بنجاح \n✓️',12,USERCAR) 
end

if cmd == "setmnsha" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكنني رفع نفسي \n") 
elseif data.type_.ID  == "UserTypeBot" then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكن رفع بوت في البوت \n") 
elseif data.type_.ID == "chatTypeChannel" then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكن رفع قناة في البوت \n") 
end
if redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n•╽انه بالتأكيد منشىء  \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID,'username',Resolv)
redis:sadd(mero..':MONSHA_BOT:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n•╽تمت ترقيته ليصبح منشىء \n✓️',12,USERCAR) 
end

if cmd == "remmnsha" then
if not redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then
return SendMention(ChatID,UserID,MsgID,'•╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n•╽انه بالتأكيد ليس منشىء \n✓️',12,USERCAR) 
end
redis:srem(mero..':MONSHA_BOT:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n•╽تم تنزيله من المنشىء \n✓️',12,USERCAR) 
end
if cmd == "RemMshrf" then
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. ChatID .. "&user_id=" ..UserID.."&can_change_info=false&can_manage_chat=false&can_manage_voice_chats=false&can_delete_messages=false&can_invite_users=false&can_restrict_members=false&can_pin_messages=false&can_promote_members=false")
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله مشرف \n✓️',12,USERCAR) 
end


if cmd == "SetMshrf" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكنني رفع نفسي \n") 
elseif data.type_.ID  == "UserTypeBot" then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكن رفع بوت في البوت \n") 
elseif data.type_.ID == "chatTypeChannel" then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكن رفع قناة في البوت \n") 
end
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. ChatID .. "&user_id=" ..UserID.."&can_manage_chat=false&can_manage_voice_chats=true&can_manage_voice_chats=false&can_delete_messages=true&can_invite_users=true&can_restrict_members=true&can_pin_messages=true&can_promote_members=false")
return SendMention(ChatID,UserID,MsgID,'•╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n•╽تم ترقيته مشرف \n✓️',12,USERCAR) 
end
if cmd == "SetMshrf1" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكنني رفع نفسي \n✿") 
elseif data.type_.ID  == "UserTypeBot" then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
elseif data.type_.ID == "chatTypeChannel" then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
end
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. ChatID .. "&user_id=" ..UserID.."&can_change_info=true&can_manage_chat=false&can_manage_voice_chats=true&can_delete_messages=true&can_invite_users=true&can_restrict_members=true&can_pin_messages=true&can_promote_members=true")
return SendMention(ChatID,UserID,MsgID,'•╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n•╽تم ترقيته مشرف \n✓️',12,USERCAR) 
end

if cmd == "setmalk" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكنني رفع نفسي \n") 
elseif data.type_.ID  == "UserTypeBot" then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكن رفع بوت في البوت \n") 
elseif data.type_.ID == "chatTypeChannel" then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكن رفع قناة في البوت \n") 
end
if redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n•╽انه بالتأكيد المالك  \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID,'username',Resolv)
redis:sadd(mero..':MALK_BOT:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n•╽تمت ترقيته ليصبح المالك   \n✓️',12,USERCAR) 
end

if cmd == "remmalk" then
if not redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then
return SendMention(ChatID,UserID,MsgID,'•╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n•╽انه بالتأكيد ليس المالك \n✓️',12,USERCAR) 
end
redis:srem(mero..':MALK_BOT:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n•╽تم تنزيله من المالك \n✓️',12,USERCAR) 
end

if cmd == "setkara" then
  if UserID == our_id then 
  return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكنني رفع نفسي \n✿") 
  elseif data.type_.ID  == "UserTypeBot" then 
  return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
  elseif data.type_.ID == "chatTypeChannel" then 
  return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
  end
  if redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
  return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد المنشىء الاساسي  \n✓️',12,USERCAR) 
  end
  redis:hset(mero..'username:'..UserID,'username',Resolv)
  redis:sadd(mero..':KARA_BOT:'..ChatID,UserID)
  return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت ترقيته ليصبح منشىء اساسي  \n✓️',12,USERCAR) 
  end
  
  if cmd == "remkara" then
  if not redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then
  return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس المنشىء الاساسي \n✓️',12,USERCAR) 
  end
  redis:srem(mero..':KARA_BOT:'..ChatID,UserID)
  return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من المنشىء الاساسي\n✓️',12,USERCAR) 
  end
  if cmd == "SetMALK_BOT" then
  if UserID == our_id then 
  return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
  elseif data.type_.ID  == "UserTypeBot" then 
  return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
  elseif data.type_.ID == "chatTypeChannel" then 
  return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
  end
  if redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
  return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد مالك المجموعه  \n✓️',12,USERCAR) 
  end
  redis:hset(mero..'username:'..UserID,'username',Resolv)
  redis:sadd(mero..':MALK_BOT:'..ChatID,UserID)
  return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت ترقيته ليصبح مالك المجموعه  \n✓️',12,USERCAR) 
  end
  
  if cmd == "RemMALK_BOT" then
  if not redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then
  return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس مالك \n✓️',12,USERCAR) 
  end
  redis:srem(mero..':MALK_BOT:'..ChatID,UserID)
  return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من المالك\n✓️',12,USERCAR) 
  end


if cmd == "setwhitelist" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
elseif data.type_.ID == "UserTypeBot" then
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
elseif data.type_.ID == "ChatTypeChannel" then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
end
if redis:sismember(mero..'whitelist:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد عضو مميز \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'whitelist:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت ترقيته ليصبح عضو مميز \n✓️',12,USERCAR) 
end

if cmd == "remwhitelist" then
if not redis:sismember(mero..'whitelist:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس عضو مميز \n✓️',12,USERCAR) 
end
redis:srem(mero..'whitelist:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت تنزيله من عضو مميز \n✓️',12,USERCAR) 
end

if cmd == "setowner" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
elseif data.type_.ID == "UserTypeBot" then
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
end
if redis:sismember(mero..'owners:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد مدير  \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'owners:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت ترقيته ليصبح مدير \n✓️',12,USERCAR) 
end

if cmd == "promote" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
elseif data.type_.ID == "UserTypeBot" then
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
end
if redis:sismember(mero..'admins:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ادمن \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'admins:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت ترقيته ليصبح ادمن \n✓️',12,USERCAR) 
end

if cmd == "remowner" then
if not redis:sismember(mero..'owners:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس مدير \n✓️',12,USERCAR) 
end
redis:srem(mero..'owners:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من المدير  \n✓️',12,USERCAR) 
end

if cmd == "demote" then
if not redis:sismember(mero..'admins:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس ادمن \n✓️',12,USERCAR) 
end
redis:srem(mero..'admins:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من الادمنيه \n✓️',12,USERCAR) 
end

if cmd == "iduser" then
return SendMention(ChatID,UserID,MsgID,"•│اضـغط على الايدي ليتم النسـخ\n\n "..USERNAME.." ~⪼ { "..UserID.." }",37,USERCAR)
end
if cmd == "whois" then
local namei = data.first_name_..' '..(data.last_name_ or "")
if data.username_ then useri = '@'..data.username_ else useri = " لا يوجد " end
SendMention(ChatID,UserID,MsgID,'•|الاسم » '..namei..'\n'..'•│ الايدي » {'..UserID..'} \n'..'•│ المعرف » '..useri..'\n'..'•│ الرتبه » '..Getrtba(UserID,ChatID)..'\n'..'✿╽ نوع الكشف » بالرد\n✿',12,USERCAR) 
end

if cmd == "active" then
local maseegs = redis:get(mero..'msgs:'..UserID..':'..ChatID) or 1
local namei = FlterName(data.first_name_..' '..(data.last_name_ or ""))
return SendMention(ChatID,UserID,MsgID,'•|العضو » '..namei..' \n•│رسائلك » ❪ '..maseegs..' ❫ رسالةة\n✿╽التفاعل »  ❪ '..Get_Ttl(maseegs)..' ❫\n🙇🏽',12,utf8.len(namei)) 
end

if cmd == "ban" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر البوت\n✿") 
elseif UserID == tonumber(1099083018) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر مبرمج السورس\n✿") 
elseif UserID == tonumber(1965223041) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر Carbon\n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المطور الاساسي\n✿") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المطور\n✿") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المـــــــــالك \n✿") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المنشىء الاساسي \n✿") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المنشــئ \n✿") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المـــــدير \n✿") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر الادمـــــن \n✿") 
end
kick_user(UserID,ChatID,function(arg,data)
if data.ID == "Error" and data.code_ == 400 then
return sendMsg(ChatID,MsgID,'✿*╿*لا يمكنني حظر العضو .\n✿*╽*لانه مشرف في المجموعه \n ❕')    
elseif data.ID == "Error" and data.code_ == 3 then
return sendMsg(ChatID,MsgID,'✿*╿*لا يمكنني حظر العضو .\n✿*╽*ليس لدي صلاحيه الحظر او لست مشرف\n ❕')    
else
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'banned:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم حظره  \n✓️',12,USERCAR) 
end
end)

end

if cmd == "unban" then
if not redis:sismember(mero..'banned:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم بالتأكيد الغاء حظره  \n✓️',12,USERCAR) 
else
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم الغاء حظره \n✓️',12,USERCAR) 
end
redis:srem(mero..'banned:'..ChatID,UserID)
StatusLeft(ChatID,UserID)
end

if cmd == "silent" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم البوت\n✿") 
elseif UserID == tonumber(1099083018) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم مبرمج السورس \n✿") 
elseif UserID == tonumber(1965223041) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم Carbon \n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المطور الاساسي\n✿") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المطور\n✿") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المـــــــــالك \n✿") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المنشىء الاساسي \n✿") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المنشــئ \n✿") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المـــــدير \n✿") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم الادمـــــن \n✿") 
end
if redis:sismember(mero..'is_silent_users:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم بالتأكيد كتمه  \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'is_silent_users:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم كتمه \n✓️',12,USERCAR) 
end

if cmd == "unsilent" then
if not redis:sismember(mero..'is_silent_users:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم بالتاكيد الغاء كتمه  \n✓️',12,USERCAR) 
end
redis:srem(mero..'is_silent_users:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم الغاء كتمه  \n✓️',12,USERCAR) 
end

if cmd == "banall" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر البوت\n✿") 
elseif UserID == tonumber(1099083018) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر مبرمج السورس\n✿") 
elseif UserID == tonumber(1965223041) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر Carbon \n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│* لا يمكنك حظر المطور الاساسي\n✿")
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المطور\n✿") 
end
if GeneralBanned(UserID) then return sendMsg(ChatID,MsgID,'✿*╿* العضو » ❪ '..USERNAME..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم بالتأكيد حظره عام \n✓️') end
redis:hset(mero..'username:'..UserID, 'username',Resolv)
redis:sadd(mero..'gban_users',UserID)
kick_user(UserID, ChatID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم حظره عام \n✓️',12,USERCAR) 
end

if cmd == "unbanall" then
if not GeneralBanned(UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم بالتأكيد الغاء حظره العام \n✓️',12,USERCAR) 
end
redis:srem(mero..'gban_users',UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم الغاء حظره العام \n✓️',12,USERCAR) 
end

if cmd == "kick" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد البوت\n✿") 
elseif UserID == tonumber(1099083018) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد مبرمج السورس\n✿") 
elseif UserID == tonumber(1965223041) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد Carbon \n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المطور الاساسي\n✿") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المطور\n✿") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المـــــــــالك \n✿") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المنشىء الاساسي \n✿") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المنشــئ \n✿") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المـــــدير \n✿") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد الادمـــــن \n✿") 
end
kick_user(UserID, ChatID,function(arg,data)
if data.ID == "Error" and data.code_ == 400 then
return sendMsg(ChatID,MsgID,'✿*╿* لا يمكنني حظر العضو .\n✿*╽*لانه مشرف في المجموعه \n ❕')    
elseif data.ID == "Error" and data.code_ == 3 then
return sendMsg(ChatID,MsgID,'✿*╿* لا يمكنني حظر العضو .\n✿*╽*ليس لدي صلاحيه الحظر او لست مشرف\n ❕')    
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'banned:'..ChatID,UserID)
StatusLeft(ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم طرد العضو \n✓️',12,USERCAR) 
end)

end

if cmd == "rtba" then
GetChatMember(ChatID,UserID,function(arg,data)
if data.status_ and data.status_.ID == "ChatMemberStatusEditor" then
SudoGroups = 'مشرف '
elseif data.status_ and data.status_.ID == "ChatMemberStatusCreator" then 
SudoGroups = "المــالك"
else
SudoGroups = "عضو .!"
end
if UserID == our_id then 
Getrtb = 'الادمـــــن ' 
elseif  UserID == tonumber(1099083018) then
Getrtb = ' مبرمج السورس ' 
elseif  UserID == tonumber(1965223041) then
Getrtb = ' Carbon ' 
elseif  UserID == SUDO_ID then
Getrtb = 'مطور اساسي ' 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then
Getrtb = 'مطور ' 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then
Getrtb = 'المـــــــــالك ' 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then
Getrtb = 'المنشىء الاساسي ' 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then
Getrtb = 'المنشــىء ' 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then
Getrtb = 'المـــــدير ' 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then
Getrtb = 'الادمـــــن ' 
elseif redis:sismember(mero..'whitelist:'..ChatID,UserID) then
Getrtb = 'مميز' 
else
Getrtb = 'عضو' 
end
return SendMention(ChatID,UserID,MsgID,'•│العضو » ❪ '..USERNAME..' ❫\n\n•│في البوت » ❪ '..Getrtb..' ❫\n•│في المجموعه » ❪ '..SudoGroups..' ❫\n✓',12,USERCAR) 
end)
end

if cmd == "up_sudo" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
elseif data.type_.ID == "UserTypeBot" then
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
end
if redis:sismember(mero..':SUDO_BOT:',UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد مطور \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..':SUDO_BOT:',UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم ترقيته ليصبح مطور \n✓️',12,USERCAR) 
end

if cmd == "dn_sudo" then
if not redis:sismember(mero..':SUDO_BOT:',UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس مطور \n✓️',12,USERCAR) 
end
redis:srem(mero..':SUDO_BOT:',UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من المطورين \n✓️',12,USERCAR) 
end  -- End Cmd 
end,nil)
else
return sendMsg(ChatID,MsgID,"✿*│* عذرا هذا العضو ليس موجود ضمن المجموعات \n❕")
end 
end


function action_by_username(arg,data)
local cmd = arg.cmd 

local ChatID = arg.msg.chat_id_
local MsgID = arg.msg.id_
if data.id_ then
local UserID = data.id_
local UserName = '@'..arg.msg.text:match('@[%a%d_]+'):gsub('@',''):gsub('_',[[\_]])
print(UserName)
if cmd =="tqeed" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد البوت\n✿") 
elseif UserID == tonumber(779108237) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد 🔹️ GENERAL \n✿") 
elseif UserID == tonumber(1211544689) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد 🔹️ Carbon 🔹️\n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد المطور الاساسي\n✿") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد المطور\n✿") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد المنشىء الاساسي 🌟\n✿") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد المـــــــــالك 🌟\n✿") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد المنشــئ 🌟\n✿") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد المـــــدير 🌟\n✿") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد الادمـــــن 🌟\n✿") 
end
GetChatMember(ChatID,our_id,function(arg,data)
if data.status_.ID == "ChatMemberStatusEditor" then 
GetChatMember(ChatID,UserID,function(arg,data)
if data.status_.ID == "ChatMemberStatusEditor" then 
return sendMsg(ChatID,MsgID,'✿*╿*لا يمكنني تقييد العضو .\n✿*╽*لانه مشرف في المجموعه \n ❕')    
else
Restrict(ChatID,UserID,1)  
redis:sadd(mero..'Muted:User:kid'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم تقييد العضـو بنجاح \n✓️') 
end
end)
else
return sendMsg(ChatID,MsgID,'✿*╿*لا يمكنني تقييد العضو .\n✿*╽*لانني لست مشرف في المجموعه \n ❕')    
end
end)

end

if cmd =="fktqeed" then
if UserID == our_id then  
return sendMsg(ChatID,MsgID,"✿*│*البوت ليس مقييد \n❗️ ") 
end
GetUserID(UserID,function(arg,data)
GetChatMember(ChatID,our_id,function(arg,data)
if data.status_.ID == "ChatMemberStatusEditor" then 
Restrict(ChatID,UserID,2)
redis:srem(mero..'Muted:User:kid'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم فك تقييد العضـو بنجاح \n✓️') 
else
return sendMsg(ChatID,MsgID,'✿*╿*لا يمكنني قك تقييد العضو .\n✿*╽*لانني لست مشرف في المجموعه \n ❕')    
end
end)
end,nil)
end

if cmd == "setkara" then
  if UserID == our_id then 
  return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
  elseif data.type_.ID  == "UserTypeBot" then 
  return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
  elseif data.type_.ID == "chatTypeChannel" then 
  return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
  end
  if redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
    return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿╽انه بالتأكيد المنشىء الاساسي  \n✓️') 
  end
  redis:hset(mero..'username:'..UserID, 'username', UserName)
  redis:sadd(mero..':KARA_BOT:'..ChatID,UserID)
  return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿╽تمت ترقيته ليصبح منشىء اساسي  \n✓️') 
  end
  
  if cmd == "remkara" then
  if not redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..UserName..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس المنشىء الاساسي \n✓️') 
  end
  redis:srem(mero..':KARA_BOT:'..ChatID,UserID)
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..UserName..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من المنشىء الاساسي\n✓️') 
  end
if cmd == "SetMALK_BOT" then
  if UserID == our_id then 
  return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
  elseif data.type_.ID  == "UserTypeBot" then 
  return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
  elseif data.type_.ID == "chatTypeChannel" then 
  return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
  end
  if redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
    return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿╽انه بالتأكيد مالك المجموعه  \n✓️') 
  end
  redis:hset(mero..'username:'..UserID, 'username', UserName)
  redis:sadd(mero..':MALK_BOT:'..ChatID,UserID)
  return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿╽تمت ترقيته ليصبح مالك المجموعه  \n✓️') 
  end
  
  if cmd == "RemMALK_BOT" then
  if not redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..UserName..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس المالك \n✓️') 
  end
  redis:srem(mero..':MALK_BOT:'..ChatID,UserID)
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..UserName..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من مالك\n✓️') 
  end
  
if cmd == "setmnsha" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
elseif data.type_.ID == "UserTypeBot" then
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
elseif data.type_.ID == "ChatTypeChannel" then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
end
if redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*انه بالتأكيد منشىء في البوت \n✓️') 
end
redis:hset(mero..'username:'..UserID, 'username', UserName)
redis:sadd(mero..':MONSHA_BOT:'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تمت ترقيته ليصبح منشىء  \n✓️')
end

if cmd == "SetMshrf" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
elseif data.type_.ID == "UserTypeBot" then
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
elseif data.type_.ID == "ChatTypeChannel" then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
end
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. ChatID .. "&user_id=" ..UserID.."&can_manage_chat=false&can_manage_voice_chats=true&can_manage_voice_chats=false&can_delete_messages=true&can_invite_users=true&can_restrict_members=true&can_pin_messages=true&can_promote_members=false")
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تمت ترقيته ليصبح مشرف  \n✓️')
end
 if cmd == "RemMshrf" then
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. ChatID .. "&user_id=" ..UserID.."&can_change_info=false&can_manage_chat=false&can_manage_voice_chats=false&can_delete_messages=false&can_invite_users=false&can_restrict_members=false&can_pin_messages=false&can_promote_members=false")
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم تنزيله مشرف  \n✓️')
end
if cmd == "SetMshrf1" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
elseif data.type_.ID == "UserTypeBot" then
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع بوت في البوت \n✿") 
elseif data.type_.ID == "ChatTypeChannel" then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
end
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. ChatID .. "&user_id=" ..UserID.."&can_change_info=true&can_manage_chat=false&can_manage_voice_chats=true&can_delete_messages=true&can_invite_users=true&can_restrict_members=true&can_pin_messages=true&can_promote_members=true")
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تمت ترقيته ليصبح مشرف  \n✓️')
end


if cmd == "remmnsha" then
if not redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*انه بالتأكيد ليس منشىء \n✓️') 
end
redis:srem(mero..':MONSHA_BOT:'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تمت تنزيله من المنشــىء \n✓️') 
end

if cmd == "setwhitelist" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
elseif data.type_.ID == "ChannelChatInfo" then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
end
if redis:sismember(mero..'whitelist:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*انه بالتأكيد من عضو مميز \n✓️') 
end
redis:hset(mero..'username:'..UserID, 'username', UserName)
redis:sadd(mero..'whitelist:'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تمت ترقيته ليصبح عضو مميز \n✓️')
end

if cmd == "remwhitelist" then
if not redis:sismember(mero..'whitelist:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*انه بالتأكيد ليس من عضو مميز \n✓️') 
end
redis:srem(mero..'whitelist:'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تمت تنزيله من عضو مميز \n✓️')
end

if cmd == "setowner" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
elseif data.type_.ID == "ChannelChatInfo" then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
end
if redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*انه بالتأكيد المـــــدير \n✓️') 
end
redis:hset(mero..'username:'..UserID, 'username', UserName)
redis:sadd(mero..'owners:'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تمت ترقيته ليصبح مدير \n✓️')
end

if cmd == "promote" then
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكنني رفع نفسي \n✿") 
elseif data.type_.ID == "ChannelChatInfo" then 
return sendMsg(ChatID,MsgID,"✿*│*عذرا لا يمكن رفع قناة في البوت \n✿") 
end
if redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*انه بالتأكيد الادمـــــن  \n✓️') 
end
redis:hset(mero..'username:'..UserID, 'username', UserName)
redis:sadd(mero..'admins:'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تمت ترقيته ليصبح الادمـــــن  \n✓️')
end

if cmd == "remowner" then
if not redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*انه بالتأكيد ليس مدير \n✓️') 
end
redis:srem(mero..'owners:'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم تنزيله من الاداره \n✓️')
end

if cmd == "demote" then
if not redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*انه بالتأكيد ليس الادمـــــن  \n✓️') 
end
redis:srem(mero..'admins:'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم تنزيله من الادمنيه \n✓️')
end

if cmd == "iduser" then
return sendMsg(ChatID,MsgID,"✿*│* اضـغط على الايدي ليتم النسـخ\n\n "..UserName.." ~⪼ ( `"..UserID.."` )")
end

if cmd == "whois" then
return sendMsg(ChatID,MsgID,
  '•✿*╿* الاسم » '..FlterName(data.title_,30)..'\n'
..'•*│* الايدي » {`'..UserID..'`} \n'
..'•*│* المعرف » '..UserName..'\n'
..'•│ الرتبه » '..Getrtba(UserID,ChatID)..'\n'..'•*╽* نوع الكشف » بالمعرف\n'
..'•')
end

if cmd == "active" then
local maseegs = redis:get(mero..'msgs:'..UserID..':'..ChatID) or 1
local namei = FlterName(data.title_)
return SendMention(ChatID,UserID,MsgID,'•العضو » ❪ '..namei..' ❫\n•│رسائلك » ❪ '..maseegs..' ❫ رسالةة\n•╽التفاعل »  ❪ '..Get_Ttl(maseegs)..' ❫\n',12,utf8.len(namei)) 
end 

if cmd == "ban" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك حظر البوت\n") 
elseif UserID == tonumber(1099083018) then
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك حظر مطور السورس \n") 
elseif UserID == tonumber(1965223041) then
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك حظر Carbon \n") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك حظر المطور الاساسي\n") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك حظر المطور\n") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك حظر المنشىء الاساسي \n") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك حظر المالك \n") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك حظر المنشــئ \n") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك حظر المـــــدير \n") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك حظر الادمـــــن \n") 
end
if UserID == our_id then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكنني حظر نفسي \n") 
elseif data.type_.ID == "ChannelChatInfo" then 
return sendMsg(ChatID,MsgID,"•*│*عذرا لا يمكن حظر قناة \n") 
end
if redis:sismember(mero..'banned:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,'•*╿*العضو » ❪ '..UserName..' ❫\n•*│*الايدي » ❪ `'..UserID..'` ❫\n•*╽*تم بالتأكيد حظره \n✓️') 
end
kick_user(UserID, ChatID,function(arg,data)
if data.ID == "Error" and data.code_ == 400 then
return sendMsg(ChatID,MsgID,'•*╿* لا يمكنني حظر العضو .\n•*╽*لانه مشرف في المجموعه \n ❕')    
elseif data.ID == "Error" and data.code_ == 3 then
return sendMsg(ChatID,MsgID,'•*╿* لا يمكنني حظر العضو .\n•*╽*ليس لدي صلاحيه الحظر او لست مشرف\n ❕')    
end
redis:hset(mero..'username:'..UserID, 'username', UserName)
redis:sadd(mero..'banned:'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'•*╿*العضو » ❪ '..UserName..' ❫\n•*│*الايدي » ❪ `'..UserID..'` ❫\n•*╽*تم حظره \n✓️')
end)
end  

if cmd == "unban" then
if not redis:sismember(mero..'banned:'..ChatID,UserID) then 
sendMsg(ChatID,MsgID,'•*╿*العضو » ❪ '..UserName..' ❫\n•*│*الايدي » ❪ `'..UserID..'` ❫\n•*╽*تم بالتأكيد الغاء حظره \n✓️') 
else
sendMsg(ChatID,MsgID,'•*╿*العضو » ❪ '..UserName..' ❫\n•*│*الايدي » ❪ `'..UserID..'` ❫\n•*╽*تم الغاء حظره \n✓️')
end
redis:srem(mero..'banned:'..ChatID,UserID)
StatusLeft(ChatID, UserID)
end

if cmd == "silent" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك كتم البوت\n") 
elseif UserID == tonumber(1099083018) then
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك كتم مطور السورس \n") 
elseif UserID == tonumber(1965223041) then
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك كتم Carbon \n") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك كتم المطور الاساسي\n") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك كتم المطور\n") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك كتم المنشىء الاساسي \n") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك كتم المالك ??\n") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك كتم المنشــئ \n") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك كتم المـــــدير \n") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"•*│*لا يمكنك كتم الادمـــــن \n") 
end
if redis:sismember(mero..'is_silent_users:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,'•*╿*العضو » ❪ '..UserName..' ❫\n•*│*الايدي » ❪`'..UserID..'` ❫\n•*╽*تم بالتأكيد كتمه \n✓️') 
end
redis:hset(mero..'username:'..UserID, 'username', UserName)
redis:sadd(mero..'is_silent_users:'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'•*╿*العضو » ❪ '..UserName..' ❫\n•*│*الايدي » ❪ `'..UserID..'` ❫\n•*╽*تم كتمه \n✓️')
end

if cmd == "unsilent" then
if not redis:sismember(mero..'is_silent_users:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,'•*╿*العضو » ❪ '..UserName..' ❫\n•*│*الايدي » ❪ `'..UserID..'` ❫\n•*╽*م بالتأكيد الغاء كتمه \n✓️') 
end
redis:srem(mero..'is_silent_users:'..ChatID,UserID)
return sendMsg(ChatID,MsgID,'•*╿*العضو » ❪ '..UserName..' ❫\n•*│*الايدي » ❪ `'..UserID..'` ❫\n•*╽*تم الغاء كتمه \n✓️')
end

if cmd == "banall" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر البوت\n✿") 
elseif UserID == tonumber(1099083018) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر 🔹️ GENERAL 🔹️️\n✿") 
elseif UserID == tonumber(1965223041) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر 🔹️ Carbon 🔹️️\n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المطور الاساسي\n✿")
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المطور\n✿") 
end
if GeneralBanned(UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم بالتأكيد حظره عام \n✓️') 
end
redis:hset(mero..'username:'..UserID, 'username', UserName)
redis:sadd(mero..'gban_users',UserID)
kick_user(UserID, ChatID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم حظره عام \n✓️')
end

if cmd == "unbanall" then
if not GeneralBanned(UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*م بالتأكيد الغاء حظره العام \n✓️') 
end
redis:srem(mero..'gban_users',UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم الغاء حظره العام \n✓️')
end

if cmd == "kick" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد البوت\n✿") 
elseif UserID == tonumber(779108237) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد 🔹️ GENERAL 🔹️\n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المطور الاساسي\n✿") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المطور\n✿") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المنشىء الاساسي 🌟\n✿") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المـــــــــالك 🌟\n✿") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المنشــئ 🌟\n✿") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المـــــدير 🌟\n✿") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد الادمـــــن 🌟\n✿") 
end
kick_user(UserID,ChatID,function(arg,data)
if data.ID == "Error" and data.code_ == 400 then
return sendMsg(ChatID,MsgID,'✿*╿* لا يمكنني طرد العضو .\n✿*╽*لانه مشرف في المجموعه \n ❕')    
elseif data.ID == "Error" and data.code_ == 3 then
return sendMsg(ChatID,MsgID,'✿*╿* لا يمكنني طرد العضو .\n✿*╽*ليس لدي صلاحيه الحظر او لست مشرف\n ❕')    
end
redis:hset(mero..'username:'..UserID, 'username', UserName)
redis:sadd(mero..'banned:'..ChatID,UserID)
StatusLeft(ChatID,UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم طرد العضو \n✓️')
end)
 
end

if cmd == "up_sudo" then
if redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*انه بالتأكيد مطور \n✓') 
end
redis:hset(mero..'username:'..UserID, 'username', UserName)
redis:sadd(mero..':SUDO_BOT:',UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم ترقيته ليصبح مطور \n✓')
end

if cmd == "dn_sudo" then
if not redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*نه بالتأكيد ليس مطور \n✓')
end
redis:srem(mero..':SUDO_BOT:',UserID)
return sendMsg(ChatID,MsgID,'✿*╿*العضو » ❪ '..UserName..' ❫\n✿*│*الايدي » ❪ `'..UserID..'` ❫\n✿*╽*تم تنزيله من المطورين \n✓') 
end

else
return sendMsg(ChatID,MsgID,"✿*│* لا يوجد عضـو بهہ‌‏ذا المـعرف \n❕")
end 

end

function action_by_id(arg, data)

local cmd = arg.cmd
local ChatID = arg.msg.chat_id_
local MsgID = arg.msg.id_
if not data.id_ then 
sendMsg(ChatID,MsgID,"✿*│* العضو لا يوجد\n❕") 
return false
end
local UserID = data.id_
local Resolv = ResolveUser(data)

if data.username_ then 
USERNAME = '@'..data.username_
else 
USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or ""),20) 
end
USERCAR = utf8.len(USERNAME)


if cmd == "tqeed" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد البوت\n✿") 
elseif UserID == tonumber(779108237) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد 🔹️ GENERAL 🔹️️\n✿") 
elseif UserID == tonumber(1211544689) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك تقييد 🔹️ Carbon 🔹️️\n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المطور الاساسي\n✿") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المطور\n✿") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المنشىء الاساسي 🌟\n✿") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المـــــــــالك 🌟\n✿") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المنشــئ 🌟\n✿") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المـــــدير 🌟\n✿") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد الادمـــــن 🌟\n✿") 
end
Restrict(ChatID,UserID,1)
redis:sadd(mero..'Muted:User:kid'..ChatID,UserID)
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..':tqeed:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تقييد العضـو بنجاح \n✓️',12,USERCAR) 
end 
if cmd =="fktqeed" then
Restrict(ChatID,UserID,2)
redis:srem(mero..'Muted:User:kid'..ChatID,UserID)
redis:srem(mero..':tqeed:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم فگ تقييد العضـو بنجاح \n✓️',12,USERCAR) 
end
if cmd == "setwhitelist" then
if redis:sismember(mero..'whitelist:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد من عضو مميز \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'whitelist:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت ترقيته ليصبح عضو مميز \n✓️',12,USERCAR) 
end

if cmd == "setkara" then
  if redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد المنشىء الاساسي  \n✓️') 
  end
  redis:hset(mero..'username:'..UserID, 'username', Resolv)
  redis:sadd(mero..':KARA_BOT:'..ChatID,UserID)
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت ترقيته ليصبح منشىء اساسي  \n✓️') 
  end
  
  if cmd == "remkara" then
  if not redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس المنشىء الاساسي \n✓️') 
  end
  redis:srem(mero..':KARA_BOT:'..ChatID,UserID)
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من المنشىء الاساسي\n✓️') 
  end

if cmd == "SetMALK_BOT" then
  if redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد مالك المجموعه  \n✓️') 
  end
  redis:hset(mero..'username:'..UserID, 'username', Resolv)
  redis:sadd(mero..':MALK_BOT:'..ChatID,UserID)
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت ترقيته ليصبح مالك المجموعه  \n✓️') 
  end
  
  if cmd == "RemMALK_BOT" then
  if not redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس المالك \n✓️') 
  end
  redis:srem(mero..':MALK_BOT:'..ChatID,UserID)
  return sendMsg(ChatID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من مالك\n✓️') 
  end


if cmd == "setmnsha" then
if redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد منشىء \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..':MONSHA_BOT:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت ترقيته ليصبح منشىء  \n✓️',12,USERCAR) 
end
if cmd == "SetMshrf" then
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. ChatID .. "&user_id=" ..UserID.."&can_manage_chat=false&can_manage_voice_chats=true&can_manage_voice_chats=false&can_delete_messages=true&can_invite_users=true&can_restrict_members=true&can_pin_messages=true&can_promote_members=false")
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم ترقيته مشرف \n✓️',12,USERCAR) 
end
if cmd == "SetMshrf1" then
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. ChatID .. "&user_id=" ..UserID.."&can_change_info=true&can_manage_chat=false&can_manage_voice_chats=true&can_delete_messages=true&can_invite_users=true&can_restrict_members=true&can_pin_messages=true&can_promote_members=true")
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم ترقيته مشرف \n✓️',12,USERCAR) 
end
if cmd == "RemMshrf" then
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. ChatID .. "&user_id=" ..UserID.."&can_change_info=false&can_manage_chat=false&can_manage_voice_chats=false&can_delete_messages=false&can_invite_users=false&can_restrict_members=false&can_pin_messages=false&can_promote_members=false")
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله مشرف \n✓️',12,USERCAR) 
end

if cmd == "remmnsha" then
if not redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس منشىء \n✓️',12,USERCAR) 
end
redis:srem(mero..':MONSHA_BOT:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من المنشىء \n✓️',12,USERCAR) 
end
if cmd == "remwhitelist" then
if not redis:sismember(mero..'whitelist:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس من عضو مميز \n✓️',12,USERCAR) 
end
redis:srem(mero..'whitelist:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت تنزيله من عضو مميز \n✓️',12,USERCAR) 
end
if cmd == "setowner" then
if redis:sismember(mero..'owners:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد المـــــدير  \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'owners:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت ترقيته ليصبح مدير \n✓️',12,USERCAR) 
end
if cmd == "promote" then
if redis:sismember(mero..'admins:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد الادمـــــن  \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'admins:'..ChatID,UserID) 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تمت ترقيته ليصبح الادمـــــن  \n✓️',12,USERCAR) 
end
if cmd == "remowner" then
if not redis:sismember(mero..'owners:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'✿╽العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس مدير \n✓️',12,USERCAR) 
end
redis:srem(mero..'owners:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من الاداره \n✓️',12,USERCAR) 
end
if cmd == "demote" then
if not redis:sismember(mero..'admins:'..ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽انه بالتأكيد ليس الادمـــــن  \n✓️',12,USERCAR) 
end
redis:srem(mero..'admins:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من الادمنيه \n✓️',12,USERCAR) 
end
if cmd == "whois" then
local namei = data.first_name_..' '..(data.last_name_ or "")
if data.username_ then 
useri = '@'..data.username_ 
else 
useri = " لا يوجد " 
end
return SendMention(ChatID,UserID,MsgID,'•|الاسم » '..namei..'\n'..'•│ الايدي » {'..UserID..'} \n'..'•│ المعرف » '..useri..'\n'..'•│ الرتبه » '..Getrtba(UserID,ChatID)..'\n'..'✿╽ نوع الكشف » بالايدي\n✿',12,USERCAR) 
end

if cmd == "up_sudo" then
if redis:sismember(mero..':SUDO_BOT:',UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽نه بالتأكيد مطور \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..':SUDO_BOT:',UserID)
return SendMention(ChatID,UserID,MsgID,'🙍✿‍♂╿العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم ترقيته ليصبح مطور \n✓️',12,USERCAR) 
end

if cmd == "dn_sudo" then
if not redis:sismember(mero..':SUDO_BOT:',UserID) then return sendMsg(ChatID,MsgID,'✿*╿*العضو » '..USERNAME..' \n✿*│* الايدي » (`'..UserID..'`)\n✿*╽*انه بالتأكيد ليس مطور \n✓') end
redis:srem(mero..':SUDO_BOT:',UserID) 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم تنزيله من المطورين \n✓️',12,USERCAR) 
end

if cmd == "ban" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر البوت\n✿") 
elseif UserID == tonumber(779108237) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر 🔹️ GENERAL 🔹️️\n✿") 
elseif UserID == tonumber(1211544689) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر 🔹️ Carbon 🔹️️\n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المطور الاساسي\n✿") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المطور\n✿") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المنشىء الاساسي 🌟\n✿") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المـــــــــالك 🌟\n✿") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المنشــئ 🌟\n✿") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المـــــدير 🌟\n✿") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر الادمـــــن 🌟\n✿") 
end
if Check_Banned(ChatID,UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم بالتأكيد حظره \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'banned:'..ChatID,UserID)
kick_user(UserID, ChatID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم حظره  \n✓️',12,USERCAR) 
end

if cmd == "kick" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد البوت\n✿") 
elseif UserID == tonumber(779108237) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد 🔹️ GENERAL 🔹️\n✿") 
elseif UserID == tonumber(1211544689) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد 🔹️ Carbon 🔹️\n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المطور الاساسي\n✿") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المطور\n✿") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المنشىء الاساسي 🌟\n✿") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المـــــــــالك 🌟\n✿") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المنشــئ 🌟\n✿") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد المـــــدير 🌟\n✿") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك طرد الادمـــــن 🌟\n✿") 
end
kick_user(UserID, ChatID,function(arg,data)
if data.ID == "Error" and data.code_ == 400 then
return sendMsg(ChatID,MsgID,'✿*╿* لا يمكنني طرد العضو .\n✿*╽* لانه مشرف في المجموعه \n ❕')    
elseif data.ID == "Error" and data.code_ == 3 then
return sendMsg(ChatID,MsgID,'✿*╿* لا يمكنني طرد العضو .\n✿*╽* ليس لدي صلاحيه الحظر او لست مشرف\n ❕')    
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'banned:'..ChatID,UserID)
StatusLeft(ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم طرد العضو \n✓️',12,USERCAR) 
end)
end

if cmd == "uban" then
if not Check_Banned(ChatID,UserID) then 
 SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم بالتأكيد الغاء حظره \n✓️',12,USERCAR) 
else
 SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم الغاء حظره \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:srem(mero..'banned:'..ChatID,UserID)
StatusLeft(ChatID,UserID)
return false
end

if cmd == "ktm" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم البوت\n✿") 
elseif UserID == tonumber(779108237) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم 🔹️ GENERAL 🔹️\n✿") 
elseif UserID == tonumber(1211544689) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم 🔹️ Carbon 🔹️\n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المطور الاساسي\n✿") 
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المطور\n✿") 
elseif redis:sismember(mero..':KARA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المنشىء الاساسي 🌟\n✿") 
elseif redis:sismember(mero..':MALK_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المـــــــــالك 🌟\n✿") 
elseif redis:sismember(mero..':MONSHA_BOT:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المنشــئ 🌟\n✿") 
elseif redis:sismember(mero..'owners:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المـــــدير 🌟\n✿") 
elseif redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم الادمـــــن 🌟\n✿") 
end
if redis:sismember(mero..'admins:'..ChatID,UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك كتم المدراء او الادمنيه\n✿") 
end
if MuteUser(ChatID, UserID) then
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم بالتأكيد كتمه \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'is_silent_users:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم كتمه  \n✓️',12,USERCAR) 
end

if cmd == "unktm" then
if not MuteUser(ChatID, UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم بالتأكيد الغاء كتمه \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:srem(mero..'is_silent_users:'..ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم الغاء كتمه \n✓️',12,USERCAR) 
end

if cmd == "bandall" then
if UserID == our_id then   
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر البوت\n✿") 
elseif UserID == tonumber(779108237) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر 🔹️ GENERAL 🔹️\n✿") 
elseif UserID == tonumber(1211544689) then
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر 🔹️ Carbon 🔹️\n✿") 
elseif UserID == SUDO_ID then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المطور الاساسي\n✿")
elseif redis:sismember(mero..':SUDO_BOT:',UserID) then 
return sendMsg(ChatID,MsgID,"✿*│*لا يمكنك حظر المطور\n✿") 
end
if GeneralBanned(UserID) then 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم بالتأكيد حظره عام \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:sadd(mero..'gban_users',UserID)
kick_user(UserID,ChatID) 
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم حظره عام \n✓️',12,USERCAR) 
end

if cmd == "unbandall" then
if not GeneralBanned(UserID) then
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم بالتأكيد الغاء حظره العام \n✓️',12,USERCAR) 
end
redis:hset(mero..'username:'..UserID, 'username', Resolv)
redis:srem(mero..'gban_users',UserID)
StatusLeft(ChatID,UserID)
return SendMention(ChatID,UserID,MsgID,'•|العضو » ❪ '..USERNAME..' ❫\n•│الايدي » ❪ '..UserID..' ❫\n✿╽تم الغاء حظره العام \n✓️',12,USERCAR) 
end

end

function settingsall(msg)
if redis:get(mero..'welcome:gett'..msg.chat_id_) then welcomex = "❪ مفعل ❫" else welcomex = "❪ معطل ❫" end
if redis:get(mero..'lock_id'..msg.chat_id_) then lock_idx = "❪ مفعل ❫" else lock_idx = "❪ معطل ❫" end
if redis:get(mero..'replay'..msg.chat_id_)  then replayx  = "❪ مفعل ❫" else replayx  = "❪ معطل ❫" end
if redis:get(mero..'lock_woring'..msg.chat_id_) then lock_woringx = "❪ مفعل ❫" else lock_woringx  = "❪ معطل ❫" end
list_settings = "*✿*` اعدادات المجموعه :` \nـــــــــــــــــــــــــــــــــــــــــــــــــــــــ\n"
.."\n•|التعديل «» "..(redis:get(mero..'lock_edit'..msg.chat_id_) or 'false')
.."\n•│الروابط «» "..(redis:get(mero..'lock_link'..msg.chat_id_) or 'false')
.."\n✿التاك «» "..(redis:get(mero..'lock_tag'..msg.chat_id_) or 'false')
.."\n•│المعرفات «» "..(redis:get(mero..'lock_username'..msg.chat_id_) or 'false')
.."\n•│التكرار «» "..(redis:get(mero..'lock_flood'..msg.chat_id_) or 'false')
.."\n•│الكلايش «» "..(redis:get(mero..'lock_spam'..msg.chat_id_) or 'false')
.."\n•│الويب «» "..(redis:get(mero..'lock_webpage'..msg.chat_id_) or 'false')
.."\n•│الماركدوان «» "..(redis:get(mero..'lock_markdown'..msg.chat_id_) or 'false')
.."\n•│بالطرد البوتات «» "..(redis:get(mero..'lock_bots_by_kick'..msg.chat_id_) or 'false')
.."\n•│البوتات «» "..(redis:get(mero..'lock_bots'..msg.chat_id_) or 'false')
.."\n•│عدد التكرار «» "..(redis:get(mero..'num_msg_mero'..msg.chat_id_) or 'false')
.."\n•│`اعدادات الوسائط :`\nـــــــــــــــــــــــــــــــــــــــــــــــــــــــــ\n"
.."\n*•│*المتحركه «» "..(redis:get(mero..'mute_gif'..msg.chat_id_) or 'false')
.."\n•│الدردشه «» "..(redis:get(mero..'mute_text'..msg.chat_id_) or 'false')
.."\n•│الانلاين «» "..(redis:get(mero..'mute_inline'..msg.chat_id_) or 'false')
.."\n•│الالعاب «» "..(redis:get(mero..'mute_game'..msg.chat_id_) or 'false')
.."\n•│الصور «» "..(redis:get(mero..'mute_photo'..msg.chat_id_) or 'false')
.."\n•│الفيديو «» "..(redis:get(mero..'mute_video'..msg.chat_id_) or 'false')
.."\n•│البصمات «» "..(redis:get(mero..'mute_audio'..msg.chat_id_) or 'false')
.."\n•│الصوت «» "..(redis:get(mero..'mute_voice'..msg.chat_id_) or 'false')
.."\n•│الملصقات «» "..(redis:get(mero..'mute_sticker'..msg.chat_id_) or 'false')
.."\n•│الجهات «» "..(redis:get(mero..'mute_contact'..msg.chat_id_) or 'false')
.."\n•│التوجيه «» "..(redis:get(mero..'mute_forward'..msg.chat_id_) or 'false')
.."\n•│الموقع «» "..(redis:get(mero..'mute_location'..msg.chat_id_) or 'false')
.."\n•│الملفات «» "..(redis:get(mero..'mute_document'..msg.chat_id_) or 'false')
.."\n•│الاشعارات «» "..(redis:get(mero..'mute_tgservice'..msg.chat_id_) or 'false')
.."\n•│الكيبورد «» "..(redis:get(mero..'mute_keyboard'..msg.chat_id_) or 'false')
.."\n•│الفشار «» "..(redis:get(mero..'lock_mmno3'..msg.chat_id_) or 'false')
.."\n•│الفارسيه «» "..(redis:get(mero..'lock_pharsi'..msg.chat_id_) or 'false')
.."\n\nـــــــــــــــــــــــــــــــــــــــــــــــــــــــــ\n*•│*`اعدادات اخرى : `"
.."\n\n*•│*الترحيب «» "..welcomex
.."\n*•│*الردود «» "..replayx
.."\n*•│*التحذير «» "..lock_woringx
.."\n*✿╽*الايدي «» "..lock_idx
list_settings = list_settings:gsub('true', '❬ مقفول ❭')
list_settings = list_settings:gsub('false', '❬ مفتوح ❭')
return sendMsg(msg.chat_id_,1,'✿\n'..list_settings..'\n')
end

function settings(msg)
list_settings = "•│`اعدادات المجموعه :` \n ـــــــــــــــــــــــــــــــــــــــــــــــــــــــــ\n "
.."*•│*التاك «» "..(redis:get(mero..'lock_tag'..msg.chat_id_) or 'false')
.."\n*•│*المعرفات «» "..(redis:get(mero..'lock_username'..msg.chat_id_) or 'false')
.."\n*•│*التعديل «» "..(redis:get(mero..'lock_edit'..msg.chat_id_) or 'false')
.."\n*•│*الروابط «» "..(redis:get(mero..'lock_link'..msg.chat_id_) or 'false')
.."\n*•│*التكرار «» "..(redis:get(mero..'lock_flood'..msg.chat_id_) or 'false')
.."\n*•│*الكلايش «» "..(redis:get(mero..'lock_spam'..msg.chat_id_) or 'false')
.."\n*•│*الويب «» "..(redis:get(mero..'lock_webpage'..msg.chat_id_) or 'false')
.."\n*•│*الماركدوان «» "..(redis:get(mero..'lock_markdown'..msg.chat_id_) or 'false')
.."\n*•│*البوتات بالطرد «» "..(redis:get(mero..'lock_bots_by_kick'..msg.chat_id_) or 'false')
.."\n*•│*البوتات «» "..(redis:get(mero..'lock_bots'..msg.chat_id_) or 'false')
.."\n*✿╽*عدد التكرار «» "..(redis:get(mero..'num_msg_mero'..msg.chat_id_) or 'false')
.."\n*✿╽*تعديل الميديا «» "..(redis:get(mero..'lock_edit_media'..msg.chat_id_) or 'false')
.."\n*✿╽*الميديا «» "..(redis:get(mero..'mute_usaet'..msg.chat_id_) or 'false')
.."\n┄─┅═ـ═┅─┄\n*✿*اعدادات التقـييد :\n ـــــــــــــــــــــــــــــــــــــــــــــــــــــــــ \n"
.."\n*•|*التقييد بالتوجيه «» "..(redis:get(mero..':tqeed_fwd:'..msg.chat_id_) or 'false')
.."\n*•│*التقييد بالصور «» "..(redis:get(mero..':tqeed_photo:'..msg.chat_id_) or 'false')
.."\n*•│*التقييد بالروابط «» "..(redis:get(mero..':tqeed_link:'..msg.chat_id_) or 'false')
.."\n*•│*التقييد بالمتحركه «» "..(redis:get(mero..':tqeed_gif:'..msg.chat_id_) or 'false')
.."\n*✿╽*التقييد الفيديو «» "..(redis:get(mero..':tqeed_video:'..msg.chat_id_) or 'false')
list_settings = list_settings:gsub('true', '❬ مقفول ❭')
list_settings = list_settings:gsub('false', '❬ مفتوح ❭')
return sendMsg(msg.chat_id_, msg.id_,'✿\n'..list_settings..'\n')
end

function media(msg)
list_settings = "*•│*`اعدادات الوسائط:`\nـــــــــــــــــــــــــــــــــــــــــــــــــــــــــ\n"
.."\n*•|*المتحركه «» "..(redis:get(mero..'mute_gif'..msg.chat_id_) or 'false')
.."\n*•│*الدردشه «» "..(redis:get(mero..'mute_text'..msg.chat_id_) or 'false')
.."\n*•│*الانلاين «» "..(redis:get(mero..'mute_inline'..msg.chat_id_) or 'false')
.."\n*•│*الالعاب «» "..(redis:get(mero..'mute_game'..msg.chat_id_) or 'false')
.."\n*•│* الصور «» "..(redis:get(mero..'mute_photo'..msg.chat_id_) or 'false')
.."\n*•│*الفيديو «» "..(redis:get(mero..'mute_video'..msg.chat_id_) or 'false')
.."\n*•│*البصمات «» "..(redis:get(mero..'mute_audio'..msg.chat_id_) or 'false')
.."\n*•│*الصوت «» "..(redis:get(mero..'mute_voice'..msg.chat_id_) or 'false')
.."\n*•│*الملصقات «» "..(redis:get(mero..'mute_sticker'..msg.chat_id_) or 'false')
.."\n*•│*الجهات «» "..(redis:get(mero..'mute_contact'..msg.chat_id_) or 'false')
.."\n*•│*التوجيه «» "..(redis:get(mero..'mute_forward'..msg.chat_id_) or 'false')
.."\n*•│*الموقع «» "..(redis:get(mero..'mute_location'..msg.chat_id_) or 'false')
.."\n*•│*الملفات «» "..(redis:get(mero..'mute_document'..msg.chat_id_) or 'false')
.."\n*•│*الاشعارات «» "..(redis:get(mero..'mute_tgservice'..msg.chat_id_) or 'false')
.."\n*✿╽*الكيبورد «» "..(redis:get(mero..'mute_keyboard'..msg.chat_id_) or 'false')
list_settings = list_settings:gsub('true', '❬ مقفول ❭')
list_settings = list_settings:gsub('false', '❬ مفتوح ❭')
return sendMsg(msg.chat_id_,msg.id_,'✿\n'..list_settings..'\n')
end
