CREATE ROLE 
	Dev, 
    manager, 
    accountant,
    register,
    reception;

GRANT ALL 
ON databaselabprj.*
TO Dev;

GRANT SELECT, UPDATE, DELETE, INSERT
ON databaselabprj.*
TO manager;

GRANT SELECT 
ON databaselabprj.*
TO accountant ;

GRANT SELECT, INSERT, UPDATE 
ON databaselabprj.*
TO register;

GRANT SELECT 
ON databaselabprj.dorm
TO reception;

GRANT SELECT 
ON databaselabprj.room
TO reception;

GRANT SELECT 
ON databaselabprj.Renting
TO reception;

Grant SELECt 
ON databaselabprj.Student
TO reception;

