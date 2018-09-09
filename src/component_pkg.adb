with Unchecked_Deallocation;

with Text_IO; use Text_IO;

package body Component_Pkg is
    function getCost(this : Components) return Dollars is
    begin
        return this.cost;
    end getCost;

    procedure setCost(this : in out Components; cost : Dollars) is
    begin
        this.cost := cost;
    end setCost;

    function getDryMass(this : Components) return Mass is
    begin
        return this.dry_mass;
    end getDryMass;

    procedure setDryMass(this : in out Components; dry_mass : Mass) is
    begin
        this.dry_mass := dry_mass;
    end setDryMass;

    function getReliability(this : Components) return Rel_Ratio is
    begin
        return this.reliability;
    end getReliability;

    procedure setReliability(this : in out Components; reliability : Rel_Ratio) is
    begin
        this.reliability := reliability;
    end setReliability;

    procedure delete is new Unchecked_Deallocation(Object => Components'Class, Name => Components_Acc);

    procedure free(this : in out Components_Acc) is
    begin
        delete(this);
    end free;
end Component_Pkg;
