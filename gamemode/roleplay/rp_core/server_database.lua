require( "mysqloo" );

local DATABASE_HOST = Roleplay.Config.MySQLHost;
local DATABASE_USER = Roleplay.Config.MySQLUser;
local DATABASE_PASS = Roleplay.Config.MySQLPass;
local DATABASE_DB	= Roleplay.Config.MySQLDatabase;
local DATABASE_PORT = Roleplay.Config.MySQLPort;

function Roleplay.db.Connect()
	Roleplay.db.object = mysqloo.connect(DATABASE_HOST, DATABASE_USER, DATABASE_PASS, DATABASE_DB, DATABASE_PORT );
	function Roleplay.db.object:onConnected( db )
		print( "Connection to MySQL Successful" );
		Roleplay.db.Init();
	end
	function Roleplay.db.object:onConnectionFailed( db, err )
		print( "Connection to MySQL Failed" );
		print( err );
		self:connect();
	end
	Roleplay.db.object:connect();
end

function Roleplay.db.Query( query, callback )
	table.insert( Roleplay.db.queries, { query = query, sent = false, callback = callback } );
end

function Roleplay.db.Init()
	Roleplay.db.Query( "CREATE TABLE IF NOT EXISTS playerdata (User VARCHAR(30) PRIMARY KEY, JobID INT, Money INT, Bank INT, Inventory TEXT, BankInventory MEDIUMTEXT, Hunger INT)" );
	Roleplay.db.Query( "CREATE TABLE IF NOT EXISTS property (Name VARCHAR(25), Door VARCHAR(25) PRIMARY KEY, Price INT, Flags VARCHAR(25), Master VARCHAR(25), Owner VARCHAR(25))" );
	Roleplay.db.Query( "CREATE TABLE IF NOT EXISTS jobs (JobID INT PRIMARY KEY, Job VARCHAR(25), Salary INT, Flags VARCHAR(20))" );
	//print( "Warning: MySQL Save not found. Ths may cause some problems" ); 
end

Roleplay.db.Connect();

function Roleplay.db.Think()
	if ( #Roleplay.db.queries <= 0 ) then return; end
	
	local query = Roleplay.db.queries[ 1 ];
	if ( !query.sent ) then
		query.sent = true;
		
		local q = Roleplay.db.object:query( query.query );
		function q:onSuccess( data )
			if ( query.callback ) then
				query.callback(data);
			end
			table.remove( Roleplay.db.queries, 1 );
		end
		function q:onError( err )
			print( err );
			table.remove( Roleplay.db.queries, 1 );
		end
		q:start();
	end
end

function Roleplay.db.LoadJobs()
	local function jobs(data)
		for k, v in pairs( data ) do
			table.insert( Roleplay.Jobs, v );
		end
	end
	Roleplay.db.Query( "SELECT * FROM jobs", jobs );
end

function Roleplay.db.LoadProperty()
	local function property(data)
		for k, v in pairs( data ) do
			Roleplay.Property[ v.Door ] = v;
		end
	end
	Roleplay.db.Query( "SELECT * FROM property", property );
end

Roleplay.db.LoadJobs();
Roleplay.db.LoadProperty();