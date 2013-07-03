AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

ENT.Levels = {};
	ENT.Levels[ 1 ] = { money = 25, time = 60, size = 0.6 };
	ENT.Levels[ 2 ] = { money = 35, time = 50, size = 0.8 };
	ENT.Levels[ 3 ] = { money = 45, time = 40, size = 1.0 };
	
function ENT:Initialize()
	self:SetModel( Roleplay.Config.MoneyPrinterMdl );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetUseType( SIMPLE_USE );
	self:Activate();
	
	self:SetMoney( 0 );
	self:SetTemp( 5 );
	self:SetLevel( 1 );
	self:SetActive( true );
	
	self.waittime = CurTime() + 60;
	self.cycle = 1;
	self.cooler = nil;
	self.sparktime = CurTime();
	//self.active = true;
	
	local phys = self:GetPhysicsObject();
	if( phys:IsValid() ) then phys:Wake(); phys:EnableMotion( true ); end
end

function ENT:SetActive( bool )
	self:SetDTBool(0, bool);
end

function ENT:Use( pl )
	if ( !IsValid( pl ) || !pl:Alive() ) then return; end
	
	if ( self:Money() > 0 ) then
		pl:AddMoney( self:Money() );
		self:SetMoney(0);
		return;
	end
	
	self.waittime = CurTime() + self.Levels[ self:Level() ].time;
	if ( !self:Active() ) then
		self:SetActive( true );
		return;
	end
	self:SetActive( false );
end

function ENT:SetMoney( amt )
	self:SetDTInt( 0, amt );
end

function ENT:SetTemp( amt )
	self:SetDTInt( 1, amt );
	if ( self:Temp() < 0 ) then
		amt = 0;
	elseif ( self:Temp() > 100 ) then
		self:Explode();
	end
	self:SetDTInt( 1, amt );
end

function ENT:SetLevel( amt )
	if ( amt > #self.Levels || amt < 1 ) then return; end
	self:SetDTInt( 2, amt );
	self:SetModelScale( self:GetModelScale() * self.Levels[ amt ].size, 0.01 )
end

function ENT:Think()
	self:SparkEffect();
	if ( CurTime() < self.waittime ) then return; end
	
	if ( self:Active() ) then
		self:SetTemp( self:Temp() + 3 );
		self:SetMoney( self:Money() + (self:Level()*45) )
	else
		if ( self:Temp() > 0 ) then
			self:SetTemp( self:Temp() - 5 );
		end
	end

	self.waittime = CurTime() + self.Levels[ self:Level() ].time;
	
	self.cycle = self.cycle + 1;
	if ( self.cycle >= 10 ) then
		self:SetLevel( self:Level() + 1 );
		self.cycle = 1;
	end
end

function ENT:OnRemove()
	if ( self.cooler ) then
		self.cooler:Remove();
		self.cooler = nil;
	end
end

function ENT:Explode()
	local effect = EffectData();
	local pos = self:GetPos();
	
	effect:SetStart( pos );
	effect:SetOrigin( pos );
	effect:SetScale( 1 );
	util.Effect( "Explosion", effect );
	
	self:Remove();
end

function ENT:Spark()
	local effect = EffectData();
	local pos = self:GetPos();
	//pos = pos + (pos:Forward() * 4);
	
	effect:SetStart( pos );
	effect:SetOrigin( pos );
	effect:SetScale( 1 );
	util.Effect( "cball_explode", effect );
	
	self:EmitSound( "ambient/energy/spark" .. math.random( 1, 6 ) .. ".wav", 50 );
end

function ENT:SparkEffect()
	if ( self:Temp() < 90 || CurTime() < self.sparktime ) then return; end
	self:Spark();
	self.sparktime = CurTime() + math.Rand( 0.1, 0.6 );
end