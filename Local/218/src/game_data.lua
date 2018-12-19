--适配
view_size=CCDirector:getInstance():getWinSize()
sharedScheduler = CCDirector:getInstance():getScheduler()
spriteFrameCache=CCSpriteFrameCache:getInstance()
AUTO_WIDTH  = view_size.width / 1000
AUTO_HEIGHT = view_size.height / 750
AUTO_SCALE  = view_size.width * view_size.height /750000


--房间信息
RoomType = 0
RoomMode=0

--游戏数据
m_game_layer=nil
m_game_status=nil

StartTime = 15
ChangeTableTime = 0
IsShowChangeTableTime = true
EndTime = 15
OutCardTime = 15
IsAutoReady = 0
isTrust = false
OpenTrustPunish = false
ConsumeGold = 0
IsAutoOut = true
IsLockRoom = false
LockRoomAutoOutTime = 180
IsPause = false

--玩家数
GamePlayer=4
--玩家信息
UserData={{},{},{},{}}
--玩家配置
UserIndex={
    left    = 1,
    down    = 2,
    right   = 3,
    up      = 4
}


--好友房信息
FriendData={
    code="",userid="",currcount=0,totalcount=0,status=0,kind=0,
}

--是否显示邀请微信好友按钮
ShowWechatBtn = true

--是否百变（RJoker是否能当任意牌）
isVariable = true

--是否进行过游戏
isPlayedGame = false

