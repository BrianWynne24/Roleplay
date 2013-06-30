
function HGRP.FindPlayer( name )
	name = string.lower( name );
	
	for k, v in pairs( player.GetAll() ) do
		local nick = string.lower( v:Name() );
		if ( string.find( nick, name ) ) then
			return v;
		end
	end
	return nil;
end

function HGRP.Payday()
	if ( CurTime() < HGRP.Global.Payday || !HGRP.Config.EnableSalary ) then return; end
	
	for k, v in pairs( player.GetAll() ) do
		v:Payday();
	end
	
	HGRP.Global.Payday = CurTime() + (HGRP.Config.PaydayTime*60)
end


function HGRP.PlayerThink()
	for k, v in pairs( player.GetAll() ) do
		v:SprintThink();
		v:HungerThink();
	end
end

function HGRP.LoadProperty()
	for k, v in pairs( ents.GetAll() ) do
		if ( v:IsValidDoor() ) then
			local master = v:GetMasterDoor();
			v:SetDTString( 1, v:GetName() );
			if ( master && master != v:GetName() ) then //This will be a child door because it has a master, unlike our other format of the table
				v:SetMasterDoor( master );
			end
		end
	end
	HGRP.LoadPropertyOwners();
end

function HGRP.SavePropertyOwners()
	local dir = HGRP.Config.SaveDirectory;
	dir = dir .. game.GetMap();

	if ( !file.IsDir( dir, "DATA" ) ) then
		file.CreateDir( dir );
	end
	
	dir = dir .. "/properties.txt";
	dir = string.lower(dir);
	
	file.Write( dir, util.TableToJSON(HGRP.Property) );
	print( "roleplay saved property owners" );
end

function HGRP.LoadPropertyOwners()
	local dir = HGRP.Config.SaveDirectory;
	dir = dir .. game.GetMap();

	if ( !file.IsDir( dir, "DATA" ) ) then
		file.CreateDir( dir );
	end
	
	dir = dir .. "/properties.txt";
	dir = string.lower(dir);
	
	if ( !file.Exists( dir, "DATA" ) ) then
		return;
	end
	
	local property = util.JSONToTable( file.Read(dir,"DATA") );
	for k, v in pairs( property ) do
		if ( v.owner != "" ) then
			HGRP.Property[ k ].owner = v.owner;
		end
	end
	print( "roleplay loaded property owners" );
end

function HGRP.RepoProperty( name )
	name = name:GetMasterDoor();
	if ( !HGRP.Property[ name ] || HGRP.Property[ name ].price <= 0 || HGRP.Property[ name ].owner ) then return; end
	
	HGRP.Property[ name ].owner = "";
	
	net.Start( "rp_UpPr" );
		net.WriteString( name );
		net.WriteString( "" );
		//net.WriteInt( 0, 16 );
	net.Broadcast();
	
	HGRP.SavePropertyOwners();
end