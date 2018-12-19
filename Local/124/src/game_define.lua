--------------------------------------------------------------------------------
-- 斗地主常量定义
--------------------------------------------------------------------------------

GAME_PLAYER = 3

LocalSelfChairId = 1

ButtonEventType = {landlord = 5, no_landlord = 6, rob = 7, no_rob = 8, outcards = 9, pass = 10, hint = 11, 
					change = 12, ready = 13, left = 14, continue = 15, report = 17, chat = 18, mark = 19, invite=20,
					grade=21,find_again = 22, show_finish = 23, revive = 24}

PlayerSex = {girl = 0, boy = 1}

UserIdentity = {null = 0, farmer = 1, landlord = 2}

-- SMessageType = {info = 0x0001, eject = 0x0002, global = 0x0004, close_game = 0x1000}

MessageType = {config = 101, clock = 102, game_info = 103, sound = 104, chat = 105, 
			button_power = 106, status = 107, identify = 108, task = 109, start_landlord = 110, 
			landlord = 111, no_landlord = 112, start_rob = 113, rob = 114, no_rob = 115, 
			start_outcards = 116, outcards = 117, send_cards = 118, finish = 119, max_outcards = 120, 
			base_cards = 121, gold_times = 122, trust = 123, mark_cards = 124, cards_count = 125,
			send_gift = 127, room_info = 128, friend_info = 129, task_finish = 130, active_info = 131, fresh_revive_btn = 132, redpacket_info = 134}

-- ActiveStatus = {Null = 0,
-- 	            WinWithOutProperty = 1,
-- 	            LoseWithOutProperty = 2,
-- 	            UsedProperty = 3,
-- 	            Seccess = 4
--     }
GameStatus = {free = 0, landlord = 1, rob = 2, outcards = 3}

-- ChatType = {notice = 0, count = 1}

ProtocolType = {landlord = 1001, no_landlord = 1002, rob = 1003, no_rob = 1004, outcards = 1005, 
				pass = 1006, hint = 1007, trust = 1008, no_trust = 1009, send_gift = 1010, revive = 1011}

ButtonPower = { start = 0x00000001, changetable = 0x00000002, landlord = 0x00000004, no_landlord = 0x00000008, 
				rob = 0x00000010, no_rob = 0x00000020, outcards = 0x00000040, hint = 0x00000080, pass = 0x00000100, 
				left = 0x00000200, continue = 0x00000400,invite = 0x00000800}

RoomLimit = {score_min = 0x00000001, score_max = 0x00000002, gold_min = 0x00000004, gold_max = 0x00000008,
			 charm_min = 0x00000010, charm_max = 0x00000020}

MB = {OK = 0, OKCANCEL = 1}

UserStatus = {null = 0, ready = 1, pass = 2, outcards = 3, landlord = 4, 
				no_landlord = 5, rob = 6, no_rob = 7, is_landlord = 8}    


KindCards = {cards_error = 0, cards_1 = 1, cards_2 = 2, cards_3 = 3, cards_3_1 = 4, cards_3_2 = 5, cards_shunzi_1 = 6, cards_shunzi_2 = 7,
			cards_shunzi_3 = 8, cards_plane = 9, cards_4_2 = 10, cards_4_4 = 11, cards_king = 12, cards_bomb = 13}

-- KindSound = {start = 0, pass = 1, outcards = 2, landlord = 3, rob = 4, no_landlord = 5, no_rob = 6, lose = 7, win = 8, plane = 9, bomb = 10,
-- 			spring = 11, king = 12}

GameResult = {win = 0, lose = 1}

TaskInfo = {last_single = 1, last_double = 2, last_shunzi = 3, last_three = 4, last_plane = 5, last_bomb = 6, last_doubleline = 7}

ChatDirection = {left_top = 1, left_down = 2, right_top = 3, right_down = 4}

-- EventList = {update_user_info = "MSG_UPDATE_SELF_DATA", update_pay_type = "MSG_PAY_TYPE", guess_type = "MSG_GUESS_TYPE"}

-- PayType = {start = 0, close = 1, success = 2, fail = 3} 

-- ItemShop = {gold = 0, ingot = 1, prop = 2, vip = 3}

BASE_CARDS_COUNT = 3
MAX_HAND_CARDS = 20
-- ID_PROP_STATUS_RECARD = 1003
-- ID_PROP_REVIVE_CARD = 1030


SEND_CARD_SPEED = 0.05

-- GuessList = {null = 0, open = 1, start = 2, close = 3, success = 4, fail = 5}

MUSIC_PATH = { 
	normal = {
		[0] = g_path .. "sound/click.mp3",
		[1] = g_path .. "sound/back.mp3",
		[2] = g_path .. "sound/enter.mp3",
		[3] = g_path .. "sound/left.mp3",
		[4] = g_path .. "sound/ready.mp3",
		[5] = g_path .. "sound/send_cards.mp3",
		[6] = g_path .. "sound/spring.mp3",
		[7] = g_path .. "sound/win.mp3",
		[8] = g_path .. "sound/lose.mp3",
		[9] = g_path .. "sound/bomb.mp3",
		[10] = g_path .. "sound/king.mp3",
		[11] = g_path .. "sound/plane.mp3"
		},

	girl = {
		[1] = g_path .. "sound/girl/landlord/Jiao.mp3",
		[2] = g_path .. "sound/girl/landlord/Not_Jiao.mp3",
		[3] = { g_path .. "sound/girl/landlord/Qiang_0.mp3",
				g_path .. "sound/girl/landlord/Qiang_1.mp3",
				g_path .. "sound/girl/landlord/Qiang_2.mp3" 
			},
		[4] = g_path .. "sound/girl/landlord/Not_Qiang.mp3",
		[5] = { g_path .. "sound/girl/pass/1.mp3",
				g_path .. "sound/girl/pass/2.mp3",
				g_path .. "sound/girl/pass/3.mp3",
				g_path .. "sound/girl/pass/4.mp3"
			},
		[6] = g_path .. "sound/girl/plane/Plane.mp3",
		[7] = g_path .. "sound/girl/bomb/wangzha.mp3",
		[8] = g_path .. "sound/girl/bomb/Bomb.mp3",
		[9] = { g_path .. "sound/girl/signle/3.mp3",
				g_path .. "sound/girl/signle/4.mp3",
				g_path .. "sound/girl/signle/5.mp3",
				g_path .. "sound/girl/signle/6.mp3",
				g_path .. "sound/girl/signle/7.mp3",
				g_path .. "sound/girl/signle/8.mp3",
				g_path .. "sound/girl/signle/9.mp3",
				g_path .. "sound/girl/signle/10.mp3",
				g_path .. "sound/girl/signle/11.mp3",
				g_path .. "sound/girl/signle/12.mp3",
				g_path .. "sound/girl/signle/13.mp3",
				g_path .. "sound/girl/signle/14.mp3",
				g_path .. "sound/girl/signle/15.mp3",
				g_path .. "sound/girl/signle/16.mp3",
				g_path .. "sound/girl/signle/17.mp3"
			},
		[10] = { g_path .. "sound/girl/couple/3.mp3",
				g_path .. "sound/girl/couple/4.mp3",
				g_path .. "sound/girl/couple/5.mp3",
				g_path .. "sound/girl/couple/6.mp3",
				g_path .. "sound/girl/couple/7.mp3",
				g_path .. "sound/girl/couple/8.mp3",
				g_path .. "sound/girl/couple/9.mp3",
				g_path .. "sound/girl/couple/10.mp3",
				g_path .. "sound/girl/couple/11.mp3",
				g_path .. "sound/girl/couple/12.mp3",
				g_path .. "sound/girl/couple/13.mp3",
				g_path .. "sound/girl/couple/14.mp3",
				g_path .. "sound/girl/couple/15.mp3"
				},
		[11] = { g_path .. "sound/girl/three/3.mp3",
				g_path .. "sound/girl/three/4.mp3",
				g_path .. "sound/girl/three/5.mp3",
				g_path .. "sound/girl/three/6.mp3",
				g_path .. "sound/girl/three/7.mp3",
				g_path .. "sound/girl/three/8.mp3",
				g_path .. "sound/girl/three/9.mp3",
				g_path .. "sound/girl/three/10.mp3",
				g_path .. "sound/girl/three/11.mp3",
				g_path .. "sound/girl/three/12.mp3",
				g_path .. "sound/girl/three/13.mp3",
				g_path .. "sound/girl/three/14.mp3",
				g_path .. "sound/girl/three/15.mp3"
				},
		[12] = { g_path .. "sound/girl/outcards/1.mp3",
				g_path .. "sound/girl/outcards/2.mp3"
			},
		[13] = g_path .. "sound/girl/3_1/3D1.mp3",
		[14] = g_path .. "sound/girl/3_1/3D2.mp3",
		[15] = g_path .. "sound/girl/4_2/4D2.mp3",
		[16] = g_path .. "sound/girl/4_2/sidailiangdui.mp3",
		[17] = g_path .. "sound/girl/straight/Straight.mp3",
		[18] = g_path .. "sound/girl/doubleline/Doubleline.mp3"
		},

	boy = {
		[1] = g_path .. "sound/boy/landlord/Jiao.mp3",
		[2] = g_path .. "sound/boy/landlord/Not_Jiao.mp3",
		[3] = { g_path .. "sound/boy/landlord/Qiang_0.mp3",
				g_path .. "sound/boy/landlord/Qiang_1.mp3",
				g_path .. "sound/boy/landlord/Qiang_2.mp3" },
		[4] = g_path .. "sound/boy/landlord/Not_Qiang.mp3",
		[5] = { g_path .. "sound/boy/pass/1.mp3",
				g_path .. "sound/boy/pass/2.mp3",
				g_path .. "sound/boy/pass/3.mp3",
				g_path .. "sound/boy/pass/4.mp3"
			},
		[6] = g_path .. "sound/boy/plane/Plane.mp3",
		[7] = g_path .. "sound/boy/bomb/wangzha.mp3",
		[8] = g_path .. "sound/boy/bomb/Bomb.mp3",
		[9] = { g_path .. "sound/boy/signle/3.mp3",
				g_path .. "sound/boy/signle/4.mp3",
				g_path .. "sound/boy/signle/5.mp3",
				g_path .. "sound/boy/signle/6.mp3",
				g_path .. "sound/boy/signle/7.mp3",
				g_path .. "sound/boy/signle/8.mp3",
				g_path .. "sound/boy/signle/9.mp3",
				g_path .. "sound/boy/signle/10.mp3",
				g_path .. "sound/boy/signle/11.mp3",
				g_path .. "sound/boy/signle/12.mp3",
				g_path .. "sound/boy/signle/13.mp3",
				g_path .. "sound/boy/signle/14.mp3",
				g_path .. "sound/boy/signle/15.mp3",
				g_path .. "sound/boy/signle/16.mp3",
				g_path .. "sound/boy/signle/17.mp3"
			},
		[10] = { g_path .. "sound/boy/couple/3.mp3",
				g_path .. "sound/boy/couple/4.mp3",
				g_path .. "sound/boy/couple/5.mp3",
				g_path .. "sound/boy/couple/6.mp3",
				g_path .. "sound/boy/couple/7.mp3",
				g_path .. "sound/boy/couple/8.mp3",
				g_path .. "sound/boy/couple/9.mp3",
				g_path .. "sound/boy/couple/10.mp3",
				g_path .. "sound/boy/couple/11.mp3",
				g_path .. "sound/boy/couple/12.mp3",
				g_path .. "sound/boy/couple/13.mp3",
				g_path .. "sound/boy/couple/14.mp3",
				g_path .. "sound/boy/couple/15.mp3"
				},
		[11] = { g_path .. "sound/boy/three/3.mp3",
				g_path .. "sound/boy/three/4.mp3",
				g_path .. "sound/boy/three/5.mp3",
				g_path .. "sound/boy/three/6.mp3",
				g_path .. "sound/boy/three/7.mp3",
				g_path .. "sound/boy/three/8.mp3",
				g_path .. "sound/boy/three/9.mp3",
				g_path .. "sound/boy/three/10.mp3",
				g_path .. "sound/boy/three/11.mp3",
				g_path .. "sound/boy/three/12.mp3",
				g_path .. "sound/boy/three/13.mp3",
				g_path .. "sound/boy/three/14.mp3",
				g_path .. "sound/boy/three/15.mp3"
				},
		[12] = { g_path .. "sound/boy/outcards/1.mp3",
				g_path .. "sound/boy/outcards/2.mp3"
			},
		[13] = g_path .. "sound/boy/3_1/3D1.mp3",
		[14] = g_path .. "sound/boy/3_1/3D2.mp3",
		[15] = g_path .. "sound/boy/4_2/4D2.mp3",
		[16] = g_path .. "sound/boy/4_2/sidailiangdui.mp3",
		[17] = g_path .. "sound/boy/straight/Straight.mp3",
		[18] = g_path .. "sound/boy/doubleline/Doubleline.mp3"
		}
}
