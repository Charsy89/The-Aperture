AddCSLuaFile( )
DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Dropper Gel Repulsion"
ENT.Category		= "Aperture Science"
ENT.Editable		= true
ENT.Spawnable		= true
ENT.RenderGroup 	= RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true

function ENT:SpawnFunction( ply, trace )

	if ( !trace.Hit ) then return end
	
	local ent = ents.Create( "ent_paint_dropper" )
	ent:SetPos( trace.HitPos )
	ent:SetModel( "models/props/switch001.mdl" )
	ent:SetAngles( trace.HitNormal:Angle() - Angle( 90, 0, 0 ) )
	ent:Spawn()
	ent:Activate()
	ent:SetGelType( 4 )

	return ent

end