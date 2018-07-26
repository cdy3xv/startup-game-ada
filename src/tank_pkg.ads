with System.Dim.Mks; use System.Dim.Mks;

with Constants_And_Units; use Constants_And_Units;
with Fuel_System_Pkg; use Fuel_System_Pkg;

package Tank_Pkg is
    type Tanks is new Fuel_Systems with private;
    type Tanks_Acc is access Tanks;

    subtype Tank_Load is Mks_Type range 0.0 .. 1.0;

    function getFuelCapacity(this : Tanks) return Mass;
    procedure setFuelCapacity(this : in out Tanks; capacity : Mass);
    function getBoiloffRate(this : Tanks) return Mass_Flow;
    procedure setBoiloffRate(this : in out Tanks; rate : Mass_Flow);

    function getBoiloffTime(this : Tanks) return Time;
    function getFuelMass(this : Tanks; load : Tank_Load := 1.0) return Mass;

    private
        type Tanks is new Fuel_Systems with
            record
                fuel_capacity : Mass;      -- kg
                boiloff_rate : Mass_Flow;  -- kg/s
            end record;
end Tank_Pkg;
