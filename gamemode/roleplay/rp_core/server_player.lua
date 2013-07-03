
function GM:PlayerInitialSpawn( pl )
	pl:OnInitialSpawn();
	pl:LoadMySQL();
end

function GM:PlayerSpawn( pl )
	pl:OnSpawn();
end

function GM:Think()
	Roleplay.Payday();
	Roleplay.PlayerThink();
	Roleplay.db.Think();
end

function GM:InitPostEntity()
	Roleplay.LoadProperty();
end

function GM:PlayerDisconnected( pl )
	//pl:SaveMySQL();
end