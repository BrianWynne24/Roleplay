
function Roleplay.FindPlayer( name )
	name = string.lower( name );
	
	for k, v in pairs( player.GetAll() ) do
		local nick = string.lower( v:Name() );
		if ( string.find( nick, name ) ) then
			return v;
		end
	end
	return nil;
end

function Roleplay.Payday()
	if ( CurTime() < Roleplay.Global.Payday || !Roleplay.Config.EnableSalary ) then return; end
	
	for k, v in pairs( player.GetAll() ) do
		v:Payday();
	end
	
	Roleplay.Global.Payday = CurTime() + (Roleplay.Config.PaydayTime*60)
end


function Roleplay.PlayerThink()
	for k, v in pairs( player.GetAll() ) do
		v:SprintThink();
		v:HungerThink();
	end
end

function Roleplay.LoadProperty()
	for k, v in pairs( ents.GetAll() ) do
		if ( v:IsValidDoor() ) then
			local master = v:GetMasterDoor();
			v:SetDTString( 1, v:GetName() );
			if ( master && master != v:GetName() ) then //This will be a child door because it has a master, unlike our other format of the table
				v:SetMasterDoor( master );
			end
		end
	end
end

function Roleplay.SavePropertyOwners()
	/*local dir = Roleplay.Config.SaveDirectory;
	dir = dir .. game.GetMap();

	if ( !file.IsDir( dir, "DATA" ) ) then
		file.CreateDir( dir );
	end
	
	dir = dir .. "/properties.txt";
	dir = string.lower(dir);
	
	file.Write( dir, util.TableToJSON(Roleplay.Property) );
	print( "roleplay saved property owners" );*/
end

function Roleplay.LoadPropertyOwners()
	/*local dir = Roleplay.Config.SaveDirectory;
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
			Roleplay.Property[ k ].owner = v.owner;
		end
	end
	print( "roleplay loaded property owners" );*/
end

function Roleplay.RepoProperty( name )
	name = name:GetMasterDoor();
	if ( !Roleplay.Property[ name ] || Roleplay.Property[ name ].price <= 0 || Roleplay.Property[ name ].owner ) then return; end
	
	Roleplay.Property[ name ].owner = "";
	
	net.Start( "rp_UpPr" );
		net.WriteString( name );
		net.WriteString( "" );
		//net.WriteInt( 0, 16 );
	net.Broadcast();
	
	Roleplay.SavePropertyOwners();
end