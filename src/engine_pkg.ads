with System.Dim.Mks; use System.Dim.Mks;

with Constants_And_Units; use Constants_And_Units;
with Fuel_System_Pkg; use Fuel_System_Pkg;

package Engine_Pkg is
    type Engines is new Fuel_Systems with private;
    type Engines_Acc is access all Engines;

    subtype Engine_Throttle is Mks_Type range 0.0 .. 1.0;

    Minimum_Throttle_Exceeded : exception;

    -- Engine Specific Methods
    function getMaxThrustVac(this : Engines) return Force;
    procedure setMaxThrustVac(this : in out Engines; thrust : Force);
    function getMinThrustVac(this : Engines) return Force;
    procedure setMinThrustVac(this : in out Engines; thrust : Force);
    function getAslIsp(this : Engines) return Time;
    procedure setAslIsp(this : in out Engines; isp : Time);
    function getVacIsp(this : Engines) return Time;
    procedure setVacIsp(this : in out Engines; isp : Time);

    function getThrustVac(this : Engines; throttle : Engine_Throttle := 1.0) return Force;
    function getMaxThrustAsl(this : Engines) return Force;
    function getMinThrustAsl(this : Engines) return Force;
    function getThrustAsl(this : Engines; throttle : Engine_Throttle := 1.0) return Force;
    function getMassFlowRate(this : Engines; throttle : Engine_Throttle) return Mass_Flow;

    private
        type Engines is new Fuel_Systems with
            record
                max_thrust : Force; -- kN
                min_thrust : Force; -- kN
                asl_isp : Time;     -- sec
                vac_isp : Time;     -- sec
            end record;
end Engine_Pkg;
