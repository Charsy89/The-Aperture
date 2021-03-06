AddCSLuaFile( )

ENT.Base 			= "gasl_turret_base"

ENT.PrintName		= "Default Turret"
ENT.Category		= "Aperture Science"
ENT.Spawnable		= true
ENT.RenderGroup 	= RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true

function ENT:SpawnFunction( ply, trace, ClassName )

	if ( !APERTURESCIENCE.ALLOWING.turret && !ply:IsSuperAdmin() ) then ply:PrintMessage( HUD_PRINTTALK, "This entity is blocked" ) return end

	if ( !trace.Hit ) then return end
	
	-- spawn counter
	if ( !ply.GASL_Player_TotalSpawnTurrets ) then ply.GASL_Player_TotalSpawnTurrets = 0 end
	ply.GASL_Player_TotalSpawnTurrets = ply.GASL_Player_TotalSpawnTurrets + 1

	local owner = NULL
	if ( ply.GASL_Player_TotalSpawnTurrets >= 10 ) then
		ply.GASL_Player_TotalSpawnTurrets = 0
		ClassName = "ent_portal_turret_different"
		owner = ply
	end

	local ent = ents.Create( ClassName )
	ent:SetPos( trace.HitPos )
	ent:SetAngles( Angle( 0, ply:EyeAngles().y, 0 ) )
	ent:Spawn()
	ent:GetPhysicsObject():Wake()
	if ( IsValid( owner ) ) then ent:SetOwner( owner ) end
	ent:Activate()
	ent.Owner = ply
	
	undo.Create( ent.PrintName )
		undo.AddEntity( ent )
		undo.SetPlayer( ply )
	undo.Finish()
	
end

function ENT:Draw()

	self.BaseClass.Draw( self )
	
end

if ( CLIENT ) then

	function ENT:Initialize()

		self.BaseClass.Initialize( self )
		
		self.GASL_Turret_Sounds = { 
			deploy = "GASL.TurretActivateVO",
			retract = "GASL.TurretAutoSearth",
			pickup = "GASL.TurretPickup",
			searth = "GASL.TurretSearth",
		}
				
		self.GASL_Turret_Bones = {
			antenna = 12,
			gunLeft = 3,
			gunRight = 6,
		}

	end
	-- no more client side
	return
	
end

function ENT:Initialize()

	self:SetModel( "models/npcs/turret/turret.mdl" )
	self.BaseClass.Initialize( self )
	self:SetCanShoot( true )

end

function ENT:Think()

	self.BaseClass.Think( self )
	
	if ( self:ExplodeWhenOnFire( 2 ) ) then
		self:SetTotalDisable( true )
	end
	
end