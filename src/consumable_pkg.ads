with System.Dim.Mks; use System.Dim.Mks;
with Constants_And_Units; use Constants_And_Units;

package Consumable_Pkg is
    type Consumables is tagged private;
    type Consumables_Acc is access all Consumables'Class;

    function getCost(this : Consumables) return Dollars;
    procedure setCost(this : in out Consumables; cost : Dollars);
    procedure setBase_Density(this : in out Consumables; base_density : Density);

    -- Virtual Methods
    function getDensity(this : Consumables) return Density;

    private
        type Consumables is tagged
            record
                cost : Dollars;         -- $/kg
                base_density : Density; -- kg/m^3
            end record;
end Consumable_Pkg;
