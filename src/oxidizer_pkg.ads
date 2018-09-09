with System.Dim.Mks; use System.Dim.Mks;
with Constants_And_Units; use Constants_And_Units;
with Consumable_Pkg; use Consumable_Pkg;

package Oxidizer_Pkg is
    type Oxidizers is new Consumables with private;
    type Oxidizers_Acc is access all Oxidizers;

    private
        type Oxidizers is new Consumables with null record;
end Fuel_Pkg;
