
Roleplay.Config.EnableOOC		= true; //out of character on or off
Roleplay.Config.EnableHunger	= true; //hunger mod
Roleplay.Config.EnableSalary	= true; //salary mod
Roleplay.Config.EnableJailPay   = false; //Paid while in jail
Roleplay.Config.PayToBank		= true; //Direct-doposit on/off
Roleplay.Config.DevMode			= true; //Helps with development/editing

Roleplay.Config.PaydayTime		= 1; //Amount in minutes players will recieve their salaries
Roleplay.Config.HungerTime		= 1.4; //Amount in minutes players get %1 of hunger taken off
Roleplay.Config.SaveDirectory   = "hgrp/" //Where to save player data/server files

Roleplay.Config.MaxItems 		= 16; //How many items can the player carry
Roleplay.Config.MaxBankItems	= 64; //How many items are allowed in the bank
Roleplay.Config.DonatorItemAdd  = 10; //Donators and admins get 10 additional slots in both their banks and inventories

Roleplay.Config.MoneyPrinterMdl = "models/props_c17/consolebox01a.mdl"; //Model the money printer

Roleplay.Config.MySQLHost		= "localhost";
Roleplay.Config.MySQLUser		= "root";
Roleplay.Config.MySQLPass		= "annoyed";
Roleplay.Config.MySQLDatabase   = "hgrp";
Roleplay.Config.MySQLPort		= 3306;

//Shops
Roleplay.Config.AddShop( "blackmarket", Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) );
Roleplay.Config.AddShop( "teller", Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) );