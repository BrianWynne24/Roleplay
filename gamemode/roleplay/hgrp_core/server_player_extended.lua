local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end

function meta:RunSpeed( speed )
	if ( speed == self.hgrp.runspeed ) then return; end
	self:SetRunSpeed( speed );
	self.hgrp.runspeed = speed;
end

function meta:WalkSpeed( speed )
	if ( speed == self.hgrp.walkspeed ) then return; end
	self:SetWalkSpeed( speed );
	self.hgrp.walkspeed = speed;
end

function meta:OnInitialSpawn()
	//First we make all the variables the player will have
	self.hgrp = {};
		self.hgrp.money = 0;
		self.hgrp.jobid = 1;
		self.hgrp.stamina = 100;
		self.hgrp.stamwait = CurTime();
		self.hgrp.runspeed = 320;
		self.hgrp.walkspeed = 180;
		self.hgrp.hunger = 100;
		self.hgrp.hungerwait = CurTime();
		self.hgrp.inventory = {};
		self.hgrp.bankinventory = {};
		self.hgrp.bankmoney = 0;
		self.hgrp.offered = 0;
		
	//self:SetJob( self.hgrp.jobid ); //This will return nil, no point trying to call it
	//self:SetMoney( self.hgrp.money );
	for k, v in pairs( HGRP.Property ) do
		if ( v.owner && v.owner != "" ) then
			local steamid = tostring(v.owner);
			net.Start( "rp_UpPr" );
				net.WriteString( k );
				net.WriteString( steamid );
			net.Send( self );
		end
	end

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
	if ( self.hgrp.money == amt ) then return; end
	
	self.hgrp.money = amt;
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
	if ( self.hgrp.bankmoney == amt ) then return; end
	
	self.hgrp.bankmoney = amt;
	net.Start( "rp_Money" );
		net.WriteBit( false );
		net.WriteInt( amt, 16 );
	net.Send( self );
end

function meta:AddBankMoney( amt )
	self:SetBankMoney( self:BankMoney() + amt );
end

function meta:SetStamina( amt )
	if ( self.hgrp.stamina == amt ) then return; end //Don't send net messages to to client for no reason
	
	self.hgrp.stamina = amt;
	net.Start( "rp_StHu" );
		net.WriteBit( true );
		net.WriteInt( amt, 8 );
	net.Send( self );
end

function meta:AddStamina( amt )
	self:SetStamina( self:Stamina() + amt );
end

function meta:SetHunger( amt )
	if ( self.hgrp.hunger == amt ) then return; end
	
	self.hgrp.hunger = amt;
	net.Start( "rp_StHu" );
		net.WriteBit( false );
		net.WriteInt( amt, 8 );
	net.Send( self );
end

function meta:AddHunger( amt )
	self:SetHunger( self:Hunger() + amt );
end

function meta:SetJob( id )
	if ( !HGRP.Jobs[ id ] || self.hgrp.jobid == id ) then return; end
	
	self.hgrp.jobid = id;
	net.Start( "rp_Job" );
		net.WriteInt( id, 8 );
	net.Send( self );
end

function meta:EmploymentOffer( offerer, jobid )
	if ( self:JobId() == jobid || self.hgrp.offered >= 1 ) then return; end
	
	local name = "CONSOLE";
	if ( IsValid( offerer ) && offerer:IsPlayer() ) then
		name = offerer:Name();
	end
	
	self.hgrp.offered = jobid;
	net.Start( "rp_Employ" );
		net.WriteString( name );
		net.WriteInt( jobid, 16 );
	net.Send( self );
end

function meta:Payday()
	if ( HGRP.Config.PayToBank ) then
		self:AddBankMoney( self:Salary() );
	else
		self:AddMoney( self:Salary() );
	end
	self:SaveData();
end

function meta:SprintThink()
	if ( CurTime() < self.hgrp.stamwait || !self:Alive() || (self:GetVelocity():Length() < 40 && self:KeyDown(IN_SPEED)) ) then return; end
	
	local stam = self:Stamina();
	if ( self:KeyDown( IN_SPEED ) ) then
		if ( stam > 0 ) then
			self:AddStamina( -1 );
			self:RunSpeed( 320 );
		elseif ( stam <= 0 ) then
			self:RunSpeed( 120 );
			self:WalkSpeed( 120 );
		end
		
		self.hgrp.stamwait = CurTime() + 0.18;
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
		self.hgrp.stamwait = CurTime() + 0.5;
	end
end

function meta:HungerThink()
	if ( CurTime() < self.hgrp.hungerwait || !self:Alive() || !HGRP.Config.EnableHunger ) then return; end
	
	self:AddHunger( -1 );
	if ( self:Hunger() < 1 ) then
		self:AddHealth( -5 );
	end
	self.hgrp.hungerwait = CurTime() + (HGRP.Config.HungerTime*60);
end

//Inventory shittttttttt
function meta:AddItemToInventory( class )
	if ( !HGRP.Items[ class ] || self:InventoryFull() ) then return; end
	table.insert( self.hgrp.inventory, class );
	
	net.Start( "rp_Inv" );
		net.WriteBit( true );
		net.WriteString( class );
	net.Send( self );
end

function meta:RemoveItemFromInventory( class )
	if ( !HGRP.Items[ class ] ) then return; end
	for k, v in pairs( self.hgrp.inventory ) do
		if ( v == class ) then
			net.Start( "rp_Inv" );
				net.WriteBit( false );
				net.WriteString( class );
			net.Send( self );
			
			table.remove( self.hgrp.inventory, k );
			return;
		end
	end
end

function meta:InventoryUse( class )
	if ( !self:HasItem( class ) || !HGRP.Items[ class ] ) then return; end
	
	local item = HGRP.Items[ class ];
	if ( !item.CanUse( self ) ) then return; end
	
	item.OnUse( self );
	
	if ( item.KillOnUse ) then
		self:RemoveItemFromInventory( class );
	end
end

function meta:InventoryDrop( class )
	if ( !self:HasItem( class ) || !HGRP.Items[ class ] ) then return; end
	
	local item = HGRP.Items[ class ];
	local prop = ents.Create( "ent_item" );
	
	prop:SetPos( self:GetShootPos() + (pl:GetAimVector()*16) );
	prop:SetAngles( self:GetAngles() );
	prop:Spawn();
	prop:Activate();
	prop:SetModel( item.Model );
	
	//prop.hgrp = {};
	prop.hgrp.class = class;
	
	self:RemoveItemFromInventory( class );
end

function meta:InventoryPickup( class, ent )
	if ( self:InventoryFull() || !HGRP.Items[ class ] ) then return; end
	
	self:AddItemToInventory( class );
	
	if ( IsValid( ent ) ) then
		ent:Remove();
	end
end

function meta:InventoryFull()
	if ( #self.hgrp.inventory >= HGRP.Config.MaxItems ) then
		return true;
	end
	return false;
end

function meta:AddItemToBank( class )
	if ( !HGRP.Items[ class ] || self:BankFull() ) then return; end
	
	table.insert( self.hgrp.bankinventory, class );
	net.Start( "rp_bItem" );
		net.WriteBit( true );
		net.WriteString( class );
	net.Send( self );
	
	//self:RemoveItemFromInventory( class );
end

function meta:RemoveItemFromBank( class )
	if ( !HGRP.Items[ class ] || !self:HasItemInBank( class ) ) then return; end
	
	for k, v in pairs( self.hgrp.bankinventory ) do
		if ( v == class ) then
			net.Start( "rp_bItem" );
				net.WriteBit( false );
				net.WriteString( class );
			net.Send( self );
			
			table.remove( self.hgrp.bankinventory, k );
			return;
		end
	end
end

function meta:BankFull()
	if ( #self.hgrp.bankinventory >= HGRP.Config.MaxBankItems ) then
		return true;
	end
	return false;
end

function meta:BankToInventory( class )
	if ( !HGRP.Items[ class ] || !self:HasItemInBank( class ) || self:InventoryFull() ) then return; end
	
	self:AddItemToInventory( class );
	self:RemoveItemFromBank( class );
end

function meta:InventoryToBank( class )
	if ( !HGRP.Items[ class ] || !self:HasItem( class ) || self:BankFull() ) then return; end
	
	self:AddItemToBank( class );
	self:RemoveItemFromInventory( class );
end

function meta:PropertiesOwned()
	local doors = {};
	for k, v in pairs( ents.GetAll() ) do
		if ( HGRP.Property[ v:GetName() ].owner == self:SteamID() ) then
			table.insert( doors, v:GetName() );
		end
	end
	return doors;
end

//Saving & Loading
function meta:SaveData()
	local dir = HGRP.Config.SaveDirectory;
	dir = dir .. "character_data/";
	
	local id = self:SteamID();
	id = string.gsub( id, ":", "_" );
	
	dir = dir .. id;
	dir = string.lower(dir) .. "/";
	
	if ( !file.IsDir( dir, "DATA" ) ) then
		file.CreateDir( dir );
	end
	
	file.Write( dir .. "inventory.txt", util.TableToJSON( self.hgrp.inventory ) );
	file.Write( dir .. "bankinventory.txt", util.TableToJSON( self.hgrp.bankinventory ) );
	
	local data = {};
		data.money = self:Money();
		data.bankmoney = self:BankMoney();
		data.jobid = self:JobId();
		data.hunger = self:Hunger();
		
	file.Write( dir .. "data.txt", util.TableToJSON( data ) );

	self:PrintMessage( 1, "roleplay data has been saved" );
end

function meta:LoadData()
	local dir = HGRP.Config.SaveDirectory;
	dir = dir .. "character_data/";
	
	local id = self:SteamID();
	id = string.gsub( id, ":", "_" );
	
	dir = dir .. id;
	dir = string.lower(dir);
	
	if ( !file.IsDir( dir, "DATA" ) ) then
		file.CreateDir( dir );
		return;
	end
	
	if ( file.Exists( dir .. "/inventory.txt", "DATA" ) ) then
		//self.hgrp.inventory = util.JSONToTable( file.Read(dir.."/inventory.txt","DATA") );
		local inventory = util.JSONToTable( file.Read(dir.."/inventory.txt","DATA") )
		for k, v in pairs( inventory ) do
			self:AddItemToInventory( v );
		end
	end
	if ( file.Exists( dir .. "/bankinventory.txt", "DATA" ) ) then
		//self.hgrp.bankinventory = util.JSONToTable( file.Read(dir.."/bankinventory.txt","DATA") );
		local inventory = util.JSONToTable( file.Read(dir.."/bankinventory.txt","DATA") )
		for k, v in pairs( inventory ) do
			self:AddItemToBank( v );
		end
	end
	if ( file.Exists( dir .. "/data.txt", "DATA" ) ) then
		local data = util.JSONToTable( file.Read(dir.."/data.txt","DATA") );
		self:SetJob( data.jobid );
		self:SetHunger( data.hunger );
		self:SetMoney( data.money );
		self:SetBankMoney( data.bankmoney );
	end
	self:PrintMessage( 1, "roleplay data has been loaded" );
end

//Propertyyyyyyy
function meta:BuyProperty( name )
	name = name:GetMasterDoor();
	if ( !HGRP.Property[ name ] || self:BankMoney() < HGRP.Property[ name ].price || HGRP.Property[ name ].price <= 0 || HGRP.Property[ name ].owner ) then return; end
	
	if ( self:Flags() != "admin" ) then
		local price = HGRP.Property[ name ].price;
		self:AddBankMoney( -price );
	end
	
	HGRP.Property[ name ].owner = self:SteamID();
	
	net.Start( "rp_UpPr" );
		net.WriteString( name );
		net.WriteString( self:SteamID() );
		//net.WriteInt( 0, 16 );
	net.Broadcast();
	
	HGRP.SavePropertyOwners();
end

function meta:Keys()
	local tr = util.QuickTrace( self:GetShootPos(), self:GetAimVector() * 64, self );
	if ( !IsValid( tr.Entity ) || !tr.Entity:IsValidDoor() ) then return; end
	
	local door = tr.Entity;
	door = door:GetMasterDoor();
	
	if ( HGRP.Property[ door ].owner == self:SteamID() ) then
		if ( !tr.Entity.locked ) then
			tr.Entity.locked = true;
			tr.Entity:Fire( "lock", "", 0 );
		else
			tr.Entity.locked = false;
			tr.Entity:Fire( "unlock", "", 0 );
		end
	end
end