net.Receive( "rp_Job", function( len )
	local id = net.ReadInt(8);

	hg_rp.jobid = id;
end );

net.Receive( "rp_Money", function( len )
	local bool = net.ReadBit();
	local amt = net.ReadInt(16);
	
	bool = tobool(bool);
	if ( bool ) then
		hg_rp.money = amt;
	else
		hg_rp.bankmoney = amt;
	end
end );

net.Receive( "rp_StHu", function( len )
	local bool = net.ReadBit();
	local amt = net.ReadInt(8);

	bool = tobool(bool);
	if ( bool ) then
		hg_rp.stamina = amt;
	else
		hg_rp.hunger = amt;
	end
end );

net.Receive( "rp_Inv", function( len )
	local bool = net.ReadBit();
	local str = net.ReadString();
	
	bool = tobool(bool);
	if ( bool ) then
		table.insert( hg_rp.inventory, str );
	else
		for k, v in pairs( hg_rp.inventory ) do
		if ( v == str ) then
				table.remove( hg_rp.inventory, k );
				return;
			end
		end
	end
end );

net.Receive( "rp_bItem", function( len )
	local bool = net.ReadBit();
	local str = net.ReadString();
	
	bool = tobool(bool);
	if ( bool ) then
		table.insert( hg_rp.bankinventory, str );
	else
		for k, v in pairs( hg_rp.bankinventory ) do
		if ( v == str ) then
				table.remove( hg_rp.bankinventory, k );
				return;
			end
		end
	end
end );

net.Receive( "rp_UpPr", function( len )
	local name = net.ReadString();
	local owner = net.ReadString();
	//local price = net.ReadInt(16);

	if ( owner == "" ) then
		HGRP.Property[ name ].owner = "";
		return;
	end
	
	HGRP.Property[ name ].owner = owner;
end );

net.Receive( "rp_Employ", function( len )
	local name = net.ReadString();
	local id = net.ReadInt(16);

	hg_rp.offered = {};
		hg_rp.offered.name = name;
		hg_rp.offered.id = id;
end );