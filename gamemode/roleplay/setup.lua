HGRP = {};
	HGRP.Load	= {};
	HGRP.Config = {};
	HGRP.Items = {};
	//HGRP.Hook = {};
	HGRP.Shops = {};
	HGRP.Property = {};
	HGRP.Jobs = {};
		if ( !game.IsDedicated() ) then
			HGRP.Jobs[ 0 ] = { job = "Unemployed", salary = 5, flags = "" };
		end
	
function HGRP.Config.AddJob( name, salary, flags )
	table.insert( HGRP.Jobs, { job = name, salary = salary, flags = flags } );
end

function HGRP.Config.AddProperty( title, master, price, child, flags )
	//table.insert( HGRP.Property, { door = doorname, price = price, childdoors = childdoors } );
	/*HGRP.Property[ doorname ] = { title = title, price = price, owner = nil };
	
	if ( #childdoors <= 0 ) then return; end
	for k, v in pairs( childdoors ) do
		HGRP.Property_Child[ v ] = { door = doorname, title = title, price = price, owner = nil };
	end*/ //I knew I could do better than this
	HGRP.Property[ master ] = { title = title, price = price, child = child, owner = nil, lastlogin = 0, flags = flags };
	for k, v in pairs( child ) do
		HGRP.Property[ v ] = { master = master };
	end
end

function HGRP.Config.AddShop( name, pos, ang )
	if ( HGRP.Shops[ name ] ) then return; end
	HGRP.Shops[ name ] = { pos = pos, ang = ang };
end

if ( CLIENT ) then	
	HGRP.HUD = {};
	HGRP.NET = {};
	
	if ( !hg_rp ) then
		hg_rp = {};
			hg_rp.jobid = 1;
			hg_rp.money = 0;
			hg_rp.stamina = 100;
			hg_rp.hunger = 100;
			hg_rp.inventory = {};
			hg_rp.bankinventory = {};
			hg_rp.bankmoney = 0;
			hg_rp.offered = nil;
	end
	
	include( "config.lua" );
else
	AddCSLuaFile( "config.lua" );
	include( "config.lua" );
	HGRP.Global = {};
		HGRP.Global.Payday = (HGRP.Config.PaydayTime*60);
	HGRP.cc = {};
		HGRP.cc.list = {};
		
	util.AddNetworkString( "rp_Job" );
	util.AddNetworkString( "rp_Money" );
	util.AddNetworkString( "rp_StHu" ); //Stamina/hunger
	util.AddNetworkString( "rp_Inv" );
	util.AddNetworkString( "rp_bItem" ); //bankitem
	util.AddNetworkString( "rp_UpPr" );
	util.AddNetworkString( "rp_Employ" );
	
	function HGRP.cc.concommand( command, func, help, flags )
		table.insert( HGRP.cc.list, { command = command, help = help, flags = flags } );
		concommand.Add( command, func );
	end
end

function HGRP.Load.Items( dir )
	print( "=======================================" );
	print( "Loading Items" );
	
	for k, v in pairs( file.Find( dir .. "/*.lua", "LUA" ) ) do
		ITEM = {};
		if ( SERVER ) then
			AddCSLuaFile( "hgrp_items/" .. v );
		end
		include( "hgrp_items/" .. v );
		
		local class = v;
		class = string.gsub( class, ".lua", "" );
		
		//ITEM.Class = class;
		HGRP.Items[ class ] = ITEM;
		
		print( "> ", class );
		
		ITEM = {};
	end
	print( "Done." );
end

function HGRP.Load.Core( dir )
	print( "Loading files" );
	for k, v in pairs( file.Find( dir .. "/client_*.lua", "LUA" ) ) do
		
		if( SERVER ) then
			AddCSLuaFile( "hgrp_core/" .. v );
			print( "> hgrp_core/" .. v );
		else
			include( "hgrp_core/" .. v );
		end
		
	end
	for k, v in pairs( file.Find( dir .. "/shared_*.lua" , "LUA" ) ) do
	
		if( SERVER ) then
			AddCSLuaFile( "hgrp_core/" .. v );
			print( "> hgrp_core/" .. v );
		end
		include( "hgrp_core/" .. v );
	
	end
	for k, v in pairs( file.Find( dir .. "/server_*.lua", "LUA" ) ) do
		
		if( SERVER ) then
			include( "hgrp_core/" .. v );
			print( "> hgrp_core/" .. v );
		end
		
	end
	print( "Done." );
end
HGRP.Load.Core( "hgrp/gamemode/roleplay/hgrp_core" );
HGRP.Load.Items( "hgrp/gamemode/roleplay/hgrp_items" );
/*function HGRP.Hook.Add( callback, func ) //HGRP.Hook.Add( "PlayerSpawn", HGRP.OnPlayerSpawn )
	if ( !HGRP.Hook[ callback ] ) then HGRP.Hook[ callback ] = {}; end
	table.insert( HGRP.Hook[ callback ], func );
end

function HGRP.Hook.Call( callback )
	if ( !HGRP.Hook[ callback ] ) then Error( "hook '" .. tostring(callback) .. "' does not exist!" ); return; end
	for k, v in pairs( HGRP.Hook[ callback ] ) do
		gamemode.Call( callback, v );
	end
end*/