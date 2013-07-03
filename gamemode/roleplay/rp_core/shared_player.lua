local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end

function meta:JobId()
	if ( SERVER ) then
		return self.hgrp.jobid;
	end
	return roleplay.jobid;
end

function meta:Money()
	if ( SERVER ) then
		return self.hgrp.money;
	end
	return roleplay.money;
end

function meta:BankMoney()
	if ( SERVER ) then
		return self.hgrp.bankmoney;
	end
	return roleplay.bankmoney;
end

function meta:Salary()
	return Roleplay.Jobs[ self:JobId() ].Salary;
end

function meta:Job()
	return Roleplay.Jobs[ self:JobId() ].Job;
end

function meta:Flags( flag )
	if ( string.find( Roleplay.Jobs[ self:JobId() ].Flags, flag ) ) then
		return true;
	end
	return false;
end

function meta:Hunger()
	if ( SERVER ) then
		return self.hgrp.hunger;
	end
	return roleplay.hunger;
end

function meta:Stamina()
	if ( SERVER ) then
		return self.hgrp.stamina;
	end
	return roleplay.stamina;
end

function meta:HasItem( class )
	if ( !Roleplay.Items[ class ] ) then return false; end
	if ( SERVER ) then
		if ( table.HasValue( self.hgrp.inventory, class ) ) then
			return true;
		end
		return false;
	end
	if ( table.HasValue( roleplay.inventory, class ) ) then
		return true;
	end
	return false;
end

function meta:HasItemInBank( class )
	if ( !Roleplay.Items[ class ] ) then return false; end
	if ( SERVER ) then
		if ( table.HasValue( self.hgrp.bankinventory, class ) ) then
			return true;
		end
		return false;
	end
	if ( table.HasValue( roleplay.bankinventory, class ) ) then
		return true;
	end
	return false;
end