function PT_LoadProcs.MAGE(playerSpec)
	if(playerSpec == "Frost") then
		--Brain Freeze
		PT_procList[57761] = true;
		
		--Fingers of Frost
		PT_procList[44544] = true;
		
		PT_procList[108843] = true;
		PT_procList[61316] = true;
	elseif(playerSpec == "Fire") then
		--Heating up
		PT_procList[48107] = true;
		
		--Pyroblast!
		PT_procList[48108] = true;
	elseif(playerSpec == "Arcane") then
		--Arcane Charge
		PT_procList[36032] = false;
		
		--Arcane Missiles
		PT_procList[79683] = true;
	end
end