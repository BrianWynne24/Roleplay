
function GM:PlayerInitialSpawn( pl )
	pl:OnInitialSpawn();
	pl:LoadData();
end

function GM:PlayerSpawn( pl )
	pl:OnSpawn();
end

function GM:Think()
	HGRP.Payday();
	HGRP.PlayerThink();
end

function GM:InitPostEntity()
	HGRP.LoadProperty();
end

function GM:PlayerDisconnected( pl )
	pl:SaveData();
end