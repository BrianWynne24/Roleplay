BS			 = {};

GM.Name		 = "HGRP";
GM.Author 	 = "Annoyed Tree";
GM.Website	 = "";
GM.Folder	 = "roleplay"; //Do not edit this...

if ( SERVER ) then
	AddCSLuaFile( GM.Folder .. "/setup.lua" );
end

include( GM.Folder .. "/setup.lua" );