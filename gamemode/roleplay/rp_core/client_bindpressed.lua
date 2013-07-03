Roleplay.Bind = {};

function Roleplay.Bind.EmploymentOffer( pl, bind )
	if ( bind == "slot1" ) then
		RunConsoleCommand( "rp_offer", "1" );
		roleplay.offered = nil;
	elseif ( bind == "slot2" ) then
		RunConsoleCommand( "rp_offer", "0" );
		roleplay.offered = nil;
	end
end

function GM:PlayerBindPress( pl, bind, pressed )
	if ( roleplay.offered ) then
		Roleplay.Bind.EmploymentOffer( pl, bind );
	end
	if ( bind == "+menu" ) then
		RunConsoleCommand( "rp_keys" );
		RunConsoleCommand( "-menu" );
	end
end