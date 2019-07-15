# delimits comments

# Creation information: made it myself! Look at me now, ma!
#     user    : sponheimcs


# define the group
        Group = NMT

# define various States
        StateDef = wm
	StateDef = gm
	StateDef = mid
	StateDef = inflated_wm_lh
	StateDef = inflated_wm_rh
	StateDef = inflated_mid_lh
	StateDef = inflated_mid_rh
	StateDef = inflated_gm_lh
	StateDef = inflated_gm_rh

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = lh.WM.gii
        LocalDomainParent = lh.WM.gii
        SurfaceState = wm
        EmbedDimension = 3
        Anatomical = Y        

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = lh.WM.inflated.surf.gii
        LocalDomainParent = lh.WM.gii
        SurfaceState = inflated_wm_lh
        EmbedDimension = 3
        Anatomical = N        

                
NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.WM.gii
        LocalDomainParent = rh.WM.gii
        SurfaceState = wm
        EmbedDimension = 3
        Anatomical = Y
      
NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.WM.inflated.surf.gii
        LocalDomainParent = rh.WM.gii
        SurfaceState = inflated_wm_rh
        EmbedDimension = 3
        Anatomical = N
NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.mid.gii
        LocalDomainParent = rh.mid.gii
        SurfaceState = mid
        EmbedDimension = 3
        Anatomical = Y

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.mid.inflated.surf.gii
        LocalDomainParent = rh.mid.gii
        SurfaceState = inflated_mid_rh
        EmbedDimension = 3
        Anatomical = N

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = lh.mid.gii
        LocalDomainParent = lh.mid.gii
        SurfaceState = mid
        EmbedDimension = 3
        Anatomical = Y

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = lh.mid.inflated.surf.gii
        LocalDomainParent = lh.mid.gii
        SurfaceState = inflated_mid_lh
        EmbedDimension = 3
        Anatomical = N

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = lh.GM.gii
        LocalDomainParent = lh.GM.gii
        SurfaceState = gm
        EmbedDimension = 3
        Anatomical = Y        

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = lh.GM.inflated.surf.gii
        LocalDomainParent = lh.GM.gii
        SurfaceState = inflated_gm_lh
        EmbedDimension = 3
        Anatomical = N        

                
NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.GM.gii
        LocalDomainParent = rh.GM.gii
        SurfaceState = gm
        EmbedDimension = 3
        Anatomical = Y
      
NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.GM.inflated.surf.gii
        LocalDomainParent = rh.GM.gii
        SurfaceState = inflated_gm_rh
        EmbedDimension = 3
        Anatomical = N