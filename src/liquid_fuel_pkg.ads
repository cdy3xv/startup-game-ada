with System.Dim.Mks; use System.Dim.Mks;
with Constants_And_Units; use Constants_And_Units;
with Fuel_Pkg; use Fuel_Pkg;

package Liquid_Fuel_Pkg is
    type Liquid_Fuels is new Fuels with private;
    type Liquid_Fuels_Acc is access all Liquid_Fuels;

    function getMeltingPoint(this : Liquid_Fuels) return Thermodynamic_Temperature;
    procedure setMeltingPoint(this : in out Liquid_Fuels; melting_point : Thermodynamic_Temperature);
    function getBoilingPoint(this : Liquid_Fuels) return Thermodynamic_Temperature;
    procedure setBoilingPoint(this : in out Liquid_Fuels; boiling_point : Thermodynamic_Temperature);

    private
        type Liquid_Fuels is new Fuels with
            record
                boiling_point : Thermodynamic_Temperature;
                melting_point : Thermodynamic_Temperature;
            end record;
end Liquid_Fuel_Pkg;
