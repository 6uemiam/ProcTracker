function PT_Events.ADDON_LOADED(...)
	local addonName = ...;

	if(addonName ~= "ProcTracker") then 
		return;
	end
	
	--left for debugging
end

function PT_Events.PLAYER_LOGIN(...)
	local playerClass = select(2, UnitClass("player"));
	local playerSpec = select(2, GetSpecializationInfo(GetSpecialization()));
	
	if PT_LoadProcs[playerClass] then
		PT_LoadProcs[playerClass](playerSpec);
	end
end

function PT_Events.ACTIVE_TALENT_GROUP_CHANGED(...)
	local playerClass = select(2, UnitClass("player"));
	local playerSpec = select(2, GetSpecializationInfo(GetSpecialization()));
	
	table.wipe(PT_procList);
	table.wipe(PT_activeProcs);
	
	if PT_LoadProcs[playerClass] then
		PT_LoadProcs[playerClass](playerSpec);
	end
end

function PT_Events.COMBAT_LOG_EVENT_UNFILTERED(...)
	local subEvent = select(2, ...);
	local destName = select(9, ...);
	local spellId = select(12, ...);
	local spellName = select(13, ...);
	
	if destName ~= UnitName("player") or PT_procList[spellId] == nil then
		return;
	end
	
	if subEvent == "SPELL_AURA_APPLIED" then
		for i = 1, NUM_PROCS do
			if PT_activeProcs[i] == nil then
				if PT_procList[spellId] then
					table.insert(PT_activeProcs, i, {procId = spellId, buff = true});
				else
					table.insert(PT_activeProcs, i, {procId = spellId, buff = false});
				end
				
				return;
			end
		end
	elseif subEvent == "SPELL_AURA_REMOVED" then
		for i = 1, NUM_PROCS do
			if PT_activeProcs[i] ~= nil and PT_activeProcs[i].procId == spellId then
				table.remove(PT_activeProcs, i);
				return;
			end
		end
	end
end