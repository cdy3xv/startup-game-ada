with System.Dim.Mks; use System.Dim.Mks;
with Constants_And_Units; use Constants_And_Units;
with Fuel_Pkg; use Fuel_Pkg;
with Oxidizer_Pkg; use Oxidizer_Pkg;

package Combustion_Pkg is
    type Combustions is tagged private;
    type Combustions_Acc is access all Combustions'Class;

    function getFuel(this : Combustions) return Fuels_Acc;
    procedure setFuel(this : in out Combustions; fuel : Fuels_Acc);
    function getOxidizer(this : Combustions) return Oxidizers_Acc;
    procedure setOxidizer(this : in out Combustions; oxidizer : Oxidizers_Acc);
    function getBaseIsp(this : Combustions) return Time;
    procedure setBaseIsp(this : in out Combustions; isp : Time);
    function getBaseTemp(this : Combustions) return Thermodynamic_Temperature;
    procedure setBaseTemp(this : in out Combustions; base_temp : Thermodynamic_Temperature);
    function getBasePressure(this : Combustions) return Pressure;
    procedure setBasePressure(this : in out Combustions; base_pressure : Pressure);
    function getIspLeanFactor(this : Combustions) return Float;
    procedure setIspLeanFactor(this : in out Combustions; isp_lean_factor : Float);
    function getIspRichFactor(this : Combustions) return Float;
    procedure setIspRichFactor(this : in out Combustions; isp_rich_factor : Float);
    function getTempLeanFactor(this : Combustions) return Float;
    procedure setTempLeanFactor(this : in out Combustions; temp_lean_factor : Float);
    function getTempRichFactor(this : Combustions) return Float;
    procedure setTempRichFactor(this : in out Combustions; temp_rich_factor : Float);
    function getPressureLeanFactor(this : Combustions) return Float;
    procedure setPressureLeanFactor(this : in out Combustions; pressure_lean_factor : Float);
    function getPressureRichFactor(this : Combustions) return Float;
    procedure setPressureRichFactor(this : in out Combustions; pressure_rich_factor : Float);

    function getIsp(this : Combustions, of_ratio_factor : Float) return Time;
    function getTemp(this : Combustions, of_ratio_factor : Float) return Thermodynamic_Temperature;
    function getPressure(this : Combustions, of_ratio_factor : Float) return Pressure;

    private
        type Liquid_Fuels is new Fuels with
            record
                fuel : Fuels_Acc;
                oxidizer : Oxidizers_Acc;
                base_isp : Time;
                base_temp : Thermodynamic_Temperature;
                base_pressure : Pressure;
                isp_lean_factor : Float;                         -- % ISP Increase Per % Lean
                isp_rich_factor : Float;                         -- % ISP Increase Per % Rich
                temp_lean_factor : Float;                        -- % Temp Increase Per % Lean
                temp_rich_factor : Float;                        -- % Temp Increase Per % Rich
                pressure_lean_factor : Float;                    -- % Pressure Increase Per % Lean
                pressure_rich_factor : Float;                    -- % Pressure Increase Per % Rich
            end record;
end Combustion_Pkg;
