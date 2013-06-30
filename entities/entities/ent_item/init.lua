AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self:SetModel( "models/Items/HealthKit.mdl" );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetUseType( SIMPLE_USE );
	self:Activate();
	
	self.hgrp = {};
	
	local phys = self:GetPhysicsObject();
	if( phys:IsValid() ) then phys:Wake(); phys:EnableMotion( true ); end
end

function ENT:Use( pl )
	if ( !IsValid( pl ) || !pl:Alive() ) then return; end
	
	pl:InventoryPickup( self.hgrp.class, self );
end