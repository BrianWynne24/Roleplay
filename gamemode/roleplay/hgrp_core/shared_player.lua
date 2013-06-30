local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end

function meta:JobId()
	if ( SERVER ) then
		return self.hgrp.jobid;
	end
	return hg_rp.jobid;
end

function meta:Money()
	if ( SERVER ) then
		return self.hgrp.money;
	end
	return hg_rp.money;
end

function meta:BankMoney()
	if ( SERVER ) then
		return self.hgrp.bankmoney;
	end
	return hg_rp.bankmoney;
end

function meta:Salary()
	return HGRP.Jobs[ self:JobId() ].salary;
end

function meta:Job()
	return HGRP.Jobs[ self:JobId() ].job;
end

function meta:Flags( flag )
	if ( table.HasValue( HGRP.Jobs[ self:JobId() ].flags, flag ) ) then
		return true;
	end
	return false;
end

function meta:Hunger()
	if ( SERVER ) then
		return self.hgrp.hunger;
	end
	return hg_rp.hunger;
end

function meta:Stamina()
	if ( SERVER ) then
		return self.hgrp.stamina;
	end
	return hg_rp.stamina;
end

function meta:HasItem( class )
	if ( !HGRP.Items[ class ] ) then return false; end
	if ( SERVER ) then
		if ( table.HasValue( self.hgrp.inventory, class ) ) then
			return true;
		end
		return false;
	end
	if ( table.HasValue( hg_rp.inventory, class ) ) then
		return true;
	end
	return false;
end

function meta:HasItemInBank( class )
	if ( !HGRP.Items[ class ] ) then return false; end
	if ( SERVER ) then
		if ( table.HasValue( self.hgrp.bankinventory, class ) ) then
			return true;
		end
		return false;
	end
	if ( table.HasValue( hg_rp.bankinventory, class ) ) then
		return true;
	end
	return false;
end