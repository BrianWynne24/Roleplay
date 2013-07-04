local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end

function meta:RunSpeed( speed )
	if ( speed == self.roleplay.runspeed ) then return; end
	self:SetRunSpeed( speed );
	self.roleplay.runspeed = speed;
end

function meta:WalkSpeed( speed )
	if ( speed == self.roleplay.walkspeed ) then return; end
	self:SetWalkSpeed( speed );
	self.roleplay.walkspeed = speed;
end

function meta:OnInitialSpawn()
	//First we make all the variables the player will have
	self.roleplay = {};
		self.roleplay.money = 0;
		self.roleplay.jobid = 1;
		self.roleplay.stamina = 100;
		self.roleplay.stamwait = CurTime();
		self.roleplay.runspeed = 320;
		self.roleplay.walkspeed = 180;
		self.roleplay.hunger = 100;
		self.roleplay.hungerwait = CurTime();
		self.roleplay.inventory = {};
		self.roleplay.bankinventory = {};
		self.roleplay.bankmoney = 0;
		self.roleplay.offered = 0;
		
	//self:SetJob( self.roleplay.jobid ); //This will return nil, no point trying to call it
	//self:SetMoney( self.roleplay.money );
	//for k, v in pairs( Roleplay.Property ) do
	//	if ( v.owner && v.owner != "" ) then
			/*local steamid = tostring(v.owner);
			net.Start( "rp_UpPr" );
				net.WriteString( k );
				net.WriteString( steamid );
			net.Send( self );*/
			net.Start( "rp_UpPr" );
				net.WriteTable( Roleplay.Property );
			net.Send( self );
			net.Start( "rp_UpJb" );
				net.WriteTable( Roleplay.Jobs );
			net.Broadcast();
		//end
	//end

end

function meta:OnSpawn()
	self:SetArmor( 100 );
	self:SetStamina( 100 );
	self:SetHunger( 100 );
end

function meta:AddHealth( hp )
	self:SetHealth( self:Health() + hp );
	if ( self:Health() > 100 ) then
		self:SetHealth( 100 );
	elseif ( self:Health() <= 0 ) then
		self:Kill();
	end
end

function meta:SetMoney( amt )
	if ( self.roleplay.money == amt ) then return; end
	
	self.roleplay.money = amt;
	net.Start( "rp_Money" );
		net.WriteBit( true );
		net.WriteInt( amt, 16 );
	net.Send( self );
end

function meta:AddMoney( amt )
	self:SetMoney( self:Money() + amt );
end

function meta:GiveMoney( pl, amt )
	if ( self:Money() < amt ) then return; end
	
	pl:AddMoney( amt );
	self:AddMoney( -amt );
	
	pl:PrintMessage( 1, self:Name() .. " gave you $" .. amt );
	self:PrintMessage( 1, "You gave " .. pl:Name() .. " $" .. amt );
end

function meta:SetBankMoney( amt )
	if ( self.roleplay.bankmoney == amt ) then return; end
	
	self.roleplay.bankmoney = amt;
	net.Start( "rp_Money" );
		net.WriteBit( false );
		net.WriteInt( amt, 16 );
	net.Send( self );
end

function meta:AddBankMoney( amt )
	self:SetBankMoney( self:BankMoney() + amt );
end

function meta:SetStamina( amt )
	if ( self.roleplay.stamina == amt ) then return; end //Don't send net messages to to client for no reason
	
	self.roleplay.stamina = amt;
	net.Start( "rp_StHu" );
		net.WriteBit( true );
		net.WriteInt( amt, 8 );
	net.Send( self );
end

function meta:AddStamina( amt )
	self:SetStamina( self:Stamina() + amt );
end

function meta:SetHunger( amt )
	if ( self.roleplay.hunger == amt ) then return; end
	
	self.roleplay.hunger = amt;
	net.Start( "rp_StHu" );
		net.WriteBit( false );
		net.WriteInt( amt, 8 );
	net.Send( self );
end

function meta:AddHunger( amt )
	self:SetHunger( self:Hunger() + amt );
end

function meta:SetJob( id )
	if ( !Roleplay.Jobs[ id ] || self.roleplay.jobid == id ) then return; end
	
	self.roleplay.jobid = id;
	net.Start( "rp_Job" );
		net.WriteInt( id, 8 );
	net.Send( self );
end

function meta:EmploymentOffer( offerer, jobid )
	if ( self:JobId() == jobid || self.roleplay.offered >= 1 ) then return; end
	
	local name = "CONSOLE";
	if ( IsValid( offerer ) && offerer:IsPlayer() ) then
		name = offerer:Name();
	end
	
	self.roleplay.offered = jobid;
	net.Start( "rp_Employ" );
		net.WriteString( name );
		net.WriteInt( jobid, 16 );
	net.Send( self );
end

function meta:Payday()
	if ( !self:Alive() ) then return; end
	
	if ( Roleplay.Config.PayToBank ) then
		self:AddBankMoney( self:Salary() );
	else
		self:AddMoney( self:Salary() );
	end
	self:SaveMySQL();
end

function meta:SprintThink()
	if ( CurTime() < self.roleplay.stamwait || !self:Alive() || (self:GetVelocity():Length() < 40 && self:KeyDown(IN_SPEED)) ) then return; end
	
	local stam = self:Stamina();
	if ( self:KeyDown( IN_SPEED ) ) then
		if ( stam > 0 ) then
			self:AddStamina( -1 );
			self:RunSpeed( 320 );
		elseif ( stam <= 0 ) then
			self:RunSpeed( 120 );
			self:WalkSpeed( 120 );
		end
		
		self.roleplay.stamwait = CurTime() + 0.18;
		return;
	elseif ( !self:KeyDown( IN_SPEED ) ) then
		self:AddStamina( 1 );
		if ( stam >= 100 ) then
			self:SetStamina( 100 );
		elseif ( stam <= 10 ) then
			self:RunSpeed( 120 );
			self:WalkSpeed( 120 );
		elseif ( stam > 10 && stam < 100 ) then
			self:RunSpeed( 320 );
			self:WalkSpeed( 180 );
		end
		
		//self:RunSpeed( 320 );
		//self:WalkSpeed( 180 );
		self.roleplay.stamwait = CurTime() + 0.5;
	end
end

function meta:HungerThink()
	if ( CurTime() < self.roleplay.hungerwait || !self:Alive() || !Roleplay.Config.EnableHunger ) then return; end
	
	self:AddHunger( -1 );
	if ( self:Hunger() < 1 ) then
		self:AddHealth( -5 );
	end
	self.roleplay.hungerwait = CurTime() + (Roleplay.Config.HungerTime*60);
end

//Inventory shittttttttt
function meta:AddItemToInventory( class )
	if ( !Roleplay.Items[ class ] || self:InventoryFull() ) then return; end
	table.insert( self.roleplay.inventory, class );
	
	net.Start( "rp_Inv" );
		net.WriteBit( true );
		net.WriteString( class );
	net.Send( self );
end

function meta:RemoveItemFromInventory( class )
	if ( !Roleplay.Items[ class ] ) then return; end
	for k, v in pairs( self.roleplay.inventory ) do
		if ( v == class ) then
			net.Start( "rp_Inv" );
				net.WriteBit( false );
				net.WriteString( class );
			net.Send( self );
			
			table.remove( self.roleplay.inventory, k );
			return;
		end
	end
end

function meta:InventoryUse( class )
	if ( !self:HasItem( class ) || !Roleplay.Items[ class ] ) then return; end
	
	local item = Roleplay.Items[ class ];
	if ( !item.CanUse( self ) ) then return; end
	
	item.OnUse( self );
	
	if ( item.KillOnUse ) then
		self:RemoveItemFromInventory( class );
	end
end

function meta:InventoryDrop( class )
	if ( !self:HasItem( class ) || !Roleplay.Items[ class ] ) then return; end
	
	local item = Roleplay.Items[ class ];
	local prop = ents.Create( "ent_item" );
	
	prop:SetPos( self:GetShootPos() + (pl:GetAimVector()*16) );
	prop:SetAngles( self:GetAngles() );
	prop:Spawn();
	prop:Activate();
	prop:SetModel( item.Model );
	
	//prop.roleplay = {};
	prop.roleplay.class = class;
	
	self:RemoveItemFromInventory( class );
end

function meta:InventoryPickup( class, ent )
	if ( self:InventoryFull() || !Roleplay.Items[ class ] ) then return; end
	
	self:AddItemToInventory( class );
	
	if ( IsValid( ent ) ) then
		ent:Remove();
	end
end

function meta:InventoryFull()
	if ( #self.roleplay.inventory >= Roleplay.Config.MaxItems ) then
		return true;
	end
	return false;
end

function meta:AddItemToBank( class )
	if ( !Roleplay.Items[ class ] || self:BankFull() ) then return; end
	
	table.insert( self.roleplay.bankinventory, class );
	net.Start( "rp_bItem" );
		net.WriteBit( true );
		net.WriteString( class );
	net.Send( self );
	
	//self:RemoveItemFromInventory( class );
end

function meta:RemoveItemFromBank( class )
	if ( !Roleplay.Items[ class ] || !self:HasItemInBank( class ) ) then return; end
	
	for k, v in pairs( self.roleplay.bankinventory ) do
		if ( v == class ) then
			net.Start( "rp_bItem" );
				net.WriteBit( false );
				net.WriteString( class );
			net.Send( self );
			
			table.remove( self.roleplay.bankinventory, k );
			return;
		end
	end
end

function meta:BankFull()
	if ( #self.roleplay.bankinventory >= Roleplay.Config.MaxBankItems ) then
		return true;
	end
	return false;
end

function meta:BankToInventory( class )
	if ( !Roleplay.Items[ class ] || !self:HasItemInBank( class ) || self:InventoryFull() ) then return; end
	
	self:AddItemToInventory( class );
	self:RemoveItemFromBank( class );
end

function meta:InventoryToBank( class )
	if ( !Roleplay.Items[ class ] || !self:HasItem( class ) || self:BankFull() ) then return; end
	
	self:AddItemToBank( class );
	self:RemoveItemFromInventory( class );
end

function meta:PropertiesOwned()
	local doors = {};
	for k, v in pairs( ents.GetAll() ) do
		if ( Roleplay.Property[ v:GetName() ].owner == self:SteamID() ) then
			table.insert( doors, v:GetName() );
		end
	end
	return doors;
end

function meta:SaveMySQL()
	Roleplay.db.Query( "INSERT INTO playerdata (User,JobID,Money,Bank,Inventory) VALUES(" .. self:SaveID() .. "," .. self:JobId() .. "," .. self:Money() .. "," .. self:BankMoney() .. ",NULL)" );
	Roleplay.db.Query( "UPDATE playerdata SET Money = " .. self:Money() .. " WHERE User = " .. self:SaveID() );
	Roleplay.db.Query( "UPDATE playerdata SET Bank = " .. self:BankMoney() .. " WHERE User = " .. self:SaveID() );	
	Roleplay.db.Query( "UPDATE playerdata SET JobID = " .. self:JobId() .. " WHERE User = " .. self:SaveID() );
	Roleplay.db.Query( "UPDATE playerdata SET Hunger = " .. self:Hunger() .. " WHERE User = " .. self:SaveID() );
	
	self:SaveInventory(); 
	self:SaveBankInventory();
	self:PrintMessage( 1, "roleplay data has been saved" );
end

function meta:SaveInventory()
	if ( #self.roleplay.inventory <= 0 ) then
		Roleplay.db.Query( "UPDATE playerdata SET Inventory = NULL WHERE User = " .. self:SaveID() );
		return;
	end
	
	local values = "UPDATE playerdata SET Inventory = '";
	for k, v in pairs( self.roleplay.inventory ) do
		values = values .. v .. ",";
	end
	values = string.sub( values, 1, -2 ) .. "' WHERE User = " .. self:SaveID();
	Roleplay.db.Query( values );
end

function meta:SaveBankInventory()
	if ( #self.roleplay.bankinventory <= 0 ) then
		Roleplay.db.Query( "UPDATE playerdata SET BankInventory = NULL WHERE User = " .. self:SaveID() );
		return;
	end
	
	local values = "UPDATE playerdata SET BankInventory = '";
	for k, v in pairs( self.roleplay.bankinventory ) do 
		values = values .. v .. ",";
	end
	values = string.sub( values, 1, -2 ) .. "' WHERE User = " .. self:SaveID();
	Roleplay.db.Query( values );
end

function meta:LoadMySQL()
	local pl = self;

	local function query( data )
		if ( !data[1] ) then return; end
		local bank = data[1].BankInventory or nil;
		local inv  = data[1].Inventory or nil;
		local job = data[1].JobID or "";
		local money = data[1].Money or 0;
		local hunger = data[1].Hunger or 100;
		local bank = data[1].Bank or 0;
		
		if ( bank ) then
			bank = string.Explode( ",", bank );
			for k, v in pairs( bank ) do
				pl:AddItemToBank( v );
			end
		end
		
		if ( inv ) then
			inv = string.Explode( ",", inv );
			for k, v in pairs( inv ) do
				pl:AddItemToBank( v );
			end
		end
		
		pl:SetJob( data[1].JobID );
		pl:SetMoney( data[1].Money );
		pl:SetBankMoney( data[1].Bank ); 
		pl:SetHunger( data[1].Hunger );
	end

	Roleplay.db.Query( "SELECT * FROM playerdata WHERE User = " .. self:SaveID(), query );
end

//Propertyyyyyyy
function meta:BuyProperty( name )
	name = name:GetMasterDoor();
	if ( !Roleplay.Property[ name ] || self:BankMoney() < Roleplay.Property[ name ].price || Roleplay.Property[ name ].price <= 0 || Roleplay.Property[ name ].owner ) then return; end
	
	if ( self:Flags() != "admin" ) then
		local price = Roleplay.Property[ name ].price;
		self:AddBankMoney( -price );
	end
	
	Roleplay.Property[ name ].owner = self:SteamID();
	
	net.Start( "rp_UpPr" );
		net.WriteString( name );
		net.WriteString( self:SteamID() );
		//net.WriteInt( 0, 16 );
	net.Broadcast();
	
	Roleplay.SavePropertyOwners();
end

function meta:Keys()
	local tr = util.QuickTrace( self:GetShootPos(), self:GetAimVector() * 64, self );
	if ( !IsValid( tr.Entity ) || !tr.Entity:IsValidDoor() ) then return; end
	
	local door = tr.Entity;
	door = door:GetMasterDoor();
	
	if ( Roleplay.Property[ door ].owner == self:SteamID() ) then
		if ( !tr.Entity.locked ) then
			tr.Entity.locked = true;
			tr.Entity:Fire( "lock", "", 0 );
		else
			tr.Entity.locked = false;
			tr.Entity:Fire( "unlock", "", 0 );
		end
	end
end

function meta:SaveID()
	local id = self:SteamID();
	id = string.gsub( id, "STEAM_", "" );
	id = string.gsub( id, ":", "" );
	
	return id;
end