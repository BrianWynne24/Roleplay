net.Receive( "rp_Job", function( len )
	local id = net.ReadInt(8);

	roleplay.jobid = id;
end );

net.Receive( "rp_Money", function( len )
	local bool = net.ReadBit();
	local amt = net.ReadInt(16);
	
	bool = tobool(bool);
	if ( bool ) then
		roleplay.money = amt;
	else
		roleplay.bankmoney = amt;
	end
end );

net.Receive( "rp_StHu", function( len )
	local bool = net.ReadBit();
	local amt = net.ReadInt(8);

	bool = tobool(bool);
	if ( bool ) then
		roleplay.stamina = amt;
	else
		roleplay.hunger = amt;
	end
end );

net.Receive( "rp_Inv", function( len )
	local bool = net.ReadBit();
	local str = net.ReadString();
	
	bool = tobool(bool);
	if ( bool ) then
		table.insert( roleplay.inventory, str );
	else
		for k, v in pairs( roleplay.inventory ) do
		if ( v == str ) then
				table.remove( roleplay.inventory, k );
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
		table.insert( roleplay.bankinventory, str );
	else
		for k, v in pairs( roleplay.bankinventory ) do
		if ( v == str ) then
				table.remove( roleplay.bankinventory, k );
				return;
			end
		end
	end
end );

net.Receive( "rp_UpPr", function( len )
	/*local name = net.ReadString();
	local owner = net.ReadString();
	//local price = net.ReadInt(16);

	if ( owner == "" ) then
		Roleplay.Property[ name ].owner = "";
		return;
	end
	
	Roleplay.Property[ name ].owner = owner;*/
	local property = net.ReadTable();
	Roleplay.Property = property;
end );

net.Receive( "rp_UpJb", function( len )
	local job = net.ReadTable();
	
	//Roleplay.Jobs[ jobid ] = { job = job, salary = salary };
	Roleplay.Jobs = job;
end );

net.Receive( "rp_Employ", function( len )
	local name = net.ReadString();
	local id = net.ReadInt(16);

	roleplay.offered = {};
		roleplay.offered.name = name;
		roleplay.offered.id = id;
end );