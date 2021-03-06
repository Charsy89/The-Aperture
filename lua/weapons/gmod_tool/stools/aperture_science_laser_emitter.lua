TOOL.Category = "Aperture Science"
TOOL.Name = "#tool.aperture_science_laser_emitter.name"

TOOL.ClientConVar[ "startenabled" ] = "0"
TOOL.ClientConVar[ "model" ] = "models/props/laser_emitter.mdl"

if ( CLIENT ) then

	//language.Add( "aperture_science_laser_emitter", "Laser Emiter" )
	language.Add( "tool.aperture_science_laser_emitter.name", "Laser Emiter" )
	language.Add( "tool.aperture_science_laser_emitter.desc", "Creates Laser Emiter" )
	language.Add( "tool.aperture_science_laser_emitter.tooldesc", "Makes Laser when enabled" )
	language.Add( "tool.aperture_science_laser_emitter.0", "Left click to use" )
	language.Add( "tool.aperture_science_laser_emitter.startenabled", "Start Enable" )
	
end

function TOOL:LeftClick( trace )

	-- Ignore if place target is Alive
	if ( trace.Entity && ( trace.Entity:IsPlayer() || trace.Entity:IsNPC() || APERTURESCIENCE:IsValidEntity( trace.Entity ) ) ) then return false end

	if ( CLIENT ) then return true end
	
	if ( !APERTURESCIENCE.ALLOWING.laser && !self:GetOwner():IsSuperAdmin() ) then self:GetOwner():PrintMessage( HUD_PRINTTALK, "This tool is disabled" ) return end

	local ply = self:GetOwner()
	local model = self:GetClientInfo( "model" )
	local startenabled = self:GetClientNumber( "startenabled" )
	
	MakeLaserEmitter( ply, model, trace.HitPos, trace.HitNormal:Angle(), startenabled, toggle, key_enable )
	
	return true
	
end

if ( SERVER ) then

	function MakeLaserEmitter( pl, model, pos, ang, startenabled )
			
		local laser_emitter = ents.Create( "ent_portal_laser" )
		laser_emitter:SetPos( pos )
		laser_emitter:SetModel( model )
		laser_emitter:SetAngles( ang )
		laser_emitter:Spawn()
		
		laser_emitter:SetStartEnabled( tobool( startenabled ) )
		laser_emitter:ToggleEnable( false )

		undo.Create( "Laser Emiter" )
			undo.AddEntity( laser_emitter )
			undo.SetPlayer( pl )
		undo.Finish()
		
		return true
		
	end
end

function TOOL:UpdateGhostLaserField( ent, ply )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()
	if ( !trace.Hit || trace.Entity && ( trace.Entity:GetClass() == "ent_LaserField" || trace.Entity:IsPlayer() ) ) then

		ent:SetNoDraw( true )
		return

	end
	
	local CurPos = ent:GetPos()
	local ang = trace.HitNormal:Angle()
	local pos = trace.HitPos

	ent:SetPos( pos )
	ent:SetAngles( ang )

	ent:SetNoDraw( false )

end

function TOOL:Think()

	local mdl = self:GetClientInfo( "model" )
	if ( !util.IsValidModel( mdl ) ) then self:ReleaseGhostEntity() return end

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != mdl ) then
		self:MakeGhostEntity( mdl, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	self:UpdateGhostLaserField( self.GhostEntity, self:GetOwner() )

end

function TOOL:RightClick( trace )


end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.aperture_science_laser_emitter.tooldesc" } )
	CPanel:AddControl( "PropSelect", { ConVar = "aperture_science_laser_emitter_model", Models = list.Get( "PortalLaserEmitterModels" ), Height = 1 } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.aperture_science_laser_emitter.startenabled", Command = "aperture_science_laser_emitter_startenabled" } )

end

function TOOL:DrawHUD()
	
end


list.Set( "PortalLaserEmitterModels", "models/props/laser_emitter.mdl", {} )
list.Set( "PortalLaserEmitterModels", "models/props/laser_emitter_center.mdl", {} )