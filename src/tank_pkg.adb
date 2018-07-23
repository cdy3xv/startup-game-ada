package body Tank_Pkg is
    function getFuelCapacity(this : Tanks) return Float is
    begin
        return this.fuel_capacity;
    end getFuelCapacity;

    procedure setFuelCapacity(this : in out Tanks; capacity : Float) is
    begin
        this.fuel_capacity := capacity;
    end setFuelCapacity;

    function getBoiloffRate(this : Tanks) return Float is
    begin
        return this.boiloff_rate;
    end getBoiloffRate;

    procedure setBoiloffRate(this : in out Tanks; rate : Float) is
    begin
        this.boiloff_rate := rate;
    end setBoiloffRate;


    function getBoiloffTime(this : Tanks) return Float is
    begin
        return this.fuel_capacity * this.boiloff_rate;
    end getBoiloffTime;

    function getFuelMass(this : Tanks; load : Tank_Load := 1.0) return Float is
    begin
        return this.getFuelCapacity * load;
    end getFuelMass;
end Tank_Pkg;
