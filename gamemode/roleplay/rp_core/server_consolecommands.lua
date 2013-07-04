
function Roleplay.cc.Withdraw( pl, cmd, args )
	local amt = tonumber( args[1] );
	
	if ( amt > pl:BankMoney() || amt <= 0 ) then
		return; //Insufficent funds
	end
	
	pl:AddMoney( amt );
	pl:AddBankMoney( -amt );
end
Roleplay.cc.concommand( "rp_withdraw", Roleplay.cc.Withdraw, "Withdraw money from your bank account in to your wallet", "" );

function Roleplay.cc.Deposit( pl, cmd, args )
	local amt = tonumber( args[1] );
	
	if ( amt > pl:Money() || amt <= 0 ) then
		return; //Insufficent funds
	end
	
	pl:AddBankMoney( amt );
	pl:AddMoney( -amt );
end
Roleplay.cc.concommand( "rp_deposit", Roleplay.cc.Deposit, "Deposit money to your bank account from your wallet", "" );

function Roleplay.cc.WithdrawItem( pl, cmd, args )
	local class = tostring( args[1] );
	
	if ( !Roleplay.Items[ class ] || !pl:HasItemInBank( class ) ) then
		pl:PrintMessage( 1, class .. " is not a valid item" );
		return;
	end
	
	pl:BankToInventory( class );
end
Roleplay.cc.concommand( "rp_withdrawitem", Roleplay.cc.WithdrawItem, "Withdraw an item from your bank to your inventory", "" );

function Roleplay.cc.DepositItem( pl, cmd, args )
	local class = tostring( args[1] );
	
	if ( !Roleplay.Items[ class ] || !pl:HasItem( class ) ) then
		pl:PrintMessage( 1, class .. " is not a valid item" );
		return;
	end
	
	pl:InventoryToBank( class );
end
Roleplay.cc.concommand( "rp_deposititem", Roleplay.cc.DepositItem, "Deposit an item from your inventory to your bank", "" );

function Roleplay.cc.GiveMoney( pl, cmd, args )
	local tr = util.QuickTrace( pl:GetShootPos(), pl:GetAimVector() * 82, pl );
	if ( !IsValid( tr.Entity ) || !tr.Entity:IsPlayer() || !tr.Entity:Alive() ) then return; end
	
	local amt = tonumber( args[1] );
	
	if ( amt <= 0 ) then return; end
	
	pl:GiveMoney( tr.Entity, amt );
end
Roleplay.cc.concommand( "rp_givemoney", Roleplay.cc.GiveMoney, "Gives money to the currently player your looking at", "" );

function Roleplay.cc.Keys( pl )
	pl:Keys();
end
Roleplay.cc.concommand( "rp_keys", Roleplay.cc.Keys, "This will lock or unlock a door you have access to", "" );

function Roleplay.cc.BuyProperty( pl )
	local tr = util.QuickTrace( pl:GetShootPos(), pl:GetAimVector() * 86, pl );
	if ( IsValid( tr.Entity ) && tr.Entity:IsValidDoor() ) then
		pl:BuyProperty( tr.Entity );
	end
end
Roleplay.cc.concommand( "rp_buyproperty", Roleplay.cc.BuyProperty, "This will buyout the property you are currently looking at", "" );

function Roleplay.cc.RepoProperty( pl )
	if ( !pl:IsAdmin() && !pl:Flags( "admin" ) ) then return; end
	
	local tr = util.QuickTrace( pl:GetShootPos(), pl:GetAimVector() * 86, pl );
	if ( IsValid( tr.Entity ) && tr.Entity:IsValidDoor() ) then
		Roleplay.RepoProperty( tr.Entity );
	end
end
Roleplay.cc.concommand( "rp_reposess", Roleplay.cc.RepoProperty, "This will reposses the property", "admin" )

function Roleplay.cc.SetJob( pl, cmd, args )
	if ( !pl:IsAdmin() && !pl:Flags( "admin" ) ) then return; end
	
	local id = tonumber( args[1] );
	
	if ( id > #Roleplay.Jobs ) then
		id = #Roleplay.Jobs;
	elseif ( id <= 0 ) then
		id = 1;
	end
	
	pl:SetJob( id );
end
Roleplay.cc.concommand( "rp_setjob", Roleplay.cc.SetJob, "Sets a job (THIS USES JOBID not NAME)", "admin" );
	
function Roleplay.cc.Employ( pl, cmd, args )
	if ( IsValid( pl ) && !pl:IsAdmin() && !pl:Flags( "admin" ) ) then return; end
	
	local name = tostring( args[1] );
	local job = tonumber( args[2] );
	name = Roleplay.FindPlayer( name );
	
	if ( !name || !Roleplay.Jobs[ job ] ) then return; end
	
	name:EmploymentOffer( pl, job );
end
Roleplay.cc.concommand( "rp_employ", Roleplay.cc.Employ, "Offer a job to somebody (NAME, JOBID)", "admin" );

function Roleplay.cc.Offer( pl, cmd, args )
	local choice = tonumber( args[1] );
	
	if ( !pl.roleplay.offered ) then return; end
	
	if ( choice == 1 ) then
		pl:SetJob( pl.roleplay.offered );
	end
	pl.roleplay.offered = 0;
end
Roleplay.cc.concommand( "rp_offer", Roleplay.cc.Offer, "0 = Declines employment offer, 1 = Accept", "" );

function Roleplay.cc.Help( pl )
	pl:PrintMessage( 1, "* = Access command is only available for your job" );
	for k, v in pairs( Roleplay.cc.list ) do
		if ( pl:Flags( v.flags ) || v.flags == "" ) then
			local txt = v.command .. " - " .. v.help;
			if ( pl:Flags( v.flags ) ) then
				txt = "*" .. txt;
			end
			pl:PrintMessage( 1, txt );
		end
	end
end
Roleplay.cc.concommand( "rp_help", Roleplay.cc.Help, "This will list all the commands available to you", "" );

function Roleplay.cc.ListJobs( pl )
	pl:PrintMessage( 1, "JOBID - NAME - $SALARY" );
	for k, v in pairs( Roleplay.Jobs ) do
		if ( k > 0 ) then
			pl:PrintMessage( 1, k .. " - " .. v.job .. " - $" .. v.salary .. "/hr" );
		end
	end
end
Roleplay.cc.concommand( "rp_joblist", Roleplay.cc.ListJobs, "This will list all the jobs available in the server", "" );