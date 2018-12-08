function playerAttemptRun()

	local cantRunFlag = true
	local activePartyMember = 1
	local maxPartyMembers = (#playerCharacters)

	if (currentFight.bossFightFlag == true) then
		return false
	end

	if (currentFight.playerSurprise == true) then
		return true
	end
	
	local partyAgility = calcTotalAgility(#playerCharacters)
	local enemyAgility = calcTotalAgility(#activeEnemyGroup)


end


function calcTotalAgility(group)
	local totalAgility = 0
	
	for i = 1, (#group) do
		if (group[i].isPlayerCharacter == true) then
			if (group[i].currentLives == 0) then
				totalAgility = totalAgility + 100
			end
		else
			totalAgility = totalAgility + group[i].agility
		end
	end
	return totalAgility
end

















