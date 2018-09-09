with System.Dim.Mks; use System.Dim.Mks;
with Constants_And_Units; use Constants_And_Units;
with Consumable_Pkg; use Consumable_Pkg;

package Fuel_Pkg is
    type Fuels is new Consumables;
    type Fuels_Acc is access all Fuels;
end Fuel_Pkg;
