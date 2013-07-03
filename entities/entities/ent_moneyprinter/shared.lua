
ENT.Base 					= "base_entity";
ENT.Type 					= "anim";

ENT.PrintName				= "#PRINTER";
ENT.Author					= "";
ENT.Contact					= "";
ENT.Purpose					= "";
ENT.Instructions			= "";

ENT.Spawnable 				= false;
ENT.AdminSpawnable 			= false;

ENT.AutomaticFrameAdvance 	= true;

function ENT:OnRemove( )
end

function ENT:PhysicsCollide( data, physobj )
end

function ENT:PhysicsUpdate( physobj )
end

function ENT:Money()
	return self:GetDTInt(0);
end

function ENT:Temp()
	return self:GetDTInt(1);
end

function ENT:Level()
	return self:GetDTInt(2);
end

function ENT:Active()
	return self:GetDTBool(0);
end