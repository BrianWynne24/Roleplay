HGRP.Bind = {};

function HGRP.Bind.EmploymentOffer( pl, bind )
	if ( bind == "slot1" ) then
		RunConsoleCommand( "rp_offer", "1" );
		hg_rp.offered = nil;
	elseif ( bind == "slot2" ) then
		RunConsoleCommand( "rp_offer", "0" );
		hg_rp.offered = nil;
	end
end

function GM:PlayerBindPress( pl, bind, pressed )
	if ( hg_rp.offered ) then
		HGRP.Bind.EmploymentOffer( pl, bind );
	end
	if ( bind == "+menu" ) then
		RunConsoleCommand( "rp_keys" );
		RunConsoleCommand( "-menu" );
	end
end