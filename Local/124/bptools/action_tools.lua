
--*部分常用组件的封装。
--*组件功能查看：全局搜索  tolua_usertype(tolua_S,"cc.

action_tools = {}

--移动
function action_tools.CCMoveTo(param_time,param_x,param_y)
	return cc.MoveTo:create(param_time, cc.p(param_x, param_y))
end
function action_tools.CCMoveBy(param_time,param_x,param_y)
    return cc.MoveBy:create(param_time, cc.p(param_x, param_y))
end

--缩放
function action_tools.CCScaleTo(param_time,param_scale)
    return cc.ScaleTo:create(param_time,param_scale)
end
function action_tools.CCScaleBy(param_time,param_scale)
    return cc.ScaleBy:create(param_time,param_scale)
end

--旋转
function action_tools.CCRotateTo(param_time,param_rotate)
    return cc.RotateTo:create(param_time,param_rotate)
end
function action_tools.CCRotateBy(param_time,param_rotate)
    return cc.RotateBy:create(param_time,param_rotate)
end

--跳跃（时间 目标位置x,y 高度 次数）
function action_tools.CCJumpTo(param_time,param_x,param_y,param_high,param_times)
    return cc.JumpTo:create(param_time,cc.p(param_x,param_y),param_high,param_times)
end
function action_tools.CCJumpBy(param_time,param_x,param_y,param_high,param_times)
    return cc.JumpBy:create(param_time,cc.p(param_x,param_y),param_high,param_times)
end

--淡入淡出
function action_tools.CCFadeIn(param_time)
    return cc.FadeIn:create(param_time)
end

function action_tools.CCFadeOut(param_time)
    return cc.FadeOut:create(param_time)
end

--延迟
function action_tools.CCDelayTime(param_time)
    return cc.DelayTime:create(param_time)
end

--回调函数
function action_tools.CCCallFunc(param_func)
    return cc.CallFunc:create(param_func)
end

--动作缓慢开始
function action_tools.CCEaseExponentialIn(param_action)
    return cc.EaseExponentialIn:create(param_action)
end
--动作缓慢结束
function action_tools.CCEaseExponentialOut(param_action)
    return cc.EaseExponentialOut:create(param_action)
end
--动作缓慢开始和结束
function action_tools.CCEaseExponentialInOut(param_action)
    return cc.EaseExponentialInOut:create(param_action)
end

--曲线轨迹运动
--@param 时间
--@param 点集 param_points格式为{{x=0,y=0},{x=1,y=1},{x=2,y=2}}
--@param 拟合度
--cc.PointArray cc.CardinalSplineTo:create cc.CardinalSplineBy lua没有绑定 舍弃不用
--function action_tools.CCCardinalSplineTo(param_time,param_points,param_tension)
--    local point_array=cc.PointArray:create(#param_points)
--    for i=1,#param_points,1 do
--        point_array:addControlPoint(cc.p(param_points[i].x,param_points.y))
--    end
--    return cc.CardinalSplineTo:create(param_time,point_array,param_tension)
--end
--function action_tools.CCCardinalSplineBy(param_time,param_points,param_tension)
--    local point_array=cc.PointArray:create(#param_points)
--    for i=1,#param_points,1 do
--        point_array:addControlPoint(cc.p(param_points[i].x,param_points.y))
--    end
--    return cc.CardinalSplineBy:create(param_time,point_array,param_tension)
--end

--动作同时执行
--参数直接传action1,action2,action3...
--如action_tools.CCSpawn(action1,action2,action3...)
function action_tools.CCSpawn(...)
    return cc.Spawn:create(...)
end

--动作顺序执行
--参数直接传action1,action2,action3...
--如action_tools.CCSequence(action1,action2,action3...)
function action_tools.CCSequence(...)
    return cc.Sequence:create(...)
end

-- 动作永久循环执行
function action_tools.CCRepeatForever(param_action)
    return cc.RepeatForever:create(param_action)
end

--获取抖动的动画
--param_time   间隔
--param_speed  快慢
--param_range  幅度
--param_loop   循环次数  0为一直循环
function action_tools.getShakeAct(param_time,param_speed,param_range,param_loop)
    local seq_action=cc.Sequence:create(
        cc.DelayTime:create(param_time),
        cc.RotateTo:create(param_speed,param_range),
        cc.RotateTo:create(param_speed,-param_range),
        cc.RotateTo:create(param_speed,param_range),
        cc.RotateTo:create(param_speed,-param_range),
        cc.RotateTo:create(param_speed,0)
    )

    if param_loop then 
    	param_loop=math.modf(param_loop)
    else 
    	param_loop=-1 
    end

    local action=nil
    if param_loop<=0 then 
    	action=cc.RepeatForever:create(seq_action)
    else
    	action=cc.Repeat:create(seq_action,param_loop)
    end

    return action
end

-- -----------------
-- DY ADD
-- -----------------
function action_tools.CCBezierTo( param_time, param_bezier )
    return cc.BezierTo:create(param_time, param_bezier)
end

function action_tools.CCScaleToXY(param_time, param_scaleX, param_scaleY)
    return cc.ScaleTo:create(param_time, param_scaleX, param_scaleY)
end

function action_tools.CCHide()
    return cc.Hide:create()
end

function action_tools.CCShow()
    return cc.Show:create()
end

function action_tools.CCEaseElasticOut(param_action)
    return cc.EaseElasticOut:create(param_action)
end