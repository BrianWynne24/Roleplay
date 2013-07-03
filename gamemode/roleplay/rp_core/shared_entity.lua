 local meta = FindMetaTable( "Entity" );
if ( !meta ) then return; end

function meta:IsValidDoor()
	local classes = { "prop_door_rotating",
					  "func_door",
					  "func_door_rotating" };
					  
	if ( table.HasValue( classes, self:GetClass() ) ) then
		return true;
	end
	return false;
end

function meta:ValidProperty()
	if ( Roleplay.Property[ self:GetName() ] ) then
		return true;
	end
	return false;
end

function meta:GetMasterDoor()
	if ( self:IsValidDoor() && Roleplay.Property[ self:GetName() ] && Roleplay.Property[ self:GetName() ].Master ) then //This has a master, is a linked door
		return Roleplay.Property[ self:GetName() ].Master or self:GetName();
	end
	return self:GetName();
end

function meta:GetPropertyOwner()
	return Roleplay.Property[ self:GetMasterDoor() ].Owner or nil;
end

function meta:GetPropertyName()
	return Roleplay.Property[ self:GetMasterDoor() ].Name;
end

function meta:GetPropertyPrice()
	return Roleplay.Property[ self:GetMasterDoor() ].Price;
end

if ( CLIENT ) then
	function meta:GetName()
		return self:GetDTString(1);
	end
end