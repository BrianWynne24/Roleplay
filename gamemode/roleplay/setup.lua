Roleplay = {};
	Roleplay.Load	= {};
	Roleplay.Config = {};
	Roleplay.Items = {};
	//Roleplay.Hook = {};
	Roleplay.Shops = {};
	if ( !Roleplay.Property ) then
		Roleplay.Property = {};
	end
	if ( !Roleplay.Jobs ) then
		Roleplay.Jobs = {};
			if ( !game.IsDedicated() ) then
				Roleplay.Jobs[ 0 ] = { job = "Unemployed", salary = 5, flags = "" };
			end
	end
	
function Roleplay.Config.AddJob( name, salary, flags )
	table.insert( Roleplay.Jobs, { job = name, salary = salary, flags = flags } );
end

function Roleplay.Config.AddProperty( title, master, price, child, flags )
	//table.insert( Roleplay.Property, { door = doorname, price = price, childdoors = childdoors } );
	/*Roleplay.Property[ doorname ] = { title = title, price = price, owner = nil };
	
	if ( #childdoors <= 0 ) then return; end
	for k, v in pairs( childdoors ) do
		Roleplay.Property_Child[ v ] = { door = doorname, title = title, price = price, owner = nil };
	end*/ //I knew I could do better than this
	Roleplay.Property[ master ] = { title = title, price = price, child = child, owner = nil, lastlogin = 0, flags = flags };
	for k, v in pairs( child ) do
		Roleplay.Property[ v ] = { master = master };
	end
end

function Roleplay.Config.AddShop( name, pos, ang )
	if ( Roleplay.Shops[ name ] ) then return; end
	Roleplay.Shops[ name ] = { pos = pos, ang = ang };
end

if ( CLIENT ) then	
	Roleplay.HUD = {};
	Roleplay.NET = {};
	
	if ( !roleplay ) then
		roleplay = {};
			roleplay.jobid = 1;
			roleplay.money = 0;
			roleplay.stamina = 100;
			roleplay.hunger = 100;
			roleplay.inventory = {};
			roleplay.bankinventory = {};
			roleplay.bankmoney = 0;
			roleplay.offered = nil;
	end
	
	include( "config.lua" );
else
	AddCSLuaFile( "config.lua" );
	include( "config.lua" );
	Roleplay.Global = {};
		Roleplay.Global.Payday = (Roleplay.Config.PaydayTime*60);
	Roleplay.cc = {};
		Roleplay.cc.list = {};
	Roleplay.db = {};
		Roleplay.db.object = nil;
		Roleplay.db.queries = {};
		
	util.AddNetworkString( "rp_Job" );
	util.AddNetworkString( "rp_Money" );
	util.AddNetworkString( "rp_StHu" ); //Stamina/hunger
	util.AddNetworkString( "rp_Inv" );
	util.AddNetworkString( "rp_bItem" ); //bankitem
	util.AddNetworkString( "rp_UpPr" );
	util.AddNetworkString( "rp_Employ" );
	util.AddNetworkString( "rp_UpJb" );
	
	function Roleplay.cc.concommand( command, func, help, flags )
		table.insert( Roleplay.cc.list, { command = command, help = help, flags = flags } );
		concommand.Add( command, func );
	end
end

function Roleplay.Load.Items( dir )
	print( "=======================================" );
	print( "Loading Items" );
	
	for k, v in pairs( file.Find( dir .. "/*.lua", "LUA" ) ) do
		ITEM = {};
		if ( SERVER ) then
			AddCSLuaFile( "roleplay_items/" .. v );
		end
		include( "roleplay_items/" .. v );
		
		local class = v;
		class = string.gsub( class, ".lua", "" );
		
		//ITEM.Class = class;
		Roleplay.Items[ class ] = ITEM;
		
		print( "> ", class );
		
		ITEM = {};
	end
	print( "Done." );
end

function Roleplay.Load.Core( dir )
	print( "Loading files" );
	for k, v in pairs( file.Find( dir .. "/client_*.lua", "LUA" ) ) do
		
		if( SERVER ) then
			AddCSLuaFile( "roleplay_core/" .. v );
			print( "> roleplay_core/" .. v );
		else
			include( "roleplay_core/" .. v );
		end
		
	end
	for k, v in pairs( file.Find( dir .. "/shared_*.lua" , "LUA" ) ) do
	
		if( SERVER ) then
			AddCSLuaFile( "roleplay_core/" .. v );
			print( "> roleplay_core/" .. v );
		end
		include( "roleplay_core/" .. v );
	
	end
	for k, v in pairs( file.Find( dir .. "/server_*.lua", "LUA" ) ) do
		
		if( SERVER ) then
			include( "roleplay_core/" .. v );
			print( "> roleplay_core/" .. v );
		end
		
	end
	print( "Done." );
end
Roleplay.Load.Core( "roleplay/gamemode/roleplay/rp_core" );
Roleplay.Load.Items( "roleplay/gamemode/roleplay/rp_items" );
/*function Roleplay.Hook.Add( callback, func ) //Roleplay.Hook.Add( "PlayerSpawn", Roleplay.OnPlayerSpawn )
	if ( !Roleplay.Hook[ callback ] ) then Roleplay.Hook[ callback ] = {}; end
	table.insert( Roleplay.Hook[ callback ], func );
end

function Roleplay.Hook.Call( callback )
	if ( !Roleplay.Hook[ callback ] ) then Error( "hook '" .. tostring(callback) .. "' does not exist!" ); return; end
	for k, v in pairs( Roleplay.Hook[ callback ] ) do
		gamemode.Call( callback, v );
	end
end*/