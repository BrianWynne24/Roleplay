
ENT.Base 					= "base_entity";
ENT.Type 					= "anim";

ENT.PrintName				= "#ITEM";
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