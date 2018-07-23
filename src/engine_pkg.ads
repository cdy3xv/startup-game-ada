with Fuel_System_Pkg; use Fuel_System_Pkg;

package Engine_Pkg is
    type Engines is new Fuel_Systems with private;
    type Engines_Acc is access Engines;

    subtype Engine_Throttle is Float range 0.0 .. 1.0;

    Minimum_Throttle_Exceeded : exception;

    -- Engine Specific Methods
    function getMaxThrustVac(this : Engines) return Float;
    procedure setMaxThrustVac(this : in out Engines; thrust : Float);
    function getMinThrustVac(this : Engines) return Float;
    procedure setMinThrustVac(this : in out Engines; thrust : Float);
    function getAslIsp(this : Engines) return Float;
    procedure setAslIsp(this : in out Engines; isp : Float);
    function getVacIsp(this : Engines) return Float;
    procedure setVacIsp(this : in out Engines; isp : Float);

    function getMaxThrustAsl(this : Engines) return Float;
    function getMinThrustAsl(this : Engines) return Float;
    function getMassFlowRate(this : Engines; throttle : Engine_Throttle) return Float;

    private
        type Engines is new Fuel_Systems with
            record
                max_thrust : Float; -- kN
                min_thrust : Float; -- kN
                asl_isp : Float;    -- sec
                vac_isp : Float;    -- sec
            end record;
end Engine_Pkg;
