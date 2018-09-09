package body Combustion_Pkg is
    function getFuel(this : Combustions) return Fuels_Acc is
    begin
        return this.fuel;
    end getFuel;

    procedure setFuel(this : in out Combustions; fuel : Fuels_Acc) is
    begin
        this.fuel := fuel;
    end setFuel;

    function getOxidizer(this : Combustions) return Oxidizers_Acc is
    begin
        return this.oxidizer;
    end getOxidizer;

    procedure setOxidizer(this : in out Combustions; oxidizer : Oxidizers_Acc) is
    begin
        this.oxidizer := oxidizer;
    end setOxidizer;

    function getBaseIsp(this : Combustions) return Time is
    begin
        return this.base_isp;
    end getBaseIsp;

    procedure setBaseIsp(this : in out Combustions; base_isp : Time) is
    begin
        this.base_isp := base_isp;
    end setBaseIsp;

    function getBaseTemp(this : Combustions) return Thermodynamic_Temperature is
    begin
        return this.base_temp;
    end getBaseTemp;

    procedure setBaseTemp(this : in out Combustions; base_temp : Thermodynamic_Temperature) is
    begin
        this.base_temp := base_temp;
    end setBaseTemp;

    function getBasePressure(this : Combustions) return Pressure is
    begin
        return this.base_pressure;
    end getBasePressure;

    procedure setBasePressure(this : in out Combustions; base_pressure : Pressure) is
    begin
        this.base_pressure := base_pressure;
    end setBasePressure;
end Combustion_Pkg;
