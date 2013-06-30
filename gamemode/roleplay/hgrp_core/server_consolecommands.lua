
function HGRP.cc.Withdraw( pl, cmd, args )
	local amt = tonumber( args[1] );
	
	if ( amt > pl:BankMoney() || amt <= 0 ) then
		return; //Insufficent funds
	end
	
	pl:AddMoney( amt );
	pl:AddBankMoney( -amt );
end
HGRP.cc.concommand( "rp_withdraw", HGRP.cc.Withdraw, "Withdraw money from your bank account in to your wallet", "" );

function HGRP.cc.Deposit( pl, cmd, args )
	local amt = tonumber( args[1] );
	
	if ( amt > pl:Money() || amt <= 0 ) then
		return; //Insufficent funds
	end
	
	pl:AddBankMoney( amt );
	pl:AddMoney( -amt );
end
HGRP.cc.concommand( "rp_deposit", HGRP.cc.Deposit, "Deposit money to your bank account from your wallet", "" );

function HGRP.cc.WithdrawItem( pl, cmd, args )
	local class = tostring( args[1] );
	
	if ( !HGRP.Items[ class ] || !pl:HasItemInBank( class ) ) then
		pl:PrintMessage( 1, class .. " is not a valid item" );
		return;
	end
	
	pl:BankToInventory( class );
end
HGRP.cc.concommand( "rp_withdrawitem", HGRP.cc.WithdrawItem, "Withdraw an item from your bank to your inventory", "" );

function HGRP.cc.DepositItem( pl, cmd, args )
	local class = tostring( args[1] );
	
	if ( !HGRP.Items[ class ] || !pl:HasItem( class ) ) then
		pl:PrintMessage( 1, class .. " is not a valid item" );
		return;
	end
	
	pl:InventoryToBank( class );
end
HGRP.cc.concommand( "rp_deposititem", HGRP.cc.DepositItem, "Deposit an item from your inventory to your bank", "" );

function HGRP.cc.GiveMoney( pl, cmd, args )
	local tr = util.QuickTrace( pl:GetShootPos(), pl:GetAimVector() * 82, pl );
	if ( !IsValid( tr.Entity ) || !tr.Entity:IsPlayer() || !tr.Entity:Alive() ) then return; end
	
	local amt = tonumber( args[1] );
	
	if ( amt <= 0 ) then return; end
	
	pl:GiveMoney( tr.Entity, amt );
end
HGRP.cc.concommand( "rp_givemoney", HGRP.cc.GiveMoney, "Gives money to the currently player your looking at", "" );

function HGRP.cc.Keys( pl )
	pl:Keys();
end
HGRP.cc.concommand( "rp_keys", HGRP.cc.Keys, "This will lock or unlock a door you have access to", "" );

function HGRP.cc.BuyProperty( pl )
	local tr = util.QuickTrace( pl:GetShootPos(), pl:GetAimVector() * 86, pl );
	if ( IsValid( tr.Entity ) && tr.Entity:IsValidDoor() ) then
		pl:BuyProperty( tr.Entity );
	end
end
HGRP.cc.concommand( "rp_buyproperty", HGRP.cc.BuyProperty, "This will buyout the property you are currently looking at", "" );

function HGRP.cc.RepoProperty( pl )
	if ( !pl:IsAdmin() && !pl:Flags( "admin" ) ) then return; end
	
	local tr = util.QuickTrace( pl:GetShootPos(), pl:GetAimVector() * 86, pl );
	if ( IsValid( tr.Entity ) && tr.Entity:IsValidDoor() ) then
		HGRP.RepoProperty( tr.Entity );
	end
end
HGRP.cc.concommand( "rp_reposess", HGRP.cc.RepoProperty, "This will reposses the property", "admin" )

function HGRP.cc.SetJob( pl, cmd, args )
	if ( !pl:IsAdmin() && !pl:Flags( "admin" ) ) then return; end
	
	local id = tonumber( args[1] );
	
	if ( id > #HGRP.Jobs ) then
		id = #HGRP.Jobs;
	elseif ( id <= 0 ) then
		id = 1;
	end
	
	pl:SetJob( id );
end
HGRP.cc.concommand( "rp_setjob", HGRP.cc.SetJob, "Sets a job (THIS USES JOBID not NAME)", "admin" );
	
function HGRP.cc.Employ( pl, cmd, args )
	if ( IsValid( pl ) && !pl:IsAdmin() && !pl:Flags( "admin" ) ) then return; end
	
	local name = tostring( args[1] );
	local job = tonumber( args[2] );
	name = HGRP.FindPlayer( name );
	
	if ( !name || !HGRP.Jobs[ job ] ) then return; end
	
	name:EmploymentOffer( pl, job );
end
HGRP.cc.concommand( "rp_employ", HGRP.cc.Employ, "Offer a job to somebody (NAME, JOBID)", "admin" );

function HGRP.cc.Offer( pl, cmd, args )
	local choice = tonumber( args[1] );
	
	if ( !pl.hgrp.offered ) then return; end
	
	if ( choice == 1 ) then
		pl:SetJob( pl.hgrp.offered );
	end
	pl.hgrp.offered = 0;
end
HGRP.cc.concommand( "rp_offer", HGRP.cc.Offer, "0 = Declines employment offer, 1 = Accept", "" );

function HGRP.cc.Help( pl )
	pl:PrintMessage( 1, "* = Access command is only available for your job" );
	for k, v in pairs( HGRP.cc.list ) do
		if ( pl:Flags( v.flags ) || v.flags == "" ) then
			local txt = v.command .. " - " .. v.help;
			if ( pl:Flags( v.flags ) ) then
				txt = "*" .. txt;
			end
			pl:PrintMessage( 1, txt );
		end
	end
end
HGRP.cc.concommand( "rp_help", HGRP.cc.Help, "This will list all the commands available to you", "" );

function HGRP.cc.ListJobs( pl )
	pl:PrintMessage( 1, "JOBID - NAME - $SALARY" );
	for k, v in pairs( HGRP.Jobs ) do
		if ( k > 0 ) then
			pl:PrintMessage( 1, k .. " - " .. v.job .. " - $" .. v.salary .. "/hr" );
		end
	end
end
HGRP.cc.concommand( "rp_joblist", HGRP.cc.ListJobs, "This will list all the jobs available in the server", "" );