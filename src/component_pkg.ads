with System.Dim.Mks; use System.Dim.Mks;
with Constants_And_Units; use Constants_And_Units;

package Component_Pkg is
    type Components is tagged private;
    type Components_Acc is access all Components;

    subtype Rel_Ratio is Float range 0.0 .. 1.0;

    -- Component Methods
    function getCost(this : Components) return Dollars;
    procedure setCost(this : in out Components; cost : Dollars);
    function getDryMass(this : Components) return Mass;
    procedure setDryMass(this : in out Components; dry_mass : Mass);
    function getReliability(this : Components) return Rel_Ratio;
    procedure setReliability(this : in out Components; reliability : Rel_Ratio);

    private
        type Components is tagged
            record
                cost : Dollars;             -- $
                dry_mass : Mass;            -- kg
                reliability : Rel_Ratio;    -- Ratio (0 - 1)
            end record;
end Component_Pkg;
