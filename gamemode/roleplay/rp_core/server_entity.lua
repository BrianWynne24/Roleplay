local meta = FindMetaTable( "Entity" );
if ( !meta ) then return; end

function meta:SetMasterDoor( str )
	for k, v in pairs( ents.GetAll() ) do
		if ( v:IsValidDoor() && v:GetName() == str ) then
			self:SetOwner( v );
			return;
		end
	end
end