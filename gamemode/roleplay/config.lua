
HGRP.Config.EnableOOC		= true; //out of character on or off
HGRP.Config.EnableHunger	= true; //hunger mod
HGRP.Config.EnableSalary	= true; //salary mod
HGRP.Config.EnableJailPay   = false; //Paid while in jail
HGRP.Config.PayToBank		= true; //Direct-doposit on/off
HGRP.Config.DevMode			= true; //Helps with development/editing

HGRP.Config.PaydayTime		= 1; //Amount in minutes players will recieve their salaries
HGRP.Config.HungerTime		= 1.4; //Amount in minutes players get %1 of hunger taken off
HGRP.Config.Currencey		= "$"; //Currencey of the server
HGRP.Config.SaveDirectory   = "hgrp/" //Where to save player data/server files

HGRP.Config.MaxItems 		= 16; //How many items can the player carry
HGRP.Config.MaxBankItems	= 64; //How many items are allowed in the bank
HGRP.Config.DonatorItemAdd  = 10; //Donators and admins get 10 additional slots in both their banks and inventories

//Jobs
HGRP.Config.AddJob( "Unemployed", 5, {} ); //The first job is the starting job
HGRP.Config.AddJob( "Admin", 50, { "admin", "police" } ); //Test job
HGRP.Config.AddJob( "Police", 30, { "police" } );

//Properties
HGRP.Config.AddProperty( "Police Station", "police_master", -1, { "police_child01", "police_child02" } );
HGRP.Config.AddProperty( "Closet", "closet_01", 100, {} );

//Shops
HGRP.Config.AddShop( "blackmarket", Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) );
HGRP.Config.AddShop( "teller", Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) );