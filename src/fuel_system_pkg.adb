package body Fuel_System_Pkg is
    function getFuelType(this : Fuel_Systems) return Fuel_Types is
    begin
        return this.fuel_type;
    end getFuelType;

    procedure setFuelType(this : in out Fuel_Systems; fuel_type : Fuel_Types) is
    begin
        this.fuel_type := fuel_type;
    end setFuelType;
end Fuel_System_Pkg;
