package body Consumable_Pkg is
    function getCost(this : Consumables) return Dollars is
    begin
        return this.cost;
    end getCost;

    procedure setCost(this : in out Consumables; cost : Dollars) is
    begin
        this.cost := cost;
    end setCost;

    function getDensity(this : Consumables) return Density is
    begin
        return this.base_density;
    end getDensity;

    procedure setBase_Density(this : in out Consumables; base_density : Density) is
    begin
        this.base_density := base_density;
    end setBase_Density;
end Consumable_Pkg;
