package body Liquid_Fuel_Pkg is
    function getMeltingPoint(this : Liquid_Fuels) return Thermodynamic_Temperature is
    begin
        return this.melting_point;
    end getMeltingPoint;

    procedure setMeltingPoint(this : in out Liquid_Fuels; melting_point : Thermodynamic_Temperature) is
    begin
        this.melting_point := melting_point;
    end setMeltingPoint;

    function getBoilingPoint(this : Liquid_Fuels) return Thermodynamic_Temperature is
    begin
        return this.boiling_point;
    end getBoilingPoint;

    procedure setBoilingPoint(this : in out Liquid_Fuels; boiling_point : Thermodynamic_Temperature) is
    begin
        this.boiling_point := boiling_point;
    end setBoilingPoint;
end Liquid_Fuel_Pkg;
