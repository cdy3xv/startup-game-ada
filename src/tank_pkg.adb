with Component_Pkg; use Component_Pkg;

package body Tank_Pkg is
    function getFuelCapacity(this : Tanks) return Mass is
    begin
        return this.fuel_capacity;
    end getFuelCapacity;

    procedure setFuelCapacity(this : in out Tanks; capacity : Mass) is
    begin
        this.fuel_capacity := capacity;
    end setFuelCapacity;

    function getBoiloffRate(this : Tanks) return Mass_Flow is
    begin
        return this.boiloff_rate;
    end getBoiloffRate;

    procedure setBoiloffRate(this : in out Tanks; rate : Mass_Flow) is
    begin
        this.boiloff_rate := rate;
    end setBoiloffRate;


    function getBoiloffTime(this : Tanks) return Time is
    begin
        return this.fuel_capacity / this.boiloff_rate;
    end getBoiloffTime;

    function getFuelMass(this : Tanks; load : Tank_Load := 1.0) return Mass is
    begin
        return this.getFuelCapacity * load;
    end getFuelMass;

    procedure free(this : in out Tanks_Acc) is
        comp_acc : Components_Acc := this.all'Access;
    begin
        free(comp_acc);
    end free;
end Tank_Pkg;
