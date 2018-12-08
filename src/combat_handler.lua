--COMBAT PROGRAM 00 - Determine Preemptive Turn
function determineSurpriseTurn()
    -- body

end



--COMBAT PROGRAM 01 - Player Run Attempt
function playerAttemptRun()
    --If battling a boss, running is impossible
	if (currentFight.bossFightFlag == true) then
		return false
	end
    --If the player has a preemptive turn, a run is always successful (unless against a boss)
	if (currentFight.playerSurprise == true) then
		return true
	end
	--Calculate the party's total agility
	local partyAgility = calcTotalAgility(#playerCharacters)
    --Calculate the currently active enemy group's total agilty
	local enemyAgility = calcTotalAgility(#activeEnemyGroup) + math.random(50)
    --If the party's agility is greater than the active enemy group, running succeeds
    if (partyAgility > enemyAgility) then
        return true
    end
end


function calcTotalAgility(group)
	local totalAgility = 0
	--For each group/party member, accumulate their agility
	for i = 1, (#group) do
        --If the current group member is a player character and is dead, the party receives a +100 AGL bonus
		if (group[i].isPlayerCharacter == true) then
			if (group[i].currentLives == 0) then
				totalAgility = totalAgility + 100
			end
		elseif (group[i].currentLives > 0) then
			totalAgility = totalAgility + group[i].agility
		end
	end
	return totalAgility
end

--COMBAT PROGRAM 02 - Determine Enemies' Actions
function determineEnemyAction()

end

function scriptedBattleApollo()
    -- body
end


--COMBAT PROGRAM 03 - Determine Attack Order
function determineAttackOrder()

end

--COMBAT PROGRAM 04

--COMBAT PROGRAM 05 - Main Combat Logic


function item( ... )
    -- body
end

--COMBAT PROGRAM 06

--COMBAT PROGRAM 07

--COMBAT PROGRAM 08

--COMBAT PROGRAM 09

--COMBAT PROGRAM 10

--COMBAT PROGRAM 11











