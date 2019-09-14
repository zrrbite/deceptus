
require "data/scripts/enemies/constants"
v2d = require "data/scripts/enemies/vectorial2"

-- place cannons here
-- 64,311
-- 78,311

------------------------------------------------------------------------------------------------------------------------
properties = {
   staticBody = true,
   sprite = "data/sprites/enemy_cannon.png",
   damage = 0
}

------------------------------------------------------------------------------------------------------------------------
config = {
}

------------------------------------------------------------------------------------------------------------------------
mFireTimer = 1
mFireInterval = 3000
mFireReady = true
mPosition = v2d.Vector2D(0, 0)
mPlayerPosition = v2d.Vector2D(0, 0)
mSpriteIndex = 0
mElapsed = 0.0
mX = 1.0
mSpriteY = 24


------------------------------------------------------------------------------------------------------------------------
function initialize()
   addShapeRect(0.2, 0.2, 0.0, 0.1) -- width, height, x, y
   updateSpriteRect(0, mSpriteY, 24, 24) -- x, y, width, height

   addSample("boom.wav")
   addWeapon(1000, 0.1) -- interval, radius
   updateBulletTexture(0, "data/sprites/enemy_blob.png", 4, 52, 16, 16) -- index, path, x, y, width, height
end


------------------------------------------------------------------------------------------------------------------------
function writeProperty(key, value)
   config[key] = value

   if (key == "alignment") then
      if (value == "left") then
         print("setting alignment to left")
         mX = -1.0
         mSpriteY = 0
      end
   end
end


------------------------------------------------------------------------------------------------------------------------
function timeout(id)
   -- print(string.format("timeout: %d", id))
   if (id == mFireTimer) then
      fire()
   end
end


------------------------------------------------------------------------------------------------------------------------
function fire()
   mElapsed = 0.0
   mSpriteIndex = 1

fireWeapon(
      0,
      mPosition:getX() + mX * 16,
      mPosition:getY() - 3,
      mX * 0.1,
      0.0
   );

   updateSpriteRect(24, mSpriteY, 24, 24)
   mFireReady = true
end


------------------------------------------------------------------------------------------------------------------------
function retrieveProperties()
   updateProperties(properties)
end


------------------------------------------------------------------------------------------------------------------------
function movedTo(x, y)
   -- print(string.format("moved to: %f, %f", x, y))
   mPosition = v2d.Vector2D(x, y)
end


------------------------------------------------------------------------------------------------------------------------
function playerMovedTo(x, y)
   -- print(string.format("player moved to: %f, %f", x, y))
   mPlayerPosition = v2d.Vector2D(x, y)
end


------------------------------------------------------------------------------------------------------------------------
function update(dt)
   if (mFireReady == true) then
      mFireReady = false
      timer(mFireInterval, mFireTimer)
   end

   -- update sprite index
   mElapsed = mElapsed + dt
   index = mSpriteIndex

   if (mSpriteIndex > 0) then
      mSpriteIndex = 1 + math.floor(mElapsed * 10.0)
   end

   if (mSpriteIndex > 7) then
      mSpriteIndex = 0
   end

   if (index ~= mSpriteIndex) then
      updateSpriteRect(mSpriteIndex * 24, mSpriteY, 24, 24)
   end
end


------------------------------------------------------------------------------------------------------------------------
function setPath(name, table)
end

