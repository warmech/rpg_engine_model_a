--Additions to map metadata
mapDrawLayers = 3

mapDrawOrder = 
{
    "bottomLayer",
    "spriteLayer",
    "topLayer"
}

elevationFlag = 
{
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
}

xformTileTable = 
{
    x       = {48,      48,     51,     51,     38,     38,     37,     38,     39,     37,     38,     39}
    y       = {28,      29,     41,     42,     42,     43,     45,     45,     45,     46,     46,     46}
    script  = {"01",    "01",   "02",   "02",   "03",   "03",   "04",   "04",   "04",   "04",   "04",   "04"}
}

--Additions to postCollisionAction()
if (currentMap.tilemap.collision[playerCharacter.gfx.yTilePosition][playerCharacter.gfx.xTilePosition] == 6) then
    for i = 1, (#xformTileTable.script) do
        if (xformTileTable.y[i] == playerCharacter.gfx.yTilePosition) then
            if (xformTileTable.x[i] == playerCharacter.gfx.xTilePosition) then
                local xformScript = "rpg_engine_model_a/dat/maps/"..currentMap.metadata.mapNumber.."/xform_"..xformTileTable.script[i]..".dat"
                local xformAction = loadScript(xformScript)
                --Need to call xformAction - that goes here
                break
            end
        end
    end
end