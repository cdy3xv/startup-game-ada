package body Fuel_System_Pkg is
    function getFuelType(this : Fuel_Systems) return Fuel_Types is
    begin
        return this.fuel_type;
    end getFuelType;
end Fuel_System_Pkg;
