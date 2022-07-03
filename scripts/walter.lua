local tex = LoadSprite("MOD/imgs/walter.png")

--local prefab = FindBody("nextbot", true)

local position = Vec(0,0,0)
local lastposition = Vec(0,0,0)
local velocity = Vec(0,0,0)

local speedMove = 0.007
local jumpForce = 1
local jumpPower = 0.0

local maxDist = 32

local lastpoint
local targetpoint

local target = nil

local isSpawned = false

local spawnDelay = 0.0

local llast = 0.0

local updatePathTime = 0.0

local patrolTime = 0.0

function init()
    isSpawned = false
    target = GetPlayerPos()
    --DebugPrint("NextBot Spawned!")
end

function tick(dt)
    
    if(isSpawned == false) then
        if(spawnDelay < 4) then
            spawnDelay = spawnDelay + 0.1
        end
        local camTransform = GetCameraTransform()
    
        local dir = TransformToParentVec(camTransform, Vec(0, 0, -1))
        local hit, d, n = QueryRaycast(camTransform.pos, dir, 100)    

        if hit then
            local hitPoint = VecAdd(camTransform.pos, VecScale(dir, d))
            position = VecAdd(hitPoint,Vec(0,1,0))
            if(InputDown("lmb") and spawnDelay > 2) then
                isSpawned = true
            end
        end
        return
    end

    if(position[2] < -20) then
        position[2] = 10
    end

    QueryRequire("physical dynamic")
	local hit, p, n, s = QueryClosestPoint(position, 2)
	if hit then
		local body = GetShapeBody(s)
		SetBodyVelocity(body, VecScale(VecSub(position,target),-1))
		MakeHole(position, 1, 1)
	end

    if(getDist(position,GetPlayerPos()) < 2) then
        SetPlayerHealth(0.0)
    end

    navigate()
end
local isChase = false
local randomPos = 0
function navigate()
    updatePathTime = updatePathTime + 0.1
    patrolTime = patrolTime + 0.1

    if(updatePathTime > 2) then
        if(getDist(position,GetPlayerPos()) < maxDist) then
            isChase = true
            target = GetPlayerPos()
            QueryPath(position, target, 100, 0.0)
        else
            isChase = false
        end
        updatePathTime = 0.0
    end

    if(isChase == false and patrolTime > 5) then
        target = Vec(math.random(position[1]-1000,position[1]+1000),0,math.random(position[3]-1000,position[3]+1000))
        patrolTime = 0.0
    end

    local d = 0
    local l = GetPathLength()
    if(llast == l) then
        velocity = VecAdd(velocity,VecScale(VecNormalize(VecSub(position,target)),-speedMove))
        velocity[2] = 0
    else
        if l > 3 then
            --position = VecLerp(position,targetpoint, speedMove)
            velocity = VecAdd(velocity,VecScale(VecNormalize(VecSub(position,targetpoint)),-speedMove))
            velocity[2] = 0
    
            local s = GetPathState()
            targetpoint = GetPathPoint(2)
            lastpoint = GetPathPoint(l)
        end
    end
    velocity = VecLerp(velocity, Vec(0,0,0), 0.04)

    local hit, d, n = QueryRaycast(position, Vec(0,-1,0), 1, 0.5)    

    if hit then
        if(getDist(position,target) < maxDist) then
            if(target[2] > position[2]+10) then
                jumpPower = jumpForce
            end
        end
        velocity[2] = velocity[2] + jumpPower
    else
        velocity[2] = velocity[2] + jumpPower
        jumpPower = jumpPower - 0.07
        if(jumpPower <= 0) then
            jumpPower = 0
            velocity[2] = velocity[2] - 9.81/40
        end
    end
    calculateCollision(velocity)
    position = VecAdd(position,velocity)

	lastposition = position
    llast = l
end

function calculateCollision(dir)
    local hit, d, n = QueryRaycast(VecAdd(position,Vec(0,1,0)), dir, 2, 0.2)    

    if hit then
        velocity = VecAdd(velocity,VecScale(dir,-1))
        velocity[2] = velocity[2] + 0.3
    end
end

function draw()
    local faceT = Transform(VecAdd(position,Vec(0,1,0)), QuatLookAt(position,GetCameraTransform().pos))

    DrawSprite(tex, faceT, 3, 3, 1, 1, 1, 1, true)
end

function err(reas)
    DebugPrint("Nextbot Base: " .. reas)
end

function randomVec()
	return Vec(math.random(-1,1),math.random(-1,1),math.random(-1,1))
end

function getDist(v1, v2)
	return VecLength(VecSub(v1,v2))
end

function lerp(a,b,t)
	return a + (b - a) * t
end