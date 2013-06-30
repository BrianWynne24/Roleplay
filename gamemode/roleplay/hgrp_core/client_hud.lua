
function GM:Initialize()
	surface.CreateFont( "RedDead_56", {
	font 		= "ChineseRocksRg-Regular",
	size 		= 56,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "RedDead_34", {
	font 		= "ChineseRocksRg-Regular",
	size 		= 34,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
end

function HGRP.HUD.Health( pl, x, y )
	local hp = pl:Health();
	local ar = pl:Armor();
	draw.DrawText( hp, "RedDead_56", x * 0.01, y * 1.88, Color( 220, 160, 0, 255 ), TEXT_ALIGN_LEFT );
	draw.DrawText( "+" .. ar, "RedDead_34", x * 0.08, y * 1.85, Color( 0, 160, 220, 255 ), TEXT_ALIGN_LEFT );
end

function HGRP.HUD.Job( pl, x, y )
	draw.DrawText( "Unemployed", "RedDead_56", x, y * 1.88, Color( 220, 160, 0, 255 ), TEXT_ALIGN_CENTER );
end

function HGRP.HUD.Dev( pl, x, y )
	draw.DrawText( pl:Job() .. "\n$" .. pl:Salary() .. "/hr\nWallet: $" .. pl:Money() .. "\nBank: $" .. pl:BankMoney() .. "\n%" .. pl:Stamina() .. "\n%" .. pl:Hunger(), "TargetID", x * 0.01, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
	
	draw.DrawText( "Bank -", "TargetID", x * 2, y * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT );
	draw.DrawText( "Inventory -", "TargetID", x * 1.60, y * 0.25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT );
	for k, v in pairs( hg_rp.bankinventory ) do
		draw.DrawText( v, "TargetID", x * 2, y - (k*32), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT );
	end
	for k, v in pairs( hg_rp.inventory ) do
		draw.DrawText( v, "TargetID", x * 1.60, y - (k*32), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT );
	end
	local tr = util.QuickTrace( pl:GetShootPos(), pl:GetAimVector() * 86, pl );
	if ( IsValid( tr.Entity ) && tr.Entity:IsValidDoor() ) then
		local ent = tr.Entity;
		if ( ent:ValidProperty() ) then
			local owner = ent:GetPropertyOwner();
			if ( owner == "" ) then
				owner = "$" .. ent:GetPropertyPrice();
			end
			draw.DrawText( ent:GetPropertyName() .. " (" .. owner .. ")", "TargetID", x * 0.01, y * 1.96, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
		end
	end
	
	if ( !hg_rp.offered ) then return; end
	
	local name = hg_rp.offered.name;
	local jobid = hg_rp.offered.id;
	
	draw.DrawText( "Employment Offer from " .. name .. "\n" .. HGRP.Jobs[ jobid ].job .. "\n$" .. HGRP.Jobs[ jobid ].salary .. " / hr\n\n1. Accept\n2. Decline", "TargetID", x * 0.01, y * 0.01, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
end

function GM:HUDPaint()
	local x = ScrW() / 2;
	local y = ScrH() / 2;
	local pl = LocalPlayer();
	
	if ( !IsValid(pl) ) then return; end
	
	if ( HGRP.Config.DevMode ) then
		HGRP.HUD.Dev( pl, x, y );
		return;
	end
	
	HGRP.HUD.Health( pl, x, y );
	HGRP.HUD.Job( pl, x, y );
end

//Hid HUD
function HGRP.HUD.Hide( name )
	local Tbl = { 
	[ "CHudHealth" ] = true, 
	[ "CHudAmmo" ]   = true, 
	[ "CHudAmmoSecondary" ] = true, 
	[ "CHudBattery" ] = true,
	[ "CHudWeaponSelection" ] = true
	}; 
	
	if ( Tbl[ name ] ) then
		return false;
	end
end
hook.Add( "HUDShouldDraw", "HGRP.HUD.Hide", HGRP.HUD.Hide );