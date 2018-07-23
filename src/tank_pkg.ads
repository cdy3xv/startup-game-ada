with Fuel_System_Pkg; use Fuel_System_Pkg;

package Tank_Pkg is
    type Tanks is new Fuel_Systems with private;
    type Tanks_Acc is access Tanks;

    subtype Tank_Load is Float range 0.0 .. 1.0;

    function getFuelCapacity(this : Tanks) return Float;
    procedure setFuelCapacity(this : in out Tanks; capacity : Float);
    function getBoiloffRate(this : Tanks) return Float;
    procedure setBoiloffRate(this : in out Tanks; rate : Float);

    function getBoiloffTime(this : Tanks) return Float;
    function getFuelMass(this : Tanks; load : Tank_Load := 1.0) return Float;

    private
        type Tanks is new Fuel_Systems with
            record
                fuel_capacity : Float;      -- kg
                boiloff_rate : Float;       -- kg/s
            end record;
end Tank_Pkg;
