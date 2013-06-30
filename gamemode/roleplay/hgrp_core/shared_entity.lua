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
	if ( HGRP.Property[ self:GetName() ] || HGRP.Property_Child[ self:GetName() ] ) then
		return true;
	end
	return false;
end

function meta:GetMasterDoor()
	if ( self:IsValidDoor() && HGRP.Property[ self:GetName() ].master ) then //This has a master, is a linked door
		return HGRP.Property[ self:GetName() ].master;
	end
	return self:GetName();
end

function meta:GetPropertyOwner()
	return HGRP.Property[ self:GetMasterDoor() ].owner or "";
end

function meta:GetPropertyName()
	return HGRP.Property[ self:GetMasterDoor() ].title;
end

function meta:GetPropertyPrice()
	return HGRP.Property[ self:GetMasterDoor() ].price;
end

if ( CLIENT ) then
	function meta:GetName()
		return self:GetDTString(1);
	end
end