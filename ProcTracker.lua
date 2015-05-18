function ProcTracker_OnLoad(self)
	self:RegisterForDrag("LeftButton");
	self:SetUserPlaced(true);
	
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("PLAYER_LOGIN");
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	
	-- update every 5 frames
	-- local frames = 0;
	
	-- self:SetScript("OnUpdate", function(...)
		-- frames = frames + 1;
		-- if frames % 5 == 0 then
			-- return ProcTracker_OnUpdate(self);
		-- end
	-- end);
end

function ProcTracker_OnEvent(self, event, ...)
	if PT_Events[event] ~= nil then
		return PT_Events[event](...);
	end
end

function ProcTracker_OnDragStart(self)
	self:StartMoving();
end

function ProcTracker_OnDragStop(self)
	self:StopMovingOrSizing();
end

function ProcTracker_OnEnter(self)
	self:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"});
end

function ProcTracker_OnLeave(self)
	self:SetBackdrop(nil);
end

function ProcTracker_OnUpdate(self)
	table.sort(PT_activeProcs, function(proc1, proc2)
		local proc1Name = GetSpellInfo(proc1.procId);
		local proc2Name = GetSpellInfo(proc2.procId);
		local proc1Expires;
		local proc2Expires;
		
		if proc1.buff then
			proc1Expires = select(7, UnitBuff("player", proc1Name));
		else
			proc1Expires = select(7, UnitDebuff("player", proc1Name));
		end
		
		if proc2.buff then
			proc2Expires = select(7, UnitBuff("player", proc2Name));
		else
			proc2Expires = select(7, UnitDebuff("player", proc2Name));
		end
		
		return proc1Expires < proc2Expires;
	end);

	for i = NUM_PROCS, 1, -1 do
		local procFrame = self:GetName().."_Proc"..i;
	
		if PT_activeProcs[i] ~= nil then
			local procName = GetSpellInfo(PT_activeProcs[i].procId);
			local procIcon = select(3, GetSpellInfo(PT_activeProcs[i].procId));
			local procCount;
			local procDuration;
			local procExpires;
			
			if PT_activeProcs[i].buff then
				procCount = select(4, UnitBuff("player", procName));
				procDuration = select(6, UnitBuff("player", procName));
				procExpires = select(7, UnitBuff("player", procName)) - GetTime();
			else
				procCount = select(4, UnitDebuff("player", procName));
				procDuration = select(6, UnitDebuff("player", procName));
				procExpires = select(7, UnitDebuff("player", procName)) - GetTime();
			end
			
			if procExpires >= 0 then
				_G[procFrame.."_Icon"]:SetBackdrop({bgFile = procIcon});
				
				if(procCount > 1) then
					_G[procFrame.."_Icon_Count"]:SetText(procCount);
				else
					_G[procFrame.."_Icon_Count"]:SetText("");
				end
				
				_G[procFrame.."_StatusBar_Name"]:SetText(procName);
				_G[procFrame.."_StatusBar_Expires"]:SetText(math.floor(procExpires).."s");
				_G[procFrame.."_StatusBar"]:SetMinMaxValues(0, procDuration);
				_G[procFrame.."_StatusBar"]:SetValue(procExpires);
				_G[procFrame]:Show();
			else
				table.remove(PT_activeProcs, i);
			end
		elseif _G[procFrame]:IsShown() then
			_G[procFrame]:Hide();
		end
	end
end