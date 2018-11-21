function mapInputDetect()
    if love.keyboard.isDown("up") then
        if playerCharacter.gfx.movementLockout == false then
            --if preCollisionMovementCheck(playerCharacter.gfx.upTile) == true then
                if((playerCharacter.gfx.movementState % 2) == 1) then
                    playerCharacter.gfx.movementState = 7
                else
                    playerCharacter.gfx.movementState = 8
                end

                if preCollisionMovementCheck(playerCharacter.gfx.upTile) == true then
                    playerCharacter.gfx.movementLockout = true
                    playerCharacter.gfx.xDelta = 0
                    playerCharacter.gfx.yDelta = -0.0625
                end
        end
    end
    if love.keyboard.isDown("down")  then
        if playerCharacter.gfx.movementLockout == false then
            --if preCollisionMovementCheck(playerCharacter.gfx.downTile) == true then
                if((playerCharacter.gfx.movementState % 2) == 1) then
                    playerCharacter.gfx.movementState = 1
                else
                    playerCharacter.gfx.movementState = 2
                end

                if preCollisionMovementCheck(playerCharacter.gfx.downTile) == true then
                    playerCharacter.gfx.movementLockout = true
                    playerCharacter.gfx.xDelta = 0
                    playerCharacter.gfx.yDelta = 0.0625
                end
        end
    end
    if love.keyboard.isDown("left")  then
        if playerCharacter.gfx.movementLockout == false then
            --if preCollisionMovementCheck(playerCharacter.gfx.leftTile) == true then
                if((playerCharacter.gfx.movementState % 2) == 1) then
                    playerCharacter.gfx.movementState = 5
                else
                    playerCharacter.gfx.movementState = 6
                end

                if preCollisionMovementCheck(playerCharacter.gfx.leftTile) == true then
                    playerCharacter.gfx.movementLockout = true
                    playerCharacter.gfx.xDelta = -0.0625
                    playerCharacter.gfx.yDelta = 0
                end
        end
    end
    if love.keyboard.isDown("right")  then
        if playerCharacter.gfx.movementLockout == false then
            --if preCollisionMovementCheck(playerCharacter.gfx.rightTile) == true then
                if((playerCharacter.gfx.movementState % 2) == 1) then
                    playerCharacter.gfx.movementState = 3
                else
                    playerCharacter.gfx.movementState = 4
                end

                if preCollisionMovementCheck(playerCharacter.gfx.rightTile) == true then
                    playerCharacter.gfx.movementLockout = true
                    playerCharacter.gfx.xDelta = 0.0625
                    playerCharacter.gfx.yDelta = 0
                end
        end
    end
    --If the movement lockout flag has been set, begin moving the "player"
    if playerCharacter.gfx.movementLockout == true then
        if playerCharacter.gfx.movementCurrentDuration == playerCharacter.gfx.movementMaxDuration then
            moveMap()
            playerCharacter.gfx.movementCurrentDuration = 1
            playerCharacter.gfx.movementLockout = false
            --Update sprite location on tilemap
            playerCharacter.gfx.xTilePosition = currentMap.metadata.mapX + playerCharacter.gfx.distToCenterX
            playerCharacter.gfx.yTilePosition = currentMap.metadata.mapY + playerCharacter.gfx.distToCenterY
            --Update surrounding tile info
            --[[ Need to resolve lack of data off of tilemap
            if currentMap.tilemap[playerCharacter.gfx.yTilePosition - 1][playerCharacter.gfx.xTilePosition] == nil then
                playerCharacter.gfx.upTile = 2
            else
                playerCharacter.gfx.upTile = currentMap.tilemap[playerCharacter.gfx.yTilePosition - 1][playerCharacter.gfx.xTilePosition]
            ]]
            playerCharacter.gfx.upTile = currentMap.tilemap[playerCharacter.gfx.yTilePosition - 1][playerCharacter.gfx.xTilePosition]
            playerCharacter.gfx.rightTile = currentMap.tilemap[playerCharacter.gfx.yTilePosition][playerCharacter.gfx.xTilePosition + 1]
            playerCharacter.gfx.downTile = currentMap.tilemap[playerCharacter.gfx.yTilePosition + 1][playerCharacter.gfx.xTilePosition]
            playerCharacter.gfx.leftTile = currentMap.tilemap[playerCharacter.gfx.yTilePosition][playerCharacter.gfx.xTilePosition - 1]
        else
            moveMap()
            playerCharacter.gfx.movementCurrentDuration = playerCharacter.gfx.movementCurrentDuration + 1
        end
    end
end

function menuInputDetect()
    -- body
end

