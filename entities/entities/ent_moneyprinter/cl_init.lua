include('shared.lua');

ENT.RenderGroup = RENDERGROUP_BOTH;

function ENT:Draw()
	self.Entity:DrawModel();
	
	local pos, ang = self:GetPos(), self:GetAngles();
	ang:RotateAroundAxis(ang:Up(), 90)
	
	pos = pos + (ang:Up() * 12)
	cam.Start3D2D(pos, ang, 1)
		if ( self:Active() ) then
			draw.DrawText( "$" .. self:Money(), "HudSelectionText", 0, -12, Color( 180, 180, 180, 255 ), TEXT_ALIGN_CENTER );
		else
			draw.DrawText( "Off", "HudSelectionText", 0, -8, Color( 180, 0, 0, 255 ), TEXT_ALIGN_CENTER );
		end
		draw.RoundedBox( 0, -12, 6, 25, 4, Color( 0, 0, 0, 180 ) );
		draw.RoundedBox( 0, -12, 6, (self:Temp()/100) * 25, 4, Color( 140, 0, 0, 180 ) );
	cam.End3D2D()	
end

function ENT:DrawTranslucent()
	self:Draw();
end