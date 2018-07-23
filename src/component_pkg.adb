package body Component_Pkg is
    function getCost(this : Components) return Float is
    begin
        return this.cost;
    end getCost;

    procedure setCost(this : in out Components; cost : Float) is
    begin
        this.cost := cost;
    end setCost;

    function getDryMass(this : Components) return Float is
    begin
        return this.mass;
    end getDryMass;

    procedure setDryMass(this : in out Components; mass : Float) is
    begin
        this.mass := mass;
    end setDryMass;

    function getReliability(this : Components) return Rel_Ratio is
    begin
        return this.reliability;
    end getReliability;

    procedure setReliability(this : in out Components; reliability : Rel_Ratio) is
    begin
        this.reliability := reliability;
    end setReliability;
end Component_Pkg;
