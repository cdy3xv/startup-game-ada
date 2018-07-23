with Component_Pkg; use Component_Pkg;

package Fuel_System_Pkg is
    type Fuel_Systems is new Components with private;
    type Fuel_Systems_Acc is access Fuel_Systems;

    type Fuel_Types is (Metholox, Kerolox,                               -- Semi Cryogenic
                       Hydrolox, Hydrogen,                              -- Cryogenic
                       Aerozine_NTO, UDMH_NTO, MMH_NTO, enBB_HNO3,      -- Storable Hypergols
                       Hydrazine, H2O4, Nitrogen,                       -- Storable Monopropellants
                       HTPB_Lox, HTPB_NO,                               -- Hybrid Fuels
                       TNG, ANCP, APCP, ADNCP, APCP_RDX, HMXCP,         -- Solid Fuels
                       Hg, Xe, Bi, I,                                   -- Ion Fuels
                       Ar);                                             -- Plasma (VASIMR) Fuels

    subtype Liquid_Fuels is Fuel_Types range Metholox .. Nitrogen;
    subtype Storable_Fuels is Liquid_Fuels range Aerozine_NTO .. Nitrogen;
    subtype Cryogenic_Fuels is Liquid_Fuels range Hydrolox .. Hydrogen;
    subtype Semi_Cryogenic_Fuels is Liquid_Fuels range Metholox .. Kerolox;

    subtype Hybrid_Fuels is Fuel_Types range HTPB_Lox .. HTPB_NO;

    subtype Solid_Fuels is Fuel_Types range TNG .. HMXCP;

    subtype Ion_Fuels is Fuel_Types range Hg .. I;

    subtype Plasma_Fuels is Fuel_Types range Ar .. Ar;

    -- Fuel System Specific Methods
    function getFuelType(this : Fuel_Systems) return Fuel_Types;

    private
        type Fuel_Systems is new Components with
            record
                fuel_type : Fuel_Types;
            end record;
end Fuel_System_Pkg;
