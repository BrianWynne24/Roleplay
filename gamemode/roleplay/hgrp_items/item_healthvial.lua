ITEM.Name			= "Health Vial";
ITEM.Description 	= "Will health for 10hp";
ITEM.Model 			= "models/Items/healthvial.mdl";
ITEM.KillOnUse 		= false;

ITEM.OnUse			= function( pl )
end

ITEM.CanUse			= function( pl )
	if ( pl:Health() >= 100 ) then
		return false;
	end
	return true;
end