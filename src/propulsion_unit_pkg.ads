with System.Dim.Mks; use System.Dim.Mks;
with Ada.Containers.Vectors; use Ada.Containers;

with Constants_And_Units; use Constants_And_Units;
with Component_Pkg; use Component_Pkg;
with Fuel_System_Pkg; use Fuel_System_Pkg;
with Tank_Pkg; use Tank_Pkg;
with Engine_Pkg; use Engine_Pkg;

package Propulsion_Unit_Pkg is
    type Propulsion_Units is new Components with private;
    type Propulsion_Units_Acc is access Propulsion_Units;

    Incomplete_Propulsion_Unit : exception;

    -- Validity Checks
    procedure checkFuelCompatibility(this : Propulsion_Units; fuel_type : Fuel_Types);
    procedure checkCompletion(this : Propulsion_Units);

    -- Tank Getter And Setters
    procedure addTank(this : in out Propulsion_Units; to_add : Tanks_Acc);
    function getNumTanks(this : Propulsion_Units) return Natural;
    function getTank(this : Propulsion_Units; index : Natural) return Tanks;
    procedure removeTank(this : in out Propulsion_Units; index : Natural);

    -- Engine Getter And Setters
    procedure addEngine(this : in out Propulsion_Units; to_add : Engines);
    function getNumEngines(this : Propulsion_Units) return Natural;
    function getEngine(this : Propulsion_Units; index : Natural) return Engines;
    procedure removeEngine(this : in out Propulsion_Units; index : Natural);

    -- Component Abstract Methods
    overriding
    function getCost(this : Propulsion_Units) return Dollars;
    overriding
    function getDryMass(this : Propulsion_Units) return Mass;
    overriding
    function getReliability(this : Propulsion_Units) return Rel_Ratio;

    -- Propulsion_Unit Specific Methods
    function getAslIsp(this : Propulsion_Units; throttle : Engine_Throttle := 1.0) return Time;     -- sec
    function getVacIsp(this : Propulsion_Units; throttle : Engine_Throttle := 1.0) return Time;     -- sec
    function getFuelMass(this : Propulsion_Units; fuel_load : Tank_Load := 1.0) return Mass;        -- kg
    function getWetMass(this : Propulsion_Units; fuel_load : Tank_Load := 1.0) return Mass;         -- kg
    function getMaxThrustAsl(this : Propulsion_Units) return Force;                                 -- kN
    function getMinThrustAsl(this : Propulsion_Units) return Force;                                 -- kN
    function getMaxThrustVac(this : Propulsion_Units) return Force;                                 -- kN
    function getMinThrustVac(this : Propulsion_Units) return Force;                                 -- kN
    function getFuelType(this : Propulsion_Units) return Fuel_Types;
    function getAslDeltaV(this : Propulsion_Units;
                            added_mass : Mass := 0.0 * kg;
                            fuel_load : Tank_Load := 1.0;
                            throttle : Engine_Throttle := 1.0) return Velocity;  -- m/s
    function getVacDeltaV(this : Propulsion_Units; added_mass : Mass := 0.0 * kg;
                            fuel_load : Tank_Load := 1.0;
                            throttle : Engine_Throttle := 1.0) return Velocity;  -- m/s
    function getMassFlowRate(this : Propulsion_Units; throttle : Engine_Throttle) return Mass_Flow; -- kg/s
    function getBurnTime(this : Propulsion_Units; throttle : Engine_Throttle) return Time;          -- sec

    private
        package Tank_Vectors is new Vectors(Natural, Tanks_Acc);
        package Engine_Vectors is new Vectors(Natural, Engines);
        type Propulsion_Units is new Components with
            record
                tankage : Tank_Vectors.Vector;
                engine_cluster : Engine_Vectors.Vector;
            end record;
end Propulsion_Unit_Pkg;
